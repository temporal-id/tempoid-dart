import 'dart:math';

import 'package:tempoid/src/utils.dart';

extension type const TempoId(String value) implements Object {
  /// Generates a new TempoId with a time part and a random part.
  /// The total length of the ID will be the sum of [timeLength] (default 8)
  /// and [randomLength] (default 13).
  ///
  /// If [time] is not provided, it will default to the current time
  /// in milliseconds since epoch.
  /// If [startTime] is provided, then [time] will be calculated
  /// as the difference between [startTime] and the current time.
  /// If [padLeft] is true, then the time part will be padded with
  /// the first character in [alphabet]. Default is true.
  /// If [alphabet] is not provided, it will default to [Alphabet.alphanumeric].
  /// If [random] is not provided, it will default to `Random.secure()`.
  factory TempoId.generate({
    int? timeLength,
    int? randomLength,
    int? time,
    DateTime? startTime,
    bool? padLeft,
    Alphabet? alphabet,
    Random? random,
  }) {
    randomLength ??= 13;
    alphabet ??= _defaultAlphabet;
    random ??= Random.secure();

    final String characters = alphabet.value;
    final int alphabetSize = characters.length;

    final buffer = StringBuffer();
    for (int i = 0; i < randomLength; i++) {
      int randomIndex;
      try {
        randomIndex = random!.nextInt(alphabetSize);
      } on UnsupportedError catch (_) {
        // fallback if Random.secure() is not supported
        random = Random();
        randomIndex = random.nextInt(alphabetSize);
      }

      final character = characters[randomIndex];
      buffer.write(character);
    }

    final timePart = TempoId.generateTime(
      timeLength: timeLength,
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
    int? timeLength,
    int? randomLength,
    int? time,
    DateTime? startTime,
    bool? padLeft,
    Alphabet? alphabet,
    Random? random,
  }) {
    return TempoId.generate(
      timeLength: timeLength,
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
    int? timeLength,
    int? time,
    DateTime? startTime,
    bool? padLeft,
    Alphabet? alphabet,
  }) {
    if (timeLength == 0) {
      return const TempoId('');
    }

    timeLength ??= 8;
    time ??= (DateTime.now().millisecondsSinceEpoch -
        (startTime?.millisecondsSinceEpoch ?? 0));
    padLeft ??= true;
    alphabet ??= _defaultAlphabet;

    final maxValue = getMaxValueOfFixedLength(
      length: timeLength,
      alphabet: alphabet,
    );

    // Handle overflow when time cannot be represented using
    // timeLength and alphabet.
    time %= (maxValue + 1);

    final millisEncoded = encodeNumber(
      number: time,
      alphabet: alphabet,
    );

    if (padLeft) {
      return TempoId(millisEncoded.padLeft(timeLength, alphabet.value[0]));
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
  static final Alphabet url = Alphabet('${alphanumeric.value}_-');

  /// Base64 characters. (64 chars)
  static final Alphabet base64 = Alphabet('${alphanumeric.value}+/');

  /// Numbers and characters without lookalikes: 1, l, I, 0, O, o, u, v, 5, S, s, 2, Z. (49 chars)
  static const Alphabet noDoppelganger =
      Alphabet('346789ABCDEFGHJKLMNPQRTUVWXYabcdefghijkmnpqrtwxyz');
}
