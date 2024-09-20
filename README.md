# Tempo ID

[![pub package](https://img.shields.io/pub/v/tempoid.svg)](https://pub.dev/packages/tempoid)
![ci](https://github.com/temporal-id/tempoid-dart/actions/workflows/ci.yml/badge.svg)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

Short IDs with temporal ordering.

A library to generate URL-friendly, unique, and short IDs that are sortable by time. Inspired by nanoid and UUIDv7.

See [tempoid.dev](https://tempoid.dev) for more information.

## Motivation

- **URL-friendly**: The IDs are easy to select and copy.
- **Unique**: The IDs are practically unique and can be used in distributed systems.
- **Short**: The IDs are shorter than UUIDs because they are encoded with a larger alphabet.
- **Sortable**: The IDs are sortable by time because a timestamp is encoded in the beginning of the ID.
- **Customizable**: You can configure the ID length and the characters used.

Example ID:

```text
0uoVxkjTFsrRX30O5B9fX
<------><----------->
  Time     Random
```

## Collisions

- **Same millisecond**: There can be only a collision if two IDs are generated in the same millisecond.
- **Low probability**: Even if two IDs are generated in the same millisecond, the probability of a collision is very low.

The 13 random characters exceed the randomness of UUIDv7 (≈10^23 vs ≈10^22).

## Getting Started

```yaml
# pubspec.yaml
dependencies:
  tempoid: <version>
```

## Usage

Every id is a string wrapped in a zero-cost [extension type](https://dart.dev/language/extension-types) called `TempoId`.

To access the string value, use the `value` getter.

Note: Auto import is only working while writing, there is no quick fix (See [Github Issue](https://github.com/dart-lang/sdk/issues/55443)).

```dart
void main() {
  TempoId id = TempoId.generate();
  String idString = id.value;

  // or generate a string directly
  String idString2 = TempoId.generateString();
}
```

## Parameters

### ➤ Length

By default, the length of the ID is 21 characters.
It contains an 8-character UNIX timestamp and an 13-character random string.
You can change the length by passing the `timeLength` and `randomLength` parameters.

```dart
TempoId id = TempoId.generate(timeLength: 10, randomLength: 6);
```

By setting `timeLength` to zero, you can generate a random ID without a timestamp.
`timeLength` should be at least 8 characters to ensure that there are no overflows within the next 7000 years.

### ➤ Alphabet

By default, the ID is encoded with an alphanumeric alphabet (`[A-Za-z0-9]`) without any special characters,
making it easy to select and copy.
You can change the alphabet by passing the `alphabet` parameter.

```dart
// use a different alphabet
TempoId id1 = TempoId.generate(alphabet: Alphabet.base64);

// or create a custom alphabet
Alphabet alphabet = Alphabet('ABCDEF');
TempoId id2 = TempoId.generate(alphabet: alphabet);
```

## License

MIT License

Copyright (c) 2024 Tien Do Nam

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
