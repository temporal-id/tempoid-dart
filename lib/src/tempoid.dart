import 'dart:math';

import 'package:tempoid/src/utils.dart';

extension type const TempoId(String value) implements Object {
  factory TempoId.generate({
    int randomLength = 21,
    int? time,
    DateTime? startTime,
    bool padLeft = false,
    Alphabet? alphabet,
    Random? random,
  }) {
    alphabet ??= _defaultAlphabet;

    Random digestedRandom = random ?? Random.secure();

    final String characters = alphabet.value;
    final int alphabetSize = characters.length;

    final buffer = StringBuffer();
    for (int i = 0; i < randomLength; i++) {
      int randomIndex;
      try {
        randomIndex = digestedRandom.nextInt(alphabetSize);
      } on UnsupportedError catch (_) {
        // fallback if Random.secure() is not supported
        digestedRandom = Random();
        randomIndex = digestedRandom.nextInt(alphabetSize);
      }

      final character = characters[randomIndex];
      buffer.write(character);
    }

    final timePart = TempoId.generateTime(
      time: time,
      startTime: startTime,
      padLeft: padLeft,
      alphabet: alphabet,
    );

    return TempoId(timePart.value + buffer.toString());
  }

  /// Alias for [TempoId.generate] that returns a string
  /// instead of a [TempoId] object.
  static String generateString({
    int randomLength = 21,
    int? time,
    DateTime? startTime,
    bool padLeft = false,
    Alphabet? alphabet,
    Random? random,
  }) {
    return TempoId.generate(
      randomLength: randomLength,
      time: time,
      startTime: startTime,
      padLeft: padLeft,
      alphabet: alphabet,
      random: random,
    ).value;
  }

  /// Generates only the time part that represents the milliseconds
  /// since epoch encoded in [alphabet].
  /// If [padLeft] is true, then it will be padded with the first
  /// character in [alphabet].
  factory TempoId.generateTime({
    int? time,
    DateTime? startTime,
    bool padLeft = false,
    Alphabet? alphabet,
  }) {
    time ??= (DateTime.now().millisecondsSinceEpoch -
        (startTime?.millisecondsSinceEpoch ?? 0));
    alphabet ??= _defaultAlphabet;

    final millisEncoded = encodeNumber(
      number: time,
      alphabet: alphabet,
    );

    if (padLeft) {
      int maxLength =
          encodeNumber(number: 999999999, alphabet: alphabet).length;
      return TempoId(millisEncoded.padLeft(maxLength, alphabet.value[0]));
    } else {
      return TempoId(millisEncoded);
    }
  }
}

final _defaultAlphabet = Alphabet.alphanumeric;

/// Predefined alphabets for generating IDs.
/// You are free to create your own alphabet by calling the constructor.
extension type const Alphabet(String value) {
  /// Numbers from 0 to 9. (10 chars)
  static const Alphabet numbers = Alphabet('0123456789');

  /// Hexadecimal with lowercase characters. (16 chars)
  static final Alphabet hexadecimalLowercase = Alphabet('0123456789abcdef');

  /// Hexadecimal with uppercase characters. (16 chars)
  static final Alphabet hexadecimalUppercase = Alphabet('0123456789ABCDEF');

  /// Lowercase characters. (26 chars)
  static const Alphabet lowercase = Alphabet('abcdefghijklmnopqrstuvwxyz');

  /// Uppercase characters. (26 chars)
  static const Alphabet uppercase = Alphabet('ABCDEFGHIJKLMNOPQRSTUVWXYZ');

  /// Numbers and characters. (62 chars)
  /// There are no symbols or any special characters.
  static final Alphabet alphanumeric =
      Alphabet(numbers.value + lowercase.value + uppercase.value);

  /// URL compatible characters. (64 chars)
  static final Alphabet url = Alphabet('_-${alphanumeric.value}');

  /// Base64 characters. (64 chars)
  static final Alphabet base64 = Alphabet('+/${alphanumeric.value}');

  /// Numbers and characters without lookalikes: 1, l, I, 0, O, o, u, v, 5, S, s, 2, Z. (49 chars)
  static const Alphabet noDoppelganger =
      Alphabet('346789ABCDEFGHJKLMNPQRTUVWXYabcdefghijkmnpqrtwxyz');
}
