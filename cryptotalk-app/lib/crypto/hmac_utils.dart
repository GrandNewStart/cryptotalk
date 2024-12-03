import 'dart:typed_data';

import 'package:pointycastle/export.dart';

class HmacUtils {
  static Uint8List hmac(Uint8List bytes, Uint8List key) {
    final hmac = HMac(SHA256Digest(), 64)..init(KeyParameter(key));
    return hmac.process(bytes);
  }
}
