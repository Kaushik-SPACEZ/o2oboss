import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme/app_spacing.dart';
import '../../core/data/app_store.dart';
import '../../core/data/db_queries.dart';
import '../../core/l10n/l10n.dart';
import '../../core/models/models.dart';
import '../../core/utils/format.dart';
import '../../core/utils/validators.dart';
import '../../shared/widgets/buttons.dart';
import '../../shared/widgets/cards.dart';
import '../../shared/widgets/feedback.dart';
import '../../shared/widgets/inputs.dart';
import '../../shared/widgets/layout.dart';

/// Edit your own name, email, city and — for people who earn commission —
/// where payouts should go.
class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _form = GlobalKey<FormState>();
  late final AppUser _me = ref.read(currentUserProvider)!;
  late final _name = TextEditingController(text: _me.name);
  late final _email = TextEditingController(text: _me.email ?? '');
  late final _upi = TextEditingController(text: _me.upiId ?? '');
  late final _bank = TextEditingController(text: _me.bankAccount ?? '');
  late final _ifsc = TextEditingController(text: _me.ifsc ?? '');
  late String _city = _me.city;
  late String? _area = _me.area;
  bool _dirty = false;

  bool get _earns =>
      _me.role == UserRole.sales ||
      _me.role == UserRole.franchise ||
      _me.role == UserRole.backOffice;

  @override
  void dispose() {
    for (final c in [_name, _email, _upi, _bank, _ifsc]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    if (!_form.currentState!.validate()) return;
    await simulateWork();
    ref.read(dbProvider.notifier).updateMyProfile(
          name: _name.text.trim(),
          email: _email.text.trim(),
          city: _city,
          area: _area,
          upiId: _earns ? _upi.text.trim() : null,
          bankAccount: _earns ? _bank.text.trim() : null,
          ifsc: _earns ? _ifsc.text.trim().toUpperCase() : null,
        );
    if (!mounted) return;
    showToast(context, context.t.toastSaved);
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final db = ref.watch(dbProvider);
    final city = db.cityByName(_city);
    return PopScope(
      canPop: !_dirty,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        if (await confirmDiscard(context) && context.mounted) {
          setState(() => _dirty = false);
          context.pop();
        }
      },
      child: Form(
        key: _form,
        onChanged: () => _dirty = true,
        child: PageScaffold(
          title: t.profileEdit,
          children: [
            AppTextField(
              label: t.labelFullName,
              controller: _name,
              required: true,
              textCapitalization: TextCapitalization.words,
              validator: (v) => Validators.name(t, v),
            ),
            Space.gapLg,
            AppTextField(
              label: t.labelMobile,
              initialValue: Fmt.phone(_me.phone),
              enabled: false,
              help: t.profilePhoneHelp,
            ),
            Space.gapLg,
            AppTextField(
              label: t.labelEmail,
              controller: _email,
              optional: true,
              keyboardType: TextInputType.emailAddress,
              validator: (v) => (v ?? '').isEmpty ? null : Validators.email(t, v),
            ),
            Space.gapLg,
            SelectField<String>(
              label: t.labelCity,
              value: _city,
              options: [for (final c in db.cities) SelectOption(c.name, c.name)],
              onChanged: (v) => setState(() {
                _dirty = true;
                if (v != _city) {
                  _city = v;
                  _area = null;
                }
              }),
            ),
            Space.gapLg,
            SelectField<String>(
              key: ValueKey('area-$_city'),
              label: t.labelArea,
              optional: true,
              value: _area,
              options: [for (final a in city?.areas ?? const <Area>[]) SelectOption(a.name, a.name)],
              onChanged: (v) => setState(() {
                _dirty = true;
                _area = v;
              }),
            ),
            if (_earns) ...[
              SectionHeader(t.earningsPayoutTitle),
              NoteCard(text: t.profilePayoutNote),
              Space.gapLg,
              AppTextField(
                label: t.profileUpi,
                controller: _upi,
                optional: true,
                hint: 'name@bank',
              ),
              Space.gapLg,
              AppTextField(
                label: t.profileBankAccount,
                controller: _bank,
                optional: true,
                keyboardType: TextInputType.number,
              ),
              Space.gapLg,
              AppTextField(
                label: t.profileIfsc,
                controller: _ifsc,
                optional: true,
                textCapitalization: TextCapitalization.characters,
              ),
            ],
          ],
          bottomBar: StickyActions(children: [
            AppButton(t.actionSaveChanges, onPressed: _save),
          ]),
        ),
      ),
    );
  }
}
