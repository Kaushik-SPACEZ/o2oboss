import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../app/router/routes.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_motion.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_typography.dart';
import '../../core/brand/brand_philosophy.dart';
import '../../core/l10n/l10n.dart';
import '../../core/utils/validators.dart';
import '../../shared/widgets/brand_widgets.dart';
import '../../shared/widgets/buttons.dart';
import '../../shared/widgets/feedback.dart';
import '../../shared/widgets/inputs.dart';
import '../../shared/widgets/layout.dart';

enum FranchiseType { womenHygiene, artGallery, coffeeKiosk, ayurvedicSpa, eggMaster, monthlyGroceries }
enum ExperienceRange { under1Year, years1to3, years3to5, years5to10, years10to15, years15to20, years20to25, years25plus }
enum BusinessSize { lakh2to5, lakh5to10, lakh10to25, lakh25to50, lakh50to1cr, above1cr }

class _D { String firstName = '', lastName = '', email = '', mobile = '', area = '', state = ''; ExperienceRange? exp; BusinessSize? size; FranchiseType? type; bool terms = false; }

class FranchiseSignupScreen extends ConsumerStatefulWidget {
  const FranchiseSignupScreen({super.key});
  @override ConsumerState<FranchiseSignupScreen> createState() => _State();
}


class _State extends ConsumerState<FranchiseSignupScreen> {
  final _key = GlobalKey<FormState>();
  final _d = _D();
  final _fn = TextEditingController(), _ln = TextEditingController(), _em = TextEditingController();
  final _mb = TextEditingController(), _ar = TextEditingController();
  bool _te = false, _done = false;

  @override void dispose() { _fn.dispose(); _ln.dispose(); _em.dispose(); _mb.dispose(); _ar.dispose(); super.dispose(); }

  Future<void> _submit() async {
    if (!_key.currentState!.validate() || !_d.terms || _d.state.isEmpty || _d.exp == null || _d.size == null) {
      setState(() => _te = !_d.terms);
      showToast(context, 'Please fill all required fields'); return;
    }
    _d..firstName = _fn.text.trim()..lastName = _ln.text.trim()..email = _em.text.trim()..mobile = _mb.text.trim()..area = _ar.text.trim();
    await simulateWork(800);
    setState(() => _done = true);
  }

  @override Widget build(BuildContext c) => _done ? _success(c) : _form(c);

  Widget _form(BuildContext c) {
    final p = Space.page(c);
    return Scaffold(
      appBar: AppBar(leading: BackButton(onPressed: () => c.canPop() ? c.pop() : c.go(Routes.signup)), title: const Text('Become a Franchiser')),
      body: SafeArea(child: ContentWidth(max: 640, child: Form(key: _key, child: ListView(padding: EdgeInsets.fromLTRB(p, Space.md, p, Space.xxxl), children: [
        _hero(c), Space.gapLg, const IndiaAcronymCard(), Space.gapXxl, _offers(c), Space.gapXxl, _fields(c), Space.gapXxl, _terms(c), Space.gapLg, AppButton('Submit Application', onPressed: _submit),
      ])))));
  }

  Widget _hero(BuildContext c) => Container(
    padding: const EdgeInsets.all(Space.lg),
    decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: Corners.lgAll, border: Border.all(color: AppColors.washBorder)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [Container(padding: const EdgeInsets.all(Space.sm), decoration: BoxDecoration(color: AppColors.blueLight, borderRadius: Corners.mdAll), child: Icon(Icons.rocket_launch_outlined, color: AppColors.primary, size: 28)), Space.gapMd, Expanded(child: Text('Start Your Own Business', style: c.text.titleLarge?.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)))]),
      Space.gapMd, Text('Become a Franchise Partner with o2oboss.com', style: c.text.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
      Space.gapXs, Text('"Affordable Franchise to Own"', style: c.text.bodyMedium?.copyWith(color: AppColors.primary, fontStyle: FontStyle.italic)),
      Space.gapMd, Text('Complete setup with training & support.', style: c.text.bodySmall?.copyWith(color: AppColors.textSecondary)),
      Space.gapSm, Container(padding: const EdgeInsets.symmetric(horizontal: Space.sm, vertical: Space.xs), decoration: BoxDecoration(color: AppColors.successLight, borderRadius: Corners.smAll), child: Text('💰 Great opportunity to earn', style: c.text.labelSmall?.copyWith(color: AppColors.successText))),
    ]),
  );

  Widget _offers(BuildContext c) {
    final o = [(FranchiseType.womenHygiene, 'Women Hygiene', Icons.spa_outlined, Colors.pink), (FranchiseType.artGallery, 'Art Gallery', Icons.palette_outlined, Colors.purple), (FranchiseType.coffeeKiosk, 'Coffee Kiosk', Icons.local_cafe_outlined, Colors.brown), (FranchiseType.ayurvedicSpa, 'Ayurvedic Spa', Icons.self_improvement_outlined, Colors.green), (FranchiseType.eggMaster, 'Egg Master', Icons.egg_outlined, Colors.orange), (FranchiseType.monthlyGroceries, 'Groceries', Icons.shopping_cart_outlined, Colors.teal)];
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [Icon(Icons.business_center_outlined, color: AppColors.primary), Space.gapSm, Text('We Offer', style: c.text.titleMedium?.copyWith(fontWeight: FontWeight.bold))]),
      Space.gapMd, GridView.count(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), crossAxisCount: 2, childAspectRatio: 1.6, crossAxisSpacing: Space.md, mainAxisSpacing: Space.md, children: [for (final (t, n, i, cl) in o) _card(c, t, n, i, cl)]),
    ]);
  }

  Widget _card(BuildContext c, FranchiseType t, String n, IconData i, Color cl) {
    final s = _d.type == t;
    return InkWell(borderRadius: Corners.mdAll, onTap: () => setState(() => _d.type = t), child: Container(padding: const EdgeInsets.all(Space.md), decoration: BoxDecoration(color: s ? cl.withValues(alpha: 0.15) : AppColors.track, borderRadius: Corners.mdAll, border: Border.all(color: s ? cl : AppColors.border, width: s ? 2 : 1)), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(i, color: cl, size: 28), Space.gapSm, Text(n, textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis, style: c.text.labelMedium?.copyWith(color: s ? cl : AppColors.text, fontWeight: s ? FontWeight.bold : FontWeight.normal))])));
  }

  Widget _fields(BuildContext c) {
    final st = ['Andhra Pradesh', 'Arunachal Pradesh', 'Assam', 'Bihar', 'Chhattisgarh', 'Goa', 'Gujarat', 'Haryana', 'Karnataka', 'Kerala', 'Madhya Pradesh', 'Maharashtra', 'Punjab', 'Rajasthan', 'Tamil Nadu', 'Telangana', 'Uttar Pradesh', 'West Bengal', 'Delhi'];
    final ex = [(ExperienceRange.under1Year, '<1yr'), (ExperienceRange.years1to3, '1-3yrs'), (ExperienceRange.years3to5, '3-5yrs'), (ExperienceRange.years5to10, '5-10yrs'), (ExperienceRange.years10to15, '10-15yrs'), (ExperienceRange.years25plus, '15+yrs')];
    final sz = [(BusinessSize.lakh2to5, '₹2L-5L'), (BusinessSize.lakh5to10, '₹5L-10L'), (BusinessSize.lakh10to25, '₹10L-25L'), (BusinessSize.lakh25to50, '₹25L-50L'), (BusinessSize.lakh50to1cr, '₹50L-1Cr'), (BusinessSize.above1cr, '₹1Cr+')];
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [Icon(Icons.person_add_outlined, color: AppColors.primary), Space.gapSm, Text('Your Details', style: c.text.titleMedium?.copyWith(fontWeight: FontWeight.bold))]), Space.gapLg,
      Row(children: [Expanded(child: AppTextField(label: 'First Name', controller: _fn, required: true, validator: (v) => Validators.name(c.t, v))), Space.gapMd, Expanded(child: AppTextField(label: 'Last Name', controller: _ln, required: true, validator: (v) => Validators.name(c.t, v)))]),
      Space.gapLg, AppTextField(label: 'Email', controller: _em, required: true, keyboardType: TextInputType.emailAddress, validator: (v) => Validators.email(c.t, v)),
      Space.gapLg, AppTextField(label: 'Mobile', controller: _mb, required: true, keyboardType: TextInputType.phone, validator: (v) => Validators.phone(c.t, v)),
      Space.gapLg, AppTextField(label: 'Area of Business', controller: _ar, required: true, validator: (v) => Validators.required(c.t, v)),
      Space.gapLg, _dd<String>(c, 'State', _d.state.isEmpty ? null : _d.state, st.map((s) => (s, s)).toList(), (v) => setState(() => _d.state = v ?? '')),
      Space.gapLg, _dd<ExperienceRange>(c, 'Experience', _d.exp, ex, (v) => setState(() => _d.exp = v)),
      Space.gapLg, _dd<BusinessSize>(c, 'Investment', _d.size, sz, (v) => setState(() => _d.size = v)),
    ]);
  }

  Widget _dd<T>(BuildContext c, String l, T? v, List<(T, String)> i, ValueChanged<T?> f) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Text('$l *', style: c.text.labelMedium?.copyWith(color: AppColors.textSecondary)), Space.gapXs,
    DropdownButtonFormField<T>(initialValue: v, decoration: InputDecoration(border: OutlineInputBorder(borderRadius: Corners.mdAll), contentPadding: const EdgeInsets.symmetric(horizontal: Space.md, vertical: Space.sm)), hint: Text('Select $l'), items: i.map((e) => DropdownMenuItem(value: e.$1, child: Text(e.$2))).toList(), onChanged: f, validator: (v) => v == null ? 'Required' : null),
  ]);

  Widget _terms(BuildContext c) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    InkWell(borderRadius: Corners.mdAll, onTap: () => setState(() => _d.terms = !_d.terms), child: Padding(padding: const EdgeInsets.symmetric(vertical: Space.xs), child: Row(children: [Checkbox(value: _d.terms, onChanged: (v) => setState(() => _d.terms = v ?? false)), Expanded(child: Text('I agree to Terms & Privacy', style: c.text.bodyMedium))]))),
    Row(children: [const SizedBox(width: 48), TextButton(onPressed: () => c.push(Routes.legal('terms')), child: const Text('Terms')), TextButton(onPressed: () => c.push(Routes.legal('privacy')), child: const Text('Privacy'))]),
    if (_te) Padding(padding: const EdgeInsetsDirectional.only(start: 48), child: Text('Please accept terms', style: c.text.bodySmall?.copyWith(color: AppColors.dangerText))),
  ]);

  Widget _success(BuildContext c) {
    Widget m = Container(width: 88, height: 88, decoration: const BoxDecoration(color: AppColors.successLight, shape: BoxShape.circle), child: const Icon(Icons.hourglass_top_rounded, size: 48, color: AppColors.successText));
    if (!Motion.reduced(c)) m = m.animate().scale(begin: const Offset(0.6, 0.6), duration: 360.ms, curve: Curves.easeOutBack).fadeIn();
    return Scaffold(body: SafeArea(child: ContentWidth(max: 480, child: ListView(padding: EdgeInsets.fromLTRB(Space.page(c), 72, Space.page(c), Space.xxl), children: [
      Center(child: m), Space.gapXxl, Text(kSuccessWelcome, textAlign: TextAlign.center, style: c.text.headlineSmall), Space.gapSm,
      Text('Our team will contact you in 2-3 business days.', textAlign: TextAlign.center, style: c.text.bodyMedium?.copyWith(color: AppColors.textSecondary)), Space.gapMd,
      const PhilosophyCard(), Space.gapXl,
      Container(padding: const EdgeInsets.all(Space.md), decoration: BoxDecoration(color: AppColors.track, borderRadius: Corners.mdAll), child: Column(children: [_row(c, 'Name', '${_d.firstName} ${_d.lastName}'), _row(c, 'Email', _d.email), _row(c, 'Mobile', _d.mobile), _row(c, 'State', _d.state)])),
      Space.gapXxl, AppButton('Back to Login', onPressed: () => c.go(Routes.login)),
    ]))));
  }

  Widget _row(BuildContext c, String l, String v) => Padding(padding: const EdgeInsets.symmetric(vertical: Space.xs), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(l, style: c.text.bodySmall?.copyWith(color: AppColors.textSecondary)), Text(v, style: c.text.bodyMedium)]));
}

