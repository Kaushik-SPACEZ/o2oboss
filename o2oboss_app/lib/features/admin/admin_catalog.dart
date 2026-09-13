import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import '../../shared/widgets/buttons.dart';
import '../../shared/widgets/check_chips.dart';
import '../../shared/widgets/feedback.dart';
import '../../shared/widgets/inputs.dart';
import '../../shared/widgets/layout.dart';
import '../../shared/widgets/pills.dart';
import '../../shared/widgets/sheets.dart';
import '../../shared/widgets/tones.dart';
import '../common/system_screens.dart';
import 'admin_settings.dart';

bool _isAdmin(WidgetRef ref) => ref.watch(currentUserProvider)?.role == UserRole.admin;

String _questionType(AppLocalizations t, QuestionType q) => switch (q) {
      QuestionType.text => t.stQText,
      QuestionType.number => t.stQNumber,
      QuestionType.choice => t.stQChoice,
      QuestionType.yesNo => t.stQYesNo,
      QuestionType.date => t.stQDate,
    };

FloatingActionButton _addButton(String label, VoidCallback onPressed) => FloatingActionButton.extended(
      heroTag: null,
      onPressed: onPressed,
      icon: const Icon(Icons.add),
      label: Text(label),
    );

/// A card of rows separated by dividers.
class _RowsCard extends StatelessWidget {
  const _RowsCard({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          for (var i = 0; i < children.length; i++) ...[
            if (i > 0) const Divider(indent: Space.lg),
            children[i],
          ],
        ],
      ),
    );
  }
}

class _LinkRow extends StatelessWidget {
  const _LinkRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.active = true,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Space.lg, vertical: Space.md),
        child: Row(
          children: [
            IconTile(icon, tone: active ? Tone.info : Tone.neutral, size: 38),
            Space.gapMd,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: context.text.titleSmall),
                  Text(subtitle, style: context.text.bodySmall, maxLines: 2, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
            if (!active) ...[Space.gapSm, StatusPill(context.t.stInactive)],
            const Icon(Icons.chevron_right, color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }
}

// ── Services and their qualification questions ────────────────────────────

class AdminCategoriesScreen extends ConsumerWidget {
  const AdminCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    if (!_isAdmin(ref)) return const NoAccessView();
    final db = ref.watch(dbProvider);

    Future<void> add() async {
      final name = await askText(context, title: t.stAddService, label: t.stServiceName, confirmLabel: t.stAddService);
      if (name == null || name.trim().isEmpty) return;
      final id = ref.read(dbProvider.notifier).saveCategory(ServiceCategory(id: '', name: name.trim(), icon: 'other'));
      if (context.mounted) context.push(Routes.adminCategory(id));
    }

    return PageScaffold(
      title: t.adCategories,
      fab: _addButton(t.stAddService, add),
      children: [
        _RowsCard(children: [
          for (final c in db.categories)
            _LinkRow(
              icon: categoryIcon(c.icon),
              title: c.name,
              subtitle: t.stQuestionsCount(c.questions.length),
              active: c.active,
              onTap: () => context.push(Routes.adminCategory(c.id)),
            ),
        ]),
      ],
    );
  }
}

class AdminCategoryScreen extends ConsumerWidget {
  const AdminCategoryScreen({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    if (!_isAdmin(ref)) return const NoAccessView();
    final c = ref.watch(dbProvider).categoryById(id);
    if (c == null) return const NotFoundScreen();
    final store = ref.read(dbProvider.notifier);
    ServiceCategory latest() => ref.read(dbProvider).categoryById(id)!;

    Future<void> rename() async {
      final name = await askText(context,
          title: t.stRename, label: t.stServiceName, confirmLabel: t.stSave, initial: c.name);
      if (name == null || name.trim().isEmpty) return;
      store.saveCategory(latest().copyWith(name: name.trim()));
    }

    Future<void> editQuestion(QualificationQuestion? q) async {
      final result = await showAppSheet<QualificationQuestion>(
        context,
        title: q == null ? t.stAddQuestion : t.stEditQuestion,
        builder: (_) => _QuestionForm(initial: q),
      );
      if (result == null) return;
      final list = [...latest().questions];
      final i = list.indexWhere((x) => x.id == result.id);
      if (i >= 0) {
        list[i] = result;
      } else {
        list.add(result);
      }
      store.saveCategory(latest().copyWith(questions: list));
      if (context.mounted) showToast(context, t.stSaved);
    }

    Future<void> delete(QualificationQuestion q) async {
      final ok = await confirmAction(context,
          title: t.stDeleteQuestionTitle, body: q.label, confirmLabel: t.stDeleteQuestion, destructive: true);
      if (!ok) return;
      store.saveCategory(latest().copyWith(questions: latest().questions.where((x) => x.id != q.id).toList()));
    }

    return PageScaffold(
      title: c.name,
      actions: [TextButton(onPressed: rename, child: Text(t.stRename))],
      bottomBar: StickyActions(children: [
        AppButton(t.stAddQuestion, icon: Icons.add, onPressed: () => editQuestion(null)),
      ]),
      children: [
        AppCard(
          padding: const EdgeInsets.symmetric(vertical: Space.xs),
          child: SwitchListTile(
            value: c.active,
            onChanged: (v) {
              store.saveCategory(c.copyWith(active: v));
              showToast(context, t.stSaved);
            },
            title: Text(t.stActive),
            subtitle: Text(t.stActiveHelp),
          ),
        ),
        SectionHeader(t.stQuestions, top: Space.xl),
        Text(t.stQuestionsHelp, style: context.text.bodySmall),
        Space.gapSm,
        if (c.questions.isEmpty)
          AppCard(
            child: Text(t.stNoQuestions,
                style: context.text.bodyMedium?.copyWith(color: AppColors.textSecondary)),
          )
        else
          _RowsCard(children: [
            for (var i = 0; i < c.questions.length; i++)
              InkWell(
                onTap: () => editQuestion(c.questions[i]),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(Space.lg, Space.md, Space.xs, Space.md),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(color: AppColors.primaryLight, shape: BoxShape.circle),
                        child: Text('${i + 1}',
                            style: context.text.labelMedium?.copyWith(color: AppColors.primaryDark)),
                      ),
                      Space.gapMd,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(c.questions[i].label, style: context.text.bodyLarge),
                            Text(
                              [
                                _questionType(t, c.questions[i].type),
                                if (c.questions[i].required) t.stRequired,
                              ].join(', '),
                              style: context.text.bodySmall,
                            ),
                            if (c.questions[i].options.isNotEmpty)
                              Text(c.questions[i].options.join(', '), style: context.text.bodySmall),
                          ],
                        ),
                      ),
                      IconButton(
                        tooltip: t.stDeleteQuestion,
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () => delete(c.questions[i]),
                      ),
                    ],
                  ),
                ),
              ),
          ]),
      ],
    );
  }
}

class _QuestionForm extends StatefulWidget {
  const _QuestionForm({this.initial});

  final QualificationQuestion? initial;

  @override
  State<_QuestionForm> createState() => _QuestionFormState();
}

class _QuestionFormState extends State<_QuestionForm> {
  final _form = GlobalKey<FormState>();
  late final _label = TextEditingController(text: widget.initial?.label ?? '');
  late final _options = TextEditingController(text: widget.initial?.options.join(', ') ?? '');
  late QuestionType _type = widget.initial?.type ?? QuestionType.text;
  late bool _required = widget.initial?.required ?? false;

  @override
  void dispose() {
    _label.dispose();
    _options.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return Form(
      key: _form,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppTextField(
            label: t.stQuestionLabel,
            controller: _label,
            required: true,
            validator: (v) => (v ?? '').trim().isEmpty ? t.validationRequired : null,
          ),
          Space.gapLg,
          SelectField<QuestionType>(
            label: t.stQuestionType,
            value: _type,
            options: [for (final q in QuestionType.values) SelectOption(q, _questionType(t, q))],
            onChanged: (q) => setState(() => _type = q),
          ),
          if (_type == QuestionType.choice) ...[
            Space.gapLg,
            AppTextField(
              label: t.stQuestionOptions,
              controller: _options,
              required: true,
              hint: t.stQuestionOptionsHint,
              validator: (v) => (v ?? '').trim().isEmpty ? t.validationRequired : null,
            ),
          ],
          Space.gapSm,
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            value: _required,
            onChanged: (v) => setState(() => _required = v),
            title: Text(t.stQuestionRequired),
          ),
          Space.gapLg,
          AppButton(t.stSave, onPressed: () {
            if (!_form.currentState!.validate()) return;
            Navigator.pop(
              context,
              QualificationQuestion(
                id: widget.initial?.id ?? 'q${DateTime.now().microsecondsSinceEpoch}',
                label: _label.text.trim(),
                type: _type,
                options: _type == QuestionType.choice
                    ? _options.text.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList()
                    : const [],
                required: _required,
              ),
            );
          }),
        ],
      ),
    );
  }
}

// ── Products ──────────────────────────────────────────────────────────────

class AdminProductsScreen extends ConsumerStatefulWidget {
  const AdminProductsScreen({super.key});

  @override
  ConsumerState<AdminProductsScreen> createState() => _AdminProductsScreenState();
}

class _AdminProductsScreenState extends ConsumerState<AdminProductsScreen> {
  String _cat = 'all';

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    if (!_isAdmin(ref)) return const NoAccessView();
    final db = ref.watch(dbProvider);
    final store = ref.read(dbProvider.notifier);
    final products = db.products.where((p) => _cat == 'all' || p.categoryId == _cat).toList()
      ..sort((a, b) => a.name.compareTo(b.name));

    Future<void> add() async {
      final p = await showAppSheet<Product>(
        context,
        title: t.stAddProduct,
        builder: (_) => _ProductForm(categories: db.categories, initialCategory: _cat == 'all' ? null : _cat),
      );
      if (p == null) return;
      store.saveProduct(p);
      if (context.mounted) showToast(context, t.stAdded);
    }

    return PageScaffold(
      title: t.adProducts,
      fab: _addButton(t.stAddProduct, add),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(0, Space.sm, 0, Space.huge + Space.xxxl),
        children: [
          FilterChipsRow<String>(
            items: [
              ('all', t.labelAll, db.products.length),
              for (final c in db.categories)
                (c.id, c.name, db.products.where((p) => p.categoryId == c.id).length),
            ],
            selected: _cat,
            onSelected: (k) => setState(() => _cat = k),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Space.page(context)),
            child: products.isEmpty
                ? EmptyState(icon: Icons.inventory_2_outlined, title: t.emptyTitle)
                : _RowsCard(children: [
                    for (final p in products)
                      SwitchListTile(
                        value: p.active,
                        onChanged: (v) => store.saveProduct(p.copyWith(active: v)),
                        title: Text(p.name),
                        subtitle: Text(db.categoryName(p.categoryId)),
                      ),
                  ]),
          ),
        ],
      ),
    );
  }
}

class _ProductForm extends StatefulWidget {
  const _ProductForm({required this.categories, this.initialCategory});

  final List<ServiceCategory> categories;
  final String? initialCategory;

  @override
  State<_ProductForm> createState() => _ProductFormState();
}

class _ProductFormState extends State<_ProductForm> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _description = TextEditingController();
  late String? _category = widget.initialCategory;

  @override
  void dispose() {
    _name.dispose();
    _description.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return Form(
      key: _form,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SelectField<String>(
            label: t.stService,
            value: _category,
            required: true,
            options: [for (final c in widget.categories) SelectOption(c.id, c.name)],
            onChanged: (c) => setState(() => _category = c),
          ),
          Space.gapLg,
          AppTextField(
            label: t.stProductName,
            controller: _name,
            required: true,
            validator: (v) => (v ?? '').trim().isEmpty ? t.validationRequired : null,
          ),
          Space.gapLg,
          AppTextField(label: t.stDescription, controller: _description, optional: true, maxLines: 2),
          Space.gapXl,
          AppButton(t.stAddProduct, onPressed: () {
            if (!_form.currentState!.validate() || _category == null) return;
            Navigator.pop(
              context,
              Product(
                id: '',
                categoryId: _category!,
                name: _name.text.trim(),
                description: _description.text.trim(),
              ),
            );
          }),
        ],
      ),
    );
  }
}

// ── Brands ────────────────────────────────────────────────────────────────

class AdminBrandsScreen extends ConsumerWidget {
  const AdminBrandsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    if (!_isAdmin(ref)) return const NoAccessView();
    final db = ref.watch(dbProvider);
    final store = ref.read(dbProvider.notifier);
    final brands = [...db.brands]..sort((a, b) => a.name.compareTo(b.name));

    Future<void> add() async {
      final b = await showAppSheet<Brand>(
        context,
        title: t.stAddBrand,
        builder: (_) => _BrandForm(categories: db.categories),
      );
      if (b == null) return;
      store.saveBrand(b);
      if (context.mounted) showToast(context, t.stAdded);
    }

    return PageScaffold(
      title: t.adBrands,
      fab: _addButton(t.stAddBrand, add),
      children: [
        _RowsCard(children: [
          for (final b in brands)
            SwitchListTile(
              value: b.active,
              onChanged: (v) => store.saveBrand(b.copyWith(active: v)),
              title: Text(b.name),
              subtitle: Text(b.categoryIds.map(db.categoryName).join(', ')),
            ),
        ]),
      ],
    );
  }
}

class _BrandForm extends StatefulWidget {
  const _BrandForm({required this.categories});

  final List<ServiceCategory> categories;

  @override
  State<_BrandForm> createState() => _BrandFormState();
}

class _BrandFormState extends State<_BrandForm> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _cats = <String>{};

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return Form(
      key: _form,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppTextField(
            label: t.stBrandName,
            controller: _name,
            required: true,
            validator: (v) => (v ?? '').trim().isEmpty ? t.validationRequired : null,
          ),
          Space.gapLg,
          FieldLabel(t.stBrandServices),
          CheckChips(
            options: [for (final c in widget.categories) (c.id, c.name)],
            selected: _cats,
            onToggle: (id) => setState(() => _cats.contains(id) ? _cats.remove(id) : _cats.add(id)),
          ),
          Space.gapXl,
          AppButton(t.stAddBrand, onPressed: () {
            if (!_form.currentState!.validate()) return;
            Navigator.pop(context, Brand(id: '', name: _name.text.trim(), categoryIds: _cats.toList()));
          }),
        ],
      ),
    );
  }
}

// ── Locations ─────────────────────────────────────────────────────────────

class AdminLocationsScreen extends ConsumerWidget {
  const AdminLocationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    if (!_isAdmin(ref)) return const NoAccessView();
    final db = ref.watch(dbProvider);

    Future<void> add() async {
      final city = await showAppSheet<City>(context, title: t.stAddCity, builder: (_) => const _CityForm());
      if (city == null) return;
      final id = ref.read(dbProvider.notifier).saveCity(city);
      if (context.mounted) context.push('${Routes.adminLocations}/$id');
    }

    return PageScaffold(
      title: t.adLocations,
      fab: _addButton(t.stAddCity, add),
      children: [
        _RowsCard(children: [
          for (final c in db.cities)
            _LinkRow(
              icon: Icons.location_city_outlined,
              title: c.name,
              subtitle: '${c.state}, ${t.stAreasCount(c.areas.length)}',
              onTap: () => context.push('${Routes.adminLocations}/${c.id}'),
            ),
        ]),
      ],
    );
  }
}

class _CityForm extends StatefulWidget {
  const _CityForm();

  @override
  State<_CityForm> createState() => _CityFormState();
}

class _CityFormState extends State<_CityForm> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _state = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _state.dispose();
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
          AppTextField(label: t.stCityName, controller: _name, required: true, validator: required),
          Space.gapLg,
          AppTextField(label: t.stState, controller: _state, required: true, validator: required),
          Space.gapXl,
          AppButton(t.stAddCity, onPressed: () {
            if (!_form.currentState!.validate()) return;
            Navigator.pop(context, City(id: '', name: _name.text.trim(), state: _state.text.trim()));
          }),
        ],
      ),
    );
  }
}

class AdminCityScreen extends ConsumerWidget {
  const AdminCityScreen({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    if (!_isAdmin(ref)) return const NoAccessView();
    final db = ref.watch(dbProvider);
    final c = db.cities.where((x) => x.id == id).firstOrNull;
    if (c == null) return const NotFoundScreen();
    final store = ref.read(dbProvider.notifier);

    Future<void> add() async {
      final area = await showAppSheet<Area>(context, title: t.stAddArea, builder: (_) => const _AreaForm());
      if (area == null) return;
      store.saveCity(c.copyWith(areas: [...c.areas, area]));
      if (context.mounted) showToast(context, t.stAdded);
    }

    Future<void> remove(Area a) async {
      final ok = await confirmAction(context,
          title: t.stRemoveAreaTitle(a.name), confirmLabel: t.stRemoveArea, destructive: true);
      if (!ok) return;
      store.saveCity(c.copyWith(areas: c.areas.where((x) => x.name != a.name).toList()));
    }

    return PageScaffold(
      title: c.name,
      bottomBar: StickyActions(children: [AppButton(t.stAddArea, icon: Icons.add, onPressed: add)]),
      children: [
        Text(c.state, style: context.text.bodyMedium?.copyWith(color: AppColors.textSecondary)),
        Space.gapMd,
        if (c.areas.isEmpty)
          AppCard(child: EmptyState(compact: true, icon: Icons.map_outlined, title: t.stAreasCount(0)))
        else
          _RowsCard(children: [
            for (final a in c.areas)
              Padding(
                padding: const EdgeInsets.fromLTRB(Space.lg, Space.sm, Space.xs, Space.sm),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(a.name, style: context.text.bodyLarge),
                          Text(a.pincode, style: context.text.bodySmall),
                        ],
                      ),
                    ),
                    IconButton(
                      tooltip: t.stRemoveArea,
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () => remove(a),
                    ),
                  ],
                ),
              ),
          ]),
      ],
    );
  }
}

class _AreaForm extends StatefulWidget {
  const _AreaForm();

  @override
  State<_AreaForm> createState() => _AreaFormState();
}

class _AreaFormState extends State<_AreaForm> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _pin = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _pin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return Form(
      key: _form,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppTextField(
            label: t.stAreaName,
            controller: _name,
            required: true,
            validator: (v) => (v ?? '').trim().isEmpty ? t.validationRequired : null,
          ),
          Space.gapLg,
          AppTextField(
            label: t.stPincode,
            controller: _pin,
            required: true,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(6)],
            validator: (v) => (v ?? '').length == 6 ? null : t.stPincodeError,
          ),
          Space.gapXl,
          AppButton(t.stAddArea, onPressed: () {
            if (!_form.currentState!.validate()) return;
            Navigator.pop(context, Area(name: _name.text.trim(), pincode: _pin.text));
          }),
        ],
      ),
    );
  }
}

// ── Franchises ────────────────────────────────────────────────────────────

class AdminFranchisesScreen extends ConsumerWidget {
  const AdminFranchisesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    if (!_isAdmin(ref)) return const NoAccessView();
    final db = ref.watch(dbProvider);

    Future<void> add() async {
      final name = await askText(context,
          title: t.stAddFranchise, label: t.stFranchiseName, confirmLabel: t.stAddFranchise);
      if (name == null || name.trim().isEmpty) return;
      final id = ref
          .read(dbProvider.notifier)
          .saveFranchise(Franchise(id: '', name: name.trim(), createdAt: DateTime.now()));
      if (context.mounted) context.push(Routes.adminFranchise(id));
    }

    return PageScaffold(
      title: t.adFranchises,
      fab: _addButton(t.stAddFranchise, add),
      children: [
        _RowsCard(children: [
          for (final f in db.franchises)
            _LinkRow(
              icon: Icons.map_outlined,
              title: f.name,
              subtitle: [
                if (f.cities.isNotEmpty) f.cities.join(', '),
                f.headUserId == null ? t.stNoHead : db.userName(f.headUserId),
              ].join('. '),
              active: f.active,
              onTap: () => context.push(Routes.adminFranchise(f.id)),
            ),
        ]),
      ],
    );
  }
}

class AdminFranchiseScreen extends ConsumerWidget {
  const AdminFranchiseScreen({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    if (!_isAdmin(ref)) return const NoAccessView();
    final db = ref.watch(dbProvider);
    final f = db.franchiseById(id);
    if (f == null) return const NotFoundScreen();
    final store = ref.read(dbProvider.notifier);
    final share = f.sharePercent ?? db.config.franchiseSharePercent;

    Future<void> rename() async {
      final name = await askText(context,
          title: t.stRename, label: t.stFranchiseName, confirmLabel: t.stSave, initial: f.name);
      if (name == null || name.trim().isEmpty) return;
      store.saveFranchise(f.copyWith(name: name.trim()));
    }

    return PageScaffold(
      title: f.name,
      actions: [TextButton(onPressed: rename, child: Text(t.stRename))],
      children: [
        AppCard(
          padding: const EdgeInsets.symmetric(vertical: Space.xs),
          child: SwitchListTile(
            value: f.active,
            onChanged: (v) {
              store.saveFranchise(f.copyWith(active: v));
              showToast(context, t.stSaved);
            },
            title: Text(t.stActive),
          ),
        ),
        SectionHeader(t.stHead, top: Space.xl),
        SelectField<String>(
          label: t.stHead,
          value: f.headUserId,
          optional: true,
          options: [
            for (final u in db.usersWithRole(UserRole.franchise)) SelectOption(u.id, u.name),
          ],
          onChanged: (u) {
            store.saveFranchise(f.copyWith(headUserId: u));
            showToast(context, t.stSaved);
          },
        ),
        SectionHeader(t.frCities, top: Space.xl),
        CheckChips(
          options: [for (final c in db.cities) (c.name, c.name)],
          selected: f.cities.toSet(),
          onToggle: (name) => store.saveFranchise(f.copyWith(
            cities: f.cities.contains(name)
                ? f.cities.where((c) => c != name).toList()
                : [...f.cities, name],
          )),
        ),
        SectionHeader(t.stFranchisePercent, top: Space.xl),
        AppCard(
          padding: EdgeInsets.zero,
          child: NumberStepRow(
            label: t.stFranchisePercent,
            value: share,
            shown: Fmt.percent(share),
            min: 0,
            max: 10,
            step: 0.25,
            onChanged: (v) => store.saveFranchise(f.copyWith(sharePercent: v)),
          ),
        ),
        Space.gapSm,
        Text(t.stShareDefault(Fmt.percent(db.config.franchiseSharePercent)), style: context.text.bodySmall),
      ],
    );
  }
}
