import 'package:encrypt/encrypt.dart' as encrypt;

class MyEncryptionDecryption {
  //For AES Encryption/Decryption
  static final key = encrypt.Key.fromLength(32);
  static final iv = encrypt.IV.fromLength(16);
  static final encrypter = encrypt.Encrypter(encrypt.AES(key));

  static encryptAES(text) {
    final encrypted = encrypter.encrypt(text, iv: iv);
    return encrypted.base16;
  }

  static decryptAES(text) {
    final decrypted = encrypter.decrypt16(text, iv: iv);
    return decrypted;
  }
}
