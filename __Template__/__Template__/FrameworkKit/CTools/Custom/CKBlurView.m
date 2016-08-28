//
//  CKBlurView.m
//  CKBlurView
//
//  Created by Conrad Kramer on 10/25/13.
//  Copyright (c) 2013 Kramer Software Productions, LLC. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "CKBlurView.h"

@interface CAFilter : NSObject

+ (instancetype)filterWithName:(NSString *)name;

@end

@interface CKBlurView ()

@property (weak, nonatomic) CAFilter *blurFilter;

@end

extern NSString * const kCAFilterGaussianBlur;

NSString * const CKBlurViewQualityDefault = @"d""e""f""a""u""l""t";

NSString * const CKBlurViewQualityLow = @"l""o""w";

static NSString * const CKBlurViewQualityKey = @"i""n""p""u""t""Q""u""a""l""i""t""y";

static NSString * const CKBlurViewRadiusKey = @"i""n""p""u""t""R""a""d""i""u""s";

static NSString * const CKBlurViewBoundsKey = @"i""n""p""u""t""B""o""u""n""d""s";

static NSString * const CKBlurViewHardEdgesKey = @"i""n""p""u""t""H""a""r""d""E""d""g""e""s";


@implementation CKBlurView

+ (Class)layerClass {
    id arrstr = @"C""A""B""a""c""k""d""r""o""p""L""a""y""e""r";
    return NSClassFromString(arrstr);
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        CAFilter *filter = [CAFilter filterWithName:kCAFilterGaussianBlur];
        self.layer.filters = @[filter];
        self.blurFilter = filter;

        self.blurQuality = CKBlurViewQualityDefault;
        self.blurRadius = 3.0f;
    }
    return self;
}

- (void)setQuality:(NSString *)quality {
    [self.blurFilter setValue:quality forKey:CKBlurViewQualityKey];
}

- (NSString *)quality {
    return [self.blurFilter valueForKey:CKBlurViewQualityKey];
}

- (void)setBlurRadius:(CGFloat)radius {
    [self.blurFilter setValue:@(radius) forKey:CKBlurViewRadiusKey];
}

- (CGFloat)blurRadius {
    return [[self.blurFilter valueForKey:CKBlurViewRadiusKey] floatValue];
}

- (void)setBlurCroppingRect:(CGRect)croppingRect {
    [self.blurFilter setValue:[NSValue valueWithCGRect:croppingRect] forKey:CKBlurViewBoundsKey];
}

- (CGRect)blurCroppingRect {
    NSValue *value = [self.blurFilter valueForKey:CKBlurViewBoundsKey];
    return value ? [value CGRectValue] : CGRectNull;
}

- (void)setBlurEdges:(BOOL)blurEdges {
    [self.blurFilter setValue:@(!blurEdges) forKey:CKBlurViewHardEdgesKey];
}

- (BOOL)blurEdges {
    return ![[self.blurFilter valueForKey:CKBlurViewHardEdgesKey] boolValue];
}

@end
