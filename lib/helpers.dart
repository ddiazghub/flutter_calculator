import 'dart:math';

String randomHexString(int length) {
  final rng = Random.secure();

  return Iterable.generate(length, (i) => rng.nextInt(16))
      .map((e) => e.toRadixString(16))
      .join();
}

