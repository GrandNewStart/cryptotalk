import 'package:flutter/material.dart';
import 'package:cryptotalk/common/api.dart';
import 'package:cryptotalk/screens/friend_screen.dart';
import 'package:toastification/toastification.dart';

import '../common/hex_utils.dart';
import '../crypto/key_utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _name = "";

  void register(BuildContext context) async {
    final kp = KeyUtils.generateKeyPair();
    print('[register] privateKey=${HexUtils.bytesToHex(kp.privateKey)}');
    print('[register] publicKey=${HexUtils.bytesToHex(kp.publicKey)}');
    try {
      await API.register(HexUtils.bytesToHex(kp.publicKey), _name);
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => FriendScreen(
                name: _name,
                privateKey: HexUtils.bytesToHex(kp.privateKey),
                publicKey: HexUtils.bytesToHex(kp.publicKey),
              )));
    } on Exception catch (e) {
      if (!mounted) return;
      toastification.show(
          context: context,
          title: const Text('오류'),
          description: const Text('등록 실패'),
          type: ToastificationType.error,
          autoCloseDuration: const Duration(seconds: 2),
          showProgressBar: false,
          showIcon: false,
          alignment: Alignment.bottomCenter);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Spacer(),
              const Text('Crypto Talk',
                  style: TextStyle(
                      color: Colors.blue,
                      fontSize: 32,
                      fontWeight: FontWeight.w900)),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Name',
                      style: TextStyle(
                          color: Colors.blueGrey,
                          fontSize: 14,
                          fontWeight: FontWeight.w500)),
                  TextField(
                    onChanged: (text) {
                      setState(() {
                        _name = text;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 32),
              MaterialButton(
                onPressed: () {
                  register(context);
                },
                padding: EdgeInsets.zero,
                color: Colors.blue,
                splashColor: Colors.blue[300],
                child: Container(
                  height: 50,
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: const Text('Log in',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w800)),
                ),
              ),
              const Spacer()
            ],
          ),
        ),
      ),
    );
  }
}
