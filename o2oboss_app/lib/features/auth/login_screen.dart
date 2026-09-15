import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/routes.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_typography.dart';
import '../../core/data/app_store.dart';
import '../../core/l10n/l10n.dart';
import '../../core/l10n/labels.dart';
import '../../core/l10n/languages.dart';
import '../../core/l10n/locale_controller.dart';
import '../../core/mock/seed.dart';
import '../../core/models/models.dart';
import '../../core/utils/validators.dart';
import '../../shared/widgets/brand_widgets.dart';
import '../../shared/widgets/buttons.dart';
import '../../shared/widgets/feedback.dart';
import '../../shared/widgets/inputs.dart';
import '../../shared/widgets/layout.dart';
import '../../shared/widgets/pills.dart';
import '../../shared/widgets/rows.dart';
import '../../shared/widgets/sheets.dart';
import '../../shared/widgets/tones.dart';
import 'auth_widgets.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _form = GlobalKey<FormState>();
  final _id = TextEditingController();
  final _password = TextEditingController();
  bool _failed = false;

  @override
  void dispose() {
    _id.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    if (!_form.currentState!.validate()) return;
    await simulateWork();
    final user = ref.read(dbProvider.notifier).findLogin(_id.text, _password.text);
    if (user == null) {
      setState(() => _failed = true);
      return;
    }
    TextInput.finishAutofillContext();
    ref.read(sessionProvider.notifier).signIn(user.id);
  }

  Future<void> _demo() async {
    final t = context.t;
    final picked = await showAppSheet<DemoAccount>(
      context,
      title: t.loginDemoTitle,
      subtitle: t.loginDemoSubtitle,
      builder: (ctx) => Column(
        children: [
          for (final a in demoAccounts)
            NavRow(
              icon: roleIcon(a.role),
              title: roleLabel(t, a.role),
              subtitle: '${_roleDescription(t, a.role)}\n${t.loginDemoCredentials(a.loginId, a.password)}',
              onTap: () => Navigator.pop(ctx, a),
            ),
        ],
      ),
    );
    if (picked == null || !mounted) return;
    _id.text = picked.loginId;
    _password.text = picked.password;
    await _signIn();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final pad = Space.page(context);
    return Scaffold(
      body: SafeArea(
        child: ContentWidth(
          max: 480,
          child: ListView(
            padding: EdgeInsets.fromLTRB(pad, Space.lg, pad, Space.xxl),
            children: [
              Row(
                children: [
                  // The logo opens the Explore page: earn, grow, start or buy.
                  Tooltip(
                    message: t.exOpen,
                    child: Semantics(
                      button: true,
                      label: t.exOpen,
                      child: InkWell(
                        borderRadius: Corners.mdAll,
                        onTap: () => context.push(Routes.explore),
                        child: const Padding(
                          padding: EdgeInsets.all(4),
                          child: BrandMark(size: 34),
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  const _LanguageButton(),
                ],
              ),
              const SizedBox(height: Space.xl),
              const TaglineBanner(compact: true),
              const SizedBox(height: Space.xl),
              Text(t.loginTitle, style: context.text.headlineSmall),
              Space.gapXs,
              Text(t.loginSubtitle,
                  style: context.text.bodyMedium?.copyWith(color: AppColors.textSecondary)),
              Space.gapXl,
              if (_failed) ...[FormErrorBanner(t.loginError), Space.gapLg],
              Form(
                key: _form,
                child: AutofillGroup(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AppTextField(
                        label: t.labelUserId,
                        controller: _id,
                        required: true,
                        prefixIcon: Icons.person_outline,
                        autofillHints: const [AutofillHints.username],
                        textInputAction: TextInputAction.next,
                        validator: (v) => Validators.required(t, v),
                      ),
                      Space.gapLg,
                      PasswordField(
                        label: t.labelPassword,
                        controller: _password,
                        textInputAction: TextInputAction.done,
                        onSubmitted: (_) => _signIn(),
                        validator: (v) => Validators.required(t, v),
                      ),
                      Align(
                        alignment: AlignmentDirectional.centerEnd,
                        child: TextButton(
                          onPressed: () => context.push(Routes.forgot),
                          child: Text(t.loginForgot),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Space.gapSm,
              AppButton(t.loginButton, onPressed: _signIn),
              Space.gapXxl,
              Row(
                children: [
                  const Expanded(child: Divider()),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Space.md),
                    child: Text(t.loginNoAccount, style: context.text.bodySmall),
                  ),
                  const Expanded(child: Divider()),
                ],
              ),
              Space.gapLg,
              AppButton.secondary(
                t.loginCreateAccount,
                icon: Icons.person_add_alt_outlined,
                onPressed: () => context.push(Routes.signup),
              ),
              Space.gapXxl,
              Center(
                child: TextButton.icon(
                  onPressed: _demo,
                  icon: const Icon(Icons.science_outlined, size: 20),
                  label: Text(t.loginDemoButton),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String _roleDescription(AppLocalizations t, UserRole r) => switch (r) {
      UserRole.sales => t.roleSalesDesc,
      UserRole.backOffice => t.roleBackOfficeDesc,
      UserRole.vendor => t.roleVendorDesc,
      UserRole.customer => t.roleCustomerDesc,
      UserRole.franchise => t.roleFranchiseDesc,
      UserRole.admin => t.roleAdminDesc,
    };

/// Shows the current language by its own name; opens the language list.
class _LanguageButton extends ConsumerWidget {
  const _LanguageButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final code = Localizations.localeOf(context).languageCode;
    final current = languageFor(code) ?? appLanguages.first;
    return OutlinedButton.icon(
      style: OutlinedButton.styleFrom(minimumSize: const Size(0, 40)),
      icon: const Icon(Icons.translate, size: 18),
      label: Text(current.endonym),
      onPressed: () async {
        final picked = await pickOption<String>(
          context,
          title: context.t.langTitle,
          selected: code,
          options: [
            for (final l in appLanguages)
              SelectOption(l.code, l.endonym, subtitle: l.englishName),
          ],
        );
        if (picked != null) ref.read(localeProvider.notifier).choose(picked);
      },
    );
  }
}
