//
//  SzSlider.h
//  SzSpeedSlider
//
//  Created by qianfeng on 15/11/9.
//  Copyright (c) 2015年 kassem. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SzSlider : UIControl
/*
 极值
 最小值
 当前值
 
 线粗
 
 填充色
 底色
 
 把手色
 
 label字体
 label颜色
 
 */
@property (nonatomic) float minimumValue;
@property (nonatomic) float maximumValue;
@property (nonatomic) float currentValue;

@property (nonatomic) int lineWidth;
@property (nonatomic, strong) UIColor* filledColor;
@property (nonatomic, strong) UIColor* unfilledColor;

@property (nonatomic, strong) UIColor* handleColor;

@property (nonatomic, strong) UIFont* labelFont;
@property (nonatomic, strong) UIColor* labelColor;
@property (nonatomic) BOOL snapToLabels;

-(void)setInnerMarkingLabels:(NSArray*)labels;
//设置以label形式显示的内圈标示
@end
