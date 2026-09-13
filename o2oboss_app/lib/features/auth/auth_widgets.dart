import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_typography.dart';
import '../../core/l10n/l10n.dart';

/// Demo OTP for the prototype. Clearly labelled as demo on screen.
const demoOtp = '123456';

/// Single 6-digit code box with platform OTP autofill.
class OtpField extends StatelessWidget {
  const OtpField({super.key, required this.controller, this.errorText, this.onCompleted});

  final TextEditingController controller;
  final String? errorText;
  final ValueChanged<String>? onCompleted;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      autofocus: true,
      keyboardType: TextInputType.number,
      maxLength: 6,
      textAlign: TextAlign.center,
      autofillHints: const [AutofillHints.oneTimeCode],
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w700, letterSpacing: 14),
      onChanged: (v) {
        if (v.length == 6) onCompleted?.call(v);
      },
      decoration: InputDecoration(
        counterText: '',
        hintText: '••••••',
        errorText: errorText,
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
      ),
    );
  }
}

/// "Send code again" with a 30-second wait.
class ResendCode extends StatefulWidget {
  const ResendCode({super.key, required this.onResend});

  final VoidCallback onResend;

  @override
  State<ResendCode> createState() => _ResendCodeState();
}

class _ResendCodeState extends State<ResendCode> {
  int _left = 30;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _start();
  }

  void _start() {
    _timer?.cancel();
    setState(() => _left = 30);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      setState(() => _left--);
      if (_left <= 0) t.cancel();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_left > 0) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Text(context.t.otpResendIn('$_left'), style: context.text.bodySmall),
      );
    }
    return TextButton(
      onPressed: () {
        widget.onResend();
        _start();
      },
      child: Text(context.t.otpResend),
    );
  }
}

/// Asks for the code sent to [phone] in a bottom sheet. Returns true once
/// the right code is entered.
Future<bool> verifyPhoneSheet(BuildContext context, String phone) async {
  final ok = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => _OtpSheet(phone: phone),
  );
  return ok ?? false;
}

class _OtpSheet extends StatefulWidget {
  const _OtpSheet({required this.phone});

  final String phone;

  @override
  State<_OtpSheet> createState() => _OtpSheetState();
}

class _OtpSheetState extends State<_OtpSheet> {
  final _code = TextEditingController();
  String? _error;
  bool _busy = false;

  @override
  void dispose() {
    _code.dispose();
    super.dispose();
  }

  Future<void> _verify() async {
    final t = context.t;
    if (_code.text.length != 6) {
      setState(() => _error = t.validationOtp);
      return;
    }
    setState(() => _busy = true);
    await Future<void>.delayed(const Duration(milliseconds: 450));
    if (!mounted) return;
    if (_code.text != demoOtp) {
      setState(() {
        _busy = false;
        _error = t.validationOtpWrong;
      });
      return;
    }
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return Padding(
      padding: EdgeInsets.fromLTRB(
          Space.xl, 0, Space.xl, Space.xl + MediaQuery.viewInsetsOf(context).bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(t.otpTitle, style: context.text.titleLarge),
          const SizedBox(height: 4),
          Text(t.otpSubtitle(widget.phone), style: context.text.bodySmall),
          Space.gapLg,
          DemoNote(t.otpDemoHint(demoOtp)),
          Space.gapLg,
          OtpField(controller: _code, errorText: _error, onCompleted: (_) => _verify()),
          Center(child: ResendCode(onResend: () {})),
          Space.gapSm,
          FilledButton(
            onPressed: _busy ? null : _verify,
            child: _busy
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2.4, color: Colors.white))
                : Text(t.otpVerify),
          ),
        ],
      ),
    );
  }
}

/// A clearly marked note that the value shown is for the demo only.
class DemoNote extends StatelessWidget {
  const DemoNote(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Space.md, vertical: Space.sm),
      decoration: const BoxDecoration(
        color: AppColors.warningLight,
        borderRadius: Corners.mdAll,
      ),
      child: Row(
        children: [
          const Icon(Icons.science_outlined, size: 18, color: AppColors.warningText),
          Space.gapSm,
          Expanded(
            child: Text(text,
                style: context.text.bodySmall?.copyWith(color: AppColors.warningText)),
          ),
        ],
      ),
    );
  }
}

/// Inline error message shown above a form.
class FormErrorBanner extends StatelessWidget {
  const FormErrorBanner(this.message, {super.key});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      liveRegion: true,
      child: Container(
        padding: const EdgeInsets.all(Space.md),
        decoration: const BoxDecoration(
          color: AppColors.dangerLight,
          borderRadius: Corners.mdAll,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.error_outline, size: 20, color: AppColors.dangerText),
            Space.gapSm,
            Expanded(
              child: Text(message,
                  style: context.text.bodyMedium?.copyWith(color: AppColors.dangerText)),
            ),
          ],
        ),
      ),
    );
  }
}

/// Step progress for multi-step forms: "Step 2 of 4" and a bar.
class StepProgress extends StatelessWidget implements PreferredSizeWidget {
  const StepProgress({super.key, required this.step, required this.total});

  final int step;
  final int total;

  @override
  Size get preferredSize => const Size.fromHeight(30);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(Space.page(context), 0, Space.page(context), Space.sm),
      child: Row(
        children: [
          Text(context.t.signupStepOf('$step', '$total'), style: context.text.labelSmall),
          Space.gapMd,
          Expanded(
            child: ClipRRect(
              borderRadius: Corners.pillAll,
              child: TweenAnimationBuilder<double>(
                tween: Tween(end: step / total),
                duration: const Duration(milliseconds: 300),
                builder: (_, v, _) => LinearProgressIndicator(value: v, minHeight: 6),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Slides step content forward or back, fading at the same time.
Widget directionalSwitch({
  required BuildContext context,
  required int step,
  required bool forward,
  required Widget child,
}) {
  final rtl = Directionality.of(context) == TextDirection.rtl;
  final dir = (forward ? 1.0 : -1.0) * (rtl ? -1 : 1);
  return AnimatedSwitcher(
    duration: MediaQuery.maybeDisableAnimationsOf(context) == true
        ? Duration.zero
        : const Duration(milliseconds: 300),
    switchInCurve: Curves.easeOutCubic,
    switchOutCurve: Curves.easeInCubic,
    layoutBuilder: (current, previous) => Stack(
      alignment: Alignment.topCenter,
      children: [...previous, ?current],
    ),
    transitionBuilder: (child, animation) {
      final incoming = child.key == ValueKey(step);
      final offset = Tween<Offset>(
        begin: Offset(incoming ? 0.12 * dir : -0.12 * dir, 0),
        end: Offset.zero,
      ).animate(animation);
      return FadeTransition(
        opacity: animation,
        child: SlideTransition(position: offset, child: child),
      );
    },
    child: KeyedSubtree(key: ValueKey(step), child: child),
  );
}
