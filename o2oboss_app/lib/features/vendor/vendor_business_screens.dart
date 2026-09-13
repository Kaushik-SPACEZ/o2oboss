import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_typography.dart';
import '../../core/data/app_store.dart';
import '../../core/data/db_queries.dart';
import '../../core/l10n/l10n.dart';
import '../../core/l10n/labels.dart';
import '../../core/models/models.dart';
import '../../core/utils/format.dart';
import '../../shared/widgets/buttons.dart';
import '../../shared/widgets/cards.dart';
import '../../shared/widgets/check_chips.dart';
import '../../shared/widgets/feedback.dart';
import '../../shared/widgets/inputs.dart';
import '../../shared/widgets/kpi.dart';
import '../../shared/widgets/layout.dart';
import '../../shared/widgets/pills.dart';
import '../../shared/widgets/rows.dart';
import '../../shared/widgets/sheets.dart';
import '../../shared/widgets/tones.dart';
import '../common/system_screens.dart';

Vendor? _myVendor(WidgetRef ref) {
  final me = ref.watch(currentUserProvider);
  return ref.watch(dbProvider).vendorById(me?.vendorId);
}

bool _same(Set<String> a, List<String> b) => a.length == b.toSet().length && a.containsAll(b);

/// The business as customers and O2O Boss see it, with one switch to pause
/// new referrals and an Edit sheet for the details.
class VendorCompanyScreen extends ConsumerWidget {
  const VendorCompanyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final v = _myVendor(ref);
    if (v == null) return const NoAccessView();
    final referrals = ref.watch(dbProvider).assignments.where((a) => a.vendorId == v.id).length;

    return PageScaffold(
      title: t.vbCompanyTitle,
      actions: [TextButton(onPressed: () => _edit(context, ref, v), child: Text(t.vbEdit))],
      children: [
        SoftHeroCard(
          padding: const EdgeInsets.all(Space.lg),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const GlowIcon(Icons.storefront_outlined, size: 52),
              Space.gapMd,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(v.companyName, style: context.text.titleLarge),
                    const SizedBox(height: 2),
                    Text(t.vbJoined(Fmt.date(context, v.joinedAt)), style: context.text.bodySmall),
                    Space.gapSm,
                    StatusPill(accountStatusLabel(t, v.status), tone: accountTone(v.status)),
                  ],
                ),
              ),
            ],
          ),
        ),
        Space.gapMd,
        StatStrip(items: [
          StatItem(
            icon: Icons.star_outline,
            value: v.rating.toStringAsFixed(1),
            label: t.vendorRating,
            tone: Tone.warning,
          ),
          StatItem(
            icon: Icons.bolt_outlined,
            value: '${v.responseRate}%',
            label: t.vendorResponse,
            tone: Tone.success,
          ),
          StatItem(icon: Icons.inbox_outlined, value: '$referrals', label: t.vendorReferrals),
        ]),
        Space.gapMd,
        AppCard(
          padding: const EdgeInsets.symmetric(vertical: Space.xs),
          child: SwitchListTile(
            value: v.available,
            onChanged: (on) {
              ref.read(dbProvider.notifier).updateVendor(v.copyWith(available: on));
              showToast(context, on ? t.vbAvailableOn : t.vbAvailableOff,
                  tone: on ? Tone.success : Tone.warning);
            },
            title: Text(t.vbAvailable),
            subtitle: Text(v.available ? t.vbAvailableOn : t.vbAvailableOff),
          ),
        ),
        SectionHeader(t.vbAbout, top: Space.xl),
        AppCard(
          child: Text(
            v.about.isEmpty ? t.vbAboutEmpty : v.about,
            style: context.text.bodyMedium
                ?.copyWith(color: v.about.isEmpty ? AppColors.textSecondary : AppColors.text),
          ),
        ),
        SectionHeader(t.vbDetails, top: Space.xl),
        AppCard(
          child: Column(
            children: [
              InfoRow(icon: Icons.person_outline, label: t.vbContactPerson, value: v.contactPerson),
              InfoRow(icon: Icons.phone_outlined, label: t.labelMobile, value: Fmt.phone(v.phone)),
              InfoRow(icon: Icons.mail_outline, label: t.vbEmail, value: v.email ?? ''),
              InfoRow(
                icon: Icons.place_outlined,
                label: t.vbAddress,
                value: [v.address, v.area, v.city].where((s) => s.isNotEmpty).join(', '),
              ),
              InfoRow(icon: Icons.receipt_long_outlined, label: t.vbGst, value: v.gstin ?? ''),
            ],
          ),
        ),
        if (v.commercialNote.isNotEmpty) ...[
          SectionHeader(t.vendorTerms, top: Space.xl),
          NoteCard(icon: Icons.handshake_outlined, text: v.commercialNote),
        ],
      ],
    );
  }

  Future<void> _edit(BuildContext context, WidgetRef ref, Vendor v) async {
    final t = context.t;
    final next = await showAppSheet<Vendor>(
      context,
      title: t.vbEditTitle,
      builder: (_) => _CompanyForm(vendor: v),
    );
    if (next == null) return;
    await simulateWork();
    ref.read(dbProvider.notifier).updateVendor(next);
    if (context.mounted) showToast(context, t.vbSaved);
  }
}

class _CompanyForm extends StatefulWidget {
  const _CompanyForm({required this.vendor});

  final Vendor vendor;

  @override
  State<_CompanyForm> createState() => _CompanyFormState();
}

class _CompanyFormState extends State<_CompanyForm> {
  final _form = GlobalKey<FormState>();
  late final _name = TextEditingController(text: widget.vendor.companyName);
  late final _person = TextEditingController(text: widget.vendor.contactPerson);
  late final _email = TextEditingController(text: widget.vendor.email ?? '');
  late final _address = TextEditingController(text: widget.vendor.address);
  late final _gst = TextEditingController(text: widget.vendor.gstin ?? '');
  late final _about = TextEditingController(text: widget.vendor.about);

  @override
  void dispose() {
    for (final c in [_name, _person, _email, _address, _gst, _about]) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    String? required(String? v) => (v ?? '').trim().isEmpty ? t.validationRequired : null;
    return Form(
      key: _form,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppTextField(label: t.vbCompanyName, controller: _name, required: true, validator: required),
          Space.gapLg,
          AppTextField(label: t.vbContactPerson, controller: _person, required: true, validator: required),
          Space.gapLg,
          AppTextField(
            label: t.vbEmail,
            controller: _email,
            optional: true,
            keyboardType: TextInputType.emailAddress,
          ),
          Space.gapLg,
          AppTextField(label: t.vbAddress, controller: _address, required: true, validator: required, maxLines: 2),
          Space.gapLg,
          AppTextField(
            label: t.vbGst,
            controller: _gst,
            optional: true,
            textCapitalization: TextCapitalization.characters,
          ),
          Space.gapLg,
          AppTextField(label: t.vbAbout, controller: _about, optional: true, maxLines: 4, minLines: 2),
          Space.gapXl,
          AppButton(t.vbSave, onPressed: () {
            if (!_form.currentState!.validate()) return;
            Navigator.pop(
              context,
              widget.vendor.copyWith(
                companyName: _name.text.trim(),
                contactPerson: _person.text.trim(),
                email: _email.text.trim(),
                address: _address.text.trim(),
                gstin: _gst.text.trim(),
                about: _about.text.trim(),
              ),
            );
          }),
        ],
      ),
    );
  }
}

void _toggle(Set<String> set, String id) => set.contains(id) ? set.remove(id) : set.add(id);

/// Services, then the products and brands of those services.
class VendorCatalogScreen extends ConsumerStatefulWidget {
  const VendorCatalogScreen({super.key});

  @override
  ConsumerState<VendorCatalogScreen> createState() => _VendorCatalogScreenState();
}

class _VendorCatalogScreenState extends ConsumerState<VendorCatalogScreen> {
  Set<String>? _cats;
  Set<String>? _products;
  Set<String>? _brands;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final db = ref.watch(dbProvider);
    final v = _myVendor(ref);
    if (v == null) return const NoAccessView();
    final cats = _cats ??= {...v.categoryIds};
    final products = _products ??= {...v.productIds};
    final brands = _brands ??= {...v.brandIds};
    final shownProducts = db.products.where((p) => p.active && cats.contains(p.categoryId)).toList();
    final shownBrands = db.brands.where((b) => b.active && b.categoryIds.any(cats.contains)).toList();
    final dirty = !_same(cats, v.categoryIds) ||
        !_same(products, v.productIds) ||
        !_same(brands, v.brandIds);

    Future<void> save() async {
      await simulateWork();
      final productIds = {for (final p in shownProducts) p.id};
      final brandIds = {for (final b in shownBrands) b.id};
      ref.read(dbProvider.notifier).updateVendor(v.copyWith(
            categoryIds: cats.toList(),
            productIds: products.where(productIds.contains).toList(),
            brandIds: brands.where(brandIds.contains).toList(),
          ));
      setState(() => _cats = _products = _brands = null);
      if (context.mounted) showToast(context, t.vbSaved);
    }

    return PageScaffold(
      title: t.vnCatalog,
      bottomBar: dirty ? StickyActions(children: [AppButton(t.vbSave, onPressed: save)]) : null,
      children: [
        Text(t.vbServicesHelp, style: context.text.bodyMedium?.copyWith(color: AppColors.textSecondary)),
        SectionHeader(t.vbServices, top: Space.lg),
        CheckChips(
          options: [for (final c in db.categories.where((c) => c.active)) (c.id, c.name)],
          selected: cats,
          onToggle: (id) => setState(() => _toggle(cats, id)),
        ),
        SectionHeader(t.vbProducts, top: Space.xl),
        if (shownProducts.isEmpty)
          Text(t.vbPickServiceFirst, style: context.text.bodyMedium?.copyWith(color: AppColors.textSecondary))
        else
          CheckChips(
            options: [for (final p in shownProducts) (p.id, p.name)],
            selected: products,
            onToggle: (id) => setState(() => _toggle(products, id)),
          ),
        SectionHeader(t.vbBrands, top: Space.xl),
        if (shownBrands.isEmpty)
          Text(t.vbPickServiceFirst, style: context.text.bodyMedium?.copyWith(color: AppColors.textSecondary))
        else
          CheckChips(
            options: [for (final b in shownBrands) (b.id, b.name)],
            selected: brands,
            onToggle: (id) => setState(() => _toggle(brands, id)),
          ),
      ],
    );
  }
}

/// Cities served, then the areas inside each chosen city.
class VendorAreasScreen extends ConsumerStatefulWidget {
  const VendorAreasScreen({super.key});

  @override
  ConsumerState<VendorAreasScreen> createState() => _VendorAreasScreenState();
}

class _VendorAreasScreenState extends ConsumerState<VendorAreasScreen> {
  Set<String>? _cities;
  Set<String>? _areas;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final db = ref.watch(dbProvider);
    final v = _myVendor(ref);
    if (v == null) return const NoAccessView();
    final cities = _cities ??= {...v.serviceCities};
    final areas = _areas ??= {...v.serviceAreas};
    final chosen = db.cities.where((c) => cities.contains(c.name)).toList();
    final dirty = !_same(cities, v.serviceCities) || !_same(areas, v.serviceAreas);

    Future<void> save() async {
      await simulateWork();
      final allowed = {for (final c in chosen) for (final a in c.areas) a.name};
      ref.read(dbProvider.notifier).updateVendor(v.copyWith(
            serviceCities: cities.toList(),
            serviceAreas: areas.where(allowed.contains).toList(),
          ));
      setState(() => _cities = _areas = null);
      if (context.mounted) showToast(context, t.vbSaved);
    }

    return PageScaffold(
      title: t.vnAreas,
      bottomBar: dirty ? StickyActions(children: [AppButton(t.vbSave, onPressed: save)]) : null,
      children: [
        Text(t.vbAreasHelp, style: context.text.bodyMedium?.copyWith(color: AppColors.textSecondary)),
        SectionHeader(t.vbCities, top: Space.lg),
        CheckChips(
          options: [for (final c in db.cities) (c.name, c.name)],
          selected: cities,
          onToggle: (id) => setState(() => _toggle(cities, id)),
        ),
        if (chosen.isEmpty) ...[
          Space.gapXl,
          Text(t.vbPickCityFirst, style: context.text.bodyMedium?.copyWith(color: AppColors.textSecondary)),
        ],
        for (final c in chosen)
          if (c.areas.isNotEmpty) ...[
            SectionHeader(c.name, top: Space.xl),
            CheckChips(
              options: [for (final a in c.areas) (a.name, a.name)],
              selected: areas,
              onToggle: (id) => setState(() => _toggle(areas, id)),
            ),
          ],
      ],
    );
  }
}

/// Uploaded documents and whether O2O Boss has checked them.
class VendorDocumentsScreen extends ConsumerWidget {
  const VendorDocumentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final v = _myVendor(ref);
    if (v == null) return const NoAccessView();
    final docs = v.documents;
    return PageScaffold(
      title: t.vendorDocuments,
      bottomBar: StickyActions(children: [
        AppButton(t.vbUpload, icon: Icons.upload_file_outlined, onPressed: () => _upload(context, ref, v)),
      ]),
      children: [
        NoteCard(icon: Icons.verified_user_outlined, text: t.vbDocsNote),
        Space.gapLg,
        if (docs.isEmpty)
          AppCard(
            child: EmptyState(compact: true, icon: Icons.description_outlined, title: t.vendorNoDocs),
          )
        else
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                for (var i = 0; i < docs.length; i++) ...[
                  if (i > 0) const Divider(indent: 66),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Space.lg, vertical: Space.md),
                    child: Row(
                      children: [
                        IconTile(Icons.description_outlined,
                            tone: docs[i].verified ? Tone.success : Tone.neutral, size: 38),
                        Space.gapMd,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(docs[i].name, style: context.text.titleSmall),
                              Text(
                                t.vbDocUploadedOn(
                                    docKindLabel(t, docs[i].kind), Fmt.date(context, docs[i].uploadedAt)),
                                style: context.text.bodySmall,
                              ),
                            ],
                          ),
                        ),
                        Space.gapSm,
                        StatusPill(
                          docs[i].verified ? t.vendorDocVerified : t.vendorDocPending,
                          tone: docs[i].verified ? Tone.success : Tone.warning,
                          icon: docs[i].verified ? Icons.verified_outlined : null,
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
      ],
    );
  }

  Future<void> _upload(BuildContext context, WidgetRef ref, Vendor v) async {
    final t = context.t;
    final kind = await showAppSheet<DocKind>(
      context,
      title: t.vbUploadTitle,
      builder: (ctx) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final k in DocKind.values)
            ListTile(
              leading: const Icon(Icons.description_outlined),
              title: Text(docKindLabel(t, k)),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.pop(ctx, k),
            ),
        ],
      ),
    );
    if (kind == null) return;
    await simulateWork(800);
    ref.read(dbProvider.notifier).addVendorDocument(v.id, '${docKindLabel(t, kind)}.pdf', kind);
    if (context.mounted) showToast(context, t.vbUploaded);
  }
}
