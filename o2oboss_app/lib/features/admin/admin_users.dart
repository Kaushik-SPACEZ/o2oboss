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
import '../../core/data/drafts.dart';
import '../../core/l10n/l10n.dart';
import '../../core/l10n/labels.dart';
import '../../core/models/models.dart';
import '../../core/utils/format.dart';
import '../../shared/widgets/buttons.dart';
import '../../shared/widgets/cards.dart';
import '../../shared/widgets/feedback.dart';
import '../../shared/widgets/inputs.dart';
import '../../shared/widgets/layout.dart';
import '../../shared/widgets/pills.dart';
import '../../shared/widgets/rows.dart';
import '../../shared/widgets/sheets.dart';
import '../../shared/widgets/tones.dart';
import '../common/system_screens.dart';

bool _isAdmin(WidgetRef ref) => ref.watch(currentUserProvider)?.role == UserRole.admin;

/// Every login, searchable and filtered by role.
class AdminUsersScreen extends ConsumerStatefulWidget {
  const AdminUsersScreen({super.key});

  @override
  ConsumerState<AdminUsersScreen> createState() => _AdminUsersScreenState();
}

class _AdminUsersScreenState extends ConsumerState<AdminUsersScreen> {
  String _query = '';
  UserRole? _role;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    if (!_isAdmin(ref)) return const NoAccessView();
    final db = ref.watch(dbProvider);
    final q = _query.toLowerCase();
    final digits = _query.replaceAll(RegExp(r'\D'), '');
    final users = db.users
        .where((u) =>
            (_role == null || u.role == _role) &&
            (q.isEmpty ||
                u.name.toLowerCase().contains(q) ||
                u.loginId.toLowerCase().contains(q) ||
                (digits.length >= 3 && u.phone.contains(digits))))
        .toList()
      ..sort((a, b) => a.name.compareTo(b.name));
    final pad = Space.page(context);

    return PageScaffold(
      title: t.adUsers,
      fab: AddFab(label: t.adAddUserShort, onPressed: () => context.push(Routes.adminNewUser)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(0, Space.sm, 0, Space.huge + Space.xxxl),
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: pad),
            child: SearchBox(onChanged: (v) => setState(() => _query = v.trim())),
          ),
          Space.gapXs,
          FilterChipsRow<String>(
            items: [
              ('all', t.labelAll, db.users.length),
              for (final r in UserRole.values)
                (r.name, roleLabel(t, r), db.users.where((u) => u.role == r).length),
            ],
            selected: _role?.name ?? 'all',
            onSelected: (k) => setState(() => _role = k == 'all' ? null : UserRole.values.byName(k)),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: pad),
            child: users.isEmpty
                ? EmptyState(icon: Icons.person_search_outlined, title: t.emptyNoResults)
                : AppCard(
                    padding: EdgeInsets.zero,
                    child: Column(
                      children: [
                        for (var i = 0; i < users.length; i++) ...[
                          if (i > 0) const Divider(indent: 66),
                          _UserRow(user: users[i]),
                        ],
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _UserRow extends StatelessWidget {
  const _UserRow({required this.user});

  final AppUser user;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final u = user;
    return InkWell(
      onTap: () => context.push(Routes.adminUser(u.id)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Space.lg, vertical: Space.md),
        child: Row(
          children: [
            InitialsAvatar(u.name, size: 38),
            Space.gapMd,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(u.name, style: context.text.titleSmall),
                  Text('${roleLabel(t, u.role)}, ${u.loginId}',
                      style: context.text.bodySmall, maxLines: 1, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
            if (u.status != AccountStatus.active) ...[
              Space.gapSm,
              StatusPill(accountStatusLabel(t, u.status), tone: accountTone(u.status)),
            ],
            const Icon(Icons.chevron_right, color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }
}

/// Create a login for anyone. The generated user ID and password are shown
/// once so the admin can hand them over.
class AdminNewUserScreen extends ConsumerStatefulWidget {
  const AdminNewUserScreen({super.key});

  @override
  ConsumerState<AdminNewUserScreen> createState() => _AdminNewUserScreenState();
}

class _AdminNewUserScreenState extends ConsumerState<AdminNewUserScreen> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _email = TextEditingController();
  final _company = TextEditingController();
  UserRole? _role;
  String? _city;
  String? _area;
  String? _franchise;
  SalesType _salesType = SalesType.company;

  @override
  void dispose() {
    for (final c in [_name, _phone, _email, _company]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _create() async {
    final t = context.t;
    final valid = _form.currentState!.validate();
    if (_role == null || _city == null) {
      showToast(context, t.adPickRoleCity, tone: Tone.warning);
      return;
    }
    if (!valid) return;
    await simulateWork();
    final name = _name.text.trim();
    final login = ref.read(dbProvider.notifier).adminCreateUser(NewUserData(
          role: _role!,
          name: name,
          phone: digitsOnly(_phone.text),
          email: _email.text.trim().isEmpty ? null : _email.text.trim(),
          city: _city!,
          area: _area,
          franchiseId: _franchise,
          salesType: _salesType,
          companyName: _company.text.trim(),
        ));
    if (!mounted) return;
    await showCredentialsSheet(context, name: name, loginId: login.loginId, password: login.password);
    if (mounted) context.pushReplacement(Routes.adminUser(login.userId));
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    if (!_isAdmin(ref)) return const NoAccessView();
    final db = ref.watch(dbProvider);
    final city = _city == null ? null : db.cityByName(_city!);
    String? required(String? v) => (v ?? '').trim().isEmpty ? t.validationRequired : null;

    return PageScaffold(
      title: t.adAddUserTitle,
      bottomBar: StickyActions(children: [AppButton(t.adCreateUser, onPressed: _create)]),
      children: [
        Form(
          key: _form,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SelectField<UserRole>(
                label: t.adRole,
                value: _role,
                required: true,
                options: [for (final r in UserRole.values) SelectOption(r, roleLabel(t, r))],
                onChanged: (r) => setState(() => _role = r),
              ),
              Space.gapLg,
              AppTextField(label: t.labelName, controller: _name, required: true, validator: required),
              Space.gapLg,
              PhoneField(controller: _phone),
              Space.gapLg,
              AppTextField(
                label: t.vbEmail,
                controller: _email,
                optional: true,
                keyboardType: TextInputType.emailAddress,
              ),
              Space.gapLg,
              SelectField<String>(
                label: t.adCity,
                value: _city,
                required: true,
                options: [for (final c in db.cities) SelectOption(c.name, c.name)],
                onChanged: (c) => setState(() {
                  _city = c;
                  _area = null;
                  _franchise ??= db.franchiseForCity(c)?.id;
                }),
              ),
              if (city != null && city.areas.isNotEmpty) ...[
                Space.gapLg,
                SelectField<String>(
                  label: t.adArea,
                  value: _area,
                  optional: true,
                  options: [for (final a in city.areas) SelectOption(a.name, a.name)],
                  onChanged: (a) => setState(() => _area = a),
                ),
              ],
              if (_role == UserRole.sales) ...[
                Space.gapLg,
                SelectField<SalesType>(
                  label: t.adSalesType,
                  value: _salesType,
                  options: [for (final s in SalesType.values) SelectOption(s, salesTypeLabel(t, s))],
                  onChanged: (s) => setState(() => _salesType = s),
                ),
              ],
              if (_role == UserRole.vendor) ...[
                Space.gapLg,
                AppTextField(label: t.adCompany, controller: _company, required: true, validator: required),
              ],
              if (_role == UserRole.franchise ||
                  _role == UserRole.sales ||
                  _role == UserRole.backOffice) ...[
                Space.gapLg,
                SelectField<String>(
                  label: t.adFranchise,
                  value: _franchise,
                  optional: true,
                  options: [for (final f in db.franchises) SelectOption(f.id, f.name)],
                  onChanged: (f) => setState(() => _franchise = f),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

/// Shows a generated user ID and password once, with copy buttons.
Future<void> showCredentialsSheet(
  BuildContext context, {
  required String name,
  required String loginId,
  required String password,
}) {
  final t = context.t;
  return showAppSheet<void>(
    context,
    title: t.adCredsTitle,
    subtitle: t.adCredsSubtitle(name),
    builder: (ctx) => Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _CredRow(label: t.adLoginId, value: loginId),
        Space.gapMd,
        _CredRow(label: t.adPassword, value: password),
        Space.gapMd,
        NoteCard(icon: Icons.lock_outline, text: t.adCredsNote),
        Space.gapXl,
        _CopyAllButton(text: t.adCredsMessage(name, loginId, password)),
        Space.gapMd,
        AppButton(t.adDone, onPressed: () => Navigator.pop(ctx)),
      ],
    ),
  );
}

class _CredRow extends StatefulWidget {
  const _CredRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  State<_CredRow> createState() => _CredRowState();
}

class _CredRowState extends State<_CredRow> {
  bool _copied = false;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return AppCard(
      color: AppColors.input,
      padding: const EdgeInsets.fromLTRB(Space.lg, Space.md, Space.xs, Space.md),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.label, style: context.text.bodySmall),
                const SizedBox(height: 2),
                SelectableText(
                  widget.value,
                  style: context.text.titleMedium
                      ?.copyWith(fontFeatures: const [FontFeature.tabularFigures()]),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: t.adCopy,
            icon: Icon(_copied ? Icons.check : Icons.copy_outlined,
                color: _copied ? AppColors.success : AppColors.textSecondary),
            onPressed: () async {
              await Clipboard.setData(ClipboardData(text: widget.value));
              setState(() => _copied = true);
            },
          ),
        ],
      ),
    );
  }
}

class _CopyAllButton extends StatefulWidget {
  const _CopyAllButton({required this.text});

  final String text;

  @override
  State<_CopyAllButton> createState() => _CopyAllButtonState();
}

class _CopyAllButtonState extends State<_CopyAllButton> {
  bool _copied = false;

  @override
  Widget build(BuildContext context) {
    return AppButton.secondary(
      context.t.adCredsShare,
      icon: _copied ? Icons.check : Icons.share_outlined,
      onPressed: () async {
        await Clipboard.setData(ClipboardData(text: widget.text));
        setState(() => _copied = true);
      },
    );
  }
}

/// One login: who it is, how they sign in, and the admin actions on it.
class AdminUserScreen extends ConsumerWidget {
  const AdminUserScreen({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    if (!_isAdmin(ref)) return const NoAccessView();
    final db = ref.watch(dbProvider);
    final me = ref.watch(currentUserProvider)!;
    final u = db.userById(id);
    if (u == null) return const NotFoundScreen();
    final store = ref.read(dbProvider.notifier);

    Future<void> reset() async {
      final ok = await confirmAction(
        context,
        title: t.adResetTitle,
        body: t.adResetBody(u.name),
        confirmLabel: t.adResetPw,
      );
      if (!ok || !context.mounted) return;
      final password = store.adminResetPassword(u.id);
      await showCredentialsSheet(context, name: u.name, loginId: u.loginId, password: password);
    }

    Future<void> suspend() async {
      final ok = await confirmAction(
        context,
        title: t.adSuspendTitle,
        body: t.adSuspendBody(u.name),
        confirmLabel: t.adSuspend,
        destructive: true,
      );
      if (!ok) return;
      store.setUserStatus(u.id, AccountStatus.suspended);
      if (context.mounted) showToast(context, t.adSuspended, tone: Tone.warning);
    }

    return PageScaffold(
      title: t.adUser,
      children: [
        SoftHeroCard(
          padding: const EdgeInsets.all(Space.lg),
          child: Row(
            children: [
              InitialsAvatar(u.name, size: 56),
              Space.gapMd,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(u.name, style: context.text.titleLarge),
                    Text(roleLabel(t, u.role), style: context.text.bodySmall),
                    Space.gapSm,
                    StatusPill(accountStatusLabel(t, u.status), tone: accountTone(u.status)),
                  ],
                ),
              ),
            ],
          ),
        ),
        SectionHeader(t.adLogin, top: Space.xl),
        AppCard(
          child: Column(
            children: [
              InfoRow(icon: Icons.badge_outlined, label: t.adLoginId, value: u.loginId),
              InfoRow(
                icon: Icons.key_outlined,
                label: t.adPassword,
                value: u.mustChangePassword ? t.adPwTemp : t.adPwSet,
              ),
            ],
          ),
        ),
        SectionHeader(t.adContact, top: Space.xl),
        AppCard(
          child: Column(
            children: [
              InfoRow(icon: Icons.phone_outlined, label: t.labelMobile, value: Fmt.phone(u.phone)),
              InfoRow(icon: Icons.mail_outline, label: t.vbEmail, value: u.email ?? ''),
              InfoRow(
                icon: Icons.place_outlined,
                label: t.labelLocation,
                value: [?u.area, u.city].where((s) => s.isNotEmpty).join(', '),
              ),
              InfoRow(
                icon: Icons.calendar_today_outlined,
                label: t.adCreated,
                value: Fmt.date(context, u.createdAt),
              ),
            ],
          ),
        ),
        if (u.vendorId != null) ...[
          Space.gapMd,
          AppCard(
            padding: EdgeInsets.zero,
            child: NavRow(
              icon: Icons.storefront_outlined,
              title: t.adOpenVendor,
              onTap: () => context.push(Routes.vendor(u.vendorId!)),
            ),
          ),
        ],
        if (u.customerId != null) ...[
          Space.gapMd,
          AppCard(
            padding: EdgeInsets.zero,
            child: NavRow(
              icon: Icons.person_outline,
              title: t.adOpenCustomer,
              onTap: () => context.push(Routes.customer(u.customerId!)),
            ),
          ),
        ],
        Space.gapXl,
        AppButton.secondary(t.adResetPw, icon: Icons.lock_reset, onPressed: reset),
        if (u.id != me.id) ...[
          Space.gapMd,
          if (u.status == AccountStatus.active)
            AppButton.danger(t.adSuspend, onPressed: suspend)
          else
            AppButton(t.adActivate, onPressed: () {
              store.setUserStatus(u.id, AccountStatus.active);
              showToast(context, t.adActivated);
            }),
        ],
      ],
    );
  }
}
