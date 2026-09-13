import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/app_spacing.dart';
import '../../core/data/app_store.dart';
import '../../core/data/db_queries.dart';
import '../../core/l10n/l10n.dart';
import '../../core/models/models.dart';
import 'enquiry_card.dart';
import 'feedback.dart';
import 'inputs.dart';

/// Remembers the chosen filter of a list while the app is open, so Home
/// tiles can open a list already filtered ("Won", "Needs action"…).
class ListFilter extends Notifier<String> {
  ListFilter(this.list);

  final String list;

  @override
  String build() => 'all';

  void set(String value) => state = value;
}

final listFilterProvider =
    NotifierProvider.family<ListFilter, String, String>(ListFilter.new);

/// One filter chip of an enquiry list.
class EnquiryFilter {
  const EnquiryFilter(this.key, this.label, this.test);

  final String key;
  final String label;
  final bool Function(Enquiry e) test;
}

/// Search box, a row of filter chips and the matching enquiry cards.
/// Shared by every role's enquiry list; each role passes its own filters.
class EnquiryListBody extends ConsumerStatefulWidget {
  const EnquiryListBody({
    super.key,
    required this.listKey,
    required this.filters,
    this.source,
    this.empty,
  });

  /// Identifies the list for [listFilterProvider].
  final String listKey;
  final List<EnquiryFilter> filters;

  /// Enquiries to show. Defaults to everything the signed-in person may see.
  final List<Enquiry> Function(DbState db, AppUser me)? source;

  /// Shown when the person has no enquiries at all.
  final Widget? empty;

  @override
  ConsumerState<EnquiryListBody> createState() => _EnquiryListBodyState();
}

class _EnquiryListBodyState extends ConsumerState<EnquiryListBody> {
  String _query = '';

  bool _matches(DbState db, Enquiry e) {
    if (_query.isEmpty) return true;
    final q = _query.toLowerCase();
    final digits = _query.replaceAll(RegExp(r'\D'), '');
    final customer = db.customerById(e.customerId);
    return e.id.toLowerCase().contains(q) ||
        db.enquiryTitle(e).toLowerCase().contains(q) ||
        (customer?.name.toLowerCase().contains(q) ?? false) ||
        (digits.length >= 3 && (customer?.phone ?? '').contains(digits)) ||
        e.area.toLowerCase().contains(q) ||
        e.city.toLowerCase().contains(q);
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final db = ref.watch(dbProvider);
    final me = ref.watch(currentUserProvider);
    if (me == null) return const SizedBox.shrink();
    final all = widget.source?.call(db, me) ?? db.enquiriesFor(me);
    final filterKey = ref.watch(listFilterProvider(widget.listKey));
    final filter =
        widget.filters.where((f) => f.key == filterKey).firstOrNull ?? widget.filters.first;
    final shown = all.where((e) => filter.test(e) && _matches(db, e)).toList();
    final pad = Space.page(context);

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(pad, Space.sm, pad, Space.xs),
            child: SearchBox(onChanged: (v) => setState(() => _query = v.trim())),
          ),
        ),
        SliverToBoxAdapter(
          child: FilterChipsRow<String>(
            items: [
              for (final f in widget.filters) (f.key, f.label, all.where(f.test).length),
            ],
            selected: filter.key,
            onSelected: (k) => ref.read(listFilterProvider(widget.listKey).notifier).set(k),
          ),
        ),
        if (all.isEmpty && widget.empty != null)
          SliverToBoxAdapter(child: widget.empty)
        else if (shown.isEmpty)
          SliverToBoxAdapter(
            child: EmptyState(
              icon: Icons.search_off,
              title: t.emptyNoResults,
              body: t.emptyNoResultsBody,
              actionLabel: _query.isEmpty && filter.key == widget.filters.first.key
                  ? null
                  : t.actionClearFilters,
              onAction: () =>
                  ref.read(listFilterProvider(widget.listKey).notifier).set(widget.filters.first.key),
            ),
          )
        else
          SliverPadding(
            padding: EdgeInsets.fromLTRB(pad, Space.sm, pad, Space.xxxl + Space.lg),
            sliver: SliverList.separated(
              itemCount: shown.length,
              separatorBuilder: (_, _) => Space.gapMd,
              itemBuilder: (_, i) => EnquiryCard(enquiry: shown[i]),
            ),
          ),
      ],
    );
  }
}
