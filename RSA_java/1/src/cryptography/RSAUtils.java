package cryptography;

import java.math.BigInteger;
import javax.crypto.Cipher;

import java.io.ByteArrayOutputStream;
import java.security.Key;
import java.security.KeyFactory;
import java.security.KeyPair;
import java.security.KeyPairGenerator;
import java.security.NoSuchAlgorithmException;
import java.security.PrivateKey;
import java.security.PublicKey;
import java.security.SecureRandom;
import java.security.Signature;
import java.security.interfaces.RSAPrivateKey;
import java.security.interfaces.RSAPublicKey;
import java.security.spec.PKCS8EncodedKeySpec;
import java.security.spec.X509EncodedKeySpec;
import java.util.Base64;
import java.util.HashMap;
import java.util.Map;

/**
 * RSA�ӽ��ܡ�������У��ǩ���Ĺ�����
 */
public class RSAUtils {
    public static final String PUBLIC_KEY = "PUBLIC_KEY";
    public static final String PRIVATE_KEY = "PRIVATE_KEY";

    private static final Base64.Encoder base64Encoder = Base64.getEncoder();
    private static final Base64.Decoder base64Decoder = Base64.getDecoder();

    private static final String ALGORITHM = "RSA";
    /**
     * ǩ���㷨
     */
    private static final String SIGN_TYPE = "SHA1withRSA";
    /**
     * ��Կ����
     */
    private static final Integer KEY_LENGTH = 1024;

    /**
     * RSA���������Ĵ�С
     */
    private static final int MAX_ENCRYPT_BLOCK = 117;
    /**
     * RSA���������Ĵ�С
     */
    private static final int MAX_DECRYPT_BLOCK = 128;

    /**
     * ������Կ�ԣ���Կ��˽Կ
     *
     * @return ��Կ��ֵ��
     * @throws Exception ������Կ���쳣
     */
    public static Map<String, Key> genKeyPair() throws Exception {
        Map<String, Key> keyMap = new HashMap<>();
        KeyPairGenerator keyPairGenerator = KeyPairGenerator.getInstance(ALGORITHM);
        keyPairGenerator.initialize(KEY_LENGTH); // ��Կ�ֽ���
        KeyPair keyPair = keyPairGenerator.generateKeyPair();
        PublicKey publicKey = keyPair.getPublic();
        PrivateKey privateKey = keyPair.getPrivate();
        keyMap.put(PUBLIC_KEY, publicKey);
        keyMap.put(PRIVATE_KEY, privateKey);
        return keyMap;
    }

    /**
     * ��Կ����
     *
     * @param data      ����ǰ����
     * @param publicKey ��Կ
     * @return ���ܺ�����
     * @throws Exception �����쳣
     */
    public static byte[] encryptByPublicKey(byte[] data, Key publicKey) throws Exception {
        // �������ݣ��ֶμ���
        Cipher cipher = Cipher.getInstance(ALGORITHM);
        cipher.init(Cipher.ENCRYPT_MODE, publicKey);
        int inputLength = data.length;
        ByteArrayOutputStream out = new ByteArrayOutputStream();
        int offset = 0;
        byte[] cache;
        int i = 0;
        while (inputLength - offset > 0) {
            if (inputLength - offset > MAX_ENCRYPT_BLOCK) {
                cache = cipher.doFinal(data, offset, MAX_ENCRYPT_BLOCK);
            } else {
                cache = cipher.doFinal(data, offset, inputLength - offset);
            }
            out.write(cache, 0, cache.length);
            i++;
            offset = i * MAX_ENCRYPT_BLOCK;
        }
        byte[] encryptedData = out.toByteArray();
        out.close();
        return encryptedData;
    }

    public static byte[] encryptByPublicKey(byte[] data, String publicKeyBase64Encoded) throws Exception {
        return encryptByPublicKey(data, parseString2PublicKey(publicKeyBase64Encoded));
    }

    /**
     * ˽Կ����
     *
     * @param data       ����ǰ����
     * @param privateKey ˽Կ
     * @return ���ܺ�����
     * @throws Exception �����쳣
     */
    public static byte[] decryptByPrivateKey(byte[] data, Key privateKey) throws Exception {
        // �������ݣ��ֶν���
        Cipher cipher = Cipher.getInstance(ALGORITHM);
        cipher.init(Cipher.DECRYPT_MODE, privateKey);
        int inputLength = data.length;
        ByteArrayOutputStream out = new ByteArrayOutputStream();
        int offset = 0;
        byte[] cache;
        int i = 0;
        while (inputLength - offset > 0) {
            if (inputLength - offset > MAX_DECRYPT_BLOCK) {
                cache = cipher.doFinal(data, offset, MAX_DECRYPT_BLOCK);
            } else {
                cache = cipher.doFinal(data, offset, inputLength - offset);
            }
            out.write(cache);
            i++;
            offset = i * MAX_DECRYPT_BLOCK;
        }
        byte[] decryptedData = out.toByteArray();
        out.close();
        return decryptedData;
    }

    public static byte[] decryptByPrivateKey(byte[] data, String privateKeyBase64Encoded) throws Exception {
        return decryptByPrivateKey(data, parseString2PrivateKey(privateKeyBase64Encoded));
    }

    /**
     * ����ǩ��
     *
     * @param source     Ҫǩ������Ϣ
     * @param privateKey ˽Կ
     * @return ǩ��
     * @throws Exception ǩ���쳣
     */
    public static byte[] createSign(String source, PrivateKey privateKey) throws Exception {
        Signature signet = Signature.getInstance(SIGN_TYPE);
        signet.initSign(privateKey);
        signet.update(source.getBytes());
        return signet.sign();
    }

    public static byte[] createSign(String source, String privateKeyBase64Encoded) throws Exception {
        return createSign(source, parseString2PrivateKey(privateKeyBase64Encoded));
    }

    /**
     * У��ǩ��
     *
     * @param expected  ������Ϣ
     * @param sign      ǩ��
     * @param publicKey ��Կ
     * @return ���
     * @throws Exception У���쳣
     */
    public static boolean checkSign(String expected, byte[] sign, PublicKey publicKey) throws Exception {
        Signature signetCheck = Signature.getInstance(SIGN_TYPE);
        signetCheck.initVerify(publicKey);
        signetCheck.update(expected.getBytes());
        return signetCheck.verify(sign);
    }

    public static boolean checkSign(String expected, byte[] sign, String publicKeyBase64Encoded) throws Exception {
        return checkSign(expected, sign, parseString2PublicKey(publicKeyBase64Encoded));
    }

    /**
     * ��base64��ʽ�Ĺ�Կת��Ϊ����
     *
     * @param publicKeyBase64Encoded base64�Ĺ�Կ
     * @return ��Կ
     * @throws Exception ת���쳣
     */
    public static PublicKey parseString2PublicKey(String publicKeyBase64Encoded) throws Exception {
        return KeyFactory.getInstance(ALGORITHM).generatePublic(
                new X509EncodedKeySpec(base64Decoder.decode(publicKeyBase64Encoded)));
    }

    /**
     * ��base64��ʽ��˽Կת��Ϊ����
     *
     * @param privateKeyBase64Encoded base64��˽Կ
     * @return ˽Կ
     * @throws Exception ת���쳣
     */
    public static PrivateKey parseString2PrivateKey(String privateKeyBase64Encoded) throws Exception {
        return KeyFactory.getInstance(ALGORITHM).generatePrivate(
                new PKCS8EncodedKeySpec(base64Decoder.decode(privateKeyBase64Encoded)));
    }
    
    
    
    public static void main(String[] args) throws Exception {
        // write your code here

        // ������Կ��
        Map<String, Key> map = RSAUtils.genKeyPair();

        PublicKey publicKey = (PublicKey) map.get(RSAUtils.PUBLIC_KEY);
        PrivateKey privateKey = (PrivateKey) map.get(RSAUtils.PRIVATE_KEY);

        System.out.println("��������Կ�ԣ�");
        System.out.println("��Կ��");
        System.out.println(publicKey);
        System.out.println("˽Կ��");
        System.out.println(privateKey);
//            
        String info = "hello world!";
        System.out.println("ԭ��Ϊ��" + info);

        String str = Base64.getEncoder().encodeToString(RSAUtils.encryptByPublicKey(info.getBytes(), publicKey));
        String sign = Base64.getEncoder().encodeToString(RSAUtils.createSign(info, privateKey));

        System.out.println(">>>>>>>>>>>");
        System.out.println("���ģ�");

        System.out.println(str);
        
        System.out.println("ǩ����");
        System.out.println(sign);
        System.out.println(">>>>>>>>>>>");

        String resultInfo = new String(RSAUtils.decryptByPrivateKey(Base64.getDecoder().decode(str), privateKey));
        Boolean resultSign = RSAUtils.checkSign(info, Base64.getDecoder().decode(sign), publicKey);

        System.out.println(String.format("���ܽ����%s��ǩ��У������%s", resultInfo, resultSign));

    }
}
