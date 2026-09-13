// Builds lib/l10n/app_<lang>.arb from the per-feature string files in
// tool/l10n/<lang>/*.json.
//
//   dart run tool/merge_arb.dart && flutter gen-l10n
//
// English (tool/l10n/en) is the template. Placeholder metadata is generated
// from {name} markers, so the source files stay plain key → text maps.
// Languages without translations still get an ARB, and any missing string
// falls back to English.
import 'dart:convert';
import 'dart:io';

import 'package:o2oboss_app/core/l10n/languages.dart';

void main() {
  final outDir = Directory('lib/l10n')..createSync(recursive: true);
  final english = _load('en');
  if (english.isEmpty) {
    stderr.writeln('No English strings found in tool/l10n/en');
    exit(1);
  }

  var problems = 0;
  for (final lang in appLanguages) {
    final strings = lang.code == 'en' ? english : _load(lang.code);
    final arb = <String, Object>{'@@locale': lang.code};
    var translated = 0;
    for (final key in english.keys.toList()..sort()) {
      final value = strings[key];
      if (value == null) continue;
      if (lang.code != 'en') {
        final expected = _placeholders(english[key]!).keys.toSet();
        final actual = _placeholders(value).keys.toSet();
        if (!actual.containsAll(expected)) {
          stderr.writeln('[${lang.code}] $key is missing placeholders '
              '${expected.difference(actual)} — using English');
          problems++;
          continue;
        }
      }
      arb[key] = value;
      translated++;
      if (lang.code == 'en') {
        final ph = _placeholders(value);
        if (ph.isNotEmpty) arb['@$key'] = {'placeholders': ph};
      }
    }
    for (final key in strings.keys) {
      if (!english.containsKey(key)) {
        stderr.writeln('[${lang.code}] unknown key "$key" ignored');
        problems++;
      }
    }
    File('${outDir.path}/app_${lang.code}.arb')
        .writeAsStringSync(const JsonEncoder.withIndent('  ').convert(arb));
    stdout.writeln('${lang.code.padRight(4)} $translated / ${english.length}');
  }
  if (problems > 0) stdout.writeln('$problems problem(s) reported above.');
}

Map<String, String> _load(String lang) {
  final dir = Directory('tool/l10n/$lang');
  final result = <String, String>{};
  if (!dir.existsSync()) return result;
  final files = dir.listSync().whereType<File>().where((f) => f.path.endsWith('.json')).toList()
    ..sort((a, b) => a.path.compareTo(b.path));
  for (final f in files) {
    final map = jsonDecode(f.readAsStringSync()) as Map<String, dynamic>;
    for (final e in map.entries) {
      if (result.containsKey(e.key)) {
        stderr.writeln('[$lang] duplicate key "${e.key}" in ${f.path}');
      }
      result[e.key] = e.value as String;
    }
  }
  return result;
}

Map<String, Object> _placeholders(String value) {
  final result = <String, Object>{};
  for (final m in RegExp(r'\{(\w+),\s*(plural|select)').allMatches(value)) {
    result[m[1]!] = {'type': m[2] == 'plural' ? 'int' : 'String'};
  }
  for (final m in RegExp(r'\{(\w+)\}').allMatches(value)) {
    result.putIfAbsent(m[1]!, () => {'type': 'String'});
  }
  return result;
}
