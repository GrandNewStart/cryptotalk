import 'dart:math';
import 'dart:typed_data';

import 'package:pointycastle/api.dart';
import 'package:pointycastle/ecc/api.dart';
import 'package:pointycastle/ecc/curves/prime256v1.dart';
import 'package:pointycastle/key_generators/api.dart';
import 'package:pointycastle/key_generators/ec_key_generator.dart';
import 'package:pointycastle/random/fortuna_random.dart';

import '../common/hex_utils.dart';
import '../models/key_pair.dart';
import 'big_int_utils.dart';

class KeyUtils {
  static final privateKeyPrefix = HexUtils.hexToBytes(
      '3041020100301306072a8648ce3d020106082a8648ce3d030107042730250201010420');
  static final publicKeyPrefix = HexUtils.hexToBytes(
      '3059301306072a8648ce3d020106082a8648ce3d030107034200');

  static ECPrivateKey getPrivateKey(Uint8List bytes) {
    // Hard-coded parsing
    final rawBytes = bytes.sublist(privateKeyPrefix.length);
    var ecDomainParams = ECDomainParameters('prime256v1');
    return ECPrivateKey(BigIntUtils.decodeBigInt(rawBytes), ecDomainParams);

    // // Parse the PKCS#8 structure
    // final asn1Parser = ASN1Parser(bytes);
    // final privateKeyInfo = asn1Parser.nextObject() as ASN1Sequence;
    //
    // // Get the private key OCTET STRING
    // final privateKeyOctetString = privateKeyInfo.elements[2] as ASN1OctetString;
    //
    // // Parse the ECPrivateKey structure
    // final privateKeyParser = ASN1Parser(privateKeyOctetString.octets);
    // final ecPrivateKeySeq = privateKeyParser.nextObject() as ASN1Sequence;
    //
    // // Extract the private key value
    // final privateKey = (ecPrivateKeySeq.elements[1] as ASN1OctetString).octets;
    //
    // // Extract curve parameters (ensure correct domain parameters)
    // final ecDomainParams = ECDomainParameters('prime256v1');
    //
    // return ECPrivateKey(decodeBigInt(privateKey), ecDomainParams);
  }

  static ECPublicKey getPublicKey(Uint8List bytes) {
    var rawBytes = bytes.sublist(publicKeyPrefix.length);
    var ecDomainParams = ECDomainParameters('prime256v1');
    var publicKeyPoint = ecDomainParams.curve.decodePoint(rawBytes);
    if (publicKeyPoint == null) {
      throw ArgumentError('Invalid public key bytes');
    }
    return ECPublicKey(publicKeyPoint, ecDomainParams);
  }

  static KeyPair generateKeyPair() {
    final secureRandom = Random.secure();
    final seed =
        Uint8List.fromList(List.generate(32, (_) => secureRandom.nextInt(256)));

    var keyParams = ECKeyGeneratorParameters(ECCurve_prime256v1());

    var random = FortunaRandom();
    random.seed(KeyParameter(seed));

    var generator = ECKeyGenerator();
    generator.init(ParametersWithRandom(keyParams, random));

    final keyPair = generator.generateKeyPair();

    ECPrivateKey privateKey = keyPair.privateKey as ECPrivateKey;
    ECPublicKey publicKey = keyPair.publicKey as ECPublicKey;

    // Encode private key in #PKCS8 format
    final privateKeyBytes = Uint8List.fromList(
        [...privateKeyPrefix, ...BigIntUtils.encodeBigInt(privateKey.d!)]);

    // Encode public key in X.509 SubjectPublicKeyInfo format
    final x = publicKey.Q!.x!.toBigInteger()!;
    final y = publicKey.Q!.y!.toBigInteger()!;
    final publicKeyBytes = Uint8List.fromList([
      ...publicKeyPrefix,
      0x04,
      ...BigIntUtils.encodeBigInt(x),
      ...BigIntUtils.encodeBigInt(y)
    ]);

    return KeyPair(privateKey: privateKeyBytes, publicKey: publicKeyBytes);
  }
}
