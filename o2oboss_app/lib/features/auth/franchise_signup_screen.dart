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
import '../../core/l10n/l10n.dart';
import '../../core/utils/format.dart';
import '../../core/utils/validators.dart';
import '../../shared/widgets/brand_widgets.dart';
import '../../shared/widgets/buttons.dart';
import '../../shared/widgets/cards.dart';
import '../../shared/widgets/feedback.dart';
import '../../shared/widgets/inputs.dart';
import '../../shared/widgets/layout.dart';
import '../../shared/widgets/rows.dart';

enum FranchiseType { womenHygiene, artGallery, coffeeKiosk, ayurvedicSpa, eggMaster, monthlyGroceries }

enum ExperienceRange { none, under3, years3to10, over10 }

/// Turnkey franchise sizes. Costs are indicative starting points; the final
/// figure depends on the format and the city.
enum FranchisePackage { kiosk, store, flagship, custom }

extension on FranchisePackage {
  double? get startsAt => switch (this) {
        FranchisePackage.kiosk => 500000,
        FranchisePackage.store => 1000000,
        FranchisePackage.flagship => 2500000,
        FranchisePackage.custom => null,
      };

  String title(AppLocalizations t) => switch (this) {
        FranchisePackage.kiosk => t.fsPkgKiosk,
        FranchisePackage.store => t.fsPkgStore,
        FranchisePackage.flagship => t.fsPkgFlagship,
        FranchisePackage.custom => t.fsPkgCustom,
      };

  String body(AppLocalizations t) => switch (this) {
        FranchisePackage.kiosk => t.fsPkgKioskBody,
        FranchisePackage.store => t.fsPkgStoreBody,
        FranchisePackage.flagship => t.fsPkgFlagshipBody,
        FranchisePackage.custom => t.fsPkgCustomBody,
      };

  String price(AppLocalizations t) =>
      startsAt == null
          ? t.fsPkgCustomPrice(Fmt.moneyCompact(FranchisePackage.flagship.startsAt!))
          : t.fsPkgFrom(Fmt.moneyCompact(startsAt!));
}

String _typeLabel(AppLocalizations t, FranchiseType f) => switch (f) {
      FranchiseType.womenHygiene => t.fsTypeHygiene,
      FranchiseType.artGallery => t.fsTypeArt,
      FranchiseType.coffeeKiosk => t.fsTypeCoffee,
      FranchiseType.ayurvedicSpa => t.fsTypeSpa,
      FranchiseType.eggMaster => t.fsTypeEgg,
      FranchiseType.monthlyGroceries => t.fsTypeGroceries,
    };

IconData _typeIcon(FranchiseType f) => switch (f) {
      FranchiseType.womenHygiene => Icons.spa_outlined,
      FranchiseType.artGallery => Icons.palette_outlined,
      FranchiseType.coffeeKiosk => Icons.local_cafe_outlined,
      FranchiseType.ayurvedicSpa => Icons.self_improvement_outlined,
      FranchiseType.eggMaster => Icons.egg_outlined,
      FranchiseType.monthlyGroceries => Icons.shopping_cart_outlined,
    };

String _experienceLabel(AppLocalizations t, ExperienceRange e) => switch (e) {
      ExperienceRange.none => t.fsExpNone,
      ExperienceRange.under3 => t.fsExpUnder3,
      ExperienceRange.years3to10 => t.fsExp3to10,
      ExperienceRange.over10 => t.fsExpOver10,
    };

const _states = [
  'Andhra Pradesh', 'Arunachal Pradesh', 'Assam', 'Bihar', 'Chhattisgarh', 'Delhi', 'Goa',
  'Gujarat', 'Haryana', 'Himachal Pradesh', 'Jharkhand', 'Karnataka', 'Kerala', 'Madhya Pradesh',
  'Maharashtra', 'Odisha', 'Puducherry', 'Punjab', 'Rajasthan', 'Tamil Nadu', 'Telangana',
  'Uttar Pradesh', 'Uttarakhand', 'West Bengal',
];

/// Franchise: O2O Boss sets up the whole outlet (brand, look, interior,
/// products, training), the same everywhere, like the big chains. The page
/// explains what is included, shows the package sizes, and takes a short
/// application.
class FranchiseSignupScreen extends ConsumerStatefulWidget {
  const FranchiseSignupScreen({super.key});

  @override
  ConsumerState<FranchiseSignupScreen> createState() => _State();
}

class _State extends ConsumerState<FranchiseSignupScreen> {
  final _key = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _mobile = TextEditingController();
  final _city = TextEditingController();
  String? _state;
  ExperienceRange? _experience;
  FranchisePackage? _package;
  FranchiseType? _type;
  bool _terms = false;
  bool _termsError = false;
  bool _done = false;

  @override
  void dispose() {
    for (final c in [_name, _email, _mobile, _city]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _submit() async {
    final t = context.t;
    final ok = _key.currentState!.validate();
    setState(() => _termsError = !_terms);
    if (!ok || !_terms) {
      showToast(context, t.validationFixErrors, tone: Tone.danger);
      return;
    }
    await simulateWork(800);
    if (mounted) setState(() => _done = true);
  }

  @override
  Widget build(BuildContext context) => _done ? _success(context) : _form(context);

  Widget _form(BuildContext context) {
    final t = context.t;
    final p = Space.page(context);
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
            onPressed: () => context.canPop() ? context.pop() : context.go(Routes.signup)),
        title: Text(t.fsTitle),
      ),
      body: SafeArea(
        child: ContentWidth(
          max: 640,
          child: Form(
            key: _key,
            child: ListView(
              padding: EdgeInsets.fromLTRB(p, Space.md, p, Space.xxxl),
              children: [
                const _Hero(),
                SectionHeader(t.fsIncludedTitle),
                const _Included(),
                SectionHeader(t.fsPackagesTitle),
                Text(t.fsPackagesHelp, style: context.text.bodySmall),
                Space.gapMd,
                _packages(context),
                SectionHeader(t.fsTypesTitle),
                _types(context),
                SectionHeader(t.fsDetailsTitle),
                _fields(context),
                Space.gapXl,
                _termsRow(context),
                Space.gapLg,
                AppButton(t.fsSubmit, onPressed: _submit),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _packages(BuildContext context) {
    final t = context.t;
    return FormField<FranchisePackage>(
      validator: (_) => _package == null ? t.validationChooseOne : null,
      builder: (field) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ResponsiveGrid(
            minItemWidth: 260,
            children: [
              for (final pkg in FranchisePackage.values)
                _PackageCard(
                  package: pkg,
                  selected: _package == pkg,
                  onTap: () {
                    setState(() => _package = pkg);
                    field.didChange(pkg);
                  },
                ),
            ],
          ),
          if (field.hasError) ...[
            Space.gapSm,
            Text(field.errorText!,
                style: context.text.bodySmall?.copyWith(color: AppColors.dangerText)),
          ],
        ],
      ),
    );
  }

  Widget _types(BuildContext context) {
    final t = context.t;
    return Wrap(
      spacing: Space.sm,
      runSpacing: Space.sm,
      children: [
        for (final f in FranchiseType.values)
          ChoiceChip(
            avatar: Icon(_typeIcon(f), size: 18, color: _type == f ? Colors.white : AppColors.primary),
            label: Text(_typeLabel(t, f)),
            selected: _type == f,
            showCheckmark: false,
            labelStyle:
                context.text.labelMedium?.copyWith(color: _type == f ? Colors.white : AppColors.text),
            onSelected: (_) => setState(() => _type = _type == f ? null : f),
          ),
      ],
    );
  }

  Widget _fields(BuildContext context) {
    final t = context.t;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppTextField(
          label: t.labelFullName,
          controller: _name,
          required: true,
          textCapitalization: TextCapitalization.words,
          validator: (v) => Validators.name(t, v),
        ),
        Space.gapLg,
        PhoneField(controller: _mobile),
        Space.gapLg,
        AppTextField(
          label: t.labelEmail,
          controller: _email,
          optional: true,
          keyboardType: TextInputType.emailAddress,
          validator: (v) => Validators.email(t, v),
        ),
        Space.gapLg,
        AppTextField(
          label: t.fsCityLabel,
          controller: _city,
          required: true,
          textCapitalization: TextCapitalization.words,
          validator: (v) => Validators.required(t, v),
        ),
        Space.gapLg,
        FormField<String>(
          validator: (_) => _state == null ? t.validationChooseOne : null,
          builder: (field) => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SelectField<String>(
                label: t.fsStateLabel,
                value: _state,
                required: true,
                icon: Icons.map_outlined,
                options: [for (final s in _states) SelectOption(s, s)],
                onChanged: (v) {
                  setState(() => _state = v);
                  field.didChange(v);
                },
              ),
              if (field.hasError)
                Padding(
                  padding: const EdgeInsets.only(top: Space.xs),
                  child: Text(field.errorText!,
                      style: context.text.bodySmall?.copyWith(color: AppColors.dangerText)),
                ),
            ],
          ),
        ),
        Space.gapLg,
        ChoiceChips<ExperienceRange>(
          label: t.fsExperienceLabel,
          required: true,
          options: [
            for (final e in ExperienceRange.values) SelectOption(e, _experienceLabel(t, e)),
          ],
          selected: _experience,
          onSelected: (v) => setState(() => _experience = v),
        ),
      ],
    );
  }

  Widget _termsRow(BuildContext context) {
    final t = context.t;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          borderRadius: Corners.mdAll,
          onTap: () => setState(() => _terms = !_terms),
          child: Row(
            children: [
              Checkbox(value: _terms, onChanged: (v) => setState(() => _terms = v ?? false)),
              Expanded(child: Text(t.signupTerms, style: context.text.bodyMedium)),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsetsDirectional.only(start: 48),
          child: Wrap(
            children: [
              TextButton(
                  onPressed: () => context.push(Routes.legal('terms')), child: Text(t.legalTerms)),
              TextButton(
                  onPressed: () => context.push(Routes.legal('privacy')),
                  child: Text(t.legalPrivacy)),
            ],
          ),
        ),
        if (_termsError && !_terms)
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 48),
            child: Text(t.signupTermsError,
                style: context.text.bodySmall?.copyWith(color: AppColors.dangerText)),
          ),
      ],
    );
  }

  Widget _success(BuildContext context) {
    final t = context.t;
    Widget mark = Container(
      width: 88,
      height: 88,
      decoration: const BoxDecoration(color: AppColors.successLight, shape: BoxShape.circle),
      child: const Icon(Icons.storefront_outlined, size: 46, color: AppColors.successText),
    );
    if (!Motion.reduced(context)) {
      mark = mark
          .animate()
          .scale(begin: const Offset(0.6, 0.6), duration: 360.ms, curve: Curves.easeOutBack)
          .fadeIn();
    }
    final pkg = _package!;
    return Scaffold(
      body: SafeArea(
        child: ContentWidth(
          max: 480,
          child: ListView(
            padding: EdgeInsets.fromLTRB(Space.page(context), 72, Space.page(context), Space.xxl),
            children: [
              Center(child: mark),
              Space.gapXxl,
              Text(kSuccessWelcome, textAlign: TextAlign.center, style: context.text.headlineSmall),
              Space.gapSm,
              Text(t.fsDoneBody,
                  textAlign: TextAlign.center,
                  style: context.text.bodyMedium?.copyWith(color: AppColors.textSecondary)),
              Space.gapMd,
              const PhilosophyCard(),
              Space.gapXl,
              AppCard(
                child: Column(
                  children: [
                    InfoRow(icon: Icons.person_outline, label: t.labelFullName, value: _name.text.trim()),
                    InfoRow(icon: Icons.phone_outlined, label: t.labelMobile, value: _mobile.text.trim()),
                    InfoRow(
                      icon: Icons.place_outlined,
                      label: t.fsCityLabel,
                      value: '${_city.text.trim()}, ${_state ?? ''}',
                    ),
                    InfoRow(
                      icon: Icons.storefront_outlined,
                      label: t.fsPackageLabel,
                      value: '${pkg.title(t)} (${pkg.price(t)})',
                    ),
                  ],
                ),
              ),
              Space.gapXxl,
              AppButton(t.soonBackToSignIn, onPressed: () => context.go(Routes.login)),
            ],
          ),
        ),
      ),
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero();

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return Container(
      padding: const EdgeInsets.all(Space.xl),
      decoration: BoxDecoration(
        borderRadius: Corners.xlAll,
        gradient: LinearGradient(
          begin: AlignmentDirectional.topStart,
          end: AlignmentDirectional.bottomEnd,
          // One hue, deepening: stays clean in both colour themes.
          colors: [AppColors.primary, Color.lerp(AppColors.primary, Colors.black, 0.22)!],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.rocket_launch_outlined, color: Colors.white, size: 34),
          Space.gapMd,
          Semantics(
            header: true,
            child: Text(
              t.fsHeroTitle,
              style: AppType.weight(context.text.headlineSmall!, FontWeight.w800)
                  .copyWith(color: Colors.white, height: 1.2),
            ),
          ),
          Space.gapSm,
          Text(
            t.fsHeroBody,
            style: context.text.bodyMedium?.copyWith(color: Colors.white.withValues(alpha: 0.92)),
          ),
          Space.gapLg,
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.16),
              borderRadius: Corners.pillAll,
            ),
            child: Text(
              t.fsHeroPrice(Fmt.moneyCompact(FranchisePackage.kiosk.startsAt!)),
              style: context.text.labelLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}

/// Everything O2O Boss sets up, so the partner does not have to.
class _Included extends StatelessWidget {
  const _Included();

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final items = [
      (Icons.verified_outlined, t.fsIncBrand, t.fsIncBrandBody),
      (Icons.format_paint_outlined, t.fsIncInterior, t.fsIncInteriorBody),
      (Icons.inventory_2_outlined, t.fsIncProducts, t.fsIncProductsBody),
      (Icons.school_outlined, t.fsIncTraining, t.fsIncTrainingBody),
      (Icons.campaign_outlined, t.fsIncLaunch, t.fsIncLaunchBody),
    ];
    return AppCard(
      child: Gap(
        space: Space.lg,
        children: [
          for (final (icon, title, body) in items)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GlowIcon(icon, size: 40),
                Space.gapMd,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: context.text.titleSmall),
                      const SizedBox(height: 2),
                      Text(body, style: context.text.bodySmall),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _PackageCard extends StatelessWidget {
  const _PackageCard({required this.package, required this.selected, required this.onTap});

  final FranchisePackage package;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return Semantics(
      selected: selected,
      button: true,
      child: AppCard(
        onTap: onTap,
        color: selected ? AppColors.primaryLight : null,
        borderColor: selected ? AppColors.primary : null,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
              color: selected ? AppColors.primary : AppColors.textMuted,
            ),
            Space.gapMd,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(package.title(t), style: context.text.titleSmall),
                  const SizedBox(height: 2),
                  Text(
                    package.price(t),
                    style: AppType.weight(context.text.titleMedium!, FontWeight.w800)
                        .copyWith(color: AppColors.primaryDark),
                  ),
                  Space.gapXs,
                  Text(package.body(t), style: context.text.bodySmall),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
