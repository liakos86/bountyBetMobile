import 'package:encrypt/encrypt.dart' as enc;
import 'package:flutter/material.dart';
import 'package:flutter_app/models/constants/UrlConstants.dart';
import 'package:flutter_app/utils/SecureUtils.dart';

  String separator = '######';

  Future<String> getToken() async{
    var deviceIdentifier = await SecureUtils.getDeviceIdentifier();
    String fullKey = encryptWithAES(UrlConstants.URL_ENC + separator + deviceIdentifier + separator + DateTime.now().millisecondsSinceEpoch.toString(), createKey(UrlConstants.URL_ENC)).base64;
    return fullKey;
  }

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
    enc.Encrypted encrypted = encryptWithAES(plainText, createKey(UrlConstants.URL_ENC));
    String encryptedBase64 = encrypted.base64;
    print('Encrypted data in base64 encoding: $encryptedBase64');

    //Decrypt
    String decryptedText = decryptWithAES(createKey(UrlConstants.URL_ENC), encrypted);
    print('Decrypted data: $decryptedText');
  }

  ///Accepts encrypted data and decrypt it. Returns plain text
  String decryptWithAES(String key, enc.Encrypted encryptedData) {
    final cipherKey = enc.Key.fromUtf8(key);

    // final encryptService = enc.Encrypter(enc.AES(cipherKey, mode: enc.AESMode.ecb)); //Using AES CBC encryption
    final encryptService = enc.Encrypter(enc.AES(cipherKey, mode: enc.AESMode.ecb)); //Using AES CBC encryption
    //final initVector = enc.IV.fromUtf8(key.substring(0, 16)); //Here the IV is generated from key. This is for example only. Use some other text or random data as IV for better security.

    return encryptService.decrypt(encryptedData);//, iv: initVector);

    // final encryptService = Encrypter(AES(cipherKey, mode: AESMode.cbc)); //Using AES CBC encryption
    // final initVector = IV.fromUtf8(key.substring(0, 16)); //Here the IV is generated from key. This is for example only. Use some other text or random data as IV for better security.
    //
    // return encryptService.decrypt(encryptedData, iv: initVector);
  }

  ///Encrypts the given plainText using the key. Returns encrypted data
enc.Encrypted encryptWithAES(String plainText, String key){

    plainText = paddedPlainText(plainText);
    final cipherKey = enc.Key.fromUtf8(key);

    final encryptService = enc.Encrypter(enc.AES(cipherKey, mode: enc.AESMode.ecb));

    enc.Encrypted encryptedData = encryptService.encrypt(plainText);//, iv: initVector);
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