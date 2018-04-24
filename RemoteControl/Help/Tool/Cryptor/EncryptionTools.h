//
//  EncryptionTools.h
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCrypto.h>

/**
 *  终端测试指令
 *
 *  DES(ECB)加密
 *  $ echo -n 520it | openssl enc -des-ecb -K 616263 -nosalt | base64
 *
  * DES(CBC)加密
 *  $ echo -n 520it | openssl enc -des-cbc -iv 0102030405060708 -K 616263 -nosalt | base64
 *
 *  AES(ECB)加密
 *  $ echo -n 520it | openssl enc -aes-128-ecb -K 616263 -nosalt | base64
 *
 *  AES(CBC)加密
 *  $ echo -n 520it | openssl enc -aes-128-cbc -iv 0102030405060708 -K 616263 -nosalt | base64
 ***********************************************************************
 *  DES(ECB)解密
 *  $ echo -n VqYjXo2ZlU4= | base64 -D | openssl enc -des-ecb -K 616263 -nosalt -d
 *
 *  DES(CBC)解密
 *  $ echo -n 7MCnAFj6DpQ= | base64 -D | openssl enc -des-cbc -iv 0102030405060708 -K 616263 -nosalt -d
 *
 *  AES(ECB)解密
 *  $ echo -n FqRpCOQG9IL2QrKBHhM+fA== | base64 -D | openssl enc -aes-128-ecb -K 616263 -nosalt -d
 *
 *  AES(CBC)解密
 *  $ echo -n Kd9MN/rNEI40hdLhayPbUw== | base64 -D | openssl enc -aes-128-cbc -iv 0102030405060708 -K 616263 -nosalt -d
 *
 *  提示：
 *      1> 加密过程是先加密，再base64编码
 *      2> 解密过程是先base64解码，再解密
 */
@interface EncryptionTools : NSObject


/**
 *  加密字符串并返回base64编码字符串
 *
 *  @return 返回加密后的base64编码字符串
 */
+ (NSString *)encryptAES:(NSString *)content key:(NSString *)key;
/**
 *  解密字符串
 */
+ (NSString *)decryptAES:(NSString *)content key:(NSString *)key;
@end
