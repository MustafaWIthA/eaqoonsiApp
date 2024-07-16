import 'package:encrypt/encrypt.dart' as encrypt;

class EncryptionService {
  static const String _key = '698b6ef4fb197ad4665a6ea648c089de';

  String encryptData(String data) {
    final key = encrypt.Key.fromUtf8(_key);
    final iv = encrypt.IV.fromLength(16);
    final encrypter = encrypt.Encrypter(encrypt.AES(key));

    final encrypted = encrypter.encrypt(data, iv: iv);
    return encrypted.base64;
  }

  String decryptData(String encryptedData) {
    final key = encrypt.Key.fromUtf8(_key);
    final iv = encrypt.IV.fromLength(16);
    final encrypter = encrypt.Encrypter(encrypt.AES(key));

    final encrypted = encrypt.Encrypted.fromBase64(encryptedData);
    return encrypter.decrypt(encrypted, iv: iv);
  }
}
