//
//  HomeViewController.m
//  Template
//
//  Created by Chance on 16/6/22.
//  Copyright © 2016年 Chance. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
}



#pragma mark -

- (void)initUI {
    self.title = @"首页";
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, (kScreenHeight * 0.5) - 30, kScreenWidth - 20, 60)];
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont fontWithName:@"Menlo" size:50];
    label.textColor = color_hex(0x1eafd8);
    label.text = @"Template";
    [self.view addSubview:label];
}

- (void)backAction1:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
