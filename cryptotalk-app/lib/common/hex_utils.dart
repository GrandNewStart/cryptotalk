import 'dart:typed_data';

class HexUtils {
  static Uint8List hexToBytes(String hex) {
    final length = hex.length;
    if (length % 2 != 0) {
      throw ArgumentError('Hex string must have an even length');
    }
    final bytes = Uint8List(length ~/ 2);
    for (var i = 0; i < length; i += 2) {
      final byte = hex.substring(i, i + 2);
      bytes[i ~/ 2] = int.parse(byte, radix: 16);
    }
    return bytes;
  }

  static String bytesToHex(Uint8List bytes) {
    return bytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join();
  }
}
