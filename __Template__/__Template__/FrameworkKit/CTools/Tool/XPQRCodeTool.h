//
//  XPQRCodeTool.h
//  CTools
//
//  Created by Chance on 15/10/15.
//  Copyright © 2015年 Chance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>

@protocol XPQRCodeToolDelegate;

/**
 *  使用示例:
 *  XPQRCodeTool *qrCodeLayer = [[XPQRCodeTool alloc] init];
 *  [viewController.view.layer insertSublayer:qrCodeLayer atIndex:0];
 *  [qrCodeLayer startScan];
 */

extern NSString *const AVObjectTypeQRCode; /**< 二维码*/
extern NSString *const AVObjectTypeBarCode; /**< 条形码*/
extern NSString *const AVObjectTypeBoth; /**< 二维码和条形码*/


/**
 *  二维码扫描图层（Layer）
 */
@interface XPQRCodeTool : AVCaptureVideoPreviewLayer
@property (nonatomic, assign) CGRect scanAreaRect;   // 扫描区域 默认居中 200*200

/**
 *  设置扫描完成回调
 *
 *  @param finishedBlock 扫描完成回调Block
 */
- (void)setFinishedBlock:(void(^)(NSString *value))finishedBlock;

/**
 *  扫描识别类型
 *
 *  @param AVMetadataObjectTypeQRCode   二维码
 *  @param AVMetadataObjectTypeBarCode  条形码
 *  @param AVMetadataObjectTypeBoth     两者
 */
- (void)setMetadataObjectType:(NSString *)type;

// 开始扫描
- (void)startScan;

// 停止扫描
- (void)stopScan;

// 扫描中
- (BOOL)isScaning;

// 开启闪光灯
- (void)onFlashLamp;

// 关闭闪光灯
- (void)offFlashLamp;

@end