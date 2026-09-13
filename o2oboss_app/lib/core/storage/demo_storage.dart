import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/models.dart';

/// Local persistence for the prototype (shared_preferences). Not a database —
/// it just lets the demo survive a page reload.
class DemoStorage {
  DemoStorage(this._prefs);

  final SharedPreferences _prefs;

  static const _dbKey = 'o2o.db';
  static const _sessionKey = 'o2o.session';
  static const _localeKey = 'o2o.locale';
  static const _languageChosenKey = 'o2o.languageChosen';
  static const _themeKey = 'o2o.theme';

  /// Debounce timer to batch rapid saves into one operation.
  Timer? _saveTimer;
  DbState? _pendingSave;

  DbState? loadDb() {
    final raw = _prefs.getString(_dbKey);
    if (raw == null) return null;
    try {
      return DbState.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      // Saved data from an older build — start again from the seed.
      return null;
    }
  }

  /// Debounced save — waits 500ms before actually writing to storage.
  /// This batches rapid state changes into a single write operation.
  Future<void> saveDb(DbState db) async {
    _pendingSave = db;
    _saveTimer?.cancel();
    _saveTimer = Timer(const Duration(milliseconds: 500), () async {
      if (_pendingSave != null) {
        final json = await compute(_encodeDb, _pendingSave!);
        await _prefs.setString(_dbKey, json);
        _pendingSave = null;
      }
    });
  }

  /// Immediate save for critical operations (like logout).
  Future<void> saveDbNow(DbState db) async {
    _saveTimer?.cancel();
    _pendingSave = null;
    final json = await compute(_encodeDb, db);
    await _prefs.setString(_dbKey, json);
  }

  static String _encodeDb(DbState db) => jsonEncode(db.toJson());

  Future<void> clearDb() => _prefs.remove(_dbKey);

  String? get sessionUserId => _prefs.getString(_sessionKey);

  Future<void> setSessionUserId(String? id) => id == null
      ? _prefs.remove(_sessionKey)
      : _prefs.setString(_sessionKey, id);

  String? get localeCode => _prefs.getString(_localeKey);

  Future<void> setLocaleCode(String code) => _prefs.setString(_localeKey, code);

  bool get languageChosen => _prefs.getBool(_languageChosenKey) ?? false;

  Future<void> setLanguageChosen() => _prefs.setBool(_languageChosenKey, true);

  String? get themeId => _prefs.getString(_themeKey);

  Future<void> setThemeId(String id) => _prefs.setString(_themeKey, id);
}
