import 'package:encrypt/encrypt.dart';

void main() {
  final plainText = "Fallback! I repeat fallback to sector 12!!";
  final key = "This 32 char key have 256 bits..";

  print('Plain text for encryption: $plainText');

  //Encrypt
  Encrypted encrypted = encryptWithAES(key, plainText);
  String encryptedBase64 = encrypted.base64;
  print('Encrypted data in base64 encoding: $encryptedBase64');

  //Decrypt
  String decryptedText = decryptWithAES(key, encrypted);
  print('Decrypted data: $decryptedText');
}

///Accepts encrypted data and decrypt it. Returns plain text
String decryptWithAES(String key, Encrypted encryptedData) {
  final cipherKey = Key.fromUtf8(key);
  final encryptService = Encrypter(AES(cipherKey, mode: AESMode.cbc)); //Using AES CBC encryption
  final initVector = IV.fromUtf8(key.substring(0, 16)); //Here the IV is generated from key. This is for example only. Use some other text or random data as IV for better security.

  return encryptService.decrypt(encryptedData, iv: initVector);
}

///Encrypts the given plainText using the key. Returns encrypted data
Encrypted encryptWithAES(String key, String plainText) {
  final cipherKey = Key.fromUtf8(key);
  final encryptService = Encrypter(AES(cipherKey, mode: AESMode.cbc));
  final initVector = IV.fromUtf8(key.substring(0, 16)); //Here the IV is generated from key. This is for example only. Use some other text or random data as IV for better security.

  Encrypted encryptedData = encryptService.encrypt(plainText, iv: initVector);
  return encryptedData;
}