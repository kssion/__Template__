//
//  UIImage+Extension.m
//  CTools
//
//  Created by Chance on 15/8/28.
//  Copyright (c) 2015年 Chance. All rights reserved.
//

#import "UIImage+Extension.h"
#import <Accelerate/Accelerate.h>

#define kWidth [[UIScreen mainScreen] bounds].size.width

@implementation UIImage (Extension)

- (UIImage *)imageScaleToSize:(CGSize)size {
    CGImageRef imgRef = self.CGImage;
    
    CGSize originSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef)); // 缩放后大小
    if (CGSizeEqualToSize(originSize, size)) {
        return self;
    }
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);//[UIScreen mainScreen].scale
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

- (UIImage *)imageScaleWithRatio:(CGFloat)ratio {
    CGImageRef imgRef = self.CGImage;
    
    if (ratio > 1 || ratio < 0) {
        return self;
    }
    
    CGSize size;
    switch (self.imageOrientation) {
        case UIImageOrientationRight: case UIImageOrientationLeft:
            size = CGSizeMake(CGImageGetHeight(imgRef) * ratio, CGImageGetWidth(imgRef) * ratio); // 缩放后大小
            break;
        default:
            size = CGSizeMake(CGImageGetWidth(imgRef) * ratio, CGImageGetHeight(imgRef) * ratio); // 缩放后大小
            break;
    }
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);//[UIScreen mainScreen].scale
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

- (UIImage *)roundImage {
    BOOL isReset = NO;
    
    CGImageRef imageRef = self.CGImage;
    CGSize size = CGSizeMake(CGImageGetWidth(imageRef), CGImageGetHeight(imageRef));
    float w = MIN(size.width, size.height);
    
    // 只取中间部分 生成正方形图片
    if (size.width != size.height) {
        imageRef = CGImageCreateWithImageInRect(self.CGImage, CGRectMake((size.width - w) * 0.5, (size.height - w) * 0.5, w, w));
        size = CGSizeMake(CGImageGetWidth(imageRef), CGImageGetHeight(imageRef));
        isReset = YES;
    }
    
    // 创建一个新的Image对象
    UIImage *newImage   = [UIImage imageWithCGImage:imageRef];
    CGPoint center      = CGPointMake(size.width * 0.5, size.height * 0.5);
    
    // 设置画布
    UIGraphicsBeginImageContextWithOptions((CGSize){w, w}, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    
    // 圆形裁剪 (对后边的绘制有影响)
    CGContextAddArc(context, center.x, center.y, w * 0.5, 0, M_PI * 2, 0);
    CGContextClip(context);
    
    [newImage drawInRect:CGRectMake(0, 0, w, w)];
    UIImage *roundImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    if (isReset) {
        CGImageRelease(imageRef);
    }
    return roundImage;
}

- (UIImage *)roundImageWithRadius:(CGFloat)radius {
    BOOL isReset = NO;
    
    CGImageRef imageRef = self.CGImage;
    CGSize size = CGSizeMake(CGImageGetWidth(imageRef), CGImageGetHeight(imageRef));
    float w = MIN(size.width, size.height);
    
    // 只取中间部分 生成正方形图片
    if (size.width != size.height) {
        imageRef = CGImageCreateWithImageInRect(self.CGImage, CGRectMake((size.width - w) * 0.5, (size.height - w) * 0.5, w, w));
        isReset = YES;
    }
    
    // 创建一个新的Image对象
    UIImage *newImage   = [UIImage imageWithCGImage:imageRef];
    CGPoint center      = CGPointMake(radius * 0.5, radius * 0.5);
    
    // 设置画布
    UIGraphicsBeginImageContextWithOptions((CGSize){radius, radius}, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    
    // 圆形裁剪 (对后边的绘制有影响)
    CGContextAddArc(context, center.x, center.y, radius * 0.5, 0, M_PI * 2, 0);
    CGContextClip(context);
    
    [newImage drawInRect:CGRectMake(0, 0, radius, radius)];
    UIImage *roundImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    if (isReset) {
        CGImageRelease(imageRef);
    }
    return roundImage;
}

- (UIImage *)roundImageWithRadius:(CGFloat)radius borderWith:(CGFloat)borderWidth borderColor:(UIColor *)borderColor {
    BOOL isReset = NO;
    
    CGImageRef imageRef = self.CGImage;
    CGSize size = CGSizeMake(CGImageGetWidth(imageRef), CGImageGetHeight(imageRef));
    float w = MIN(size.width, size.height);
    
    // 只取中间部分 生成正方形图片
    if (size.width != size.height) {
        imageRef = CGImageCreateWithImageInRect(self.CGImage, CGRectMake(floorf((size.width - w) * .5), floorf((size.height - w) * .5), w, w));
        isReset = YES;
    }
    
    // 创建一个新的Image对象
    UIImage *newImage   = [UIImage imageWithCGImage:imageRef];
    CGPoint center      = CGPointMake(radius * 0.5, radius * 0.5);
    
    // 设置画布
    UIGraphicsBeginImageContextWithOptions((CGSize){radius, radius}, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    
    // 绘制区域大小
    float drawWidth = radius - borderWidth * 2;
    
    // 添加边框
    [[borderColor colorWithAlphaComponent:0.5] set];
    CGContextAddArc(context, center.x, center.y, drawWidth * 0.5 + borderWidth, 0, M_PI * 2, 0);
    CGContextFillPath(context);
    
    // 圆形裁剪(对后边的绘制有影响)
    CGContextAddArc(context, center.x, center.y, drawWidth * 0.5, 0, M_PI * 2, 0);
    CGContextClip(context);
    
    // 绘制图像
    [newImage drawInRect:CGRectMake(borderWidth, borderWidth, drawWidth, drawWidth)];
    UIImage *roundImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    if (isReset) {
        CGImageRelease(imageRef);
    }
    return roundImage;
}

- (UIImage*)blurImageWithRadius:(CGFloat)radius {
    return [self blurImageWithRadius:radius color:nil];
}

- (UIImage*)blurImageWithRadius:(CGFloat)radius color:(UIColor *)color {
    radius = MAX(radius, 0.f);
    radius = MIN(radius, 1.f);
    
    int rSize = (int)(radius * 200);
    rSize = rSize - (rSize % 2) + 1;
    
    CGImageRef img = self.CGImage;
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    void *pixelBuffer;
    
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    
    if(pixelBuffer == NULL) NSLog(@"No pixelbuffer");
    
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, rSize, rSize, NULL, kvImageEdgeExtend);
    if (!error) {
        error = vImageBoxConvolve_ARGB8888(&outBuffer, &inBuffer, NULL, 0, 0, rSize, rSize, NULL, kvImageEdgeExtend);
    }
//    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, rSize, rSize, NULL, kvImageEdgeExtend)
//    ?: vImageBoxConvolve_ARGB8888(&outBuffer, &inBuffer, NULL, 0, 0, rSize, rSize, NULL, kvImageEdgeExtend)
//    ?: vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, rSize, rSize, NULL, kvImageEdgeExtend);
    
    CFRelease(inBitmapData);
    
    if (error) {
        NSLog(@"error from convolution %ld", error);
        return self;
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             (CGBitmapInfo)kCGImageAlphaNoneSkipLast);
    
    CGRect imageRect = {CGPointZero, self.size};
    
    // Add in color tint.
    if (color) {
        CGContextSaveGState(ctx);
        CGContextSetFillColorWithColor(ctx, color.CGColor);
        CGContextFillRect(ctx, imageRect);
        CGContextRestoreGState(ctx);
    }
    
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    
    //clean up
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    
    free(pixelBuffer);
    //free(pixelBuffer2);
    
    CGImageRelease(imageRef);
    
    return returnImage;
}

+ (UIImage *)imageWithScreenshot {
    CGSize imageSize = [[UIScreen mainScreen] bounds].size;
    
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    
    for (UIWindow *window in [[UIApplication sharedApplication] windows]) {
        if ([window screen] == [UIScreen mainScreen]) {
            [window drawViewHierarchyInRect:[[UIScreen mainScreen] bounds] afterScreenUpdates:NO];
        }
    }
    
    UIView *statusBar = [[UIApplication sharedApplication] valueForKey:@"statusBar"];
    [statusBar drawViewHierarchyInRect:[statusBar bounds] afterScreenUpdates:NO];
    
    UIImage *screenImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return screenImage;
}

+ (UIImage *)imageWithScreenshotNoStatusBar {
    CGSize imageSize = [[UIScreen mainScreen] bounds].size;
    
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    for (UIWindow *window in [[UIApplication sharedApplication] windows]) {
        if ([window screen] == [UIScreen mainScreen]) {
            
            CGContextSaveGState(context);
            CGContextTranslateCTM(context, [window center].x, [window center].y);
            CGContextConcatCTM(context, [window transform]);
            CGContextTranslateCTM(context,
                                  -[window bounds].size.width * [[window layer] anchorPoint].x,
                                  -[window bounds].size.height * [[window layer] anchorPoint].y);
            
            [[window layer] renderInContext:context];
            
            CGContextRestoreGState(context);
        }
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

//#pragma mark - 二维码
//+ (UIImage *)imageQRCodeWithString:(NSString *)string {
//    return [self imageQRCodeWithString:string width:kWidth color:nil];
//}
//
//+ (UIImage *)imageQRCodeWithString:(NSString *)string width:(CGFloat)width {
//    return [self imageQRCodeWithString:string width:width color:nil];
//}
//
//+ (UIImage *)imageQRCodeWithString:(NSString *)string color:(UIColor *)color {
//    return [self imageQRCodeWithString:string width:kWidth color:color];
//}
//
//+ (UIImage *)imageQRCodeWithString:(NSString *)string width:(CGFloat)width color:(UIColor *)color {
//    if (!color) {
//        color = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1];
//    }
//    CIImage *outImage = [self generateQRCodeForString:string];
//    UIImage *endImage = [self createNonInterpolatedUIImageFormCIImage:outImage withSize:width];
//    return [self imageBlackToTransparent:endImage withColor:color];
//}
//
//#pragma mark - 条形码
//+ (UIImage *)imageBarCodeWithString:(NSString *)string {
//    return [self imageBarCodeWithString:string size:CGSizeMake(kWidth, 50) color:nil];
//}
//
//+ (UIImage *)imageBarCodeWithString:(NSString *)string size:(CGSize)size {
//    return [self imageBarCodeWithString:string size:size color:nil];
//}
//
//+ (UIImage *)imageBarCodeWithString:(NSString *)string color:(UIColor *)color {
//    return [self imageBarCodeWithString:string size:CGSizeMake(kWidth, 50) color:color];
//}
//
//+ (UIImage *)imageBarCodeWithString:(NSString *)string size:(CGSize)size color:(UIColor *)color {
//    if (!color) {
//        color = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1];
//    }
//    CIImage *outImage = [self generateBarCodeForString:string];
//    UIImage *endImage = [self createNonInterpolatedUIImageFormCIImage1:outImage withSize:size];
//    return [self imageBlackToTransparent:endImage withColor:color];
//}
//
//#pragma mark - Other Support Function
//// 生成二维码 CIImage
//+ (CIImage *)generateQRCodeForString:(NSString *)codeString {
//    // Need to convert the string to a UTF-8 encoded NSData object
//    NSData *stringData = [codeString dataUsingEncoding:NSUTF8StringEncoding];
//    // Create the filter
//    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
//    // Set the message content and error-correction level
//    [qrFilter setValue:stringData forKey:@"inputMessage"];
//    [qrFilter setValue:@"M" forKey:@"inputCorrectionLevel"];
//    // Send the image back
//    return [qrFilter outputImage];
//}
//
//// 生成条形码 CIImage
//+ (CIImage *)generateBarCodeForString:(NSString *)codeString {
//    NSData *data = [codeString dataUsingEncoding:NSISOLatin1StringEncoding allowLossyConversion:false];
//    CIFilter *filter = [CIFilter filterWithName:@"CICode128BarcodeGenerator"];
//    [filter setValue:data forKey:@"inputMessage"];
//    return [filter outputImage];
//}
//
//
//// CIImage 转换到 UIImage
//+ (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat)size {
//    CGRect extent = CGRectIntegral(image.extent);
//    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
//    // create a bitmap image that we'll draw into a bitmap context at the desired size;
//    size_t width = CGRectGetWidth(extent) * scale;
//    size_t height = CGRectGetHeight(extent) * scale;
//    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
//    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
//    CIContext *context = [CIContext contextWithOptions:nil];
//    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
//    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
//    CGContextScaleCTM(bitmapRef, scale, scale);
//    CGContextDrawImage(bitmapRef, extent, bitmapImage);
//    // Create an image with the contents of our bitmap
//    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
//    // Cleanup
//    CGContextRelease(bitmapRef);
//    CGImageRelease(bitmapImage);
//    return [UIImage imageWithCGImage:scaledImage];
//}
//
//// CIImage 转换到 UIImage
//+ (UIImage *)createNonInterpolatedUIImageFormCIImage1:(CIImage *)image withSize:(CGSize)size {
//    CGRect extent = CGRectIntegral(image.extent);
//    CGFloat scaleW = size.width / CGRectGetWidth(extent);
//    CGFloat scaleH = size.height / CGRectGetHeight(extent);
//    // create a bitmap image that we'll draw into a bitmap context at the desired size;
//    size_t width = CGRectGetWidth(extent) * scaleW;
//    size_t height = CGRectGetHeight(extent) * scaleH;
//    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
//    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
//    CIContext *context = [CIContext contextWithOptions:nil];
//    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
//    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
//    CGContextScaleCTM(bitmapRef, scaleW, scaleH);
//    CGContextDrawImage(bitmapRef, extent, bitmapImage);
//    // Create an image with the contents of our bitmap
//    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
//    // Cleanup
//    CGContextRelease(bitmapRef);
//    CGImageRelease(bitmapImage);
//    return [UIImage imageWithCGImage:scaledImage];
//}
//
//// ?
//void ProviderReleaseData(void *info, const void *data, size_t size) {
//    free((void*)data);
//}
//
//// 重置颜色
//+ (UIImage*)imageBlackToTransparent:(UIImage*)image withColor:(UIColor *)color {
//    const int imageWidth = image.size.width;
//    const int imageHeight = image.size.height;
//    const CIColor *_color = [CIColor colorWithCGColor:color.CGColor];
//    size_t      bytesPerRow = imageWidth * 4;
//    uint32_t* rgbImageBuf = (uint32_t*)malloc(bytesPerRow * imageHeight);
//    // create context
//    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//    CGContextRef context = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, 8, bytesPerRow, colorSpace,
//                                                 kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
//    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), image.CGImage);
//    // traverse pixe
//    int pixelNum = imageWidth * imageHeight;
//    uint32_t* pCurPtr = rgbImageBuf;
//    for (int i = 0; i < pixelNum; i++, pCurPtr++){
//        uint8_t* ptr = (uint8_t*)pCurPtr;
//        if ((*pCurPtr & 0xFFFFFF00) < 0x99999900){
//            ptr[3] = _color.red * 255; //0~255
//            ptr[2] = _color.green * 255;
//            ptr[1] = _color.blue * 255;
//        }else{
//            ptr[0] = 0;
//        }
//    }
//    // context to image
//    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, rgbImageBuf, bytesPerRow * imageHeight, ProviderReleaseData);
//    CGImageRef imageRef = CGImageCreate(imageWidth, imageHeight, 8, 32, bytesPerRow, colorSpace,
//                                        kCGImageAlphaLast | kCGBitmapByteOrder32Little, dataProvider,
//                                        NULL, true, kCGRenderingIntentDefault);
//    CGDataProviderRelease(dataProvider);
//    UIImage* resultUIImage = [UIImage imageWithCGImage:imageRef];
//    // release
//    CGImageRelease(imageRef);
//    CGContextRelease(context);
//    CGColorSpaceRelease(colorSpace);
//    return resultUIImage;
//}



@end
