import 'dart:io';

import 'package:human_short_code/human_short_code.dart';
import 'package:test/test.dart';

void main() {
  test('vectors', () {
    final lines = File('../../spec/vectors.tsv').readAsStringSync().replaceAll('\r\n', '\n').split('\n');
    for (var n = 0; n < lines.length; n++) {
      final line = lines[n];
      if (line.isEmpty || line.startsWith('#')) continue;
      final f = line.split('\t');
      final alpha = f[2] == '-' ? defaultAlphabet : f[2];
      final length = f[3] == '-' ? defaultLength : int.parse(f[3]);
      String run() {
        switch (f[0]) {
          case 'encode':
            return encode(int.parse(f[1]), alphabet: alpha, length: length);
          case 'decode':
            return decode(f[1], alphabet: alpha, length: length).toString();
          default:
            return verify(f[1], alphabet: alpha, length: length).toString();
        }
      }

      if (f[4] == '!error') {
        expect(run, throwsA(predicate((e) => e is ArgumentError && e.message.toString().startsWith('human-short-code:'))), reason: 'line ${n + 1}');
      } else {
        expect(run(), f[4], reason: 'line ${n + 1}');
      }
    }
  });
}
