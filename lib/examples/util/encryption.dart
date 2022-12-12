import 'package:encrypt/encrypt.dart';
import 'package:flutter_app/models/constants/UrlConstants.dart';

 // String createKey(text1, text2){
 String createKey(String text1){
   String finalKey = reverse(text1);
   if (finalKey.length >= 16){
     finalKey = finalKey.substring(0, 16);
   }else{
     int missing = 16 - finalKey.length;
     finalKey = finalKey + text1.substring(0, missing);
   }

   return finalKey;
 }

String reverse(String s) {
  StringBuffer sb=new StringBuffer();
  for(int i=s.length-1;i>=0;i--) {
    sb.write(s[i]);
  }
  return sb.toString();
}

  void main() {
    final plainText = "liakos@gmail.com";
    print('Plain text for encryption: $plainText');

    //Encrypt
    Encrypted encrypted = encryptWithAES(plainText, createKey(UrlConstants.URL_ENC));
    String encryptedBase64 = encrypted.base64;
    print('Encrypted data in base64 encoding: $encryptedBase64');

    //Decrypt
    String decryptedText = decryptWithAES(createKey(UrlConstants.URL_ENC), encrypted);
    print('Decrypted data: $decryptedText');
  }

  ///Accepts encrypted data and decrypt it. Returns plain text
  String decryptWithAES(String key, Encrypted encryptedData) {
    final cipherKey = Key.fromUtf8(key);

    final encryptService = Encrypter(AES(cipherKey, mode: AESMode.ecb)); //Using AES CBC encryption
    final initVector = IV.fromUtf8(key.substring(0, 16)); //Here the IV is generated from key. This is for example only. Use some other text or random data as IV for better security.

    return encryptService.decrypt(encryptedData, iv: initVector);

    // final encryptService = Encrypter(AES(cipherKey, mode: AESMode.cbc)); //Using AES CBC encryption
    // final initVector = IV.fromUtf8(key.substring(0, 16)); //Here the IV is generated from key. This is for example only. Use some other text or random data as IV for better security.
    //
    // return encryptService.decrypt(encryptedData, iv: initVector);
  }

  ///Encrypts the given plainText using the key. Returns encrypted data
  Encrypted encryptWithAES(String plainText, String key){
      // , String initialKey) {



    plainText = paddedPlainText(plainText);
   // final String key = createKey(plainText, initialKey);
    print('Will encrypt ' + plainText +  ' key is  $key');
    final cipherKey = Key.fromUtf8(key);

    print ('key after creation is ' + cipherKey.base64);
    final encryptService = Encrypter(AES(cipherKey, mode: AESMode.ecb));
    // final encryptService = Encrypter(AES(cipherKey, mode: AESMode.cbc));
    final initVector = IV.fromUtf8(key); //Here the IV is generated from key. This is for example only. Use some other text or random data as IV for better security.

    Encrypted encryptedData = encryptService.encrypt(plainText, iv: initVector);
    return encryptedData;
  }


/**
 * Since no aes padding is used, we need to apply padding to our text, in order to be multiple of 16bits.
 */
String paddedPlainText(String plainText) {
  if (plainText.length < 16){
    int len = plainText.length;
    for (int i=0; i< 16 - len; i++){
      plainText += '@';
    }
  }else {
    int mod = plainText.length % 16;
    int missingBytes = 16 - mod;
    for (int i = 0; i < missingBytes; i++) {
      plainText += '@';
    }
  }

  return plainText;
}