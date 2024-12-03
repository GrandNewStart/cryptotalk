import 'dart:typed_data';

import 'package:pointycastle/digests/sha256.dart';

class Sha256Utils {
  static Uint8List sha256(Uint8List bytes) {
    final sha256 = SHA256Digest();
    return sha256.process(bytes);
  }
}
