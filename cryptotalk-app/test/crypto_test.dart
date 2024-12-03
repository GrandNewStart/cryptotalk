import 'dart:convert';

import 'package:cryptotalk/crypto/ecdsa_utils.dart';
import 'package:cryptotalk/crypto/key_utils.dart';
import 'package:cryptotalk/common/hex_utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testJavaECDSAVerification();
}

void testSignature() {
  final message = 'hello';
  final messageBytes = utf8.encode(message);

  test('Dart ECDSA Signature Tests', () {
    for (int i = 0; i < 5; i++) {
      final kp = KeyUtils.generateKeyPair();
      final prv = kp.privateKey;
      final pub = kp.publicKey;
      final signature = ECDSAUtils.sign(utf8.encode(message), prv);
      final verified = ECDSAUtils.verify(messageBytes, signature, pub);

      print('KEY ${i + 1}');
      print(' Private = ${HexUtils.bytesToHex(prv)}');
      print(' Public = ${HexUtils.bytesToHex(pub)}');
      print(' Signature = ${HexUtils.bytesToHex(signature)}');
      print(' Verified = $verified');

      expect(verified, isTrue,
          reason: 'Signature verification failed for key ${i + 1}');
    }
  });
}

void testJavaECDSAVerification() {
  final message = 'hello';
  final messageBytes = utf8.encode(message);

  test('Java ECDSA Verification Tests', () {
    final list = [
      [
        "3041020100301306072a8648ce3d020106082a8648ce3d0301070427302502010104203d58065a7c1164b2b52308f24c78a8c5ea92a439df83e5120f2add9feef61e46",
        "3059301306072a8648ce3d020106082a8648ce3d03010703420004ce795774d1d3cebee3d84605c9132d5f4a3d81891f8e44343ca57a4f3db3f92dc3aa365e9561d30e62b5166c8dc16e49f1a66330f052a522972c35d071c4940c",
        "304502207e024490f30345c3ccf6177b9892fe48892d1a85660c2505f3ac3da0ff3deaf9022100d854c2a0a80fd1189a5baa080208a172bca7de203a6b52e36eff6de7a7312448"
      ],
      [
        "3041020100301306072a8648ce3d020106082a8648ce3d0301070427302502010104207c2d1f2fdcff873b46d877710e736140268343fad10b390453081bdbfd248777",
        "3059301306072a8648ce3d020106082a8648ce3d03010703420004c7ef72a496b86739b30a1797f3bf7ef00252c71c04ca70e13e7aea870988e297b83c82e022c28489b9dd1fbff3132195be5276d95123b4808b0e453665881cfa",
        "304502205a1f9ae0d87b4577700f5203dce3919d2c4f47d507e011cc2fdd2dc3e8deb72d022100869917a19ec4f645deb4a967772ff17bdfb53765c0644e66ae1cd9f9efe4a877"
      ],
      [
        "3041020100301306072a8648ce3d020106082a8648ce3d0301070427302502010104201c7dd7f4c98e41e7ff9dde93cff189411c0c88e610215fcbf810dbb6453ce307",
        "3059301306072a8648ce3d020106082a8648ce3d030107034200048eb328a72a93e4ff1f4340432346ce8f9ff64c418681cff32164960103b32fb0d6ff3a7395c087fb09cf13414f298ea7b16b62712ff4c25c6ad7a7146b7abe08",
        "30450220403b2a4da183e063d31fa68f92be8d14ac6a1b947dbf1ea253f99708eb5c8ed9022100acc03b405f1c1b6ff94725eabbeca3e10a374747494930a5ca82deac2a348fd6"
      ],
      [
        "3041020100301306072a8648ce3d020106082a8648ce3d03010704273025020101042059e96035069ae45ed70d2d26e34997c833928af009374de0aceabd267ed94bde",
        "3059301306072a8648ce3d020106082a8648ce3d03010703420004bf0d0886444ee35b1cd5d216a88e5f80b2f318bffb0c5f5e461e5387a4039c0b54ecc5909d39e7812e5159a3be2a9b7bbe4b95e234baddfd5295ef4361ba95b2",
        "304602210094a292d48ed7ebb8b3a9f285f27d23c87ce606cc814f90900da9299092195be2022100fb4bdf54ce11aa13f5b4ae4a81d8c2e964b884ce288b157236b56b3a74d7f72f"
      ],
      [
        "3041020100301306072a8648ce3d020106082a8648ce3d030107042730250201010420a1f6d8e5e1e3017bb48a04d465edfe02dfeba7cfc6cff62925aa244225058818",
        "3059301306072a8648ce3d020106082a8648ce3d03010703420004fe5d6be96434f6f6b75319ec93bd0c3cdadae05a1bf4561ac5ac7067a1e6c5916e68a91871217cb13eb4dfbe73b30f44258709fa80ec0a2c9c1642723334052b",
        "30460221009dce4506d53f0fbe0583b2cb75e54f3a30a5b5e3e43cd9ae93677c65e906fde1022100becde70aefa8512a715b31a3562993125d9c5a5073ede0b2631046ea31791488"
      ]
    ];
    for (int i = 0; i < list.length; i++) {
      final prv = HexUtils.hexToBytes(list[i][0]);
      final pub = HexUtils.hexToBytes(list[i][1]);
      final sig = HexUtils.hexToBytes(list[i][2]);
      final verified = ECDSAUtils.verify(messageBytes, sig, pub);
      final signature = ECDSAUtils.sign(utf8.encode(message), prv);
      final match = sig == signature;

      print('KEY ${i + 1}');
      print(' Verified = $verified');
      print(' Match = $match');

      expect(verified, isTrue,
          reason: 'Java Signature verification failed for key ${i + 1}');
    }
  });
}
