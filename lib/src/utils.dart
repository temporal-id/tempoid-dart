import 'dart:math';

import 'package:tempoid/src/tempoid.dart';

/// Encodes the [number] using only the
/// characters of the given [alphabet].
String encodeNumber({
  required int number,
  required Alphabet alphabet,
}) {
  assert(alphabet.value.isNotEmpty, 'Alphabet cannot be empty');

  final chars = alphabet.value;
  final alphabetSize = chars.length;

  final buffer = <int>[];
  int curr = number;
  do {
    int digit = curr % alphabetSize;
    curr ~/= alphabetSize;
    buffer.add(chars.codeUnitAt(digit));
  } while (curr != 0);

  return String.fromCharCodes([
    for (int i = buffer.length - 1; i != -1; i--) buffer[i],
  ]);
}

/// Returns the maximum value the [alphabet] can
/// represent with a given [length].
int getMaxValueOfFixedLength({
  required int length,
  required Alphabet alphabet,
}) {
  assert(length > 0, 'Length must be greater than 0 (current = $length)');
  return pow(alphabet.value.length, length).toInt() - 1;
}
