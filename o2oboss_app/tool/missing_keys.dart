// Lists translation keys used in lib/ (as `t.key` or `context.t.key`) that
// are missing from tool/l10n/en/*.json. Run: dart run tool/missing_keys.dart
import 'dart:convert';
import 'dart:io';

void main() {
  final known = <String>{};
  for (final f in Directory('tool/l10n/en').listSync().whereType<File>()) {
    if (!f.path.endsWith('.json')) continue;
    known.addAll((jsonDecode(f.readAsStringSync()) as Map<String, dynamic>).keys);
  }
  final used = <String, String>{};
  final pattern = RegExp(r'\b(?:t|ctx\.t|context\.t|preview)\.([a-z][A-Za-z0-9]*)');
  const ignore = {'text', 'toString', 'hashCode', 'localeName'};
  for (final f in Directory('lib').listSync(recursive: true).whereType<File>()) {
    if (!f.path.endsWith('.dart') || f.path.contains('${Platform.pathSeparator}gen${Platform.pathSeparator}')) {
      continue;
    }
    for (final m in pattern.allMatches(f.readAsStringSync())) {
      final k = m.group(1)!;
      if (!known.contains(k) && !ignore.contains(k)) used.putIfAbsent(k, () => f.path);
    }
  }
  final keys = used.keys.toList()..sort();
  for (final k in keys) {
    stdout.writeln('$k\t${used[k]}');
  }
  stdout.writeln('${keys.length} missing');
}
