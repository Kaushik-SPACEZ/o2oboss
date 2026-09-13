import 'package:shared_preferences/shared_preferences.dart';

import '../core/storage/demo_storage.dart';

/// Development-only shortcuts, enabled with `--dart-define=DEMO_TOOLS=true`.
/// Lets automated screenshots open a role directly, e.g.
/// `/#/bo/home?as=backoffice&lang=ta&theme=brand`. Never enabled in a
/// normal build.
const kDemoTools = bool.fromEnvironment('DEMO_TOOLS');

const _demoUserIds = {
  'sales': 'u_sales_arun',
  'backoffice': 'u_bo_divya',
  'vendor': 'u_v_securevision',
  'customer': 'u_customer',
  'franchise': 'u_franchise',
  'admin': 'u_admin',
};

Future<void> applyDemoUrlOptions(SharedPreferences prefs) async {
  if (!kDemoTools) return;
  final fragment = Uri.base.fragment;
  final params = {
    ...Uri.base.queryParameters,
    if (fragment.isNotEmpty) ...Uri.parse(fragment).queryParameters,
  };
  final storage = DemoStorage(prefs);
  if (params['reset'] == '1') await storage.clearDb();
  final lang = params['lang'];
  if (lang != null) {
    await storage.setLocaleCode(lang);
    await storage.setLanguageChosen();
  }
  final as = params['as'];
  if (as != null && _demoUserIds.containsKey(as)) {
    await storage.setSessionUserId(_demoUserIds[as]);
    await storage.setLanguageChosen();
  }
  if (params['logout'] == '1') await storage.setSessionUserId(null);
  final theme = params['theme'];
  if (theme != null) await storage.setThemeId(theme);
}
