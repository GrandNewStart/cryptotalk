package dev.jinwoo.cryptotalk;

import dev.jinwoo.cryptotalk.common.CryptoService;
import dev.jinwoo.cryptotalk.common.Utils;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import java.security.KeyPair;
import java.util.List;

@SpringBootTest
class CryptotalkApplicationTests {

	@Autowired
	CryptoService cryptoService;

	@Test
	void signatureTest() throws Exception{
		String message = "hello";
		byte[] messageBytes = message.getBytes();

        for (int i=0; i<5; i++) {
			System.out.println("KEY " + (i+1));
			KeyPair kp = cryptoService.generateKeyPair();
			byte[] prv = kp.getPrivate().getEncoded();
			byte[] pub = kp.getPublic().getEncoded();
            System.out.println("	Private = " + Utils.bytesToHex(prv).toLowerCase());
            System.out.println("	Public = " + Utils.bytesToHex(pub).toLowerCase());
			byte[] signature = cryptoService.sign(messageBytes, prv);
			boolean verified = cryptoService.verify(messageBytes, signature, pub);
			System.out.println("	SIGNATURE = " + Utils.bytesToHex(signature).toLowerCase());
			System.out.println("	VERIFIED = " + verified);
			try {
				Assertions.assertTrue(verified);
			} catch (Exception ex) {
				throw new RuntimeException(ex);
			}
        }
	}

	@Test
	void dartSignatureTest() throws Exception {
		String message = "hello";
		byte[] messageBytes = message.getBytes();
		List<List<String>> list = List.of(
				List.of(
						"3041020100301306072a8648ce3d020106082a8648ce3d030107042730250201010420c148f788f1a08bfa1c94af437b4db16a5adf9dd6741f8c12741fd69fe0f73698",
						"3059301306072a8648ce3d020106082a8648ce3d030107034200041754c4c82e82dd6322057a8cf8261e7c91b6c50b1e48703be40b31ea59bb2e1f6ebf3f04196fc57957fa846f5f4bb256cc6e308dab063c4e3d06f63359a39fc1",
						"3046022100a41c511df991d3e73f7df0be728b61bde986a378750da6622c75079fdbedd0a7022100f3516f8cf3f118436e3b22bbba17fd645a6d83c7523483a91952b5c99cd11c3d"
				),
				List.of(
						"3041020100301306072a8648ce3d020106082a8648ce3d030107042730250201010420c440a7136bddaa2553eb4ca6b9df2b9794a019a6bb8463340356d2b57e8eb19a",
						"3059301306072a8648ce3d020106082a8648ce3d03010703420004478be97b6ada70037eb217fceb290f764411382cfffa236f3453d07d3340edf8e720b607f713d0f8893be6e56579a59718ee08b27c5b6ca1fc5088d8b23567a0",
						"30460221009be84c2b9a95acfd704abfd1640c1ef90a9df9f68c4154893cb75a9129cd178d022100bf4ed613c19a94775290c05d9264e2045842af7b71e726ff7e725e46a95a2310"
				),
				List.of(
						"3041020100301306072a8648ce3d020106082a8648ce3d030107042730250201010420f6d6acda8f63c37b3c7b2fdd32b357f2c0fa373571dc3b73f1713464eb4a08ca",
						"3059301306072a8648ce3d020106082a8648ce3d03010703420004978ebb9f2c19a102380cd35060c12185ab370458ed97d7b0cc7fb75381c974c4d675258aa7410fa3a5248cf9da6a6ae193e66a3f57ccff9a9abea9e8ad9b2b6a",
						"3046022100e671b436b15d1e1b888fed66ba9fee9e5b27bdd84a0b676b8e70dedba3349d6a022100c88a21cdfaa0e152df1df2d8794cad31f1271f45acd1fde3895aa685edec976c"
				),
				List.of(
						"3041020100301306072a8648ce3d020106082a8648ce3d0301070427302502010104203abbd39d7e2f0b8c8f698b7778a6234e3f17bc68287da40e64db2d9423a0fcc6",
						"3059301306072a8648ce3d020106082a8648ce3d0301070342000414fd6cb0b31172844b0f37ffd2fd5d0e6ac04c326506877166f299ed35370bee67f3f0b576cc94ecf7619fc3ffd3bc065eb6668d31145ac068597985286dac4c",
						"3046022100a474167403d80a5dd902994a88c0444a45b3955adfbbcf11f1bafdd96cce90b4022100957ff26e4c2a394527932d83b362a1eb0aee1181eec0369ecd79ba1430909224"
				),
				List.of(
						"3041020100301306072a8648ce3d020106082a8648ce3d030107042730250201010420502c860050c38cb57198f64debc0789e797435434e36f0891cb4e9d8b6053bc0",
						"3059301306072a8648ce3d020106082a8648ce3d03010703420004eea4ae57439d02bca8a3f2323b7404cb9f24debe6297b6952d357a01e523f4d325096f7e64217581a1c2b29f61512b69de96c393f906f0d03704bf9ca7af874f",
						"3044022038bd84226f033e09862f6b0abb0eb1310019a5e719f524c5820ff3a493a3c1fb02207bdda278ad001692d23b3849223c3baa24b0c9bad7e099bdad88c35125d0ac37"
				)
		);
		for (int i=0; i<list.size(); i++) {
			List<String> item = list.get(i);
			byte[] prv = Utils.hexToBytes(item.get(0));
			byte[] pub = Utils.hexToBytes(item.get(1));
			byte[] sig = Utils.hexToBytes(item.get(2));
			try {
				Assertions.assertTrue(cryptoService.verify(messageBytes, sig, pub));
			} catch (Exception ex) {
				throw new RuntimeException(ex);
			}
		}
	}

}