//
//  NSString+Extension.h
//  CTools
//
//  Created by Chance on 15/3/2.
//  Copyright (c) 2015年 Chance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (Extension)

#pragma mark - 字符串计算
- (CGFloat)heightWithScopeSize:(CGSize)size font:(UIFont *)font;
- (CGFloat)heightWithScopeSize:(CGSize)size fontSize:(CGFloat)fontSize;
- (CGSize)sizeWithScopeSize:(CGSize)size font:(UIFont *)font;
- (CGSize)sizeWithScopeSize:(CGSize)size fontSize:(CGFloat)fontSize;

#pragma mark - 字符串处理

/**
 *  清除空格字符
 */
- (NSString *)trimming;

/**
 *  清除空格字符
 */
- (NSString *)trimmingInArray:(NSArray *)character;

/**
 *  取子字符串（索引, 长度）
 *  @param  index       起始索引
 *  @param  length      长度
 */
- (NSString *)substringFromIndex:(NSUInteger)index length:(NSUInteger)length;

/**
 *  取子字符串（起始索引, 结束索引）
 *  @param  index       起始索引
 *  @param  toIndex     结束索引(不包含)
 */
- (NSString *)substringFromIndex:(NSUInteger)index toIndex:(NSUInteger)toIndex;

/**
 *  移除开头字符
 */
- (NSString *)removeFirstCharacters;

/**
 *  移除末尾字符
 */
- (NSString *)removeLastCharacters;

/**
 *  移除子字符串（索引, 长度）
 *
 *  @param index  起始索引
 *  @param length 长度
 */
- (NSString *)removeStringFromIndex:(NSUInteger)index length:(NSUInteger)length;

/**
 *  移除子字符串（起始索引, 结束索引）
 *
 *  @param index   起始索引
 *  @param toIndex 结束索引
 */
- (NSString *)removeStringFromIndex:(NSUInteger)index toIndex:(NSUInteger)toIndex;

/**
 *  过滤html特殊字符 "\t", "&lt;", "&gt;", "&lt;", "&amp;", "&nbsp;",
 */
- (NSString *)ignoreHTMLSpecialString;

#pragma mark - 正则表达式处理相关
/**
 *  替换匹配的字符串
 *
 *  @param regexp      正则表达式
 *  @param replacement 替换的字符串
 *
 *  @return 返回替换后的字符串
 */
- (NSString *)replacingOfRegexp:(NSString *)regexp withString:(NSString *)replacement;

/**
 *  生成匹配的字符串
 *
 *  @param matchRegex 正则表达式
 *
 *  @return 匹配成功的字符串
 */
- (NSString *)stringWithMatchString:(NSString *)matchRegex;

/**
 *  生成匹配的所有子字符串
 *
 *  @param matchRegex 正则表达式
 *
 *  @return 返回匹配的子字符串
 */
- (NSMutableArray *)substringsWithMatchString:(NSString *)matchRegex;

/**
 *  匹配匹配的所有子字符串所在范围
 *
 *  @param matchRegex 正则表达式
 *
 *  @return 返回所有匹配的子字符串所在范围
 */
- (NSMutableArray *)rangesWithMatchString:(NSString *)matchRegex;



#pragma mark -

/**
 *  字符串MD5值
 */
- (NSString *)MD5;

/**
 *  字符串SHA1值
 */
- (NSString*)SHA1;

/**
 *  字符串AES256加密
 */
- (NSString *)AES256Encrypt:(NSString *)key;

/**
 *  字符串AES256解密
 */
- (NSString *)AES256Decrypt:(NSString *)key;

/**
 *  Base64 编码
 */
- (NSString *)base64Encoding;

/**
 *  Base64 解码
 */
- (NSString *)base64Decoding;

/**
 *  返回UTF8编码的URL
 */
- (NSURL *)URLUTF8StringEncoding;

/**
 *  返回指定编码的URL
 */
- (NSURL *)URLWithEncoding:(NSStringEncoding)encoding;

/**
 *  转换到拼音
 */
- (NSString *)transformToPinyin;

/**
 *  中文转Unicode
 */
- (NSString *)chineseToUnicode;

/**
 *  Unicode转中文
 */
- (NSString *)unicodeToChinese;

/**
 *  转换为颜色
 *  支持(#,0x) 前缀 #0099ff、0x0099ff，也可以不写前缀 0099ff
 *  支持缩写 #ccc＝#cccccc
 *  支持透明度 #0099ff10 长度为8位的最后两位表示透明度 0(0.0) 到 10(1.0)
 *  缩写不支持透明度
 */
- (UIColor *)toColor;

// int转换字符串
NSString *parseInt(int value);
NSString *parseInteger(NSInteger value);
NSString *parseUchar(const unsigned char *cString);

/**
 *  字符串关键字变色
 *  @param str   关键字
 *  @param color 颜色
 */
- (NSAttributedString *)attributeWithSubtr:(NSString *)substr color:(UIColor *)color;

/**
 *  HTML转换为属性字符串
 */
- (NSAttributedString *)HTMLToAttributeString;

#pragma mark - 字符串检查
/**
 *  判断是否为真实手机号码
 */
- (BOOL)isMobileNumber;

/**
 *  判断email格式是否正确
 */
- (BOOL)isEmail;

/**
 *  判断车牌号格式是否正确
 */
- (BOOL)isLicenseNumber;

/**
 *  创建一个唯一的标识 UUID
 */
+ (NSString *)stringCreateUUID;

//+ (NSString *)stringWithNumber:(NSNumber *)number formatterStyle:(NSNumberFormatterStyle)style;
@end

@interface NSAttributedString (Extension)

@end
