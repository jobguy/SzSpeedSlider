//
//  ViewController.m
//  SzSpeedSlider
//
//  Created by qianfeng on 15/11/9.
//  Copyright (c) 2015年 kassem. All rights reserved.
//

#import "ViewController.h"
#import "SzSlider.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    SzSlider * sz = [[SzSlider alloc]initWithFrame:CGRectMake(100, 100, 200, 200)];
    [self.view addSubview:sz];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
