//
//  UIImageView+Animation.m
//  ZZKTV
//
//  Created by stevenhu on 15/4/5.
//  Copyright (c) 2015年 zz. All rights reserved.
//
#import "Utility.h"
#import "UIImageView+Animation.h"
//#define SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
//#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
@implementation UIImageView (Animation)
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
    NSLog(@"start:%@",NSStringFromCGPoint(CGPointMake(self.frame.origin.x, transitionLayer.position.y)));
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
    group.delegate=self;
    group.fillMode=kCAFillModeForwards;
    group.removedOnCompletion=NO;
    group.autoreverses=NO;
    [transitionLayer addAnimation:group forKey:@"opacity"];
    
    [self performSelector:@selector(removeFrom:) withObject:transitionLayer afterDelay:1.5f];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    NSLog(@"animationDidStopGroup------>");
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

//{
//    //界限
//    
//    CABasicAnimation *boundsAnimation = [CABasicAnimationanimationWithKeyPath:@"bounds"];
//    boundsAnimation.fromValue = [NSValue valueWithCGRect: logoLayer.bounds];
//    boundsAnimation.toValue = [NSValue valueWithCGRect:CGRectZero];
//    
//    
//    //透明度变化
//    CABasicAnimation *opacityAnimation = [CABasicAnimationanimationWithKeyPath:@"opacity"];
//    opacityAnimation.fromValue = [NSNumber numberWithFloat:1.0];
//    opacityAnimation.toValue = [NSNumber numberWithFloat:0.5];
//    //位置移动
//    
//    CABasicAnimation *animation  = [CABasicAnimation animationWithKeyPath:@"position"];
//    animation.fromValue =  [NSValue valueWithCGPoint: logoLayer.position];
//    CGPoint toPoint = logoLayer.position;
//    toPoint.x += 180;
//    animation.toValue = [NSValue valueWithCGPoint:toPoint];
//    //旋转动画
//    CABasicAnimation* rotationAnimation =
//    [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];//"z"还可以是“x”“y”，表示沿z轴旋转
//    rotationAnimation.toValue = [NSNumber numberWithFloat:(2 * M_PI) * 3];
//    // 3 is the number of 360 degree rotations
//    // Make the rotation animation duration slightly less than the other animations to give it the feel
//    // that it pauses at its largest scale value
//    rotationAnimation.duration = 2.0f;
//    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]; //缓入缓出
//    
//    
//    //缩放动画
//    
//    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
//    scaleAnimation.fromValue = [NSNumber numberWithFloat:0.0];
//    scaleAnimation.toValue = [NSNumber numberWithFloat:1.0];
//    scaleAnimation.duration = 2.0f;
//    scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    
//    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
//    animationGroup.duration = 2.0f;
//    animationGroup.autoreverses = YES;   //是否重播，原动画的倒播
//    animationGroup.repeatCount = NSNotFound;//HUGE_VALF;     //HUGE_VALF,源自math.h
//    [animationGroup setAnimations:[NSArray arrayWithObjects:rotationAnimation, scaleAnimation, nil]];
//    
//    
//    //将上述两个动画编组
//    [logoLayer addAnimation:animationGroup forKey:@"animationGroup"];
//}
////去掉所有动画
//[logoLayer removeAllAnimations];
////去掉key动画
//
//[logoLayer removeAnimationForKey:@"animationGroup"];

- (void)startImagesAutoSwitch:(NSArray *)images {
//    [logoView startImagesAutoSwitch:@[[UIImage imageNamed:@"1"],[UIImage imageNamed:@"2"]]];
    if (images.count <=0) return;
    self.animationImages=images;
    self.animationDuration=10;
    self.animationRepeatCount=0;
    [self startAnimating];
}

- (void)stopImagesAutoSwitch {
    [self stopAnimating];
}
@end
