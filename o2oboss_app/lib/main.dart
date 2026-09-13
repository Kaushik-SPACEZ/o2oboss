import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/app.dart';
import 'app/demo_tools.dart';
import 'core/data/app_store.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Preload Google Fonts to avoid lag during first render.
  // Inter is used throughout the app with these weights.
  GoogleFonts.pendingFonts([
    GoogleFonts.inter(fontWeight: FontWeight.w400),
    GoogleFonts.inter(fontWeight: FontWeight.w500),
    GoogleFonts.inter(fontWeight: FontWeight.w600),
    GoogleFonts.inter(fontWeight: FontWeight.w700),
  ]);
  
  await initializeDateFormatting();
  final prefs = await SharedPreferences.getInstance();
  await applyDemoUrlOptions(prefs);
  runApp(
    ProviderScope(
      overrides: [prefsProvider.overrideWithValue(prefs)],
      child: const O2OBossApp(),
    ),
  );
}
