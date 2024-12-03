package dev.jinwoo.cryptotalk.common;

import jakarta.annotation.PostConstruct;
import org.bouncycastle.asn1.*;
import org.bouncycastle.asn1.nist.NISTNamedCurves;
import org.bouncycastle.asn1.x9.X9ECParameters;
import org.bouncycastle.crypto.digests.SHA256Digest;
import org.bouncycastle.crypto.params.ECDomainParameters;
import org.bouncycastle.crypto.params.ECPrivateKeyParameters;
import org.bouncycastle.crypto.params.ECPublicKeyParameters;
import org.bouncycastle.crypto.params.ParametersWithRandom;
import org.bouncycastle.crypto.signers.ECDSASigner;
import org.bouncycastle.crypto.signers.HMacDSAKCalculator;
import org.bouncycastle.jce.ECNamedCurveTable;
import org.bouncycastle.jce.provider.BouncyCastleProvider;
import org.bouncycastle.math.ec.ECCurve;
import org.bouncycastle.math.ec.ECPoint;
import org.springframework.stereotype.Service;

import javax.crypto.*;
import javax.crypto.spec.GCMParameterSpec;
import javax.crypto.spec.SecretKeySpec;
import java.io.ByteArrayInputStream;
import java.math.BigInteger;
import java.security.*;
import java.security.interfaces.ECPrivateKey;
import java.security.interfaces.ECPublicKey;
import java.security.spec.ECGenParameterSpec;
import java.security.spec.ECParameterSpec;
import java.security.spec.PKCS8EncodedKeySpec;
import java.security.spec.X509EncodedKeySpec;

@Service
public class CryptoService {

    public CryptoService() {
        Security.insertProviderAt(new BouncyCastleProvider(), 0);
    }

    @PostConstruct
    void onInit() {
        Security.insertProviderAt(new BouncyCastleProvider(), 0);
    }

    public byte[] sha256(byte[] bytes) throws NoSuchAlgorithmException {
        MessageDigest digest = MessageDigest.getInstance("SHA-256");
        return digest.digest(bytes);
    }

    public byte[] generateRandomBytes(int size) {
        return new SecureRandom().generateSeed(size);
    }

    public KeyPair generateKeyPair() throws InvalidAlgorithmParameterException, NoSuchAlgorithmException {
        KeyPairGenerator keyPairGenerator = KeyPairGenerator.getInstance("EC");
        ECGenParameterSpec ecSpec = new ECGenParameterSpec("secp256r1");
        keyPairGenerator.initialize(ecSpec, new SecureRandom());
        return keyPairGenerator.generateKeyPair();
    }

    public SecretKey generateKey() throws NoSuchAlgorithmException {
        KeyGenerator keyGen = KeyGenerator.getInstance("AES");
        keyGen.init(256);
        return keyGen.generateKey();
    }

    public byte[] calculateHMAC(byte[] message, byte[] key) throws Exception {
        SecretKeySpec secretKeySpec = new SecretKeySpec(key, "HmacSHA256");
        Mac mac = Mac.getInstance("HmacSHA256");
        mac.init(secretKeySpec);
        return mac.doFinal(message);
    }

    public byte[] sign(byte[] message, byte[] key) throws Exception {
        KeyFactory keyFactory = KeyFactory.getInstance("EC", "BC");

        PKCS8EncodedKeySpec privateKeySpec = new PKCS8EncodedKeySpec(key);
        PrivateKey privateKey = keyFactory.generatePrivate(privateKeySpec);

        Signature signature = Signature.getInstance("SHA256withECDSA");
        signature.initSign(privateKey);
        signature.update(message);

        return signature.sign();
    }

    public boolean verify(byte[] message, byte[] signature, byte[] key) throws Exception {
        KeyFactory keyFactory = KeyFactory.getInstance("EC", "BC");
        X509EncodedKeySpec keySpec = new X509EncodedKeySpec(key);
        PublicKey publicKey = keyFactory.generatePublic(keySpec);

        Signature sign = Signature.getInstance("SHA256withECDSA");
        sign.initVerify(publicKey);
        sign.update(message);

        return sign.verify(signature);
    }

    public byte[] encrypt(byte[] data, byte[] key, byte[] iv) throws Exception {
        // Create a SecretKeySpec from the provided key
        SecretKeySpec secretKeySpec = new SecretKeySpec(key, "AES");

        // Initialize the cipher for AES-GCM encryption
        Cipher cipher = Cipher.getInstance("AES/GCM/NoPadding");
        GCMParameterSpec gcmParameterSpec = new GCMParameterSpec(16 * 8, iv);
        cipher.init(Cipher.ENCRYPT_MODE, secretKeySpec, gcmParameterSpec);

        // Perform encryption
        return cipher.doFinal(data);
    }

    public byte[] decrypt(byte[] encryptedData, byte[] key, byte[] iv) throws Exception {
        // Create a SecretKeySpec from the provided key
        SecretKeySpec secretKeySpec = new SecretKeySpec(key, "AES");

        // Initialize the cipher for AES-GCM decryption
        Cipher cipher = Cipher.getInstance("AES/GCM/NoPadding");
        GCMParameterSpec gcmParameterSpec = new GCMParameterSpec(16 * 8, iv);
        cipher.init(Cipher.DECRYPT_MODE, secretKeySpec, gcmParameterSpec);

        // Perform decryption
        return cipher.doFinal(encryptedData);
    }

    public byte[] computeSharedSecret(byte[] privateKeyBytes, byte[] publicKeyBytes) throws Exception {
        // Load the private key from the byte array
        KeyFactory keyFactory = KeyFactory.getInstance("EC");
        PKCS8EncodedKeySpec privateKeySpec = new PKCS8EncodedKeySpec(privateKeyBytes);
        PrivateKey privateKey = keyFactory.generatePrivate(privateKeySpec);

        // Load the public key from the byte array
        X509EncodedKeySpec publicKeySpec = new X509EncodedKeySpec(publicKeyBytes);
        PublicKey publicKey = keyFactory.generatePublic(publicKeySpec);

        // Perform ECDH key agreement
        KeyAgreement keyAgreement = KeyAgreement.getInstance("ECDH");
        keyAgreement.init(privateKey);
        keyAgreement.doPhase(publicKey, true);

        // Generate the shared secret
        return keyAgreement.generateSecret();
    }

}