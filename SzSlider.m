//
//  SzSlider.m
//  SzSpeedSlider
//
//  Created by qianfeng on 15/11/9.
//  Copyright (c) 2015年 kassem. All rights reserved.
//

#import "SzSlider.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreImage/CoreImage.h>

//辅助公式 度数与弧度的转换
#define ToRad(deg) ( (M_PI * (deg) ) / 180.0)
#define ToDeg(rad) ( (180.0 * (rad)) / M_PI )
#define SQR(x) ( (x) * (x) )
#define Golden (sqrt(5.00) - 1)/2
#define HalfTransGolden ((1 - ((sqrt(5.00) - 1)/2))/2)
@implementation SzSlider
{
    

    CGFloat radius;
    int angle;
    int fixedAngle;
    NSMutableDictionary* labelsWithPercents;
    NSArray* labelsEvenSpacing;
}
- (id)initWithFrame:(CGRect)frame
{

    self = [super initWithFrame:frame];
    if (self) {
        // Defaults
        _maximumValue = 100.0f;
        _minimumValue = 0.0f;
        _currentValue = 0.0f;
        _lineWidth = 10;
        _unfilledColor = [UIColor grayColor];
        _filledColor = [UIColor colorWithRed:155/255.0f green:211/255.0f blue:156/255.0f alpha:1.0f];
        _handleColor = _filledColor;
        _labelFont = [UIFont systemFontOfSize:10.0f];
        _snapToLabels = NO;
        _labelColor = [UIColor redColor];
        
        angle = 0;
        radius = self.frame.size.height/2 - _lineWidth/2 - 10;
        
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    //画底板
    CGContextAddArc(ctx, self.frame.size.width/2, self.frame.size.height/2, radius,( M_PI*(1-Golden)/2), (M_PI- (M_PI*(1-Golden)/2)), 1);
    [_unfilledColor setStroke];
    CGContextSetLineWidth(ctx, _lineWidth);
    CGContextSetLineCap(ctx, kCGLineCapButt);
    CGContextDrawPath(ctx, kCGPathStroke);
    
   // Draw filled circle
    if (angle < 180.0 ) {
        CGContextAddArc(ctx, self.frame.size.width/2, self.frame.size.height/2, radius,(M_PI-(M_PI*(1-Golden)/2)), (M_PI-(M_PI*(1-Golden)/2))+ToRad(angle+3), 0);
        [_filledColor setStroke];
        CGContextSetLineWidth(ctx, _lineWidth);
        CGContextSetLineCap(ctx, kCGLineCapButt);
        CGContextDrawPath(ctx, kCGPathStroke);
        [self drawHandle:ctx];
    }
    else if(angle>=180){
        CGContextAddArc(ctx, self.frame.size.width/2, self.frame.size.height/2, radius,(M_PI-(M_PI*(1-Golden)/2)), (M_PI-(M_PI*(1-Golden)/2))-ToRad(angle+3), 0);
        [_filledColor setStroke];
        CGContextSetLineWidth(ctx, _lineWidth);
        CGContextSetLineCap(ctx, kCGLineCapButt);
        CGContextDrawPath(ctx, kCGPathStroke);
        [self drawHandle:ctx];
    }

   
}
- (void)drawHandle:(CGContextRef)ctx{
 CGContextSaveGState(ctx);
    CGPoint handleCenter = [self pointFromAngle:angle];
    [_handleColor set];
    CGContextAddArc(ctx, handleCenter.x + (_lineWidth)/2, handleCenter.y + (_lineWidth)/2, 8, 0, M_PI *2, 0);
    CGContextSetLineWidth(ctx, 3);
    CGContextSetLineCap(ctx, kCGLineCapButt);
    CGContextDrawPath(ctx, kCGPathStroke);
    
    CGContextAddArc(ctx, handleCenter.x + _lineWidth/2, handleCenter.y + _lineWidth/2, _lineWidth/2, 0, M_PI *2, 0);
    CGContextSetLineWidth(ctx, 2);
    CGContextSetLineCap(ctx, kCGLineCapButt);
    CGContextDrawPath(ctx, kCGPathStroke);
      CGContextRestoreGState(ctx);
}

-(CGPoint)pointFromAngle:(int)angleInt{
    
    //Define the Circle center
    CGPoint centerPoint = CGPointMake(self.frame.size.width/2 - _lineWidth/2, self.frame.size.height/2 - _lineWidth/2);
    
    //Define The point position on the circumference
    CGPoint result;
    NSLog(@"弧度的转过%d",angleInt);
    result.y = centerPoint.y + radius * sin(ToRad(angleInt+ToDeg(M_PI-(M_PI*(1-Golden)/2)))) ;
    result.x = centerPoint.x + radius * cos(ToRad(angleInt+ToDeg(M_PI-(M_PI*(1-Golden)/2))));
   
    return result;
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    [super beginTrackingWithTouch:touch withEvent:event];
    
    return YES;
}
-(BOOL) continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [super continueTrackingWithTouch:touch withEvent:event];
    
    CGPoint lastPoint = [touch locationInView:self];
    NSLog(@"坐标为%f,%f",lastPoint.x,lastPoint.y);
    [self moveHandle:lastPoint];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    
    return YES;
}
//-(void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
//    [super endTrackingWithTouch:touch withEvent:event];
//    if(_snapToLabels && labelsEvenSpacing != nil) {
//        CGPoint bestGuessPoint;
//        float minDist = 360;
//        for (int i=0; i<[labelsEvenSpacing count]; i++) {
//            CGFloat percentageAlongCircle = i/(float)[labelsEvenSpacing count];
//            CGFloat degreesForLabel = percentageAlongCircle * 360;
//            if(abs(fixedAngle - degreesForLabel) < minDist) {
//                minDist = abs(fixedAngle - degreesForLabel);
//                bestGuessPoint = [self pointFromAngle:degreesForLabel + 90 + 180];
//            }
//        }
//        CGPoint centerPoint = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
//        angle = floor(AngleFromNorth(centerPoint, bestGuessPoint, NO));
//        _currentValue = [self valueFromAngle];
//        [self setNeedsD                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         isplay];
//    }
//}
-(void)moveHandle:(CGPoint)point {
    CGPoint centerPoint = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    
    int currentAngle = floor(AngleFromFromGoldenStarter(radius,centerPoint, point, NO));
    angle = currentAngle;
   
    _currentValue = [self valueFromAngle];
    [self setNeedsDisplay];
     NSLog(@"转了%f",angle);
}

static inline float AngleFromFromGoldenStarter(CGFloat rr,CGPoint p1, CGPoint p2, BOOL flipped) {
   
    
    //p1 圆心的frame下坐标
    //p2 触点的frame下坐标
    
    //先算出goldenStarter的圆心向量坐标
    CGPoint GoldenStarter = CGPointMake(-(rr * cos(HalfTransGolden)),+(rr * sin(HalfTransGolden)) );
    CGPoint currentlocation = CGPointMake(p2.x - p1.x, p2.y - p1.y);
    
    CGFloat tran = (GoldenStarter.x * currentlocation.x + GoldenStarter.y * currentlocation.y)/ ((sqrt(SQR(GoldenStarter.x)+SQR(GoldenStarter.y))*sqrt(SQR(currentlocation.x)+SQR(currentlocation.y))));
    NSLog(@"余弦%f",tran);
    double fuck = acos(tran);
    NSLog(@"反余弦%f",fuck);
    float result = ToDeg(fuck);
    NSLog(@"猜猜看%f",result);
     return result;
}

-(float) valueFromAngle {
    if(angle < 0) {
        _currentValue = -angle;
    } else {
        _currentValue = 270 - angle + 90;
    }
    fixedAngle = _currentValue;
    return (_currentValue*(_maximumValue - _minimumValue))/360.0f;
}
@end
