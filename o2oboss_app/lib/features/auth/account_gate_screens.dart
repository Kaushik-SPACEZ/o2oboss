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
import '../../core/l10n/labels.dart';
import '../../core/models/models.dart';
import '../../core/utils/validators.dart';
import '../../shared/widgets/buttons.dart';
import '../../shared/widgets/feedback.dart';
import '../../shared/widgets/inputs.dart';
import '../../shared/widgets/layout.dart';
import '../../shared/widgets/pills.dart';
import '../../shared/widgets/tones.dart';
import 'auth_widgets.dart';

/// Shown to accounts that can't use the app yet: vendors awaiting approval,
/// or rejected / suspended accounts.
class PendingScreen extends ConsumerWidget {
  const PendingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final me = ref.watch(currentUserProvider);
    final db = ref.watch(dbProvider);
    if (me == null) return const SizedBox.shrink();
    final vendor = db.vendorById(me.vendorId);
    final status = me.status;
    final (title, body, icon, tone) = switch (status) {
      AccountStatus.rejected =>
        (t.pendingRejectedTitle, t.pendingRejectedBody, Icons.block, Tone.danger),
      AccountStatus.suspended =>
        (t.pendingSuspendedTitle, t.pendingSuspendedBody, Icons.pause_circle_outline, Tone.warning),
      _ => (t.pendingTitle, t.pendingBody, Icons.hourglass_top_rounded, Tone.warning),
    };
    final waiting = status == AccountStatus.pending || status == AccountStatus.underReview;
    final pad = Space.page(context);
    return Scaffold(
      body: SafeArea(
        child: ContentWidth(
          max: 520,
          child: ListView(
            padding: EdgeInsets.fromLTRB(pad, Space.lg, pad, Space.xxl),
            children: [
              const BrandMark(),
              const SizedBox(height: Space.huge),
              Center(child: IconTile(icon, tone: tone, size: 72)),
              Space.gapXl,
              Text(title, textAlign: TextAlign.center, style: context.text.headlineSmall),
              Space.gapSm,
              Text(body,
                  textAlign: TextAlign.center,
                  style: context.text.bodyMedium?.copyWith(color: AppColors.textSecondary)),
              Space.gapLg,
              Center(child: StatusPill(accountStatusLabel(t, status), tone: accountTone(status))),
              if (vendor != null) ...[
                Space.gapXl,
                AppCard(
                  child: Row(
                    children: [
                      const IconTile(Icons.storefront_outlined),
                      Space.gapMd,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(vendor.companyName, style: context.text.titleSmall),
                            Text(
                              vendor.categoryIds.map(db.categoryName).join(', '),
                              style: context.text.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              if (waiting) ...[
                Space.gapXl,
                Text(t.pendingWhatNext, style: context.text.titleSmall),
                Space.gapSm,
                for (final (i, s) in [t.pendingStep1, t.pendingStep2, t.pendingStep3].indexed)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: Space.xs),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 12,
                          backgroundColor: AppColors.primaryLight,
                          child: Text('${i + 1}',
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primaryDark)),
                        ),
                        Space.gapMd,
                        Expanded(child: Text(s, style: context.text.bodyMedium)),
                      ],
                    ),
                  ),
              ],
              Space.gapXxl,
              AppButton.secondary(t.pendingContact,
                  icon: Icons.support_agent_outlined,
                  onPressed: () => context.push(Routes.help)),
              Space.gapMd,
              AppButton(t.actionLogout,
                  kind: ButtonKind.text,
                  onPressed: () => ref.read(sessionProvider.notifier).signOut()),
            ],
          ),
        ),
      ),
    );
  }
}

/// Lets a person set their own password. Forced for admin-created accounts.
class ChangePasswordScreen extends ConsumerStatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  ConsumerState<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends ConsumerState<ChangePasswordScreen> {
  final _form = GlobalKey<FormState>();
  final _current = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  bool _wrongCurrent = false;

  @override
  void dispose() {
    _current.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _save(AppUser me) async {
    if (!_form.currentState!.validate()) return;
    if (!me.mustChangePassword && _current.text != me.password) {
      setState(() => _wrongCurrent = true);
      return;
    }
    await simulateWork();
    ref.read(dbProvider.notifier).setPassword(me.id, _password.text);
    if (!mounted) return;
    showToast(context, context.t.changePwDone);
    if (context.canPop()) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final me = ref.watch(currentUserProvider);
    if (me == null) return const SizedBox.shrink();
    final forced = me.mustChangePassword;
    return PageScaffold(
      title: forced ? t.changePwTitle : t.profileChangePassword,
      actions: forced
          ? [
              TextButton(
                onPressed: () => ref.read(sessionProvider.notifier).signOut(),
                child: Text(t.actionLogout),
              ),
            ]
          : null,
      children: [
        Form(
          key: _form,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (forced) ...[
                Text(t.changePwSubtitle,
                    style: context.text.bodyMedium?.copyWith(color: AppColors.textSecondary)),
                Space.gapXl,
              ] else ...[
                if (_wrongCurrent) ...[FormErrorBanner(t.changePwWrong), Space.gapLg],
                PasswordField(
                  label: t.changePwCurrent,
                  controller: _current,
                  validator: (v) => Validators.required(t, v),
                ),
                Space.gapLg,
              ],
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
            ],
          ),
        ),
      ],
      bottomBar: StickyActions(children: [
        AppButton(t.actionSave, onPressed: () => _save(me)),
      ]),
    );
  }
}
