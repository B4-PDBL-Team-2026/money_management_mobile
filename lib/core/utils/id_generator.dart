import 'dart:math';

class IdGenerator {
  static final Random rnd = Random.secure();

  static int intId() {
    return rnd.nextInt(1 << 31); // Generate a random integer up to 2^31
  }

  static String stringId(int length) {
    final String chars =
        '1234567890qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM';

    return String.fromCharCodes(
      Iterable.generate(
        length,
        (_) => chars.codeUnitAt(rnd.nextInt(chars.length)),
      ),
    );
  }
}
