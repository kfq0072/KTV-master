//
//  UILabel+Animation.m
//  KTV
//
//  Created by mCloud on 15/4/27.
//  Copyright (c) 2015年 stevenhu. All rights reserved.
//

#import "UILabel+Animation.h"
#import "Utility.h"
#import "CommandControler.h"

@implementation UILabel (Animation)
- (void)shakeAndFlyAnimationToView:(UIBarButtonItem*)item{
    //－－－－>shake
    CABasicAnimation *shake=[CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    shake.fromValue=[NSNumber numberWithFloat:-0.2];
    shake.toValue=[NSNumber numberWithFloat:0.4];
    shake.duration=0.2;
    shake.autoreverses=YES;
    shake.repeatCount=4;
    
    //---->
    CAKeyframeAnimation* xunzhuang = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    xunzhuang.duration = 0.5;
    
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    xunzhuang.values = values;
    
    //--->bounds
    CABasicAnimation *boundsAnimation = [CABasicAnimation animationWithKeyPath:@"bounds"];
    boundsAnimation.fromValue = [NSValue valueWithCGRect: self.bounds];
    boundsAnimation.toValue = [NSValue valueWithCGRect:CGRectZero];
    
    //-----> 加入购物车
    //1.找到要加的layout content 和相对 key window 的frame
    CALayer *transitionLayer=[CALayer layer];
    [CATransaction begin];
    //    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    transitionLayer.opacity=1.0f;
    if ([[[UIDevice currentDevice]systemVersion]floatValue]< 7.9999999){
        transitionLayer.contents = self.layer.contents;
    } else {
        //        CALayer *tmpLayer = [self.layer.sublayers objectAtIndex:0];
        //        transitionLayer.contents = tmpLayer.contents;
        transitionLayer.contents=self.layer.contents;
    }
    transitionLayer.frame=[[UIApplication sharedApplication].keyWindow convertRect:self.bounds fromView:self];
    //    NSLog(@"%@",fromView.superview);
    //      transitionLayer.frame=[[UIApplication sharedApplication].keyWindow convertRect:self.frame toView:fromView];
    
    [[UIApplication sharedApplication].keyWindow.layer addSublayer:transitionLayer];
    [CATransaction commit];
    //2//路径虚线
    UIBezierPath *movepath=[UIBezierPath bezierPath];
    //起点
    [movepath moveToPoint:CGPointMake(transitionLayer.position.x, transitionLayer.position.y)];
//    NSLog(@"start:%@",NSStringFromCGPoint(CGPointMake(self.frame.origin.x, transitionLayer.position.y)));
    //终点
    //    CGPoint toPoint=CGPointMake(SCREEN_WIDTH, SCREEN_HEIGHT+10);
    //    CGPoint toPoint=CGPointMake(SCREEN_WIDTH, 0+10);
    CGPoint toPoint=[[UIApplication sharedApplication].keyWindow convertPoint:item.customView.center toView:[UIApplication sharedApplication].keyWindow];
    
    
    [movepath addQuadCurveToPoint:toPoint controlPoint:CGPointMake(self.superview.center.x,transitionLayer.position.y)];
    
    //3 关键帧
    CAKeyframeAnimation *positionAnimation=[CAKeyframeAnimation animationWithKeyPath:@"position"];
    positionAnimation.path=movepath.CGPath;
    positionAnimation.removedOnCompletion=YES;
    
    CAAnimationGroup *group=[CAAnimationGroup animation];
    group.beginTime=CACurrentMediaTime();
    group.duration=1.5f;//运动曲线的运动时间
    group.animations=[NSArray arrayWithObjects:boundsAnimation,xunzhuang,shake,positionAnimation, nil];
    group.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    group.fillMode=kCAFillModeForwards;
    group.removedOnCompletion=NO;
    group.autoreverses=NO;
    group.delegate=self;
    [transitionLayer addAnimation:group forKey:@"opacity"];
    [self performSelector:@selector(removeFrom:) withObject:transitionLayer afterDelay:1.5];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    NSLog(@"animationDidStopGroup------>");
    [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_YIDIAN_INCREASION object:nil];
}


/**
 *  自动移除layer
 *
 *  @param transitionLayer layer
 */
-(void)removeFrom:(CALayer *)transitionLayer
{
    [transitionLayer removeFromSuperlayer];
    
}
@end
