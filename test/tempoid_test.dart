import 'dart:math';

import 'package:test/test.dart';
import 'package:tempoid/tempoid.dart';

void main() {
  test('Should return an id', () {
    final random = FakeRandom();
    expect(TempoId.generate(randomLength: 1, time: 0, random: random), '00');
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
