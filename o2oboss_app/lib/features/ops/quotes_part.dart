import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_typography.dart';
import '../../core/data/app_store.dart';
import '../../core/data/db_queries.dart';
import '../../core/data/permissions.dart';
import '../../core/l10n/l10n.dart';
import '../../core/models/models.dart';
import '../../shared/widgets/cards.dart';
import '../../shared/widgets/feedback.dart';
import '../../shared/widgets/layout.dart';
import '../quotation/quotation_card.dart';

/// Quotations for one enquiry, latest version of each, plus whether the
/// customer may compare several vendors' quotations.
class QuotesPart extends ConsumerWidget {
  const QuotesPart({super.key, required this.enquiry});

  final Enquiry enquiry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final db = ref.watch(dbProvider);
    final me = ref.watch(currentUserProvider)!;
    final e = db.enquiryById(enquiry.id) ?? enquiry;
    final quotes = db.currentQuotations(e.id)
        .where((q) => q.status != QuotationStatus.draft)
        .toList();
    final vendors = quotes.map((q) => q.vendorId).toSet().length;
    final canManage = can(me.role, Perm.reviewQuotation, db.config);
    final waiting = quotes.where((q) => q.status == QuotationStatus.submitted).length;

    return PageScaffold(
      title: t.navQuotations,
      children: [
        if (waiting > 0) ...[
          NoteCard(tone: Tone.warning, icon: Icons.rate_review_outlined, text: t.quotesToReview(waiting)),
          Space.gapLg,
        ],
        if (quotes.isEmpty)
          EmptyState(icon: Icons.request_quote_outlined, title: t.opsNoQuotesYet, body: t.quotesEmptyBody)
        else
          Gap(children: [for (final q in quotes) QuotationCard(quotation: q)]),
        if (canManage && (vendors > 1 || db.activeAssignmentsFor(e.id).length > 1)) ...[
          Space.gapXl,
          AppCard(
            padding: EdgeInsets.zero,
            child: SwitchListTile(
              value: e.multipleQuotesVisible,
              onChanged: (v) {
                ref.read(dbProvider.notifier).setMultipleQuotesVisible(e.id, v);
                showToast(context, t.toastUpdated);
              },
              title: Text(t.vendorsShowAllQuotes, style: context.text.bodyLarge),
              subtitle: Text(t.vendorsShowAllQuotesHelp, style: context.text.bodySmall),
            ),
          ),
        ],
        Space.gapXl,
        NoteCard(icon: Icons.mark_email_read_outlined, text: t.quotesCopyNote(db.config.adminCopyEmail)),
      ],
    );
  }
}
