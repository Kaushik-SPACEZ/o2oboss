import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/routes.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_typography.dart';
import '../../core/data/app_store.dart';
import '../../core/data/db_queries.dart';
import '../../core/data/drafts.dart';
import '../../core/l10n/l10n.dart';
import '../../core/models/models.dart';
import '../../core/utils/format.dart';
import '../../shared/widgets/buttons.dart';
import '../../shared/widgets/cards.dart';
import '../../shared/widgets/check_chips.dart';
import '../../shared/widgets/feedback.dart';
import '../../shared/widgets/inputs.dart';
import '../../shared/widgets/layout.dart';
import '../../shared/widgets/pills.dart';
import '../../shared/widgets/rows.dart';
import '../../shared/widgets/sheets.dart';
import '../../shared/widgets/tones.dart';
import '../common/system_screens.dart';

enum ProductSort { popular, priceLow, priceHigh, name }

extension ProductQueries on DbState {
  /// Active vendors that sell [p] in [city]. Customers only ever see this
  /// count; who the vendors are stays with O2O Boss, the middleman.
  int productVendorCount(Product p, String city) => vendors
      .where((v) =>
          v.isActive &&
          v.productIds.contains(p.id) &&
          (v.serviceCities.contains(city) || v.city == city))
      .length;

  List<Brand> productBrands(Product p) =>
      brands.where((b) => b.active && b.categoryIds.contains(p.categoryId)).toList();
}

String _cityOf(DbState db, AppUser me) => db.customerById(me.customerId)?.city ?? me.city;

/// Price unit such as "per kW". Spaces are non-breaking so a narrow card
/// wraps the unit as a whole instead of splitting it across lines.
String _unitLabel(AppLocalizations t, PriceUnit u) => switch (u) {
      PriceUnit.each => t.prUnitEach,
      PriceUnit.visit => t.prUnitVisit,
      PriceUnit.kw => t.prUnitKw,
      PriceUnit.sqft => t.prUnitSqft,
      PriceUnit.gram => t.prUnitGram,
      PriceUnit.job => '',
    }.replaceAll(' ', '\u00A0');

String _sortLabel(AppLocalizations t, ProductSort s) => switch (s) {
      ProductSort.popular => t.prSortPopular,
      ProductSort.priceLow => t.prSortPriceLow,
      ProductSort.priceHigh => t.prSortPriceHigh,
      ProductSort.name => t.prSortName,
    };

// ── Products tab ──────────────────────────────────────────────────────────

/// Everything a customer can order through O2O Boss: search, a row of
/// categories, and one button for sorting and filtering. Tapping a product
/// opens its page.
class ProductsScreen extends ConsumerStatefulWidget {
  const ProductsScreen({super.key});

  @override
  ConsumerState<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends ConsumerState<ProductsScreen> {
  String _q = '';
  String _category = 'all';
  _Filters _filters = const _Filters();
  int _searchKey = 0;

  void _clear() => setState(() {
        _q = '';
        _category = 'all';
        _filters = const _Filters();
        _searchKey++;
      });

  Future<void> _openFilters(List<Brand> brands, String city) async {
    final t = context.t;
    final result = await showAppSheet<_Filters>(
      context,
      title: t.prSortFilter,
      builder: (_) => _FilterSheet(initial: _filters, brands: brands, city: city),
    );
    if (result != null) setState(() => _filters = result);
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final db = ref.watch(dbProvider);
    final me = ref.watch(currentUserProvider);
    if (me == null) return const SizedBox.shrink();
    final city = _cityOf(db, me);
    final all = db.products.where((p) => p.active).toList();
    final categories = db.categories
        .where((c) => c.active && all.any((p) => p.categoryId == c.id))
        .toList();
    final brandOptions = db.brands
        .where((b) => b.active && (_category == 'all' || b.categoryIds.contains(_category)))
        .toList();

    final words = _q.toLowerCase().split(RegExp(r'\s+')).where((w) => w.isNotEmpty);
    bool matches(Product p) {
      if (words.isEmpty) return true;
      final text = [
        p.name,
        p.description,
        db.categoryName(p.categoryId),
        ...p.highlights,
        ...db.productBrands(p).map((b) => b.name),
      ].join(' ').toLowerCase();
      return words.every(text.contains);
    }

    final f = _filters;
    final items = all
        .where((p) =>
            (_category == 'all' || p.categoryId == _category) &&
            matches(p) &&
            (!f.nearOnly || db.productVendorCount(p, city) > 0) &&
            (f.brands.isEmpty || db.productBrands(p).any((b) => f.brands.contains(b.id))))
        .toList()
      ..sort((a, b) => switch (f.sort) {
            ProductSort.popular => b.popularity.compareTo(a.popularity),
            ProductSort.priceLow =>
              (a.priceFrom ?? double.infinity).compareTo(b.priceFrom ?? double.infinity),
            ProductSort.priceHigh => (b.priceFrom ?? -1).compareTo(a.priceFrom ?? -1),
            ProductSort.name => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
          });
    final pad = Space.page(context);

    return PageScaffold(
      title: t.navProducts,
      body: ListView(
        padding: const EdgeInsets.only(top: Space.sm, bottom: Space.xxxl + Space.lg),
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: pad),
            child: Row(
              children: [
                Expanded(
                  child: SearchBox(
                    key: ValueKey(_searchKey),
                    hint: t.prSearchHint,
                    onChanged: (v) => setState(() => _q = v.trim()),
                  ),
                ),
                Space.gapSm,
                IconButton(
                  tooltip: t.prSortFilter,
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.surface,
                    side: const BorderSide(color: AppColors.borderStrong),
                    shape: const RoundedRectangleBorder(borderRadius: Corners.mdAll),
                    minimumSize: const Size(Sizes.touch, Sizes.touch),
                  ),
                  onPressed: () => _openFilters(brandOptions, city),
                  icon: Badge(
                    isLabelVisible: f.isActive,
                    smallSize: 9,
                    backgroundColor: AppColors.primary,
                    child: const Icon(Icons.tune),
                  ),
                ),
              ],
            ),
          ),
          Space.gapSm,
          FilterChipsRow<String>(
            items: [
              ('all', t.labelAll, null),
              for (final c in categories) (c.id, c.name, null),
            ],
            selected: _category,
            onSelected: (k) => setState(() {
              _category = k;
              // Brands belong to categories, so an old pick could hide everything.
              _filters = _filters.copyWith(brands: {});
            }),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: pad),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Space.gapSm,
                Text(t.prCount(items.length), style: context.text.bodySmall),
                Space.gapMd,
                if (items.isEmpty)
                  EmptyState(
                    icon: Icons.search_off,
                    title: t.emptyNoResults,
                    body: t.emptyNoResultsBody,
                    actionLabel: t.actionClearFilters,
                    onAction: _clear,
                  )
                else
                  _ProductGrid(items: items),
                Space.gapXl,
                NoteCard(
                  icon: Icons.lightbulb_outline,
                  title: t.prCantFindTitle,
                  text: t.prCantFindBody,
                  action: AppButton.secondary(
                    t.cuNewRequirement,
                    icon: Icons.add,
                    expand: false,
                    onPressed: () => context.push(Routes.refer()),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Filters {
  const _Filters({this.sort = ProductSort.popular, this.nearOnly = false, this.brands = const {}});

  final ProductSort sort;
  final bool nearOnly;
  final Set<String> brands;

  bool get isActive => sort != ProductSort.popular || nearOnly || brands.isNotEmpty;

  _Filters copyWith({ProductSort? sort, bool? nearOnly, Set<String>? brands}) => _Filters(
        sort: sort ?? this.sort,
        nearOnly: nearOnly ?? this.nearOnly,
        brands: brands ?? this.brands,
      );
}

class _FilterSheet extends StatefulWidget {
  const _FilterSheet({required this.initial, required this.brands, required this.city});

  final _Filters initial;
  final List<Brand> brands;
  final String city;

  @override
  State<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<_FilterSheet> {
  late _Filters _f = widget.initial;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(t.prSortTitle, style: context.text.titleSmall),
        Space.gapXs,
        for (final s in ProductSort.values)
          OptionTile(
            label: _sortLabel(t, s),
            selected: _f.sort == s,
            onTap: () => setState(() => _f = _f.copyWith(sort: s)),
          ),
        const Divider(height: Space.xxl),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          value: _f.nearOnly,
          onChanged: (v) => setState(() => _f = _f.copyWith(nearOnly: v)),
          title: Text(t.prFilterNear(widget.city), style: context.text.bodyLarge),
        ),
        if (widget.brands.isNotEmpty) ...[
          const Divider(height: Space.xxl),
          Text(t.prFilterBrands, style: context.text.titleSmall),
          Space.gapMd,
          CheckChips(
            options: [for (final b in widget.brands) (b.id, b.name)],
            selected: _f.brands,
            onToggle: (id) => setState(() {
              final next = {..._f.brands};
              if (!next.remove(id)) next.add(id);
              _f = _f.copyWith(brands: next);
            }),
          ),
        ],
        Space.gapXxl,
        Row(
          children: [
            Expanded(
              child: AppButton.secondary(
                t.actionReset,
                onPressed: () => Navigator.pop(context, const _Filters()),
              ),
            ),
            Space.gapMd,
            Expanded(child: AppButton(t.actionApply, onPressed: () => Navigator.pop(context, _f))),
          ],
        ),
      ],
    );
  }
}

/// Two columns on phones, more on wide screens. Cards in a row share one
/// height so prices line up, however long a name runs in translation.
class _ProductGrid extends StatelessWidget {
  const _ProductGrid({required this.items});

  final List<Product> items;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, c) {
      final columns = (c.maxWidth / 180).floor().clamp(2, 4);
      return Column(
        children: [
          for (var start = 0; start < items.length; start += columns)
            Padding(
              padding: const EdgeInsets.only(bottom: Space.md),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (var i = 0; i < columns; i++) ...[
                      if (i > 0) Space.gapMd,
                      Expanded(
                        child: start + i < items.length
                            ? ProductCard(product: items[start + i])
                            : const SizedBox.shrink(),
                      ),
                    ],
                  ],
                ),
              ),
            ),
        ],
      );
    });
  }
}

class ProductCard extends ConsumerWidget {
  const ProductCard({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final db = ref.watch(dbProvider);
    final p = product;
    final category = db.categoryById(p.categoryId);
    final unit = _unitLabel(t, p.unit);
    return AppCard(
      onTap: () => context.push(Routes.product(p.id)),
      padding: const EdgeInsets.all(Space.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 72,
            width: double.infinity,
            alignment: Alignment.center,
            decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: Corners.mdAll),
            child: Icon(categoryIcon(category?.icon ?? ''), size: 34, color: AppColors.primary),
          ),
          Space.gapMd,
          Text(p.name, style: context.text.titleSmall, maxLines: 2, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 2),
          Text(category?.name ?? '',
              style: context.text.bodySmall, maxLines: 1, overflow: TextOverflow.ellipsis),
          const Spacer(),
          Space.gapSm,
          if (p.priceFrom == null)
            Text(t.prPriceOnQuote, style: context.text.bodySmall)
          else
            Text.rich(
              TextSpan(children: [
                TextSpan(
                  text: t.prFrom(Fmt.money(p.priceFrom!)),
                  style: context.text.labelLarge?.copyWith(fontWeight: FontWeight.w700),
                ),
                if (unit.isNotEmpty) TextSpan(text: ' $unit', style: context.text.bodySmall),
              ]),
            ),
        ],
      ),
    );
  }
}

// ── Product page ──────────────────────────────────────────────────────────

/// One product: what it is, an estimated price, whether it is available in
/// the customer's city, and two actions — ask the O2O Boss team, or order.
/// Vendors are never named here; O2O Boss matches one after the order.
class ProductDetailScreen extends ConsumerWidget {
  const ProductDetailScreen({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final db = ref.watch(dbProvider);
    final me = ref.watch(currentUserProvider);
    final p = db.productById(id);
    if (me == null) return const SizedBox.shrink();
    if (p == null || !p.active) return const NotFoundScreen();
    final category = db.categoryById(p.categoryId);
    final city = _cityOf(db, me);
    final vendorCount = db.productVendorCount(p, city);
    final brands = db.productBrands(p);
    final isCustomer = me.role == UserRole.customer;
    final open = isCustomer
        ? db.enquiriesFor(me)
            .where((e) => e.productId == p.id && !e.status.isEnded && !e.status.isClosed)
            .firstOrNull
        : null;
    final unit = _unitLabel(t, p.unit);

    return PageScaffold(
      title: category?.name ?? t.navProducts,
      bottomBar: isCustomer
          ? StickyActions(children: [
              AppButton.secondary(
                t.prAsk,
                icon: Icons.chat_bubble_outline,
                onPressed: () => _ask(context, ref, p, open),
              ),
              AppButton(
                t.prOrderNow,
                icon: Icons.shopping_bag_outlined,
                onPressed: () => _order(context, p),
              ),
            ])
          : null,
      children: [
        SoftHeroCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GlowIcon(categoryIcon(category?.icon ?? ''), size: 60),
                  Space.gapLg,
                  Expanded(
                    child: Semantics(
                      header: true,
                      child: Text(p.name, style: context.text.titleLarge),
                    ),
                  ),
                ],
              ),
              Space.gapLg,
              if (p.priceFrom == null)
                Text(t.prPriceOnQuote, style: context.text.titleMedium)
              else ...[
                Text.rich(
                  TextSpan(children: [
                    TextSpan(
                      text: p.priceTo == null
                          ? t.prFrom(Fmt.money(p.priceFrom!))
                          : t.prPriceRange(Fmt.money(p.priceFrom!), Fmt.money(p.priceTo!)),
                      style: AppType.money(context),
                    ),
                    if (unit.isNotEmpty) TextSpan(text: '  $unit', style: context.text.bodyMedium),
                  ]),
                ),
                const SizedBox(height: 2),
                Text(t.prPriceNote, style: context.text.bodySmall),
              ],
              Space.gapLg,
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    vendorCount > 0 ? Icons.verified_outlined : Icons.location_searching,
                    size: Sizes.icon,
                    color: vendorCount > 0 ? AppColors.success : AppColors.warningText,
                  ),
                  Space.gapSm,
                  Expanded(
                    child: Text(
                      vendorCount > 0 ? t.prVendorsNear(vendorCount, city) : t.prNotNear(city),
                      style: context.text.bodyMedium,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        if (open != null) ...[
          Space.gapLg,
          NoteCard(
            icon: Icons.assignment_outlined,
            text: t.prOpenRequest(open.id),
            action: AppButton.secondary(
              t.prViewRequest,
              expand: false,
              onPressed: () => context.push(Routes.enquiry(open.id)),
            ),
          ),
        ],
        SectionHeader(t.prAbout),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (p.description.isNotEmpty) Text(p.description, style: context.text.bodyMedium),
              if (p.description.isNotEmpty && p.highlights.isNotEmpty) Space.gapMd,
              for (final h in p.highlights)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.check_circle_outline, size: 18, color: AppColors.success),
                      Space.gapSm,
                      Expanded(child: Text(h, style: context.text.bodyMedium)),
                    ],
                  ),
                ),
            ],
          ),
        ),
        if (brands.isNotEmpty) ...[
          SectionHeader(t.prBrandsAvailable),
          Wrap(
            spacing: Space.sm,
            runSpacing: Space.sm,
            children: [for (final b in brands) StatusPill(b.name)],
          ),
        ],
        SectionHeader(t.prHowTitle),
        AppCard(
          child: StepsList(steps: [
            (t.prHow1Title, t.prHow1Body),
            (t.prHow2Title, t.prHow2Body),
            (t.prHow3Title, t.prHow3Body),
          ]),
        ),
        Space.gapLg,
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.shield_outlined, size: 18, color: AppColors.textSecondary),
            Space.gapSm,
            Expanded(child: Text(t.prPrivacyNote, style: context.text.bodySmall)),
          ],
        ),
      ],
    );
  }

  Future<void> _order(BuildContext context, Product p) async {
    final t = context.t;
    final enquiryId = await showAppSheet<String>(
      context,
      title: t.prOrderTitle(p.name),
      builder: (_) => _OrderSheet(product: p),
    );
    if (enquiryId == null || !context.mounted) return;
    showToast(context, t.prOrderPlaced);
    context.push(Routes.enquiry(enquiryId));
  }

  /// Questions go to the O2O Boss team through the normal enquiry chat, so
  /// back office sees them with everything else and no vendor is involved.
  Future<void> _ask(BuildContext context, WidgetRef ref, Product p, Enquiry? open) async {
    if (open != null) {
      context.push(Routes.chat(open.id, ChatMessage.customerThread));
      return;
    }
    final t = context.t;
    final question = await askText(
      context,
      title: t.prAskTitle(p.name),
      label: t.prAskLabel,
      hint: t.prAskHint,
      subtitle: t.prAskHelp,
      confirmLabel: t.actionSend,
    );
    if (question == null || question.isEmpty || !context.mounted) return;
    final store = ref.read(dbProvider.notifier);
    final id = store.createEnquiry(_draftFor(ref, p, question));
    store.sendMessage(id, ChatMessage.customerThread, question);
    showToast(context, t.toastSent);
    context.push(Routes.chat(id, ChatMessage.customerThread));
  }
}

/// A requirement for [p], filled in from the customer's own profile.
EnquiryDraft _draftFor(WidgetRef ref, Product p, String requirement, {String? brandId}) {
  final me = ref.read(currentUserProvider)!;
  final c = ref.read(dbProvider).customerById(me.customerId);
  return EnquiryDraft(
    customerName: me.name,
    customerPhone: me.phone,
    city: c?.city ?? me.city,
    area: c?.area ?? me.area ?? '',
    pincode: c?.pincode,
    address: c?.address,
    categoryId: p.categoryId,
    productId: p.id,
    brandId: brandId,
    requirement: requirement,
  );
}

/// Short order form: brand, quantity, a note. The address comes from the
/// profile. Placing the order creates a requirement that back office picks
/// up, exactly like one posted from the Requirement tab.
class _OrderSheet extends ConsumerStatefulWidget {
  const _OrderSheet({required this.product});

  final Product product;

  @override
  ConsumerState<_OrderSheet> createState() => _OrderSheetState();
}

class _OrderSheetState extends ConsumerState<_OrderSheet> {
  final _note = TextEditingController();
  int _qty = 1;
  String? _brand;

  Product get _p => widget.product;
  bool get _countable => _p.unit == PriceUnit.each || _p.unit == PriceUnit.visit;

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  Future<void> _place() async {
    final db = ref.read(dbProvider);
    final brand = db.brandById(_brand)?.name;
    final note = _note.text.trim();
    final text = StringBuffer(_countable ? '${_p.name} × $_qty' : _p.name);
    if (brand != null) text.write(' ($brand)');
    if (note.isNotEmpty) text.write('. $note');
    await simulateWork();
    final id = ref.read(dbProvider.notifier)
        .createEnquiry(_draftFor(ref, _p, text.toString(), brandId: _brand));
    if (mounted) Navigator.pop(context, id);
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final db = ref.watch(dbProvider);
    final me = ref.watch(currentUserProvider)!;
    final c = db.customerById(me.customerId);
    final brands = db.productBrands(_p);
    final address = [c?.address, c?.area ?? me.area, c?.city ?? me.city]
        .whereType<String>()
        .where((s) => s.trim().isNotEmpty)
        .join(', ');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (brands.isNotEmpty) ...[
          FieldLabel(t.labelBrand),
          Wrap(
            spacing: Space.sm,
            runSpacing: Space.sm,
            children: [
              for (final (id, label) in [
                (null, t.labelAnyBrand),
                for (final b in brands) (b.id, b.name),
              ])
                ChoiceChip(
                  label: Text(label),
                  selected: _brand == id,
                  labelStyle: context.text.labelMedium
                      ?.copyWith(color: _brand == id ? Colors.white : AppColors.text),
                  onSelected: (_) => setState(() => _brand = id),
                ),
            ],
          ),
          Space.gapLg,
        ],
        if (_countable) ...[
          Row(
            children: [
              Expanded(child: FieldLabel(t.prQuantity)),
              IconButton.outlined(
                tooltip: t.prLess,
                onPressed: _qty > 1 ? () => setState(() => _qty--) : null,
                icon: const Icon(Icons.remove),
              ),
              SizedBox(
                width: 44,
                child: Text('$_qty', textAlign: TextAlign.center, style: context.text.titleMedium),
              ),
              IconButton.outlined(
                tooltip: t.prMore,
                onPressed: _qty < 99 ? () => setState(() => _qty++) : null,
                icon: const Icon(Icons.add),
              ),
            ],
          ),
          Space.gapLg,
        ],
        AppTextField(
          label: t.prNoteLabel,
          controller: _note,
          optional: true,
          hint: t.prNoteHint,
          maxLines: 3,
          minLines: 2,
          textCapitalization: TextCapitalization.sentences,
        ),
        Space.gapMd,
        InfoRow(icon: Icons.location_on_outlined, label: t.prDeliverTo, value: address),
        Space.gapLg,
        AppButton(t.prPlaceOrder, onPressed: _place),
        Space.gapSm,
        Text(t.prOrderFootnote, style: context.text.bodySmall, textAlign: TextAlign.center),
      ],
    );
  }
}
