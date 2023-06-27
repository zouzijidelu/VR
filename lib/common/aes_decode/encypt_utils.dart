import 'dart:convert';
import 'dart:typed_data';

import 'package:encrypt/encrypt.dart';
import 'package:flutter/services.dart';
import 'package:pointycastle/asymmetric/api.dart';

/// Created by XieXin on 2021/8/13.
/// 加密工具类
class EncryptUtils {
  ///aes
  static late Key _keyAes;
  static late Encrypter _encryptAes;
  static IV _ivAes = IV.fromLength(16);

  ///rsa
  static late RSAPublicKey _publicKey;
  static late RSAPrivateKey _privateKey;
  static late Encrypter _encryptRsa;
  static late Signer _signer;

  /// Rsa加密最大长度
  static const int MAX_ENCRYPT_BLOCK = 117;

  /// Rsa解密最大长度
  static const int MAX_DECRYPT_BLOCK = 128;

  ///初始化AES加密启动时调用
  static Future<void> initAes(
      String key, {
        mode = AESMode.ecb,
        padding = 'PKCS7',
      }) async {
    if (key.length == 16 || key.length == 24 || key.length == 32) {
      _keyAes = Key.fromUtf8(key);
      _encryptAes = Encrypter(AES(_keyAes, mode: mode, padding: padding));
      return;
    }
    print("密钥长度为16/24/32位");
  }

  ///初始化RAS加密启动时调用
  static Future<void> initRsa(String publicPath, String privatePath) async {
    String publicKeyString = await rootBundle.loadString(publicPath);
    String privateKeyString = await rootBundle.loadString(privatePath);
    _publicKey = RSAKeyParser().parse(publicKeyString) as RSAPublicKey;
    _privateKey = RSAKeyParser().parse(privateKeyString) as RSAPrivateKey;

    _encryptRsa = Encrypter(
      RSA(publicKey: _publicKey, privateKey: _privateKey),
    );
    _signer = Signer(RSASigner(RSASignDigest.SHA256,
        publicKey: _publicKey, privateKey: _privateKey));
  }

  ///Aes加密
  static String encryptAes(String context) {
    return _encryptAes.encrypt(context, iv: _ivAes).base64;
  }

  ///Aes解密
  static String decryptAes(String context) {
    return _encryptAes.decrypt(Encrypted.fromBase64(context), iv: _ivAes);
  }

  ///公钥Rsa加密
  static String encryptRsa(String context) {
    // 原始字符串转成字节数组
    List<int> sourceBytes = utf8.encode(context);
    // 数据长度
    int inputLen = sourceBytes.length;
    // 缓存数组
    List<int> cache = [];
    // 分段加密 步长为MAX_ENCRYPT_BLOCK
    for (var i = 0; i < inputLen; i += MAX_ENCRYPT_BLOCK) {
      // 剩余长度
      int endLen = inputLen - i;
      List<int> item;
      if (endLen > MAX_ENCRYPT_BLOCK) {
        item = sourceBytes.sublist(i, i + MAX_ENCRYPT_BLOCK);
      } else {
        item = sourceBytes.sublist(i, i + endLen);
      }
      // 加密后对象转换成数组存放到缓存
      cache.addAll(_encryptRsa.encryptBytes(item).bytes);
    }
    // 加密后数组转换成base64编码并返回
    String en = base64.encode(cache);
    return en;
  }

  ///私钥Rsa解密
  static String decryptRsa(String data) {
    // 原始字符串转成字节数组
    Uint8List sourceBytes = base64.decode(data);
    // 数据长度
    int inputLen = sourceBytes.length;
    // 缓存数组
    List<int> cache = [];
    // 分段解密 步长为MAX_DECRYPT_BLOCK
    for (var i = 0; i < inputLen; i += MAX_DECRYPT_BLOCK) {
      // 剩余长度
      int endLen = inputLen - i;
      Uint8List item;
      if (endLen > MAX_DECRYPT_BLOCK) {
        item = sourceBytes.sublist(i, i + MAX_DECRYPT_BLOCK);
      } else {
        item = sourceBytes.sublist(i, i + endLen);
      }
      // 解密后存放到缓存
      cache.addAll(_encryptRsa.decryptBytes(Encrypted(item)));
    }
    // 解密后数组解码并返回
    String decode = utf8.decode(cache);
    return decode;
  }

  ///用私钥对信息生成数字签名
  static String sign(String data) {
    return _signer.sign(data).base64;
  }

  ///校验数字签名
  static bool verify(String data, String sign) {
    return _signer.verify64(data, sign);
  }
}
