//
//  XPQRCodeTool.m
//  CTools
//
//  Created by Chance on 15/10/15.
//  Copyright © 2015年 Chance. All rights reserved.
//

#import "XPQRCodeTool.h"

NSString *const AVObjectTypeQRCode = @"AVMetadataObjectTypeQRCode";
NSString *const AVObjectTypeBarCode = @"AVMetadataObjectTypeBarCode";
NSString *const AVObjectTypeBoth = @"AVMetadataObjectTypeBoth";

@interface XPQRCodeTool ()<AVCaptureMetadataOutputObjectsDelegate>

@property (strong, nonatomic) AVCaptureDevice           *device;
@property (strong, nonatomic) AVCaptureDeviceInput      *input;
@property (strong, nonatomic) AVCaptureMetadataOutput   *output;
@property (nonatomic, strong) AVCaptureSession          *aSession;
@property (nonatomic, strong) NSArray                   *types;

@property (nonatomic, assign) BOOL                      isOnFlashLamp;

@property (nonatomic, strong) CALayer *alayer;

@property (nonatomic, copy) void (^finishedBlock)(NSString *value);

@end

@implementation XPQRCodeTool

- (instancetype)init {
    self = [super init];
    if (self) {
        _scanAreaRect = CGRectMake((kScreenWidth - 200) / 2, (kScreenHeight - 200) / 2, 200, 200);
        
        _alayer = [CALayer layer];
        _alayer.frame = _scanAreaRect;
        _alayer.borderColor = [UIColor lightGrayColor].CGColor;
        _alayer.borderWidth = kSingleLine;
        [self addSublayer:_alayer];
        
        _types = @[AVMetadataObjectTypeQRCode];
        self.videoGravity = AVLayerVideoGravityResize;
        self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    }
    return self;
}

- (void)setScanAreaRect:(CGRect)scanAreaRect {
    _scanAreaRect = scanAreaRect;
    _alayer.frame = _scanAreaRect;
    [self setRectOfInterest:scanAreaRect];
}

// 修正扫描区域
- (void)setRectOfInterest:(CGRect)rect {
    CGRect cropRect = CGRectMake(rect.origin.y, kScreenWidth - rect.origin.x - rect.size.width, rect.size.height, rect.size.width);
    
    // 扫描区域 条形码时需要重新修正
    [_output setRectOfInterest:CGRectMake(cropRect.origin.x / kScreenHeight, cropRect.origin.y / kScreenWidth, cropRect.size.height / kScreenHeight, cropRect.size.width / kScreenWidth)];
}

- (void)setMetadataObjectType:(NSString *)type {
    if ([type isEqualToString:AVObjectTypeQRCode]) {
        _types = @[AVMetadataObjectTypeQRCode];
    } else if ([type isEqualToString:AVObjectTypeBarCode]) {
        _types = @[AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypeCode39Mod43Code, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode93Code, AVMetadataObjectTypeUPCECode];
    } else {
        _types = @[AVMetadataObjectTypeQRCode, AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypeCode39Mod43Code, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode93Code, AVMetadataObjectTypeUPCECode];
    }
    
    if (_output) {
        
        if ([self.session isRunning]) {
            
            self.session = nil;
            
            __weak __typeof(self) _self = self;
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [_self.aSession stopRunning];
                
                [_output setMetadataObjectTypes:_types];
                
                [_self.aSession startRunning];
                _self.session = self.aSession;
                
                if (_self.isOnFlashLamp) {
                    [_self onFlashLamp];
                }
            });
        }
    }
}

- (void)setFinishedBlock:(void (^)(NSString *))finishedBlock {
    if (_finishedBlock != finishedBlock) {
        _finishedBlock = finishedBlock;
    }
}

- (void)startScan {
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    NSError *error = nil;
    // Input
    _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:&error];
    
    if (error) {
        NSLog(@"出错啦:%@", error);
        return;
    }
    
    // Output
    _output = [[AVCaptureMetadataOutput alloc] init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    // Session
    _aSession = [[AVCaptureSession alloc] init];
    [_aSession setSessionPreset:AVCaptureSessionPresetHigh];
    
    if ([_aSession canAddInput:self.input]) {
        [_aSession addInput:self.input];
    }
    
    if ([_aSession canAddOutput:self.output]) {
        [_aSession addOutput:self.output];
    }
    
    // 条码类型 AVMetadataObjectTypeQRCode
    _output.metadataObjectTypes = _types;
    
    self.session = _aSession;
    
    __weak __typeof(self) _self = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [_self.session startRunning];
    });
    
    [self setRectOfInterest:_scanAreaRect];
    
}

- (void)stopScan {
    [self.session stopRunning];
    self.device = nil;
    self.input = nil;
    self.output = nil;
    self.aSession = nil;
    self.session = nil;
}

- (BOOL)isScaning {
    return [self.session isRunning];
}

- (void)onFlashLamp {
    self.isOnFlashLamp = YES;
    Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
    if (captureDeviceClass != nil) {
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        if ([device hasTorch] /*&& [device hasFlash]*/){
            
            [device lockForConfiguration:nil];
            
            [device setTorchMode:AVCaptureTorchModeOn];
            [device setFlashMode:AVCaptureFlashModeOn];
            
            [device unlockForConfiguration];
        }
    }
}

- (void)offFlashLamp {
    self.isOnFlashLamp = NO;
    Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
    if (captureDeviceClass != nil) {
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        if ([device hasTorch] && [device hasFlash]){
            
            [device lockForConfiguration:nil];
            
            [device setTorchMode:AVCaptureTorchModeOff];
            [device setFlashMode:AVCaptureFlashModeOff];
            
            [device unlockForConfiguration];
        }
    }
}

- (BOOL)checkAVAuthorizationStatus {
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    if(status == AVAuthorizationStatusAuthorized) {
        return YES;
    } else {
        if (self.finishedBlock) {
            self.finishedBlock(@"您没有权限访问相机");
        }
    }
    return NO;
}

- (void)appDidActive {
    NSLog(@"appDidActive");
    if (self.isOnFlashLamp) {
        [self onFlashLamp];
    }
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    NSString *stringValue;
    if ([metadataObjects count] > 0)
    {
        //停止扫描
        [self stopScan];
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
    }
    
    NSLog(@" %@",stringValue);
    
    if (self.finishedBlock) {
        self.finishedBlock(stringValue);
    }
}

- (void)dealloc {
    [self stopScan];
    self.finishedBlock = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
}

@end
