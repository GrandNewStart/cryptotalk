# CryptoTalk

## The single most secure chat app you have ever witnessed in the market

### This is a tutorial project intended for practicing the real-life digital cryptography
### If you want to learn how cryptography is implemented in an actual product,
### you're in the right place.
 
## What's this app?
CryptoTalk is a fully-encrypted chat app.
You sign in with your name and you will be given an asymmetric key pair.
You can add a new friend by scanning the QR of his/her public key.
You can send messages that are encrypted with shared secret.
Only you and your friend can decrypt your messages.

## Components
- ***cryptotalk-server***: Spring(Java)
- ***cryptotalk-app***: Flutter(Dart)
  
## How to test
1. Run cryptotalk-server
2. Host the server (ie. via ngrok)
3. Change the **HOST_URL** to your own endpoint
    ***(cryptotalk-app > lib > common > api.dart)***
4. Run cryptotalk-app

## You can experience
1. EC key generation (on P-256 curve, a.k.a. secp256r1, prime256v1)
2. ECDH key exchange
3. ECDSA signature and verification
4. AES-256-GCM en/decryption
5. **Java BouncyCastle** & **Dart PointyCastle** compatibility
