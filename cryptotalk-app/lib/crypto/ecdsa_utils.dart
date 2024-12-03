import 'dart:math';
import 'dart:typed_data';

import 'package:asn1lib/asn1lib.dart';
import 'package:pointycastle/export.dart';

import 'key_utils.dart';

class ECDSAUtils {
  static Uint8List sign(Uint8List message, Uint8List privateKeyBytes) {
    final privateKey = KeyUtils.getPrivateKey(privateKeyBytes);

    // Create the signer
    var signer = ECDSASigner(SHA256Digest(), null);
    final secureRandom = FortunaRandom();
    final random = Random.secure();
    final seed = Uint8List(32); // 32 bytes = 256 bits
    for (int i = 0; i < seed.length; i++) {
      seed[i] = random.nextInt(256);
    }
    secureRandom.seed(KeyParameter(seed));
    signer.init(
        true,
        ParametersWithRandom(
            PrivateKeyParameter<ECPrivateKey>(privateKey), secureRandom));

    // Create signature
    ECSignature signature = signer.generateSignature(message) as ECSignature;

    // Encode r and s into DER format
    var seq = ASN1Sequence();
    seq.add(ASN1Integer(signature.r));
    seq.add(ASN1Integer(signature.s));

    // Explicitly encode to get DER bytes
    return seq.encodedBytes;
  }

  static bool verify(
      Uint8List message, Uint8List signatureBytes, Uint8List publicKeyBytes) {
    // Extract r and s from the signature bytes
    final asn1Parser = ASN1Parser(signatureBytes);
    final sequence = asn1Parser.nextObject() as ASN1Sequence;
    final r = (sequence.elements[0] as ASN1Integer).valueAsBigInteger;
    final s = (sequence.elements[1] as ASN1Integer).valueAsBigInteger;

    // Get ECPublicKey
    final publicKey = KeyUtils.getPublicKey(publicKeyBytes);

    // Create the signer
    var signer = ECDSASigner(SHA256Digest(), null);
    signer.init(false, PublicKeyParameter<ECPublicKey>(publicKey));

    // Verify signature
    return signer.verifySignature(
        Uint8List.fromList(message), ECSignature(r, s));
  }
}
