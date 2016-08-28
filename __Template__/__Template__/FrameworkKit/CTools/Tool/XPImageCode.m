//
//  QRCode.m
//  CTools
//
//  Created by Chance on 16/7/21.
//  Copyright © 2016年 Chance. All rights reserved.
//

#import "XPImageCode.h"

// 释放内存
void ProviderReleaseData(void *info, const void *data, size_t size) {
    free((void*)data);
}

// CIImage 转换到 UIImage
UIImage *createNonInterpolatedUIImageFormCIImage(CIImage *image, CGSize size, int scaleType) {
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scaleW = size.width / CGRectGetWidth(extent);
    CGFloat scaleH = size.height / CGRectGetHeight(extent);
    
    if (scaleType == 0) {
        scaleW = scaleH = MIN(scaleW, scaleH);
    }
    
    // create a bitmap image that we'll draw into a bitmap context at the desired size;
    size_t width = CGRectGetWidth(extent) * scaleW;
    size_t height = CGRectGetHeight(extent) * scaleH;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scaleW, scaleH);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // Create an image with the contents of our bitmap
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    UIImage *rtimg = [UIImage imageWithCGImage:scaledImage];
    
    // Cleanup
    CGColorSpaceRelease(cs);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    CGImageRelease(scaledImage);
    return rtimg;
}

// 重置颜色
UIImage *imageBlackToTransparent(UIImage *image, UIColor *color) {
    const int imageWidth = image.size.width;
    const int imageHeight = image.size.height;
    const CIColor *_color = [CIColor colorWithCGColor:color.CGColor];
    size_t      bytesPerRow = imageWidth * 4;
    uint32_t* rgbImageBuf = (uint32_t*)malloc(bytesPerRow * imageHeight);
    // create context
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, 8, bytesPerRow, colorSpace,
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), image.CGImage);
    // traverse pixe
    int pixelNum = imageWidth * imageHeight;
    uint32_t* pCurPtr = rgbImageBuf;
    for (int i = 0; i < pixelNum; i++, pCurPtr++){
        uint8_t* ptr = (uint8_t*)pCurPtr;
        if ((*pCurPtr & 0xFFFFFF00) < 0x99999900){
            ptr[3] = _color.red * 255; //0~255
            ptr[2] = _color.green * 255;
            ptr[1] = _color.blue * 255;
        }else{
            ptr[0] = 0;
        }
    }
    // context to image
    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, rgbImageBuf, bytesPerRow * imageHeight, ProviderReleaseData);
    CGImageRef imageRef = CGImageCreate(imageWidth, imageHeight, 8, 32, bytesPerRow, colorSpace,
                                        kCGImageAlphaLast | kCGBitmapByteOrder32Little, dataProvider,
                                        NULL, true, kCGRenderingIntentDefault);
    CGDataProviderRelease(dataProvider);
    UIImage* resultUIImage = [UIImage imageWithCGImage:imageRef];
    // release
    CGImageRelease(imageRef);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    return resultUIImage;
}


#pragma mark - 二维码

@implementation QRCode

#pragma mark - 生成
+ (UIImage *)encodeWithString:(NSString *)string {
    return [self encodeWithString:string width:kScreenWidth color:nil];
}

+ (UIImage *)encodeWithString:(NSString *)string width:(CGFloat)width {
    return [self encodeWithString:string width:width color:nil];
}

+ (UIImage *)encodeWithString:(NSString *)string color:(UIColor *)color {
    return [self encodeWithString:string width:kScreenWidth color:color];
}

+ (UIImage *)encodeWithString:(NSString *)string width:(CGFloat)width color:(UIColor *)color {
    if (!color) {
        color = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1];
    }
    CIImage *outImage = [self generateQRCodeForString:string];
    UIImage *endImage = createNonInterpolatedUIImageFormCIImage(outImage, CGSizeMake(width, 0), 0);
    return imageBlackToTransparent(endImage, color);
}

#pragma mark - Other Support Function
// 生成二维码 CIImage
+ (CIImage *)generateQRCodeForString:(NSString *)codeString {
    // Need to convert the string to a UTF-8 encoded NSData object
    NSData *stringData = [codeString dataUsingEncoding:NSUTF8StringEncoding];
    // Create the filter
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // Set the message content and error-correction level
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"M" forKey:@"inputCorrectionLevel"];
    // Send the image back
    return [qrFilter outputImage];
}

#pragma mark - 识别
+ (NSString *)decodeWithImage:(UIImage *)image {
    CIImage *ciimg = [[CIImage alloc] initWithImage:image];
    CIContext *context = [CIContext contextWithOptions:@{kCIContextUseSoftwareRenderer: @YES}];
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:context options:@{CIDetectorAccuracy: CIDetectorAccuracyHigh}];
    NSArray *features = [detector featuresInImage:ciimg];
    return [[features lastObject] messageString];
}

@end


#pragma mark - 条形码
@implementation BarCode

+ (UIImage *)encodeWithString:(NSString *)string {
    return [self encodeWithString:string size:CGSizeMake(kScreenWidth, 50) color:nil];
}

+ (UIImage *)encodeWithString:(NSString *)string size:(CGSize)size {
    return [self encodeWithString:string size:size color:nil];
}

+ (UIImage *)encodeWithString:(NSString *)string color:(UIColor *)color {
    return [self encodeWithString:string size:CGSizeMake(kScreenWidth, 50) color:color];
}

+ (UIImage *)encodeWithString:(NSString *)string size:(CGSize)size color:(UIColor *)color {
    if (!color) {
        color = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1];
    }
    CIImage *outImage = [self generateBarCodeForString:string];
    UIImage *endImage = createNonInterpolatedUIImageFormCIImage(outImage, size, 1);
    return imageBlackToTransparent(endImage, color);
}

#pragma mark -
// 生成条形码 CIImage
+ (CIImage *)generateBarCodeForString:(NSString *)codeString {
    NSData *data = [codeString dataUsingEncoding:NSISOLatin1StringEncoding allowLossyConversion:false];
    CIFilter *filter = [CIFilter filterWithName:@"CICode128BarcodeGenerator"];
    [filter setValue:data forKey:@"inputMessage"];
    return [filter outputImage];
}

@end
