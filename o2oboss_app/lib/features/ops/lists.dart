import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/routes.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_typography.dart';
import '../../core/data/app_store.dart';
import '../../core/data/db_queries.dart';
import '../../core/data/permissions.dart';
import '../../core/l10n/l10n.dart';
import '../../core/l10n/labels.dart';
import '../../core/models/models.dart';
import '../../core/utils/format.dart';
import '../../shared/widgets/buttons.dart';
import '../../shared/widgets/cards.dart';
import '../../shared/widgets/enquiry_card.dart';
import '../../shared/widgets/feedback.dart';
import '../../shared/widgets/inputs.dart';
import '../../shared/widgets/layout.dart';
import '../../shared/widgets/pills.dart';
import '../../shared/widgets/rows.dart';
import '../../shared/widgets/sheets.dart';
import '../../shared/widgets/tones.dart';
import '../common/earnings_screen.dart';
import '../common/system_screens.dart';
import '../quotation/quotation_card.dart';
import '../visits/visit_widgets.dart';
import 'commission_part.dart';
import 'info_parts.dart';

/// IDs of every enquiry the person may see.
Set<String> visibleEnquiryIds(DbState db, AppUser me) =>
    db.enquiriesFor(me).map((e) => e.id).toSet();

/// A page with a row of filter chips and a list under it.
class _FilteredList<T> extends StatefulWidget {
  const _FilteredList({
    required this.title,
    required this.filters,
    required this.items,
    required this.itemBuilder,
    required this.emptyIcon,
    this.initial,
  });

  final String title;
  final List<(String, String, bool Function(T))> filters;
  final List<T> items;
  final Widget Function(T item) itemBuilder;
  final IconData emptyIcon;
  final String? initial;

  @override
  State<_FilteredList<T>> createState() => _FilteredListState<T>();
}

class _FilteredListState<T> extends State<_FilteredList<T>> {
  late String _key = widget.initial ?? widget.filters.first.$1;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final filter = widget.filters.firstWhere((f) => f.$1 == _key, orElse: () => widget.filters.first);
    final shown = widget.items.where(filter.$3).toList();
    return PageScaffold(
      title: widget.title,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(0, Space.sm, 0, Space.xxxl),
        children: [
          FilterChipsRow<String>(
            items: [
              for (final f in widget.filters) (f.$1, f.$2, widget.items.where(f.$3).length),
            ],
            selected: filter.$1,
            onSelected: (v) => setState(() => _key = v),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Space.page(context)),
            child: shown.isEmpty
                ? EmptyState(icon: widget.emptyIcon, title: t.emptyTitle)
                : Gap(children: [for (final i in shown) widget.itemBuilder(i)]),
          ),
        ],
      ),
    );
  }
}

class AppointmentsListScreen extends ConsumerWidget {
  const AppointmentsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final db = ref.watch(dbProvider);
    final me = ref.watch(currentUserProvider)!;
    final ids = visibleEnquiryIds(db, me);
    final now = DateTime.now();
    final items = db.appointments
        .where((a) => ids.contains(a.enquiryId) &&
            (me.role != UserRole.vendor || a.vendorId == me.vendorId))
        .toList()
      ..sort((a, b) => a.at.compareTo(b.at));
    return _FilteredList<Appointment>(
      title: t.listVisits,
      emptyIcon: Icons.event_outlined,
      items: items,
      filters: [
        ('upcoming', t.upcoming, (a) => a.status.isOpen && a.at.isAfter(now.subtract(const Duration(hours: 3)))),
        ('confirm', t.aptPendingConfirmation, (a) => a.status == AppointmentStatus.pendingConfirmation),
        ('past', t.listPast, (a) => !a.status.isOpen || a.at.isBefore(now)),
      ],
      itemBuilder: (a) => VisitCard(appointment: a, showEnquiry: true),
    );
  }
}

class QuotationsListScreen extends ConsumerWidget {
  const QuotationsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final db = ref.watch(dbProvider);
    final me = ref.watch(currentUserProvider)!;
    final ids = visibleEnquiryIds(db, me);
    final items = [
      for (final id in ids) ...db.currentQuotations(id),
    ].where((q) => switch (me.role) {
          UserRole.vendor => true,
          UserRole.customer => q.status.isWithCustomer,
          _ => q.status != QuotationStatus.draft,
        }).toList()
      ..sort((a, b) => (b.submittedAt ?? b.createdAt).compareTo(a.submittedAt ?? a.createdAt));
    return _FilteredList<Quotation>(
      title: t.navQuotations,
      emptyIcon: Icons.request_quote_outlined,
      items: items,
      filters: me.role == UserRole.customer
          ? [
              ('decide', t.cuQuotesToDecide,
                  (q) => q.status == QuotationStatus.sent || q.status == QuotationStatus.viewed),
              ('accepted', t.quoteAccepted, (q) => q.status == QuotationStatus.accepted),
              ('all', t.labelAll, (_) => true),
            ]
          : [
        if (me.role == UserRole.vendor) ...[
          ('draft', t.vnQuotesDrafts, (q) => q.status == QuotationStatus.draft),
          ('checking', t.vnQuotesChecking, (q) => q.status == QuotationStatus.submitted),
        ] else
          ('review', t.listToReview, (q) => q.status == QuotationStatus.submitted),
        ('customer', t.listWithCustomer, (q) => q.status == QuotationStatus.sent || q.status == QuotationStatus.viewed),
        ('changes', t.quoteRevisionRequested, (q) => q.status == QuotationStatus.revisionRequested),
        ('accepted', t.quoteAccepted, (q) => q.status == QuotationStatus.accepted),
        ('all', t.labelAll, (_) => true),
      ],
      itemBuilder: (q) => QuotationCard(quotation: q, showEnquiry: true),
    );
  }
}

class ProjectsListScreen extends ConsumerWidget {
  const ProjectsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final db = ref.watch(dbProvider);
    final me = ref.watch(currentUserProvider)!;
    final ids = visibleEnquiryIds(db, me);
    final items = db.projects
        .where((p) => ids.contains(p.enquiryId) &&
            (me.role != UserRole.vendor || p.vendorId == me.vendorId))
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return _FilteredList<Project>(
      title: me.role == UserRole.customer ? t.navOrders : t.listProjects,
      emptyIcon: Icons.construction_outlined,
      items: items,
      filters: [
        ('active', t.listActive, (p) => p.status == ProjectStatus.inProgress || p.status == ProjectStatus.notStarted || p.status == ProjectStatus.onHold),
        ('completed', t.completed, (p) => p.status == ProjectStatus.completed),
        ('all', t.labelAll, (_) => true),
      ],
      itemBuilder: (p) => ProjectCard(project: p),
    );
  }
}

class ProjectCard extends ConsumerWidget {
  const ProjectCard({super.key, required this.project});

  final Project project;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final db = ref.watch(dbProvider);
    final me = ref.watch(currentUserProvider)!;
    final p = project;
    final e = db.enquiryById(p.enquiryId);
    final pay = db.paymentStatusOf(p, DateTime.now());
    return AppCard(
      onTap: () => context.push(Routes.project(p.id)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(e == null ? p.id : db.enquiryTitle(e), style: context.text.titleSmall),
                    Text(
                      me.role == UserRole.vendor
                          ? '${p.id}, ${e?.area ?? ''}'
                          : '${p.id}, ${db.vendorName(p.vendorId)}',
                      style: context.text.bodySmall,
                    ),
                  ],
                ),
              ),
              StatusPill(projectStatusLabel(t, p.status), tone: projectTone(p.status)),
            ],
          ),
          Space.gapMd,
          ClipRRect(
            borderRadius: Corners.pillAll,
            child: LinearProgressIndicator(value: p.progress, minHeight: 6),
          ),
          Space.gapSm,
          Row(
            children: [
              Expanded(
                child: Text(t.jdWork('${p.doneCount}', '${p.milestones.length}'),
                    style: context.text.labelSmall),
              ),
              StatusPill(paymentStatusLabel(t, pay), tone: paymentTone(pay)),
            ],
          ),
        ],
      ),
    );
  }
}

class PaymentsListScreen extends ConsumerWidget {
  const PaymentsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final db = ref.watch(dbProvider);
    final me = ref.watch(currentUserProvider)!;
    final ids = visibleEnquiryIds(db, me);
    final projects = db.projects
        .where((p) => ids.contains(p.enquiryId) &&
            (me.role != UserRole.vendor || p.vendorId == me.vendorId))
        .toList();
    final now = DateTime.now();
    final due = projects.where((p) => db.paymentStatusOf(p, now) != PaymentStatus.fullyPaid).toList()
      ..sort((a, b) => (a.paymentDueDate ?? a.expectedCompletion)
          .compareTo(b.paymentDueDate ?? b.expectedCompletion));
    final received = [
      for (final p in projects) ...db.paymentsFor(p.id),
    ]..sort((a, b) => b.at.compareTo(a.at));
    final outstanding = due.fold<double>(0, (s, p) => s + (p.finalValue - db.paidFor(p.id)));
    final collected = received.fold<double>(0, (s, r) => s + r.amount);

    return PageScaffold(
      title: t.listPayments,
      children: [
        if (!db.config.paymentTrackingEnabled) ...[
          NoteCard(tone: Tone.warning, text: t.paymentsOff),
          Space.gapLg,
        ],
        TileGrid(children: [
          _Stat(label: t.paymentsOutstanding, value: Fmt.moneyCompact(outstanding), tone: Tone.warning),
          _Stat(label: t.paymentsCollected, value: Fmt.moneyCompact(collected), tone: Tone.success),
        ]),
        SectionHeader(t.paymentsDue),
        if (due.isEmpty)
          AppCard(child: EmptyState(compact: true, icon: Icons.check_circle_outline, title: t.paymentsNoneDue))
        else
          Gap(children: [for (final p in due) ProjectCard(project: p)]),
        SectionHeader(t.paymentsReceived),
        if (received.isEmpty)
          AppCard(child: EmptyState(compact: true, icon: Icons.currency_rupee, title: t.emptyTitle))
        else
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                for (var i = 0; i < received.length; i++) ...[
                  if (i > 0) const Divider(indent: Space.lg),
                  ListTile(
                    title: Text(Fmt.money(received[i].amount), style: AppType.money(context)),
                    subtitle: Text(
                      '${db.projectById(received[i].projectId)?.enquiryId ?? ''}, '
                      '${methodLabel(t, received[i].method)}, ${Fmt.date(context, received[i].at)}',
                      style: context.text.bodySmall,
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => context.push(Routes.project(received[i].projectId)),
                  ),
                ],
              ],
            ),
          ),
      ],
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value, required this.tone});

  final String label;
  final String value;
  final Tone tone;

  @override
  Widget build(BuildContext context) => AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: context.text.bodySmall),
            const SizedBox(height: 4),
            Text(value, style: AppType.kpi(context).copyWith(color: tone.foreground)),
          ],
        ),
      );
}

class CallsListScreen extends ConsumerWidget {
  const CallsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final db = ref.watch(dbProvider);
    final me = ref.watch(currentUserProvider)!;
    final ids = visibleEnquiryIds(db, me);
    final calls = db.calls
        .where((c) => c.byUserId == me.id || (me.role != UserRole.backOffice && ids.contains(c.enquiryId)))
        .toList()
      ..sort((a, b) => b.at.compareTo(a.at));
    return PageScaffold(
      title: t.listCalls,
      children: [
        if (calls.isEmpty)
          EmptyState(icon: Icons.call_outlined, title: t.callNone)
        else
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                for (var i = 0; i < calls.length; i++) ...[
                  if (i > 0) const Divider(indent: 66),
                  CallRow(call: calls[i], showEnquiry: true),
                ],
              ],
            ),
          ),
      ],
    );
  }
}

/// Admin sees and manages every commission; everyone else sees their own.
class CommissionsScreen extends ConsumerWidget {
  const CommissionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final db = ref.watch(dbProvider);
    final me = ref.watch(currentUserProvider)!;
    if (!can(me.role, Perm.approveCommission, db.config)) return const EarningsScreen();
    final items = [...db.commissions]..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return _FilteredList<Commission>(
      title: t.opsPartCommission,
      emptyIcon: Icons.account_balance_wallet_outlined,
      items: items,
      filters: [
        ('todo', t.listNeedsAction, (c) =>
            c.status == CommissionStatus.pending ||
            c.status == CommissionStatus.approved ||
            c.status == CommissionStatus.payable),
        ('hold', t.comOnHold, (c) => c.status == CommissionStatus.onHold),
        ('paid', t.comPaid, (c) => c.status == CommissionStatus.paid),
        ('all', t.labelAll, (_) => true),
      ],
      itemBuilder: (c) => CommissionManageCard(commission: c, canApprove: true, showEnquiry: true),
    );
  }
}

class CustomersListScreen extends ConsumerStatefulWidget {
  const CustomersListScreen({super.key});

  @override
  ConsumerState<CustomersListScreen> createState() => _CustomersListScreenState();
}

class _CustomersListScreenState extends ConsumerState<CustomersListScreen> {
  String _q = '';

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final db = ref.watch(dbProvider);
    final me = ref.watch(currentUserProvider)!;
    final enquiries = db.enquiriesFor(me);
    final ids = enquiries.map((e) => e.customerId).toSet();
    final q = _q.toLowerCase();
    final list = db.customers
        .where((c) => (me.role == UserRole.admin || ids.contains(c.id)) &&
            (q.isEmpty || c.name.toLowerCase().contains(q) || c.phone.contains(q)))
        .toList()
      ..sort((a, b) => a.name.compareTo(b.name));
    return PageScaffold(
      title: t.searchCustomers,
      children: [
        SearchBox(onChanged: (v) => setState(() => _q = v.trim())),
        Space.gapMd,
        if (list.isEmpty)
          EmptyState(icon: Icons.people_outline, title: t.emptyNoResults)
        else
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                for (var i = 0; i < list.length; i++) ...[
                  if (i > 0) const Divider(indent: 66),
                  NavRow(
                    icon: Icons.person_outline,
                    title: list[i].name,
                    subtitle: '${Fmt.phone(list[i].phone)}, ${list[i].city}',
                    badge: 0,
                    trailing: Text(t.countEnquiries(
                        db.enquiries.where((e) => e.customerId == list[i].id).length),
                        style: context.text.labelSmall),
                    onTap: () => context.push(Routes.customer(list[i].id)),
                  ),
                ],
              ],
            ),
          ),
      ],
    );
  }
}

class CustomerDetailScreen extends ConsumerWidget {
  const CustomerDetailScreen({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final db = ref.watch(dbProvider);
    final me = ref.watch(currentUserProvider)!;
    final c = db.customerById(id);
    if (c == null) return const NotFoundScreen();
    final enquiries = db.enquiriesFor(me).where((e) => e.customerId == id).toList();
    if (enquiries.isEmpty && me.role != UserRole.admin) return const NoAccessView();
    return PageScaffold(
      title: c.name,
      children: [
        AppCard(
          child: Column(
            children: [
              InfoRow(icon: Icons.phone_outlined, label: t.labelMobile, value: Fmt.phone(c.phone)),
              if ((c.email ?? '').isNotEmpty)
                InfoRow(icon: Icons.email_outlined, label: t.labelEmail, value: c.email!),
              InfoRow(
                icon: Icons.place_outlined,
                label: t.labelAddress,
                value: [if (c.address.isNotEmpty) c.address, c.area, c.city, ?c.pincode].join(', '),
              ),
              InfoRow(icon: Icons.event_outlined, label: t.listCustomerSince, value: Fmt.date(context, c.createdAt)),
            ],
          ),
        ),
        SectionHeader(t.navEnquiries),
        Gap(children: [for (final e in enquiries) EnquiryCard(enquiry: e)]),
      ],
    );
  }
}

class VendorsListScreen extends ConsumerWidget {
  const VendorsListScreen({super.key, this.initialFilter});

  final String? initialFilter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final db = ref.watch(dbProvider);
    final me = ref.watch(currentUserProvider)!;
    final items = db.vendors
        .where((v) => me.role != UserRole.franchise || v.franchiseId == me.franchiseId)
        .toList()
      ..sort((a, b) => a.companyName.compareTo(b.companyName));
    return _FilteredList<Vendor>(
      title: t.searchVendors,
      emptyIcon: Icons.storefront_outlined,
      initial: initialFilter,
      items: items,
      filters: [
        ('active', t.accActive, (v) => v.status == AccountStatus.active),
        ('pending', t.listAwaitingApproval,
            (v) => v.status == AccountStatus.pending || v.status == AccountStatus.underReview),
        ('stopped', t.listStopped,
            (v) => v.status == AccountStatus.suspended || v.status == AccountStatus.rejected),
        ('all', t.labelAll, (_) => true),
      ],
      itemBuilder: (v) => VendorCard(vendor: v),
    );
  }
}

class VendorCard extends ConsumerWidget {
  const VendorCard({super.key, required this.vendor});

  final Vendor vendor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final db = ref.watch(dbProvider);
    final v = vendor;
    return AppCard(
      onTap: () => context.push(Routes.vendor(v.id)),
      child: Row(
        children: [
          InitialsAvatar(v.companyName),
          Space.gapMd,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(v.companyName, style: context.text.titleSmall),
                Text(
                  '${v.categoryIds.map(db.categoryName).take(2).join(', ')}, ${v.city}',
                  style: context.text.bodySmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (v.isActive)
                  Text(t.vendorsMeta(v.area, v.rating.toStringAsFixed(1), '${v.responseRate}'),
                      style: context.text.labelSmall),
              ],
            ),
          ),
          Space.gapSm,
          StatusPill(accountStatusLabel(t, v.status), tone: accountTone(v.status)),
        ],
      ),
    );
  }
}

/// A vendor's profile for operations roles, with approval actions for admin.
class VendorDetailScreen extends ConsumerWidget {
  const VendorDetailScreen({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final db = ref.watch(dbProvider);
    final me = ref.watch(currentUserProvider)!;
    final store = ref.read(dbProvider.notifier);
    final v = db.vendorById(id);
    if (v == null) return const NotFoundScreen();
    if (me.role == UserRole.franchise && v.franchiseId != me.franchiseId) return const NoAccessView();
    final canApprove = can(me.role, Perm.approveVendors, db.config);
    final referrals = db.assignments.where((a) => a.vendorId == id).toList();
    final won = referrals.where((a) => db.enquiryById(a.enquiryId)?.status.isWon ?? false).length;
    final login = db.vendorUsers(id).firstOrNull;

    Future<void> reject() async {
      final reason = await askReason(
        context,
        title: t.vendorReject,
        reasons: [t.vendorRejectDocs, t.vendorRejectArea, t.vendorRejectQuality],
        confirmLabel: t.vendorReject,
        destructive: true,
      );
      if (reason == null) return;
      store.rejectVendor(id, reason);
      if (context.mounted) showToast(context, t.vendorRejected, tone: Tone.warning);
    }

    Future<void> suspend() async {
      final reason = await askText(context, title: t.vendorSuspend, label: t.labelReason, confirmLabel: t.vendorSuspend);
      if (reason == null) return;
      store.suspendVendor(id, reason);
      if (context.mounted) showToast(context, t.vendorSuspended, tone: Tone.warning);
    }

    final pending = v.status == AccountStatus.pending || v.status == AccountStatus.underReview;

    return PageScaffold(
      title: v.companyName,
      children: [
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  InitialsAvatar(v.companyName, size: 52),
                  Space.gapMd,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(v.companyName, style: context.text.titleMedium),
                        Text(v.contactPerson, style: context.text.bodySmall),
                      ],
                    ),
                  ),
                  StatusPill(accountStatusLabel(t, v.status), tone: accountTone(v.status)),
                ],
              ),
              if (v.isActive) ...[
                Space.gapLg,
                TileGrid(minItemWidth: 90, children: [
                  _Stat(label: t.vendorRating, value: v.rating.toStringAsFixed(1), tone: Tone.warning),
                  _Stat(label: t.vendorResponse, value: '${v.responseRate}%', tone: Tone.info),
                  _Stat(label: t.vendorReferrals, value: '${referrals.length}', tone: Tone.neutral),
                  _Stat(label: t.salesKpiWon, value: '$won', tone: Tone.success),
                ]),
              ],
            ],
          ),
        ),
        if (pending && canApprove) ...[
          Space.gapMd,
          NoteCard(
            tone: Tone.warning,
            icon: Icons.pending_actions,
            title: t.vendorAwaiting,
            text: t.vendorAwaitingBody,
          ),
        ],
        SectionHeader(t.vendorBusiness),
        AppCard(
          child: Column(
            children: [
              InfoRow(icon: Icons.phone_outlined, label: t.labelMobile, value: Fmt.phone(v.phone)),
              if ((v.email ?? '').isNotEmpty) InfoRow(icon: Icons.email_outlined, label: t.labelEmail, value: v.email!),
              InfoRow(icon: Icons.place_outlined, label: t.labelAddress, value: '${v.address}, ${v.area}, ${v.city}'),
              InfoRow(icon: Icons.category_outlined, label: t.labelCategoriesYouServe,
                  value: v.categoryIds.map(db.categoryName).join(', ')),
              if (v.brandIds.isNotEmpty)
                InfoRow(icon: Icons.sell_outlined, label: t.labelBrandsYouSupply,
                    value: v.brandIds.map(db.brandName).join(', ')),
              InfoRow(icon: Icons.map_outlined, label: t.labelServiceCities,
                  value: [...v.serviceCities, ...v.serviceAreas].join(', ')),
              if ((v.gstin ?? '').isNotEmpty) InfoRow(icon: Icons.receipt_long_outlined, label: t.labelGstin, value: v.gstin!),
              if (v.commercialNote.isNotEmpty)
                InfoRow(icon: Icons.handshake_outlined, label: t.vendorTerms, value: v.commercialNote),
              InfoRow(icon: Icons.badge_outlined, label: t.labelUserId, value: login?.loginId ?? t.notSet),
              InfoRow(icon: Icons.event_outlined, label: t.listCustomerSince, value: Fmt.date(context, v.joinedAt)),
            ],
          ),
        ),
        SectionHeader(t.vendorDocuments),
        if (v.documents.isEmpty)
          AppCard(child: EmptyState(compact: true, icon: Icons.folder_open, title: t.vendorNoDocs))
        else
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                for (var i = 0; i < v.documents.length; i++) ...[
                  if (i > 0) const Divider(indent: 66),
                  NavRow(
                    icon: Icons.description_outlined,
                    title: docKindLabel(t, v.documents[i].kind),
                    subtitle: v.documents[i].name,
                    tone: v.documents[i].verified ? Tone.success : Tone.warning,
                    trailing: v.documents[i].verified
                        ? StatusPill(t.vendorDocVerified, tone: Tone.success)
                        : (canApprove
                            ? TextButton(
                                onPressed: () {
                                  store.verifyVendorDocument(id, i);
                                  showToast(context, t.vendorDocVerifiedToast);
                                },
                                child: Text(t.vendorVerifyDoc),
                              )
                            : StatusPill(t.vendorDocPending, tone: Tone.warning)),
                  ),
                ],
              ],
            ),
          ),
        const SizedBox(height: 80),
      ],
      bottomBar: !canApprove
          ? null
          : pending
              ? StickyActions(children: [
                  AppButton.secondary(t.vendorReject, onPressed: reject),
                  AppButton(t.vendorApprove, kind: ButtonKind.success, onPressed: () {
                    store.approveVendor(id);
                    showToast(context, t.vendorApproved);
                  }),
                ])
              : v.status == AccountStatus.active
                  ? StickyActions(children: [
                      AppButton.secondary(t.vendorSuspend, onPressed: suspend),
                    ])
                  : StickyActions(children: [
                      AppButton(t.vendorReactivate, onPressed: () {
                        store.approveVendor(id);
                        showToast(context, t.vendorApproved);
                      }),
                    ]),
    );
  }
}
