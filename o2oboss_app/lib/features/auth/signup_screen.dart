import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/routes.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_motion.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_typography.dart';
import '../../core/brand/brand_philosophy.dart';
import '../../core/data/app_store.dart';
import '../../core/data/db_queries.dart';
import '../../core/data/drafts.dart';
import '../../core/l10n/l10n.dart';
import '../../core/models/models.dart';
import '../../core/utils/format.dart';
import '../../core/utils/validators.dart';
import '../../shared/widgets/brand_widgets.dart';
import '../../shared/widgets/buttons.dart';
import '../../shared/widgets/feedback.dart';
import '../../shared/widgets/inputs.dart';
import '../../shared/widgets/layout.dart';
import '../../shared/widgets/pills.dart';
import '../../shared/widgets/tones.dart';
import 'auth_widgets.dart';

/// Sign-up: who you are → details → verify mobile → create login → done.
/// One short step per screen, with progress shown at the top.
class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  static const _stepCount = 4;

  int _step = 0;
  bool _forward = true;
  final _d = SignUpData();
  final _detailsKey = GlobalKey<FormState>();
  final _credKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _email = TextEditingController();
  final _business = TextEditingController();
  final _address = TextEditingController();
  final _gstin = TextEditingController();
  final _loginId = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  final _otp = TextEditingController();
  String? _otpError;
  bool _termsError = false;
  String? _createdUserId;

  @override
  void dispose() {
    for (final c in [
      _name, _phone, _email, _business, _address, _gstin, _loginId, _password, _confirm, _otp,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  void _goTo(int step) => setState(() {
        _forward = step > _step;
        _step = step;
      });

  void _back() {
    if (_step == 0) {
      context.canPop() ? context.pop() : context.go(Routes.login);
    } else if (_step < 4) {
      _goTo(_step - 1);
    }
  }

  Future<void> _submitDetails() async {
    final ok = _detailsKey.currentState!.validate();
    setState(() => _termsError = !_d.acceptedTerms);
    if (!ok || !_d.acceptedTerms) {
      showToast(context, context.t.validationFixErrors, tone: Tone.danger);
      return;
    }
    _d
      ..name = _name.text.trim()
      ..phone = _phone.text.trim()
      ..email = _email.text.trim().isEmpty ? null : _email.text.trim()
      ..companyName = _business.text.trim()
      ..address = _address.text.trim()
      ..gstin = _gstin.text.trim().isEmpty ? null : _gstin.text.trim();
    if (_d.role == UserRole.vendor && _d.serviceCities.isEmpty) _d.serviceCities = [_d.city];
    await simulateWork();
    if (_loginId.text.isEmpty) {
      _loginId.text = ref.read(dbProvider.notifier).suggestLoginId(_d.name);
    }
    _otp.clear();
    _otpError = null;
    _goTo(2);
  }

  Future<void> _verifyOtp() async {
    if (_otp.text.length != 6) {
      setState(() => _otpError = context.t.validationOtp);
      return;
    }
    await simulateWork();
    if (_otp.text != demoOtp) {
      setState(() => _otpError = context.t.validationOtpWrong);
      return;
    }
    setState(() => _otpError = null);
    _goTo(3);
  }

  Future<void> _create() async {
    if (!_credKey.currentState!.validate()) return;
    _d
      ..loginId = _loginId.text.trim()
      ..password = _password.text;
    await simulateWork(600);
    final id = ref.read(dbProvider.notifier).registerUser(_d);
    setState(() => _createdUserId = id);
    _goTo(4);
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final Widget content = switch (_step) {
      0 => _who(context),
      1 => _details(context),
      2 => _verify(context),
      3 => _credentials(context),
      _ => _done(context),
    };
    final Widget? action = switch (_step) {
      1 => AppButton(t.actionContinue, onPressed: _submitDetails),
      2 => AppButton(t.otpVerify, onPressed: _verifyOtp),
      3 => AppButton(t.signupCreate, onPressed: _create),
      _ => null,
    };
    return PopScope(
      canPop: _step == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _back();
      },
      child: Scaffold(
        appBar: _step == 4
            ? null
            : AppBar(
                leading: BackButton(onPressed: _back),
                title: Text(t.signupTitle),
                bottom: _step == 0 ? null : StepProgress(step: _step, total: _stepCount),
              ),
        body: SafeArea(
          child: ContentWidth(
            max: 560,
            child: directionalSwitch(
              context: context,
              step: _step,
              forward: _forward,
              child: content,
            ),
          ),
        ),
        bottomNavigationBar: action == null ? null : StickyActions(children: [action]),
      ),
    );
  }

  EdgeInsets _pad(BuildContext context) => EdgeInsets.fromLTRB(
      Space.page(context), Space.lg, Space.page(context), Space.xxxl);

  Widget _who(BuildContext context) {
    final t = context.t;
    final options = [
      (UserRole.sales, t.signupWhoSales, t.signupWhoSalesDesc, Icons.campaign_outlined),
      (UserRole.vendor, t.signupWhoVendor, t.signupWhoVendorDesc, Icons.storefront_outlined),
      (UserRole.customer, t.signupWhoCustomer, t.signupWhoCustomerDesc, Icons.shopping_bag_outlined),
    ];
    return ListView(
      padding: _pad(context),
      children: [
        const AbundanceBanner(),
        Space.gapXl,
        Text(t.signupWhoTitle, style: context.text.headlineSmall),
        Space.gapXl,
        for (final (role, title, desc, icon) in options) ...[
          AppCard(
            onTap: () {
              setState(() {
                _d.role = role;
                _d.serviceCities = [];
                _d.categoryIds = [];
                _d.brandIds = [];
              });
              _goTo(1);
            },
            child: Row(
              children: [
                IconTile(icon, size: 52),
                Space.gapLg,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: context.text.titleSmall),
                      const SizedBox(height: 4),
                      Text(desc, style: context.text.bodySmall),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: AppColors.textMuted),
              ],
            ),
          ),
          Space.gapMd,
        ],
        // Franchise Partner option - navigates to dedicated screen
        Space.gapMd,
        AppCard(
          onTap: () => context.push(Routes.signupFranchise),
          child: Row(
            children: [
              IconTile(Icons.rocket_launch_outlined, size: 52),
              Space.gapLg,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Become a Franchise Partner', style: context.text.titleSmall),
                    const SizedBox(height: 4),
                    Text('Start your own business with our support', style: context.text.bodySmall),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: AppColors.textMuted),
            ],
          ),
        ),
      ],
    );
  }

  Widget _details(BuildContext context) {
    final t = context.t;
    final db = ref.watch(dbProvider);
    final isVendor = _d.role == UserRole.vendor;
    final city = db.cityByName(_d.city);
    final brands = db.brands
        .where((b) => b.active && b.categoryIds.any(_d.categoryIds.contains))
        .toList();
    return Form(
      key: _detailsKey,
      child: ListView(
        padding: _pad(context),
        children: [
          Text(isVendor ? t.signupBusinessTitle : t.signupDetailsTitle,
              style: context.text.titleLarge),
          Space.gapXl,
          if (isVendor) ...[
            AppTextField(
              label: t.labelBusinessName,
              controller: _business,
              required: true,
              textCapitalization: TextCapitalization.words,
              validator: (v) => Validators.name(t, v),
            ),
            Space.gapLg,
          ],
          AppTextField(
            label: isVendor ? t.labelYourName : t.labelFullName,
            controller: _name,
            required: true,
            textCapitalization: TextCapitalization.words,
            autofillHints: const [AutofillHints.name],
            validator: (v) => Validators.name(t, v),
          ),
          Space.gapLg,
          PhoneField(
            controller: _phone,
            validator: (v) =>
                Validators.phone(t, v) ??
                (db.userByPhone(v!) != null ? t.signupPhoneExists : null),
          ),
          Space.gapLg,
          AppTextField(
            label: t.labelEmail,
            optional: true,
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            autofillHints: const [AutofillHints.email],
            validator: (v) => Validators.email(t, v),
          ),
          Space.gapLg,
          SelectField<String>(
            label: t.labelCity,
            value: _d.city.isEmpty ? null : _d.city,
            required: true,
            icon: Icons.location_city_outlined,
            options: [for (final c in db.cities) SelectOption(c.name, c.name, subtitle: c.state)],
            onChanged: (v) => setState(() {
              _d.city = v;
              _d.area = '';
              _d.pincode = null;
              if (isVendor) _d.serviceCities = [v];
            }),
          ),
          Space.gapLg,
          SelectField<String>(
            label: t.labelArea,
            value: _d.area.isEmpty ? null : _d.area,
            required: true,
            enabled: city != null,
            icon: Icons.place_outlined,
            options: [
              for (final a in city?.areas ?? const <Area>[])
                SelectOption(a.name, a.name, subtitle: a.pincode),
            ],
            onChanged: (v) => setState(() {
              _d.area = v;
              _d.pincode = city!.areas.firstWhere((a) => a.name == v).pincode;
            }),
          ),
          if (isVendor) ...[
            Space.gapLg,
            AppTextField(
              label: t.labelAddress,
              optional: true,
              controller: _address,
              maxLines: 2,
            ),
            Space.gapXl,
            MultiChips<String>(
              label: t.labelCategoriesYouServe,
              required: true,
              options: [
                for (final c in db.categories.where((c) => c.active))
                  SelectOption(c.id, c.name, icon: categoryIcon(c.icon)),
              ],
              selected: _d.categoryIds.toSet(),
              onChanged: (s) => setState(() => _d.categoryIds = s.toList()),
            ),
            if (brands.isNotEmpty) ...[
              Space.gapXl,
              MultiChips<String>(
                label: t.labelBrandsYouSupply,
                options: [for (final b in brands) SelectOption(b.id, b.name)],
                selected: _d.brandIds.toSet(),
                onChanged: (s) => setState(() => _d.brandIds = s.toList()),
              ),
            ],
            Space.gapXl,
            MultiChips<String>(
              label: t.labelServiceCities,
              options: [for (final c in db.cities) SelectOption(c.name, c.name)],
              selected: _d.serviceCities.toSet(),
              onChanged: (s) => setState(() => _d.serviceCities = s.toList()),
            ),
            Space.gapLg,
            AppTextField(
              label: t.labelGstin,
              optional: true,
              controller: _gstin,
              textCapitalization: TextCapitalization.characters,
            ),
          ],
          Space.gapXl,
          _TermsRow(
            value: _d.acceptedTerms,
            error: _termsError && !_d.acceptedTerms,
            onChanged: (v) => setState(() => _d.acceptedTerms = v),
          ),
        ],
      ),
    );
  }

  Widget _verify(BuildContext context) {
    final t = context.t;
    return ListView(
      padding: _pad(context),
      children: [
        const Align(
          alignment: AlignmentDirectional.centerStart,
          child: IconTile(Icons.sms_outlined, size: 56),
        ),
        Space.gapLg,
        Text(t.otpTitle, style: context.text.titleLarge),
        Space.gapXs,
        Text(t.otpSubtitle(Fmt.maskedPhone(_d.phone)),
            style: context.text.bodyMedium?.copyWith(color: AppColors.textSecondary)),
        Space.gapXl,
        FieldLabel(t.otpLabel),
        OtpField(controller: _otp, errorText: _otpError, onCompleted: (_) => _verifyOtp()),
        Space.gapMd,
        DemoNote(t.otpDemoHint(demoOtp)),
        Space.gapSm,
        Row(
          children: [
            ResendCode(onResend: () => showToast(context, t.otpResent, tone: Tone.info)),
            const Spacer(),
            TextButton(onPressed: () => _goTo(1), child: Text(t.otpChangeNumber)),
          ],
        ),
      ],
    );
  }

  Widget _credentials(BuildContext context) {
    final t = context.t;
    final store = ref.read(dbProvider.notifier);
    final id = _loginId.text.trim();
    final available = Validators.loginId(t, id) == null && !store.isLoginIdTaken(id);
    return Form(
      key: _credKey,
      child: ListView(
        padding: _pad(context),
        children: [
          Text(t.credTitle, style: context.text.titleLarge),
          Space.gapXs,
          Text(t.credSubtitle,
              style: context.text.bodyMedium?.copyWith(color: AppColors.textSecondary)),
          Space.gapXl,
          AppTextField(
            label: t.labelUserId,
            controller: _loginId,
            required: true,
            help: available ? t.credAvailable : t.credUserIdHelp,
            prefixIcon: Icons.alternate_email,
            autofillHints: const [AutofillHints.newUsername],
            onChanged: (_) => setState(() {}),
            suffix: available
                ? const Icon(Icons.check_circle, color: AppColors.success)
                : null,
            validator: (v) =>
                Validators.loginId(t, v) ??
                (store.isLoginIdTaken(v!.trim()) ? t.validationLoginIdTaken : null),
          ),
          Space.gapLg,
          PasswordField(
            label: t.labelPassword,
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
    );
  }

  Widget _done(BuildContext context) {
    final t = context.t;
    final isVendor = _d.role == UserRole.vendor;
    Widget mark = Container(
      width: 88,
      height: 88,
      decoration: const BoxDecoration(color: AppColors.successLight, shape: BoxShape.circle),
      child: Icon(isVendor ? Icons.hourglass_top_rounded : Icons.check_rounded,
          size: 48, color: AppColors.successText),
    );
    if (!Motion.reduced(context)) {
      mark = mark.animate().scale(
          begin: const Offset(0.6, 0.6), duration: 360.ms, curve: Curves.easeOutBack).fadeIn();
    }
    return ListView(
      padding: EdgeInsets.fromLTRB(Space.page(context), 72, Space.page(context), Space.xxl),
      children: [
        Center(child: mark),
        Space.gapXxl,
        Text(kSuccessWelcome, textAlign: TextAlign.center, style: context.text.headlineSmall),
        Space.gapSm,
        Text(isVendor ? t.signupVendorDoneBody : t.signupDoneBody(_d.loginId),
            textAlign: TextAlign.center,
            style: context.text.bodyMedium?.copyWith(color: AppColors.textSecondary)),
        Space.gapMd,
        const PhilosophyCard(),
        Space.gapXl,
        AppCard(
          child: Row(
            children: [
              const Icon(Icons.alternate_email, color: AppColors.textSecondary),
              Space.gapMd,
              Text(t.labelUserId, style: context.text.bodySmall),
              const Spacer(),
              Text(_d.loginId, style: context.text.titleSmall),
            ],
          ),
        ),
        Space.gapXxl,
        AppButton(t.signupGoHome, onPressed: () {
          final id = _createdUserId;
          if (id != null) ref.read(sessionProvider.notifier).signIn(id);
        }),
      ],
    );
  }
}

class _TermsRow extends StatelessWidget {
  const _TermsRow({required this.value, required this.error, required this.onChanged});

  final bool value;
  final bool error;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          borderRadius: Corners.mdAll,
          onTap: () => onChanged(!value),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: Space.xs),
            child: Row(
              children: [
                Checkbox(value: value, onChanged: (v) => onChanged(v ?? false)),
                Expanded(child: Text(t.signupTerms, style: context.text.bodyMedium)),
              ],
            ),
          ),
        ),
        Row(
          children: [
            const SizedBox(width: 48),
            TextButton(
              onPressed: () => context.push(Routes.legal('terms')),
              child: Text(t.legalTerms),
            ),
            TextButton(
              onPressed: () => context.push(Routes.legal('privacy')),
              child: Text(t.legalPrivacy),
            ),
          ],
        ),
        if (error)
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 48),
            child: Text(t.signupTermsError,
                style: context.text.bodySmall?.copyWith(color: AppColors.dangerText)),
          ),
      ],
    );
  }
}
