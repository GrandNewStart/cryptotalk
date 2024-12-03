import 'dart:math';
import 'dart:typed_data';

import 'package:pointycastle/api.dart';
import 'package:pointycastle/block/aes.dart';
import 'package:pointycastle/block/modes/gcm.dart';

class AESUtils {
  static Uint8List generateIV() {
    final secureRandom = Random.secure();
    return Uint8List.fromList(
        List.generate(12, (_) => secureRandom.nextInt(256)));
  }

  static Map<String, Uint8List> encrypt(
      Uint8List key, Uint8List iv, Uint8List plaintext) {
    if (iv.length != 12) {
      throw ArgumentError('IV must be exactly 12 bytes for AES-GCM');
    }
    if (key.length != 32) {
      throw ArgumentError('Key must be exactly 32 bytes for AES-256');
    }

    final gcm = GCMBlockCipher(AESEngine())
      ..init(
        true, // true for encryption
        AEADParameters(
          KeyParameter(key),
          128, // Authentication tag length in bits
          iv,
          Uint8List(0), // Associated data (AAD), optional
        ),
      );

    final ciphertextAndTag =
        Uint8List(plaintext.length + gcm.macSize); // Allocate space
    try {
      final processedLength =
          gcm.processBytes(plaintext, 0, plaintext.length, ciphertextAndTag, 0);
      gcm.doFinal(ciphertextAndTag, processedLength);
    } catch (e) {
      throw StateError('Encryption failed: $e');
    }
    return {
      'cipherText':
          ciphertextAndTag.sublist(0, ciphertextAndTag.length - gcm.macSize),
      'tag': ciphertextAndTag.sublist(ciphertextAndTag.length - gcm.macSize),
      'iv': iv,
    };
  }

  static Uint8List decrypt(
      Uint8List key, Uint8List tag, Uint8List iv, Uint8List ciphertext) {
    if (iv.length != 12) {
      throw ArgumentError('IV must be exactly 12 bytes for AES-GCM');
    }
    if (key.length != 32) {
      throw ArgumentError('Key must be exactly 32 bytes for AES-256');
    }

    final gcm = GCMBlockCipher(AESEngine())
      ..init(
        false, // false for decryption
        AEADParameters(
          KeyParameter(key),
          128, // Authentication tag length in bits
          iv, // IV used during encryption
          Uint8List(0), // Associated data (AAD), optional
        ),
      );

    // Combine ciphertext and tag
    final ciphertextAndTag = Uint8List.fromList([...ciphertext, ...tag]);

    final plaintext = Uint8List(ciphertext.length); // Allocate space
    final processedLength = gcm.processBytes(
        ciphertextAndTag, 0, ciphertextAndTag.length, plaintext, 0);
    gcm.doFinal(plaintext, processedLength);

    return plaintext;
  }
}
