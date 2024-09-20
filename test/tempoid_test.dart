import 'dart:math';

import 'package:test/test.dart';
import 'package:tempoid/tempoid.dart';

void main() {
  test('Should return an id', () {
    final random = FakeRandom();
    expect(TempoId.generate(randomLength: 1, time: 0, random: random), '00');
    expect(TempoId.generate(randomLength: 1, time: 0, random: random), '01');
    expect(TempoId.generate(randomLength: 1, time: 5, random: random), '52');
  });

  test('Should handle time overflow', () {
    final random = FakeRandom();
    expect(
      TempoId.generate(
        timeLength: 2,
        randomLength: 1,
        time: 99,
        alphabet: Alphabet.numbers,
        random: random,
      ),
      '990',
    );

    expect(
      TempoId.generate(
        timeLength: 2,
        randomLength: 1,
        time: 100,
        alphabet: Alphabet.numbers,
        random: random,
      ),
      '01',
    );
  });

  test('Should pad left time', () {
    final random = FakeRandom();
    expect(
      TempoId.generate(
        timeLength: 3,
        randomLength: 1,
        time: 5,
        padLeft: true,
        alphabet: Alphabet.numbers,
        random: random,
      ),
      '0050',
    );

    expect(
      TempoId.generate(
        timeLength: 3,
        randomLength: 1,
        time: 12,
        padLeft: true,
        alphabet: Alphabet.numbers,
        random: random,
      ),
      '0121',
    );

    expect(
      TempoId.generate(
        timeLength: 3,
        randomLength: 1,
        time: 123,
        padLeft: true,
        alphabet: Alphabet.numbers,
        random: random,
      ),
      '1232',
    );

    expect(
      TempoId.generate(
        timeLength: 3,
        randomLength: 1,
        time: 1234,
        padLeft: true,
        alphabet: Alphabet.numbers,
        random: random,
      ),
      '2343',
    );
  });

  test('Should return inner string on toString', () {
    expect(const TempoId('abc').toString(), 'abc');
  });
}

/// A [Random] that counts from 0 to max int.
class FakeRandom implements Random {
  int state = 0;

  @override
  bool nextBool() => false;

  @override
  double nextDouble() => 0;

  @override
  int nextInt(int max) => (state++) % max;
}
