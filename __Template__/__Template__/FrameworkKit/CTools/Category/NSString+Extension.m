//
//  NSString+Extension.m
//  CTools
//
//  Created by Chance on 15/3/2.
//  Copyright (c) 2015年 Chance. All rights reserved.
//

#import "NSString+Extension.h"
#import <CommonCrypto/CommonDigest.h>
#import "NSData+Encryption.h"

@implementation NSString (Extension)

#pragma mark - 字符串所需大小计算
- (CGFloat)heightWithScopeSize:(CGSize)size font:(UIFont *)font {
    CGRect rect = [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName: font} context:nil];
    return rect.size.height;
}
- (CGFloat)heightWithScopeSize:(CGSize)size fontSize:(CGFloat)fontSize {
    return [self heightWithScopeSize:size font:[UIFont systemFontOfSize:fontSize]];
}

- (CGSize)sizeWithScopeSize:(CGSize)size font:(UIFont *)font {
    CGRect rect = [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName: font} context:nil];
    return rect.size;
}
- (CGSize)sizeWithScopeSize:(CGSize)size fontSize:(CGFloat)fontSize {
    return [self sizeWithScopeSize:size font:[UIFont systemFontOfSize:fontSize]];
}

#define Set(...) [NSSet setWithArray:@[__VA_ARGS__]];

#pragma mark - 字符串处理
- (NSString *)trimming {   
    NSString *str = [self stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSCharacterSet *cs = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    return [str stringByTrimmingCharactersInSet:cs];
}

- (NSString *)trimmingInArray:(NSArray *)character {
    NSSet *set = [NSSet setWithArray:character];
    
    NSString *str = nil;
    for (NSString *s in set) {
        str = [self stringByReplacingOccurrencesOfString:s withString:@""];
    }
    return str;
}

- (NSString *)substringFromIndex:(NSUInteger)index length:(NSUInteger)length {
    NSRange range;
    range.location = index;
    range.length = length;
    if (range.location + range.length > self.length) {
        return self;
    }
    return [self substringWithRange:range];
}

- (NSString *)substringFromIndex:(NSUInteger)index toIndex:(NSUInteger)toIndex {
    NSRange range;
    range.location = index;
    range.length = toIndex - index;
    if (range.location + range.length > self.length) {
        return self;
    }
    return [self substringWithRange:range];
}

- (NSString *)removeFirstCharacters {
    if ([self length] > 0) {
        return [self substringFromIndex:1];
    }
    return self;
}

- (NSString *)removeLastCharacters {
    if ([self length] > 0) {
        return [self substringToIndex:self.length - 1];
    }
    return self;
}

- (NSString *)removeStringFromIndex:(NSUInteger)index length:(NSUInteger)length {
    if (index + length < self.length) {
        NSString *lstr = [self substringToIndex:index];
        NSString *rstr = [self substringFromIndex:index + length];
        return [lstr stringByAppendingString:rstr];
    }
    return self;
}

- (NSString *)removeStringFromIndex:(NSUInteger)index toIndex:(NSUInteger)toIndex {
    if (index < toIndex) {
        NSString *lstr = [self substringToIndex:index];
        NSString *rstr = [self substringFromIndex:toIndex + 1];
        return [lstr stringByAppendingString:rstr];
    }
    return self;
}

- (NSString *)ignoreHTMLSpecialString {
    NSString *returnStr = [self stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    returnStr = [returnStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    returnStr = [returnStr stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    returnStr = [returnStr stringByReplacingOccurrencesOfString:@"&lt;" withString:@""];
    returnStr = [returnStr stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    returnStr = [returnStr stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    returnStr = [returnStr stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    returnStr = [returnStr stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    
    // 如果还有别的特殊字符，请添加在这里
    // ...
    /*
     returnStr = [returnStr stringByReplacingOccurrencesOfString:@"&ge;" withString:@"—"];
     returnStr = [returnStr stringByReplacingOccurrencesOfString:@"&mdash;" withString:@"®"];
     returnStr = [returnStr stringByReplacingOccurrencesOfString:@"&ldquo;" withString:@"“"];
     returnStr = [returnStr stringByReplacingOccurrencesOfString:@"&rdquo;" withString:@"”"];
     returnStr = [returnStr stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
     */
    
    return returnStr;
}

#pragma mark - 正则表达式处理相关
- (NSString *)replacingOfRegexp:(NSString *)regexp withString:(NSString *)replacement {
    NSError *error = NULL;
    NSRegularExpression *reg = [NSRegularExpression regularExpressionWithPattern:regexp options:0 error:&error];
    
    if (error) {
        return self;
    }
    
    NSString *result = [reg stringByReplacingMatchesInString:self options:0 range:NSMakeRange(0, self.length) withTemplate:replacement];
    return result;
}

- (NSString *)stringWithMatchString:(NSString *)matchRegex {
    NSError *error = NULL;
    NSRegularExpression *reg = [NSRegularExpression regularExpressionWithPattern:matchRegex options:NSRegularExpressionCaseInsensitive error:&error];
    
    NSArray *match = [reg matchesInString:self options:NSMatchingReportCompletion range:NSMakeRange(0, [self length])];
    
    NSMutableString *ms = [NSMutableString string];
    
    // 取得所有的NSRange对象
    if(match.count != 0) {
        for (NSTextCheckingResult *matc in match) {
            [ms appendString:[self substringWithRange:[matc range]]];
        }
    }
    
    return [ms copy];
}

- (NSMutableArray *)substringsWithMatchString:(NSString *)matchRegex {
    NSError *error = NULL;
    NSRegularExpression *reg = [NSRegularExpression regularExpressionWithPattern:matchRegex options:NSRegularExpressionCaseInsensitive error:&error];
    
    NSArray *match = [reg matchesInString:self options:NSMatchingReportCompletion range:NSMakeRange(0, [self length])];
    
    NSMutableArray *strArray = [NSMutableArray array];
    
    // 取得所有的NSRange对象
    if(match.count != 0) {
        for (NSTextCheckingResult *matc in match) {
            [strArray addObject:[self substringWithRange:[matc range]]];
        }
    }
    
    return strArray;
}

- (NSMutableArray *)rangesWithMatchString:(NSString *)matchRegex {
    NSError *error = NULL;
    NSRegularExpression *reg = [NSRegularExpression regularExpressionWithPattern:matchRegex options:NSRegularExpressionCaseInsensitive error:&error];
    
    NSArray *match = [reg matchesInString:self options:NSMatchingReportCompletion range:NSMakeRange(0, [self length])];
    
    NSMutableArray *rangeArr = [NSMutableArray array];
    
    // 取得所有的NSRange对象
    if(match.count != 0) {
        for (NSTextCheckingResult *matc in match) {
            NSValue *value = [NSValue valueWithRange:[matc range]];
            [rangeArr addObject:value];
        }
    }
    return rangeArr;
}

#pragma mark - 字符串转换
- (NSString *)MD5 {
    const char *cstr = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(cstr, (CC_LONG)strlen(cstr), result);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x",result[i]];
    }
    return output;
}

- (NSString *)SHA1 {
    const char *cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];
    unsigned char digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(cstr, (CC_LONG)strlen(cstr), digest);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    return output;
}

- (NSString *)AES256Encrypt:(NSString *)key {
    const char *cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:self.length];
    //对数据进行加密
    NSData *result = [data AES256EncryptWithKey:key];
    
    //转换为2进制字符串
    if (result && result.length > 0) {
        
        Byte *datas = (Byte*)[result bytes];
        NSMutableString *output = [NSMutableString stringWithCapacity:result.length * 2];
        for(int i = 0; i < result.length; i++){
            [output appendFormat:@"%02x", datas[i]];
        }
        return output;
    }
    return nil;
}

- (NSString *)AES256Decrypt:(NSString *)key {
    //转换为2进制Data
    NSMutableData *data = [NSMutableData dataWithCapacity:self.length / 2];
    unsigned char whole_byte;
    char byte_chars[3] = {'\0','\0','\0'};
    
    for (int i = 0; i < [self length] / 2; i++) {
        byte_chars[0] = [self characterAtIndex:i * 2];
        byte_chars[1] = [self characterAtIndex:i * 2 + 1];
        whole_byte = strtol(byte_chars, NULL, 16);
        [data appendBytes:&whole_byte length:1];
    }
    
    //对数据进行解密
    NSData* result = [data AES256DecryptWithKey:key];
    if (result && result.length > 0) {
        return [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
    }
    return nil;
}

- (NSString *)base64Encoding {
    NSData *originData = [self dataUsingEncoding:NSUTF8StringEncoding];
    return [originData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
}

- (NSString *)base64Decoding {
    NSData *decodeData = [[NSData alloc] initWithBase64EncodedString:self options:0];
    return [[NSString alloc] initWithData:decodeData encoding:NSUTF8StringEncoding];
}

- (NSURL *)URLUTF8StringEncoding {
    return [NSURL URLWithString:[self stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
}

- (NSURL *)URLWithEncoding:(NSStringEncoding)encoding {
    return [NSURL URLWithString:[self stringByAddingPercentEscapesUsingEncoding:encoding]];
}

- (NSString *)transformToPinyin {
    NSMutableString *pinyin = [self mutableCopy];
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformStripCombiningMarks, NO);
    return pinyin;
}

- (NSString *)chineseToUnicode
{
    NSMutableString *asciis = [NSMutableString string];
    
    for (int i = 0; i < self.length; i++) {
        NSString *cs = [self substringWithRange:NSMakeRange(i, 1)];
        unichar code = [cs characterAtIndex:0];
        if (code > 127) {
            [asciis appendString:@"\\u"];
            [asciis appendFormat:@"%04x", code];
        } else {
            [asciis appendString:cs];
        }
    }
    return [asciis copy];
}
- (NSString *)unicodeToChinese
{
    return [NSString stringWithCString:[self cStringUsingEncoding:NSUTF8StringEncoding] encoding:NSNonLossyASCIIStringEncoding];
}

- (UIColor *)toColor
{
    return colorFromHex(self);
}

UIColor *colorFromHex(NSString *hexs) {
    
    NSMutableString *string = [[hexs lowercaseString] mutableCopy];
    if ([string hasPrefix:@"0x"]) {
        [string deleteCharactersInRange:NSMakeRange(0, 2)];
    }
    if ([string hasPrefix:@"#"]) {
        [string deleteCharactersInRange:NSMakeRange(0, 1)];
    }
    
    int c = 0;
    int x = 0;
    
    if (string.length == 3) {
        c = 1;
        x = 2;
    }
    
    if (string.length == 6) {
        c = 2;
        x = 2;
    }
    
    if (string.length == 8) {
        c = 3;
    }
    
    int idx = 0;
    for (int i = 0; i < x; i--) {
        idx += c;
        [string insertString:@" " atIndex:idx++];
    }
    
    int r = 0, g = 0, b = 0, a = 10;
    
    sscanf([string UTF8String],"%x %x %x %d", &r, &g, &b, &a);
    
    if (c == 1) {
        r = 16 * r + r;
        g = 16 * g + g;
        b = 16 * b + b;
    }
    
    return [UIColor colorWithRed:r / 255.0 green:g / 255.0 blue:b / 255.0 alpha:a / 10.0];
}

NSString *parseInt(int value) {
    return [NSString stringWithFormat:@"%d", value];
}

NSString *parseInteger(NSInteger value) {
    return [NSString stringWithFormat:@"%@", @(value)];
}

NSString *parseUchar(const unsigned char *cString) {
    if (cString) {
        return [NSString stringWithUTF8String:(const char *)cString];
    }
    return nil;
}

- (NSAttributedString *)attributeWithSubtr:(NSString *)substr color:(UIColor *)color {
    NSRange range = [self rangeOfString:substr];
    NSMutableAttributedString *outStr = [[NSMutableAttributedString alloc] initWithString:self];
    [outStr addAttributes:@{NSForegroundColorAttributeName: color} range:range];
    return outStr;
}

- (NSAttributedString *)HTMLToAttributeString {
    NSData *htmlData = [self dataUsingEncoding:NSUnicodeStringEncoding];
    NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:htmlData options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    return attrStr;
}

#pragma mark - 字符串检查
// 判断是否为真实手机号码
- (BOOL)isMobileNumber {
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|70)\\d{8}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    return [regextestmobile evaluateWithObject:self];
}

// 各运营商号段正则
- (BOOL)mobileNumber {
    if (self.length != 11)
    {
        return NO;
    }
    /**
     * 手机号码:
     * 13[0-9], 14[5,7], 15[0, 1, 2, 3, 5, 6, 7, 8, 9], 17[6, 7, 8], 18[0-9], 170[0-9]
     * 移动号段: 134,135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,147,178,1705
     * 联通号段: 130,131,132,155,156,185,186,145,176,1709
     * 电信号段: 133,153,180,181,189,177,1700
     */
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|70)\\d{8}$";
    /**
     * 中国移动：China Mobile
     * 134,135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,147,178,1705
     */
    NSString *CM = @"(^1(3[4-9]|4[7]|5[0-27-9]|7[8]|8[2-478])\\d{8}$)|(^1705\\d{7}$)";
    /**
     * 中国联通：China Unicom
     * 130,131,132,155,156,185,186,145,176,1709
     */
    NSString *CU = @"(^1(3[0-2]|4[5]|5[56]|7[6]|8[56])\\d{8}$)|(^1709\\d{7}$)";
    /**
     * 中国电信：China Telecom
     * 133,153,180,181,189,177,1700
     */
    NSString *CT = @"(^1(33|53|77|8[019])\\d{8}$)|(^1700\\d{7}$)";
    
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:self] == YES)
        || ([regextestcm evaluateWithObject:self] == YES)
        || ([regextestct evaluateWithObject:self] == YES)
        || ([regextestcu evaluateWithObject:self] == YES))
    {
        return YES;
    } else {
        return NO;
    }
}

// 判断email格式是否正确
- (BOOL)isEmail {
    NSString *emailRegEx =
    @"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
    @"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
    @"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
    @"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
    @"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
    @"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
    @"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";
    
    NSPredicate *regExPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
    
    //先把NSString转换为小写
    NSString *lowerString = self.lowercaseString;
    
    return [regExPredicate evaluateWithObject:lowerString] ;
}

- (BOOL)isLicenseNumber {
    NSString *emailRegEx = @"^[\u4e00-\u9fa5]{1}[A-Z]{1}[A-Z_0-9]{5}$";
    NSPredicate *regExPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
    NSString *lowerString = self.uppercaseString;
    return [regExPredicate evaluateWithObject:lowerString];
}

+ (NSString *)stringCreateUUID {
    NSString *UUID = nil;
    
    CFUUIDRef uuidRef = CFUUIDCreate(NULL);
    CFStringRef str = CFUUIDCreateString(NULL, uuidRef);
    
    UUID = [NSString stringWithFormat:@"%@", str];
    
    CFRelease(uuidRef);
    CFRelease(str);
    
    return UUID;
}

//+ (NSString *)stringWithNumber:(NSNumber *)number formatterStyle:(NSNumberFormatterStyle)style
//{
//    
//}















@end
