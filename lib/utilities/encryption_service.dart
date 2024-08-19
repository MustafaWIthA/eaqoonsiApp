import 'package:encrypt/encrypt.dart' as encrypt;
import 'dart:convert';

class EncryptionService {
  static const String _key =
      '698b6ef4fb197ad4665a6ea648c089de'; // 32-char key for AES-256

  String encryptData(String data) {
    final key = encrypt.Key.fromUtf8(_key);
    final iv = encrypt.IV.fromLength(16);
    final encrypter =
        encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));

    final encrypted = encrypter.encrypt(data, iv: iv);
    return base64Encode(iv.bytes + encrypted.bytes);
  }

  String decryptData(String encryptedData) {
    try {
      final key = encrypt.Key.fromUtf8(_key);
      final bytes = base64Decode(encryptedData);
      final iv = encrypt.IV(bytes.sublist(0, 16));
      final encrypter =
          encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));

      final encrypted = encrypt.Encrypted(bytes.sublist(16));
      return encrypter.decrypt(encrypted, iv: iv);
    } catch (e) {
      throw Exception('Decryption failed: ${e.toString()}');
    }
  }
}
