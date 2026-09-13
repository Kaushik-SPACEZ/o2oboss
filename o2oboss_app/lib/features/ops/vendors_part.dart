import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/routes.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_typography.dart';
import '../../core/data/app_store.dart';
import '../../core/data/db_queries.dart';
import '../../core/data/matching.dart';
import '../../core/data/permissions.dart';
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
import '../../shared/widgets/tones.dart';

/// Vendors on this enquiry, and the matching list to send it to more.
/// Only qualified enquiries can go to vendors (business rule 1).
class VendorsPart extends ConsumerStatefulWidget {
  const VendorsPart({super.key, required this.enquiry});

  final Enquiry enquiry;

  @override
  ConsumerState<VendorsPart> createState() => _VendorsPartState();
}

class _VendorsPartState extends ConsumerState<VendorsPart> {
  final Map<String, int> _picked = {};
  int? _hours;
  bool? _showAll;
  bool _showMore = false;

  Future<void> _send() async {
    final t = context.t;
    final e = widget.enquiry;
    final config = ref.read(configProvider);
    final hours = _hours ?? config.vendorResponseHours;
    final ok = await confirmAction(
      context,
      title: t.vendorsSendTitle(_picked.length),
      body: t.vendorsSendBody('$hours'),
      confirmLabel: t.vendorsSendConfirm,
    );
    if (!ok) return;
    await simulateWork();
    ref.read(dbProvider.notifier).assignVendors(
          e.id,
          [for (final p in _picked.entries) (vendorId: p.key, score: p.value)],
          deadlineHours: hours,
          showMultipleQuotes: _showAll,
        );
    if (!mounted) return;
    setState(_picked.clear);
    showToast(context, t.vendorsSent);
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final db = ref.watch(dbProvider);
    final me = ref.watch(currentUserProvider)!;
    final config = db.config;
    final e = db.enquiryById(widget.enquiry.id) ?? widget.enquiry;
    final canAssign = can(me.role, Perm.assignVendor, config) && !e.status.isClosed;
    final current = db.assignmentsFor(e.id)
        .where((a) => a.status != AssignmentStatus.withdrawn)
        .toList();
    final matches = matchVendors(db, e)
        .where((m) =>
            m.existing == null ||
            m.existing!.status == AssignmentStatus.rejected ||
            m.existing!.status == AssignmentStatus.expired ||
            m.existing!.status == AssignmentStatus.withdrawn)
        .toList();
    final exact = matches.where((m) => m.isExact).toList();
    final others = matches.where((m) => !m.isExact).toList();
    final showMatching = canAssign && e.status.isQualified && !e.status.isWon;

    return PageScaffold(
      title: t.opsPartVendors,
      children: [
        if (!e.status.isQualified && !e.status.isEnded)
          NoteCard(tone: Tone.warning, icon: Icons.lock_clock_outlined, text: t.vendorsNotQualified),
        if (current.isNotEmpty) ...[
          SectionHeader(t.vendorsOnThis, top: Space.sm),
          Gap(children: [for (final a in current) _AssignmentCard(assignment: a, canManage: canAssign)]),
        ],
        if (showMatching) ...[
          SectionHeader(t.vendorsSuggested, top: current.isEmpty ? Space.sm : Space.xxl),
          Text(t.vendorsSuggestedHelp, style: context.text.bodySmall),
          Space.gapMd,
          if (matches.isEmpty)
            AppCard(
              child: EmptyState(
                compact: true,
                icon: Icons.storefront_outlined,
                title: t.vendorsNoneTitle,
                body: t.vendorsNoneBody,
              ),
            )
          else ...[
            Gap(children: [
              for (final m in exact.isEmpty ? others.take(3) : exact)
                _MatchCard(
                  match: m,
                  selected: _picked.containsKey(m.vendor.id),
                  onChanged: (on) => setState(() =>
                      on ? _picked[m.vendor.id] = m.score : _picked.remove(m.vendor.id)),
                ),
            ]),
            if (exact.isNotEmpty && others.isNotEmpty) ...[
              Space.gapSm,
              TextButton.icon(
                onPressed: () => setState(() => _showMore = !_showMore),
                icon: Icon(_showMore ? Icons.expand_less : Icons.expand_more),
                label: Text(_showMore
                    ? t.actionShowLess
                    : t.vendorsShowPartial(others.length)),
              ),
              if (_showMore)
                Gap(children: [
                  for (final m in others)
                    _MatchCard(
                      match: m,
                      selected: _picked.containsKey(m.vendor.id),
                      onChanged: (on) => setState(() =>
                          on ? _picked[m.vendor.id] = m.score : _picked.remove(m.vendor.id)),
                    ),
                ]),
            ],
          ],
          if (_picked.isNotEmpty) ...[
            SectionHeader(t.vendorsOptions),
            ChoiceChips<int>(
              label: t.vendorsDeadline,
              options: [for (final h in [12, 24, 48]) SelectOption(h, t.hoursLeftShort(h))],
              selected: _hours ?? config.vendorResponseHours,
              onSelected: (v) => setState(() => _hours = v),
            ),
            if (_picked.length + current.length > 1) ...[
              Space.gapLg,
              AppCard(
                padding: EdgeInsets.zero,
                child: SwitchListTile(
                  value: _showAll ?? config.multipleQuotationsDefault,
                  onChanged: (v) => setState(() => _showAll = v),
                  title: Text(t.vendorsShowAllQuotes, style: context.text.bodyLarge),
                  subtitle: Text(t.vendorsShowAllQuotesHelp, style: context.text.bodySmall),
                ),
              ),
            ],
          ],
          const SizedBox(height: 80),
        ],
      ],
      bottomBar: showMatching && _picked.isNotEmpty
          ? StickyActions(children: [
              AppButton(t.vendorsSendButton(_picked.length), icon: Icons.send_outlined, onPressed: _send),
            ])
          : null,
    );
  }
}

class _AssignmentCard extends ConsumerWidget {
  const _AssignmentCard({required this.assignment, required this.canManage});

  final VendorAssignment assignment;
  final bool canManage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final db = ref.watch(dbProvider);
    final a = assignment;
    final v = db.vendorById(a.vendorId);
    final store = ref.read(dbProvider.notifier);
    final e = db.enquiryById(a.enquiryId)!;
    final introduced = e.status.index >= EnquiryStatus.customerContact.index;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              InitialsAvatar(v?.companyName ?? '?'),
              Space.gapMd,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(v?.companyName ?? '', style: context.text.titleSmall),
                    Text(
                      a.status == AssignmentStatus.pending
                          ? Fmt.timeLeft(context, a.deadline)
                          : t.vendorsSentOn(Fmt.dayOrDate(context, a.assignedAt)),
                      style: context.text.bodySmall?.copyWith(
                        color: a.status == AssignmentStatus.pending &&
                                a.deadline.isBefore(DateTime.now())
                            ? AppColors.dangerText
                            : null,
                      ),
                    ),
                  ],
                ),
              ),
              StatusPill(assignmentLabel(t, a.status), tone: assignmentTone(a.status)),
            ],
          ),
          if (a.status == AssignmentStatus.accepted &&
              (a.expectedPrice != null || a.expectedDays != null)) ...[
            Space.gapSm,
            Text(
              [
                if (a.expectedPrice != null) t.vendorsExpectedPrice(Fmt.money(a.expectedPrice!)),
                if (a.expectedDays != null) t.vendorsExpectedDays('${a.expectedDays}'),
              ].join('   '),
              style: context.text.bodySmall,
            ),
          ],
          if (a.status == AssignmentStatus.rejected && (a.rejectReason ?? '').isNotEmpty) ...[
            Space.gapSm,
            Text(t.vendorsDeclined(a.rejectReason!), style: context.text.bodySmall),
          ],
          Space.gapSm,
          Wrap(
            spacing: Space.sm,
            children: [
              TextButton.icon(
                onPressed: () => context.push(Routes.chat(e.id, a.vendorId)),
                icon: const Icon(Icons.chat_bubble_outline, size: 18),
                label: Text(t.actionMessage),
              ),
              TextButton.icon(
                onPressed: () => context.push(Routes.vendor(a.vendorId)),
                icon: const Icon(Icons.storefront_outlined, size: 18),
                label: Text(t.vendorsProfile),
              ),
              if (canManage && a.status == AssignmentStatus.accepted && !introduced)
                TextButton.icon(
                  onPressed: () {
                    store.introduceVendor(e.id, a.vendorId);
                    showToast(context, t.vendorsIntroduced);
                  },
                  icon: const Icon(Icons.handshake_outlined, size: 18),
                  label: Text(t.vendorsIntroduce),
                ),
              if (canManage && a.status == AssignmentStatus.pending)
                TextButton.icon(
                  onPressed: () async {
                    final ok = await confirmAction(
                      context,
                      title: t.vendorsWithdrawTitle,
                      body: t.vendorsWithdrawBody(v?.companyName ?? ''),
                      confirmLabel: t.vendorsWithdraw,
                      destructive: true,
                    );
                    if (!ok) return;
                    store.withdrawAssignment(a.id);
                    if (context.mounted) showToast(context, t.vendorsWithdrawn);
                  },
                  icon: const Icon(Icons.undo, size: 18),
                  label: Text(t.vendorsWithdraw),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MatchCard extends StatelessWidget {
  const _MatchCard({required this.match, required this.selected, required this.onChanged});

  final VendorMatch match;
  final bool selected;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final m = match;
    final v = m.vendor;
    Widget reason(bool ok, String label) => Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(ok ? Icons.check_circle : Icons.remove_circle_outline,
                size: 15, color: ok ? AppColors.success : AppColors.textMuted),
            const SizedBox(width: 4),
            Text(label,
                style: context.text.labelSmall?.copyWith(
                    color: ok ? AppColors.successText : AppColors.textSecondary)),
          ],
        );
    return AppCard(
      onTap: () => onChanged(!selected),
      color: selected ? AppColors.primaryLight : null,
      borderColor: selected ? AppColors.primary : null,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Checkbox(value: selected, onChanged: (on) => onChanged(on ?? false)),
          Space.gapXs,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(child: Text(v.companyName, style: context.text.titleSmall)),
                    StatusPill(t.vendorsScore('${m.score}'),
                        tone: m.score >= 85 ? Tone.success : (m.score >= 70 ? Tone.info : Tone.neutral)),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  t.vendorsMeta(v.area, v.rating.toStringAsFixed(1), '${v.responseRate}'),
                  style: context.text.bodySmall,
                ),
                Space.gapSm,
                Wrap(
                  spacing: Space.md,
                  runSpacing: 4,
                  children: [
                    reason(m.productOk, t.vendorsReasonProduct),
                    if (m.brandAsked) reason(m.brandOk, t.vendorsReasonBrand),
                    reason(m.cityOk, t.vendorsReasonCity),
                    reason(m.areaOk, t.vendorsReasonArea),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
