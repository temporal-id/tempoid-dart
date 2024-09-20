import 'package:test/test.dart';
import 'package:tempoid/src/tempoid.dart';
import 'package:tempoid/src/utils.dart';

void main() {
  group('encodeNumber', () {
    test('Should parse zero', () {
      final encoded = encodeNumber(
        number: 0,
        alphabet: const Alphabet('z'),
      );

      expect(encoded, 'z');
    });

    test('Should parse overflow', () {
      final encoded = encodeNumber(
        number: 2,
        alphabet: const Alphabet('01'),
      );

      expect(encoded, '10');
    });
  });

  group('getMaxValueOfFixedLength', () {
    test('Should return correct max value of alphabet size 1', () {
      expect(
        getMaxValueOfFixedLength(length: 1, alphabet: const Alphabet('0')),
        0,
      );
      expect(
        getMaxValueOfFixedLength(length: 1, alphabet: const Alphabet('01')),
        1,
      );
      expect(
        getMaxValueOfFixedLength(length: 1, alphabet: const Alphabet('012')),
        2,
      );
    });

    test('Should return correct max value of alphabet size 2', () {
      expect(
        getMaxValueOfFixedLength(length: 2, alphabet: const Alphabet('0')),
        0,
      );
      expect(
        getMaxValueOfFixedLength(length: 2, alphabet: const Alphabet('01')),
        3,
      );
      expect(
        getMaxValueOfFixedLength(length: 2, alphabet: const Alphabet('012')),
        8,
      );
    });
  });
}
