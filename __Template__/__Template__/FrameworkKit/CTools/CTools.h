//
//  CTools.h
//  CTools
//
//  Version: 2.0
//  iOS SDK: Later iOS 7.0
//
//  Created by Chance on 15/4/22.
//  Copyright (c) 2015年 Chance. All rights reserved.
//

#ifndef CTools_CToolHeader_h
#define CTools_CToolHeader_h

// Base Header
#import "Base/Define.h"
#import "Base/Constant.h"
#import "Base/NSTool.h"
#import "Base/SingletonTemplate.h"


// Nib Header
#import "Nib/UIButtonNib.h"
#import "Nib/UIImageViewNib.h"
#import "Nib/UILabelNib.h"
#import "Nib/UITextFieldNib.h"
#import "Nib/UITextViewNib.h"
#import "Nib/UIViewNib.h"

// Tool Header
#import "Tool/AppManager.h"
#import "Tool/Keychain.h"
#import "Tool/NSFormatterTool.h"
#import "Tool/TouchID.h"
#import "Tool/UIViewController+XPInputHandle.h"
#import "Tool/XPPromptTag.h"
#import "Tool/XPQRCodeTool.h"
#import "Tool/XPSingleTool.h"
#import "Tool/APPSBaseManager.h"
#import "Tool/XPImageCode.h"
#import "Tool/XPInputEmojiFilter.h"

// Custom Header
#import "Custom/CActionSheet.h"
#import "Custom/CKBlurView.h"
#import "Custom/UILabelEdge.h"
#import "Custom/UILineView.h"
#import "Custom/UITextFieldEdge.h"
#import "Custom/XPWebView.h"
#import "Custom/XPScrollView.h"

// Function Header
#import "Function/Function.h"

// Category Header
#import "Category/NSArray+Extension.h"
#import "Category/NSData+Encryption.h"
#import "Category/NSDate+Extension.h"
#import "Category/NSDictionary+Extension.h"
#import "Category/NSNumber+Extension.h"
#import "Category/NSObject+Extension.h"
#import "Category/NSObject+Invocation.h"
#import "Category/NSString+Extension.h"
#import "Category/NSString+Log.h"
#import "Category/NSURL+Extension.h"
#import "Category/NSUserDefaults+Extension.h"
#import "Category/UIAlertController+Extenstion.h"
#import "Category/UIAlertView+Extension.h"
#import "Category/UIButton+Extension.h"
#import "Category/UIButton+State.h"
#import "Category/UIControl+Block.h"
#import "Category/UIImage+Extension.h"
#import "Category/UILabel+Extension.h"
#import "Category/UINavigationController+Extention.h"
#import "Category/UINib+Extension.h"
#import "Category/UIScrollView+Extension.h"
#import "Category/UITabBar+Extension.h"
#import "Category/UITableView+Extension.h"
#import "Category/UITableViewCell+Extension.h"
#import "Category/UITextField+Extension.h"
#import "Category/UITextView+Extension.h"
#import "Category/UIView+Events.h"
#import "Category/UIView+Extension.h"
#import "Category/UIGestureRecognizer+Handle.h"
#import "Category/UIViewController+Extension.h"

#endif

@interface CTools : NSObject

@end
