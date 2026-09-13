import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/routes.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_motion.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_typography.dart';
import '../../core/data/app_store.dart';
import '../../core/data/db_queries.dart';
import '../../core/data/drafts.dart';
import '../../core/l10n/l10n.dart';
import '../../core/l10n/labels.dart';
import '../../core/models/models.dart';
import '../../core/utils/format.dart';
import '../../core/utils/validators.dart';
import '../../shared/widgets/buttons.dart';
import '../../shared/widgets/cards.dart';
import '../../shared/widgets/feedback.dart';
import '../../shared/widgets/inputs.dart';
import '../../shared/widgets/layout.dart';
import '../../shared/widgets/rows.dart';
import '../../shared/widgets/tones.dart';
import '../auth/auth_widgets.dart';

enum _Step { customer, need, place, review, done }

/// "Refer a customer" for referral partners and back office, and "Post a
/// requirement" for customers. One short step per screen.
class NewEnquiryScreen extends ConsumerStatefulWidget {
  const NewEnquiryScreen({super.key, this.categoryId});

  final String? categoryId;

  @override
  ConsumerState<NewEnquiryScreen> createState() => _NewEnquiryScreenState();
}

class _NewEnquiryScreenState extends ConsumerState<NewEnquiryScreen> {
  late final EnquiryDraft _d = EnquiryDraft(categoryId: widget.categoryId);
  late final List<_Step> _steps;
  int _index = 0;
  bool _forward = true;
  bool _consent = false;
  bool _consentError = false;
  String? _createdId;

  final _customerKey = GlobalKey<FormState>();
  final _needKey = GlobalKey<FormState>();
  final _placeKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _email = TextEditingController();
  final _requirement = TextEditingController();
  final _pincode = TextEditingController();
  final _address = TextEditingController();
  final _time = TextEditingController();

  bool get _isCustomer => ref.read(currentUserProvider)?.role == UserRole.customer;

  @override
  void initState() {
    super.initState();
    final me = ref.read(currentUserProvider)!;
    if (me.role == UserRole.customer) {
      final c = ref.read(dbProvider).customerById(me.customerId);
      _d
        ..customerName = me.name
        ..customerPhone = me.phone
        ..city = c?.city ?? me.city
        ..area = c?.area ?? me.area ?? '';
      _pincode.text = c?.pincode ?? '';
      _address.text = c?.address ?? '';
      _steps = [_Step.need, _Step.place, _Step.review, _Step.done];
    } else {
      _steps = [_Step.customer, _Step.need, _Step.place, _Step.review, _Step.done];
    }
  }

  @override
  void dispose() {
    for (final c in [_name, _phone, _email, _requirement, _pincode, _address, _time]) {
      c.dispose();
    }
    super.dispose();
  }

  _Step get _step => _steps[_index];

  bool get _dirty =>
      _name.text.isNotEmpty || _phone.text.isNotEmpty || _requirement.text.isNotEmpty;

  void _goTo(_Step s) => setState(() {
        final target = _steps.indexOf(s);
        _forward = target > _index;
        _index = target;
      });

  Future<void> _back() async {
    if (_step == _Step.done) {
      context.pop();
      return;
    }
    if (_index == 0) {
      if (!_dirty || await confirmDiscard(context)) {
        if (mounted) context.pop();
      }
      return;
    }
    _goTo(_steps[_index - 1]);
  }

  Future<void> _submitCustomer() async {
    if (!_customerKey.currentState!.validate()) return;
    final t = context.t;
    final store = ref.read(dbProvider.notifier);
    final db = ref.read(dbProvider);
    _d
      ..customerName = _name.text.trim()
      ..customerPhone = _phone.text.trim()
      ..customerEmail = _email.text.trim().isEmpty ? null : _email.text.trim();
    await simulateWork(300);
    final dupes = store.findDuplicates(_d.customerPhone);
    if (dupes.isNotEmpty && mounted) {
      final e = dupes.first;
      final go = await confirmAction(
        context,
        title: t.referDuplicateTitle,
        body: t.referDuplicateBody(e.id, db.categoryName(e.categoryId)),
        confirmLabel: t.referDuplicateContinue,
        cancelLabel: t.referDuplicateCheck,
      );
      if (!go) return;
    }
    // Returning customers: fill in what we already know.
    final known = db.customerByPhone(_d.customerPhone);
    if (known != null && _d.city.isEmpty) {
      _d
        ..existingCustomerId = known.id
        ..city = known.city
        ..area = known.area;
      _pincode.text = known.pincode ?? '';
    }
    _goTo(_Step.need);
  }

  void _submitNeed() {
    if (!_needKey.currentState!.validate()) return;
    _d.requirement = _requirement.text.trim();
    _goTo(_Step.place);
  }

  void _submitPlace() {
    if (!_placeKey.currentState!.validate()) return;
    _d
      ..pincode = _pincode.text.trim().isEmpty ? null : _pincode.text.trim()
      ..address = _address.text.trim().isEmpty ? null : _address.text.trim()
      ..preferredTime = _d.contactPreference == ContactPreference.callAtTime
          ? _time.text.trim()
          : null;
    _goTo(_Step.review);
  }

  Future<void> _submit() async {
    if (!_consent) {
      setState(() => _consentError = true);
      return;
    }
    final config = ref.read(configProvider);
    if (config.otpEnabled) {
      final ok = await verifyPhoneSheet(context, Fmt.phone(_d.customerPhone));
      if (!ok) return;
      _d.otpVerified = true;
    }
    await simulateWork(600);
    final store = ref.read(dbProvider.notifier);
    final id = store.createEnquiry(_d);
    store.recordConsent(ConsentAction.communication, enquiryId: id);
    setState(() => _createdId = id);
    _goTo(_Step.done);
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final title = _isCustomer ? t.referTitleCustomer : t.referTitle;
    final Widget content = switch (_step) {
      _Step.customer => _customerStep(context),
      _Step.need => _needStep(context),
      _Step.place => _placeStep(context),
      _Step.review => _reviewStep(context),
      _Step.done => _doneStep(context),
    };
    final Widget? action = switch (_step) {
      _Step.customer => AppButton(t.actionContinue, onPressed: _submitCustomer),
      _Step.need => AppButton(t.actionContinue, onPressed: _submitNeed),
      _Step.place => AppButton(t.actionContinue, onPressed: _submitPlace),
      _Step.review => AppButton(
          _isCustomer ? t.referSubmitCustomer : t.referSubmit,
          icon: Icons.send_outlined,
          onPressed: _submit,
        ),
      _Step.done => null,
    };
    final total = _steps.length - 1;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _back();
      },
      child: Scaffold(
        appBar: _step == _Step.done
            ? null
            : AppBar(
                leading: BackButton(onPressed: _back),
                title: Text(title),
                bottom: StepProgress(step: _index + 1, total: total),
              ),
        body: SafeArea(
          child: ContentWidth(
            max: 560,
            child: directionalSwitch(
              context: context,
              step: _index,
              forward: _forward,
              child: content,
            ),
          ),
        ),
        bottomNavigationBar: action == null ? null : StickyActions(children: [action]),
      ),
    );
  }

  EdgeInsets _pad(BuildContext context) =>
      EdgeInsets.fromLTRB(Space.page(context), Space.lg, Space.page(context), Space.xxxl);

  Widget _heading(BuildContext context, String title, [String? subtitle]) => Padding(
        padding: const EdgeInsets.only(bottom: Space.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: context.text.titleLarge),
            if (subtitle != null) ...[
              const SizedBox(height: 4),
              Text(subtitle,
                  style: context.text.bodyMedium?.copyWith(color: AppColors.textSecondary)),
            ],
          ],
        ),
      );

  // ── Step: who is the customer ────────────────────────────────────────────
  Widget _customerStep(BuildContext context) {
    final t = context.t;
    return Form(
      key: _customerKey,
      child: ListView(
        padding: _pad(context),
        children: [
          _heading(context, t.referCustomerTitle, t.referCustomerSubtitle),
          AppTextField(
            label: t.labelFullName,
            controller: _name,
            required: true,
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.next,
            validator: (v) => Validators.name(t, v),
          ),
          Space.gapLg,
          PhoneField(controller: _phone, textInputAction: TextInputAction.next),
          Space.gapLg,
          AppTextField(
            label: t.labelEmail,
            controller: _email,
            optional: true,
            keyboardType: TextInputType.emailAddress,
            validator: (v) => (v ?? '').isEmpty ? null : Validators.email(t, v),
          ),
          Space.gapXl,
          NoteCard(icon: Icons.lock_outline, text: t.referPrivacyNote),
        ],
      ),
    );
  }

  // ── Step: what is needed ─────────────────────────────────────────────────
  Widget _needStep(BuildContext context) {
    final t = context.t;
    final db = ref.watch(dbProvider);
    final categories = db.categories.where((c) => c.active).toList();
    final products = db.products
        .where((p) => p.active && p.categoryId == _d.categoryId)
        .toList();
    final brands = db.brands
        .where((b) => b.active && b.categoryIds.contains(_d.categoryId))
        .toList();
    return Form(
      key: _needKey,
      child: ListView(
        padding: _pad(context),
        children: [
          _heading(context, _isCustomer ? t.referNeedTitleCustomer : t.referNeedTitle),
          SelectField<String>(
            label: t.labelCategory,
            required: true,
            value: _d.categoryId,
            icon: _d.categoryId == null
                ? Icons.category_outlined
                : categoryIcon(db.categoryById(_d.categoryId)?.icon ?? ''),
            options: [
              for (final c in categories) SelectOption(c.id, c.name, icon: categoryIcon(c.icon)),
            ],
            onChanged: (v) => setState(() {
              if (v != _d.categoryId) {
                _d
                  ..categoryId = v
                  ..productId = null
                  ..brandId = null;
              }
            }),
          ),
          if (products.isNotEmpty) ...[
            Space.gapLg,
            SelectField<String>(
              key: ValueKey('product-${_d.categoryId}'),
              label: t.labelProduct,
              optional: true,
              value: _d.productId,
              options: [for (final p in products) SelectOption(p.id, p.name)],
              onChanged: (v) => setState(() => _d.productId = v),
            ),
          ],
          if (brands.isNotEmpty) ...[
            Space.gapLg,
            SelectField<String>(
              key: ValueKey('brand-${_d.categoryId}'),
              label: t.labelBrand,
              optional: true,
              value: _d.brandId ?? '',
              options: [
                SelectOption('', t.labelAnyBrand),
                for (final b in brands) SelectOption(b.id, b.name),
              ],
              onChanged: (v) => setState(() => _d.brandId = v.isEmpty ? null : v),
            ),
          ],
          Space.gapLg,
          AppTextField(
            label: t.labelRequirement,
            controller: _requirement,
            required: true,
            maxLines: 4,
            minLines: 3,
            hint: t.referRequirementHint,
            textCapitalization: TextCapitalization.sentences,
            validator: (v) =>
                (v ?? '').trim().length < 5 ? t.referRequirementError : null,
          ),
        ],
      ),
    );
  }

  // ── Step: where and how to contact ───────────────────────────────────────
  Widget _placeStep(BuildContext context) {
    final t = context.t;
    final db = ref.watch(dbProvider);
    final city = db.cityByName(_d.city);
    return Form(
      key: _placeKey,
      child: ListView(
        padding: _pad(context),
        children: [
          _heading(context, t.referPlaceTitle),
          SelectField<String>(
            label: t.labelCity,
            required: true,
            value: _d.city.isEmpty ? null : _d.city,
            icon: Icons.location_city_outlined,
            options: [for (final c in db.cities) SelectOption(c.name, c.name, subtitle: c.state)],
            onChanged: (v) => setState(() {
              if (v != _d.city) {
                _d
                  ..city = v
                  ..area = '';
                _pincode.clear();
              }
            }),
          ),
          Space.gapLg,
          SelectField<String>(
            key: ValueKey('area-${_d.city}'),
            label: t.labelArea,
            required: true,
            enabled: city != null,
            value: _d.area.isEmpty ? null : _d.area,
            icon: Icons.place_outlined,
            options: [
              for (final a in city?.areas ?? const <Area>[])
                SelectOption(a.name, a.name, subtitle: a.pincode),
            ],
            onChanged: (v) => setState(() {
              _d.area = v;
              final pin = city?.areas.where((a) => a.name == v).firstOrNull?.pincode;
              if (pin != null) _pincode.text = pin;
            }),
          ),
          Space.gapLg,
          AppTextField(
            label: t.labelPincode,
            controller: _pincode,
            optional: true,
            keyboardType: TextInputType.number,
            maxLength: 6,
          ),
          Space.gapLg,
          AppTextField(
            label: t.labelAddress,
            controller: _address,
            optional: true,
            maxLines: 2,
            textCapitalization: TextCapitalization.sentences,
          ),
          Space.gapXl,
          ChoiceChips<ContactPreference>(
            label: _isCustomer ? t.referContactLabelCustomer : t.referContactLabel,
            options: [
              for (final p in ContactPreference.values)
                SelectOption(p, contactPrefLabel(t, p)),
            ],
            selected: _d.contactPreference,
            onSelected: (v) => setState(() => _d.contactPreference = v),
          ),
          if (_d.contactPreference == ContactPreference.callAtTime) ...[
            Space.gapLg,
            AppTextField(
              label: t.referPreferredTime,
              controller: _time,
              required: true,
              hint: t.referPreferredTimeHint,
              validator: (v) => Validators.required(t, v),
            ),
          ],
        ],
      ),
    );
  }

  // ── Step: check and send ─────────────────────────────────────────────────
  Widget _reviewStep(BuildContext context) {
    final t = context.t;
    final db = ref.watch(dbProvider);
    final config = ref.watch(configProvider);
    final category = db.categoryById(_d.categoryId);
    final what = [
      db.brandById(_d.brandId)?.name,
      db.productById(_d.productId)?.name ?? category?.name,
    ].whereType<String>().join(' ');
    Widget change(_Step s) => TextButton(onPressed: () => _goTo(s), child: Text(t.actionChange));
    return ListView(
      padding: _pad(context),
      children: [
        _heading(context, t.referReviewTitle, t.referReviewSubtitle),
        if (!_isCustomer) ...[
          SectionCard(
            title: t.labelCustomer,
            icon: Icons.person_outline,
            trailing: change(_Step.customer),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InfoRow(label: t.labelName, value: _d.customerName),
                InfoRow(label: t.labelMobile, value: Fmt.phone(_d.customerPhone)),
                if (_d.customerEmail != null) InfoRow(label: t.labelEmail, value: _d.customerEmail!),
              ],
            ),
          ),
          Space.gapMd,
        ],
        SectionCard(
          title: t.labelRequirement,
          icon: categoryIcon(category?.icon ?? ''),
          trailing: change(_Step.need),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InfoRow(label: t.labelProduct, value: what),
              InfoRow(label: t.labelRequirement, value: _d.requirement),
            ],
          ),
        ),
        Space.gapMd,
        SectionCard(
          title: t.labelLocation,
          icon: Icons.place_outlined,
          trailing: change(_Step.place),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InfoRow(
                label: t.labelArea,
                value: [_d.area, _d.city, ?_d.pincode].join(', '),
              ),
              InfoRow(
                label: _isCustomer ? t.referContactLabelCustomer : t.referContactLabel,
                value: _d.contactPreference == ContactPreference.callAtTime
                    ? '${contactPrefLabel(t, _d.contactPreference)}: ${_d.preferredTime ?? ''}'
                    : contactPrefLabel(t, _d.contactPreference),
              ),
            ],
          ),
        ),
        Space.gapXl,
        _ConsentBox(
          value: _consent,
          error: _consentError,
          text: _isCustomer ? t.referConsentCustomer : t.referConsent,
          onChanged: (v) => setState(() {
            _consent = v;
            if (v) _consentError = false;
          }),
        ),
        if (config.otpEnabled) ...[
          Space.gapMd,
          NoteCard(icon: Icons.sms_outlined, text: t.referOtpNote),
        ],
      ],
    );
  }

  // ── Done ─────────────────────────────────────────────────────────────────
  Widget _doneStep(BuildContext context) {
    final t = context.t;
    final id = _createdId ?? '';
    final reduced = Motion.reduced(context);
    Widget icon = Container(
      width: 88,
      height: 88,
      decoration: const BoxDecoration(color: AppColors.successLight, shape: BoxShape.circle),
      child: const Icon(Icons.check_rounded, size: 52, color: AppColors.success),
    );
    if (!reduced) {
      icon = icon.animate().scale(
          begin: const Offset(0.6, 0.6), duration: 420.ms, curve: Curves.easeOutBack);
    }
    return ListView(
      padding: EdgeInsets.fromLTRB(Space.page(context), Space.giant, Space.page(context), Space.xxxl),
      children: [
        Center(child: icon),
        Space.gapXl,
        Text(
          _isCustomer ? t.referDoneTitleCustomer : t.referDoneTitle,
          style: context.text.headlineSmall,
          textAlign: TextAlign.center,
        ),
        Space.gapSm,
        Text(t.referDoneId(id),
            style: context.text.titleMedium?.copyWith(color: AppColors.primaryDark),
            textAlign: TextAlign.center),
        Space.gapXxl,
        AppCard(
          child: StepsList(steps: [
            (t.referNext1Title, _isCustomer ? t.referNext1BodyCustomer : t.referNext1Body),
            (t.referNext2Title, t.referNext2Body),
            (t.referNext3Title, _isCustomer ? t.referNext3BodyCustomer : t.referNext3Body),
          ]),
        ),
        Space.gapXxl,
        AppButton(t.referTrack, onPressed: () => context.pushReplacement(Routes.enquiry(id))),
        Space.gapMd,
        AppButton.secondary(
          _isCustomer ? t.actionDone : t.referAnother,
          onPressed: () => _isCustomer ? context.pop() : context.pushReplacement(Routes.refer()),
        ),
      ],
    );
  }
}

class _ConsentBox extends StatelessWidget {
  const _ConsentBox({
    required this.value,
    required this.error,
    required this.text,
    required this.onChanged,
  });

  final bool value;
  final bool error;
  final String text;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Material(
          color: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: Corners.lgAll,
            side: BorderSide(color: error ? AppColors.danger : AppColors.border),
          ),
          clipBehavior: Clip.antiAlias,
          child: CheckboxListTile(
            value: value,
            onChanged: (v) => onChanged(v ?? false),
            controlAffinity: ListTileControlAffinity.leading,
            title: Text(text, style: context.text.bodyMedium),
          ),
        ),
        if (error)
          Padding(
            padding: const EdgeInsets.only(top: 6, left: Space.xs),
            child: Text(context.t.referConsentError,
                style: context.text.bodySmall?.copyWith(color: AppColors.dangerText)),
          ),
      ],
    );
  }
}
