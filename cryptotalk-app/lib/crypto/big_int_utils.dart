import 'dart:typed_data';

class BigIntUtils {
  static BigInt decodeBigInt(Uint8List bytes) {
    return BigInt.parse(
        bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join(),
        radix: 16);
  }

  static Uint8List encodeBigInt(BigInt number) {
    // Raw encoding
    // var hexString = number.toRadixString(16);
    //
    // if (hexString.length % 2 != 0) {
    //   hexString = '0$hexString';
    // }
    //
    // return hexToBytes(hexString);

    // Padded encoding
    final bytes = number
        .toUnsigned(256)
        .toRadixString(16)
        .padLeft(64, '0'); // 64 hex chars for 32 bytes
    return Uint8List.fromList(
      List<int>.generate(
          32, (i) => int.parse(bytes.substring(i * 2, i * 2 + 2), radix: 16)),
    );
  }
}
