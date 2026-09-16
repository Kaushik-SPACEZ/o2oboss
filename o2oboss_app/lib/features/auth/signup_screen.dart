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
import '../../core/l10n/labels.dart';
import '../../core/models/models.dart';
import '../../core/utils/format.dart';
import '../../core/utils/validators.dart';
import '../../shared/widgets/brand_widgets.dart';
import '../../shared/widgets/buttons.dart';
import '../../shared/widgets/cards.dart';
import '../../shared/widgets/feedback.dart';
import '../../shared/widgets/inputs.dart';
import '../../shared/widgets/layout.dart';
import '../../shared/widgets/pills.dart';
import '../../shared/widgets/tones.dart';
import 'auth_widgets.dart';
import 'explore_screen.dart';

/// Sign-up: who you are → details → verify mobile → create login → done.
/// One short step per screen, with progress shown at the top.
class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key, this.initialRole, this.initialOccupation});

  /// Set when the person already chose on the Explore page.
  final UserRole? initialRole;
  final Occupation? initialOccupation;

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  static const _stepCount = 4;

  /// Picked in the city list when someone's city is not served yet.
  static const _otherCity = '__other__';

  int _step = 0;

  /// On the first step, showing "Which of these describes you?" for earners.
  bool _pickOccupation = false;

  /// City typed by hand because it is not in our list.
  bool _unlisted = false;

  /// Thank-you page for people from a city we do not serve yet.
  bool _waitlisted = false;
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
  final _age = TextEditingController();
  final _cityText = TextEditingController();
  final _areaText = TextEditingController();
  String? _otpError;
  bool _termsError = false;
  String? _createdUserId;

  @override
  void dispose() {
    for (final c in [
      _name, _phone, _email, _business, _address, _gstin, _loginId, _password, _confirm, _otp,
      _age, _cityText, _areaText,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    final role = widget.initialRole;
    if (role == null) return;
    _d
      ..role = role
      ..occupation = widget.initialOccupation;
    if (role == UserRole.sales && widget.initialOccupation == null) {
      _pickOccupation = true;
    } else {
      _step = 1;
    }
  }

  void _goTo(int step) => setState(() {
        _forward = step > _step;
        _step = step;
      });

  void _back() {
    if (_step == 0 && _pickOccupation) {
      setState(() {
        _forward = false;
        _pickOccupation = false;
      });
    } else if (_step == 1 && _d.role == UserRole.sales) {
      setState(() {
        _forward = false;
        _step = 0;
        _pickOccupation = true;
      });
    } else if (_step == 0) {
      context.canPop() ? context.pop() : context.go(Routes.login);
    } else if (_step < 4) {
      _goTo(_step - 1);
    }
  }

  Future<void> _submitDetails() async {
    final t = context.t;
    if (_unlisted) {
      // They typed a city we already serve: pick it for them.
      final known = ref.read(dbProvider).cities
          .where((c) => c.name.toLowerCase() == _cityText.text.trim().toLowerCase())
          .firstOrNull;
      if (known != null) {
        setState(() {
          _unlisted = false;
          _d
            ..city = known.name
            ..area = '';
        });
        showToast(context, t.soonWeAreThere(known.name), tone: Tone.info);
        return;
      }
    }
    final ok = _detailsKey.currentState!.validate();
    setState(() => _termsError = !_d.acceptedTerms);
    if (!ok || !_d.acceptedTerms) {
      showToast(context, t.validationFixErrors, tone: Tone.danger);
      return;
    }
    _d.age = int.tryParse(_age.text.trim());
    if (_unlisted) {
      _d
        ..name = _name.text.trim()
        ..phone = _phone.text.trim()
        ..email = _email.text.trim().isEmpty ? null : _email.text.trim()
        ..city = _cityText.text.trim()
        ..area = _areaText.text.trim();
      await simulateWork();
      ref.read(dbProvider.notifier).joinWaitlist(_d);
      setState(() => _waitlisted = true);
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
    if (_waitlisted) return _soon(context);
    final Widget content = switch (_step) {
      0 => _pickOccupation ? _occupation(context) : _who(context),
      1 => _details(context),
      2 => _verify(context),
      3 => _credentials(context),
      _ => _done(context),
    };
    final Widget? action = switch (_step) {
      1 => AppButton(_unlisted ? t.soonNotify : t.actionContinue, onPressed: _submitDetails),
      2 => AppButton(t.otpVerify, onPressed: _verifyOtp),
      3 => AppButton(t.signupCreate, onPressed: _create),
      _ => null,
    };
    return PopScope(
      canPop: _step == 0 && !_pickOccupation,
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
        body: Stack(
          children: [
            // Background pattern
            Positioned.fill(
              child: Image.asset('assets/images/bg_pattern.png', fit: BoxFit.cover),
            ),
            SafeArea(
              child: ContentWidth(
                max: 560,
                child: directionalSwitch(
                  context: context,
                  step: _pickOccupation ? -1 : _step,
                  forward: _forward,
                  child: content,
                ),
              ),
            ),
          ],
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
      (UserRole.sales, Goal.earn, t.signupWhoSales, t.signupWhoSalesDesc, Icons.campaign_outlined),
      (UserRole.vendor, Goal.grow, t.signupWhoVendor, t.signupWhoVendorDesc, Icons.storefront_outlined),
      (UserRole.customer, Goal.buy, t.signupWhoCustomer, t.signupWhoCustomerDesc,
          Icons.shopping_bag_outlined),
    ];
    return ListView(
      padding: _pad(context),
      children: [
        const AbundanceBanner(),
        Space.gapXl,
        Text(t.signupWhoTitle, style: context.text.headlineSmall),
        Space.gapXl,
        for (final (role, goal, title, desc, icon) in options) ...[
          _WhoCard(
            goal: goal,
            icon: icon,
            title: title,
            body: desc,
            onTap: () {
              setState(() {
                _d.role = role;
                _d.serviceCities = [];
                _d.categoryIds = [];
                _d.brandIds = [];
                _d.occupation = null;
              });
              if (role == UserRole.sales) {
                setState(() {
                  _forward = true;
                  _pickOccupation = true;
                });
              } else {
                _goTo(1);
              }
            },
          ),
          Space.gapMd,
        ],
        _WhoCard(
          goal: Goal.start,
          icon: Icons.rocket_launch_outlined,
          title: t.signupWhoFranchise,
          body: t.signupWhoFranchiseDesc,
          onTap: () => context.push(Routes.signupFranchise),
        ),
      ],
    );
  }

  /// Earners only: one tap to say what they do, then the short form.
  Widget _occupation(BuildContext context) {
    final t = context.t;
    return ListView(
      padding: _pad(context),
      children: [
        Text(t.exWhoTitle, style: context.text.headlineSmall),
        Space.gapXs,
        Text(t.exWhoSubtitle,
            style: context.text.bodyMedium?.copyWith(color: AppColors.textSecondary)),
        Space.gapXl,
        for (final o in Occupation.values) ...[
          AppCard(
            onTap: () {
              setState(() => _d.occupation = o);
              _goTo(1);
            },
            child: Row(
              children: [
                IconTile(occupationIcon(o), size: 48),
                Space.gapLg,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(occupationLabel(t, o), style: context.text.titleSmall),
                      const SizedBox(height: 2),
                      Text(occupationBody(t, o), style: context.text.bodySmall),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: AppColors.textMuted),
              ],
            ),
          ),
          Space.gapMd,
        ],
      ],
    );
  }

  Widget _details(BuildContext context) {
    final t = context.t;
    final db = ref.watch(dbProvider);
    final isVendor = _d.role == UserRole.vendor && !_unlisted;
    final isEarner = _d.role == UserRole.sales;
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
          if (isEarner) ...[
            ChoiceChips<Occupation>(
              label: t.occLabel,
              required: true,
              options: [for (final o in Occupation.values) SelectOption(o, occupationLabel(t, o))],
              selected: _d.occupation,
              onSelected: (o) => setState(() => _d.occupation = o),
            ),
            Space.gapLg,
          ],
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
          if (isEarner) ...[
            Space.gapLg,
            AppTextField(
              label: t.labelAge,
              controller: _age,
              required: true,
              keyboardType: TextInputType.number,
              validator: (v) {
                final age = int.tryParse(v?.trim() ?? '');
                if (age == null || age < 1 || age > 120) return t.validationAge;
                if (age < 18) return t.validationAgeMin;
                return null;
              },
            ),
          ],
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
            value: _unlisted ? _otherCity : (_d.city.isEmpty ? null : _d.city),
            required: true,
            icon: Icons.location_city_outlined,
            options: [
              for (final c in db.cities) SelectOption(c.name, c.name, subtitle: c.state),
              SelectOption(_otherCity, t.cityNotListed, icon: Icons.add_location_alt_outlined),
            ],
            onChanged: (v) => setState(() {
              _unlisted = v == _otherCity;
              _d.city = _unlisted ? '' : v;
              _d.area = '';
              _d.pincode = null;
              if (_d.role == UserRole.vendor && !_unlisted) _d.serviceCities = [v];
            }),
          ),
          Space.gapLg,
          if (_unlisted) ...[
            AppTextField(
              label: t.labelYourCity,
              controller: _cityText,
              required: true,
              textCapitalization: TextCapitalization.words,
              onChanged: (_) => setState(() {}),
              validator: (v) => Validators.required(t, v),
            ),
            Space.gapLg,
            AppTextField(
              label: t.labelYourArea,
              controller: _areaText,
              required: true,
              textCapitalization: TextCapitalization.words,
              validator: (v) => Validators.required(t, v),
            ),
            Space.gapLg,
            NoteCard(
              icon: Icons.schedule_outlined,
              title: _cityText.text.trim().isEmpty
                  ? t.soonNoteTitleAny
                  : t.soonNoteTitle(_cityText.text.trim()),
              text: t.soonNoteBody,
            ),
          ] else
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
                for (final c in db.categories.where((c) => c.active && c.id != kSourcingCategoryId))
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
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            ResendCode(onResend: () => showToast(context, t.otpResent, tone: Tone.info)),
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

  /// For people from a city we do not serve yet: nothing to log in to, just
  /// a clear promise that we will tell them when we arrive.
  Widget _soon(BuildContext context) {
    final t = context.t;
    return Scaffold(
      body: SafeArea(
        child: ContentWidth(
          max: 560,
          child: ListView(
            padding: EdgeInsets.fromLTRB(Space.page(context), 72, Space.page(context), Space.xxl),
            children: [
              Center(
                child: Container(
                  width: 88,
                  height: 88,
                  decoration: BoxDecoration(color: AppColors.primaryLight, shape: BoxShape.circle),
                  child: Icon(Icons.notifications_active_outlined, size: 44, color: AppColors.primary),
                ),
              ),
              Space.gapXxl,
              Text(t.soonDoneTitle(_d.name.split(' ').first),
                  textAlign: TextAlign.center, style: context.text.headlineSmall),
              Space.gapSm,
              Text(t.soonDoneBody(_d.city),
                  textAlign: TextAlign.center,
                  style: context.text.bodyMedium?.copyWith(color: AppColors.textSecondary)),
              Space.gapXxl,
              AppButton(t.soonBackToSignIn, onPressed: () => context.go(Routes.login)),
            ],
          ),
        ),
      ),
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
        // Wraps so long translations never run off the screen.
        Padding(
          padding: const EdgeInsetsDirectional.only(start: 48),
          child: Wrap(
            children: [
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

/// A sign-up choice with its goal written above it, e.g. "Earning".
class _WhoCard extends StatelessWidget {
  const _WhoCard({
    required this.goal,
    required this.icon,
    required this.title,
    required this.body,
    required this.onTap,
  });

  final Goal goal;
  final IconData icon;
  final String title;
  final String body;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      child: Row(
        children: [
          IconTile(icon, size: 52),
          Space.gapLg,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  goal.title(context.t),
                  style: context.text.labelMedium
                      ?.copyWith(color: goal.accent, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 2),
                Text(title, style: context.text.titleSmall),
                const SizedBox(height: 4),
                Text(body, style: context.text.bodySmall),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: AppColors.textMuted),
        ],
      ),
    );
  }
}
