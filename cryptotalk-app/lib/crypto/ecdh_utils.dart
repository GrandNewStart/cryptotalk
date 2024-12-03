import 'dart:typed_data';

import 'package:pointycastle/ecc/ecdh.dart';

import 'big_int_utils.dart';
import 'key_utils.dart';

class ECDHUtils {
  static Uint8List computeSharedSecret(
      Uint8List privateKeyBytes, Uint8List publicKeyBytes) {
    final privateKey = KeyUtils.getPrivateKey(privateKeyBytes);
    final publicKey = KeyUtils.getPublicKey(publicKeyBytes);

    final agreement = ECDHBasicAgreement();
    agreement.key = privateKey;
    final sharedSecret = agreement.calculateAgreement(publicKey);
    return BigIntUtils.encodeBigInt(sharedSecret);
  }
}
