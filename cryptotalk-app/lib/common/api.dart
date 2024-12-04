import 'dart:convert';
import 'dart:typed_data';
import 'package:cryptotalk/crypto/aes_utils.dart';
import 'package:cryptotalk/crypto/ecdh_utils.dart';
import 'package:cryptotalk/crypto/ecdsa_utils.dart';
import 'package:cryptotalk/models/message.dart';
import 'package:http/http.dart' as http;

import 'package:cryptotalk/models/friend.dart';

import 'hex_utils.dart';

class API {
  static const HOST_URL = 'YOUT_HOST_URL';
  static const HEADERS = {'Content-Type': 'application/json;charset=utf-8'};

  static Uint8List createBody(dynamic body) {
    final str = jsonEncode(body);
    return utf8.encode(str);
  }

  static Future<void> register(String publicKey, String name) async {
    var url = Uri.parse('$HOST_URL/user/register');
    final body = createBody({'name': name, 'publicKey': publicKey});
    final response = await http.post(url, headers: HEADERS, body: body);
    final responseBody = jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode != 201) {
      throw Exception(responseBody['message']);
    }
  }

  static Future<Friend> getFriend(String publicKey) async {
    var url = Uri.parse('$HOST_URL/user?publicKey=$publicKey');

    final response = await http.get(url, headers: HEADERS);

    final responseBody = jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode != 200) {
      throw Exception(responseBody['message']);
    }
    final body = responseBody['body'] as Map<String, dynamic>;
    final name = body['name'] as String;
    return Friend(publicKey: publicKey, name: name);
  }

  static Future<Message> sendMessage(String privateKey, String publicKey,
      String recipient, String message) async {
    final messageBytes = utf8.encode(message);

    // ECDH
    final privateKeyBytes = HexUtils.hexToBytes(privateKey);
    final publicKeyBytes = HexUtils.hexToBytes(recipient);
    final secret =
        ECDHUtils.computeSharedSecret(privateKeyBytes, publicKeyBytes);

    // Encryption
    final iv = AESUtils.generateIV();
    final encrypted = AESUtils.encrypt(secret, iv, messageBytes);
    final cipherText = encrypted['cipherText'] as Uint8List;
    final authTag = encrypted['tag'] as Uint8List;
    final dataBytes = Uint8List.fromList([...cipherText, ...iv, ...authTag]);
    final data = HexUtils.bytesToHex(dataBytes);

    // Signature
    final signatureBytes = ECDSAUtils.sign(dataBytes, privateKeyBytes);
    final signature = HexUtils.bytesToHex(signatureBytes);

    var url = Uri.parse('$HOST_URL/message/send');
    final body = createBody({
      'from': publicKey,
      'to': recipient,
      'data': data,
      'signature': signature
    });

    final response = await http.post(url, headers: HEADERS, body: body);

    final responseBody = jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode != 201) {
      throw Exception(responseBody['message'] as String);
    }
    final dto = responseBody['body'] as Map<String, dynamic>;
    return Message(
        id: dto['id'] as String,
        from: dto['from'] as String,
        to: dto['to'] as String,
        message: message,
        date: dto['date'] as String);
  }

  static Future<List<Message>> getMessages(
      String privateKey, String publicKey, String recipient) async {
    // ECDH
    final privateKeyBytes = HexUtils.hexToBytes(privateKey);
    final publicKeyBytes = HexUtils.hexToBytes(recipient);
    final secret =
        ECDHUtils.computeSharedSecret(privateKeyBytes, publicKeyBytes);

    var url = Uri.parse('$HOST_URL/message/get');
    final body = createBody({'from': publicKey, 'to': recipient});

    final response = await http.post(url, headers: HEADERS, body: body);

    final responseBody = jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode != 200) {
      throw Exception(responseBody['message'] as String);
    }
    final list = responseBody['data'] as List<dynamic>;
    return list.map((e) => Message.from(e, secret)).toList();
  }
}
