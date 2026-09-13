import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/routes.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_typography.dart';
import '../../core/data/app_store.dart';
import '../../core/data/db_queries.dart';
import '../../core/l10n/l10n.dart';
import '../../core/models/models.dart';
import '../../core/utils/format.dart';
import '../../core/utils/validators.dart';
import '../../shared/widgets/buttons.dart';
import '../../shared/widgets/feedback.dart';
import '../../shared/widgets/inputs.dart';
import '../../shared/widgets/layout.dart';
import '../../shared/widgets/pills.dart';
import 'auth_widgets.dart';

/// Forgot password: find account → code to registered mobile → new password.
class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  int _step = 0;
  bool _forward = true;
  AppUser? _user;
  final _idForm = GlobalKey<FormState>();
  final _pwForm = GlobalKey<FormState>();
  final _id = TextEditingController();
  final _otp = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  bool _notFound = false;
  String? _otpError;

  @override
  void dispose() {
    for (final c in [_id, _otp, _password, _confirm]) {
      c.dispose();
    }
    super.dispose();
  }

  void _goTo(int s) => setState(() {
        _forward = s > _step;
        _step = s;
      });

  Future<void> _find() async {
    if (!_idForm.currentState!.validate()) return;
    await simulateWork();
    final db = ref.read(dbProvider);
    final input = _id.text.trim();
    final user = db.userByLogin(input) ?? db.userByPhone(input);
    if (user == null) {
      setState(() => _notFound = true);
      return;
    }
    _user = user;
    _notFound = false;
    _goTo(1);
  }

  Future<void> _verify() async {
    await simulateWork();
    if (_otp.text != demoOtp) {
      setState(() => _otpError = _otp.text.length == 6
          ? context.t.validationOtpWrong
          : context.t.validationOtp);
      return;
    }
    _goTo(2);
  }

  Future<void> _save() async {
    if (!_pwForm.currentState!.validate()) return;
    await simulateWork();
    ref.read(dbProvider.notifier).setPassword(_user!.id, _password.text);
    if (!mounted) return;
    showToast(context, context.t.resetDone);
    context.go(Routes.login);
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final pad = EdgeInsets.fromLTRB(Space.page(context), Space.lg, Space.page(context), Space.xxl);
    final content = switch (_step) {
      0 => Form(
          key: _idForm,
          child: ListView(padding: pad, children: [
            const Align(
              alignment: AlignmentDirectional.centerStart,
              child: IconTile(Icons.lock_reset, size: 56),
            ),
            Space.gapLg,
            Text(t.forgotTitle, style: context.text.titleLarge),
            Space.gapXs,
            Text(t.forgotSubtitle,
                style: context.text.bodyMedium?.copyWith(color: AppColors.textSecondary)),
            Space.gapXl,
            if (_notFound) ...[FormErrorBanner(t.forgotNotFound), Space.gapLg],
            AppTextField(
              label: t.forgotIdLabel,
              controller: _id,
              required: true,
              prefixIcon: Icons.person_outline,
              validator: (v) => Validators.required(t, v),
              onSubmitted: (_) => _find(),
            ),
          ]),
        ),
      1 => ListView(padding: pad, children: [
          Text(t.otpTitle, style: context.text.titleLarge),
          Space.gapXs,
          Text(t.otpSubtitle(Fmt.maskedPhone(_user?.phone ?? '')),
              style: context.text.bodyMedium?.copyWith(color: AppColors.textSecondary)),
          Space.gapXl,
          FieldLabel(t.otpLabel),
          OtpField(controller: _otp, errorText: _otpError, onCompleted: (_) => _verify()),
          Space.gapMd,
          DemoNote(t.otpDemoHint(demoOtp)),
          ResendCode(onResend: () {}),
        ]),
      _ => Form(
          key: _pwForm,
          child: ListView(padding: pad, children: [
            Text(t.resetTitle, style: context.text.titleLarge),
            Space.gapXl,
            PasswordField(
              label: t.changePwNew,
              controller: _password,
              help: t.credPasswordHelp,
              autofillHints: const [AutofillHints.newPassword],
              validator: (v) => Validators.password(t, v),
            ),
            Space.gapLg,
            PasswordField(
              label: t.credConfirmPassword,
              controller: _confirm,
              autofillHints: const [AutofillHints.newPassword],
              validator: (v) => v != _password.text ? t.validationPasswordMatch : null,
            ),
          ]),
        ),
    };
    return PopScope(
      canPop: _step == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _goTo(_step - 1);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(t.forgotTitle),
          bottom: StepProgress(step: _step + 1, total: 3),
        ),
        body: SafeArea(
          child: ContentWidth(
            max: 520,
            child: directionalSwitch(
                context: context, step: _step, forward: _forward, child: content),
          ),
        ),
        bottomNavigationBar: StickyActions(children: [
          switch (_step) {
            0 => AppButton(t.forgotSendCode, onPressed: _find),
            1 => AppButton(t.otpVerify, onPressed: _verify),
            _ => AppButton(t.resetButton, onPressed: _save),
          },
        ]),
      ),
    );
  }
}
