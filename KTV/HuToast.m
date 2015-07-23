

#import "HuToast.h"

#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

@interface HuToast ()
{
    UIView *tempView;
}
@property (nonatomic, strong) NSString *viewFrame;
@property (nonatomic, assign) NSString *textAlign;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, assign) CGFloat time;
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, assign) CGFloat textFont;
@property(nonatomic,strong)UILabel *privateLabel;
@end

@implementation HuToast


- (instancetype)init
{
    self = [super init];
    if (self) {
        _label = [[UILabel alloc] init];
        _label.numberOfLines = 0;
    }
    return self;
}

- (void)setToastWithMessage:(NSString *)message WithTimeDismiss:(NSString *)time messageType:(KMessageStyle)style;{
    _message = message;
    [self setMessage:message];
    CGFloat temTime = [time floatValue];
    [self setTime:temTime];
    _label.font = [UIFont systemFontOfSize:12];
    UIWindow  *window = [UIApplication sharedApplication].windows[0];
    UIFont *font = [UIFont systemFontOfSize:12];
    CGRect width = [_message boundingRectWithSize:CGSizeMake(300, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{ NSFontAttributeName :font} context:nil];
    _label.frame = CGRectMake(5, 5, width.size.width+10, width.size.height+20);
    tempView = [[UIView alloc] initWithFrame:CGRectMake(0, _label.frame.origin.y-10, width.size.width+20,width.size.height+30)];
    tempView.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT-100);
    
    switch (style) {
        case KMessageSuccess: {
            tempView.backgroundColor = [UIColor greenColor];
            _label.textColor=[UIColor blueColor];
            break;
        }
        case KMessageStyleError: {
            tempView.backgroundColor = [UIColor redColor];
            _label.textColor=[UIColor whiteColor];
            break;
        }
        case KMessageWarning:{
            tempView.backgroundColor = [UIColor yellowColor];
            _label.textColor=[UIColor blackColor];
            break;
        }
        case KMessageStyleInfo: {
            tempView.backgroundColor = [UIColor blueColor];
            _label.textColor=[UIColor groupTableViewBackgroundColor];
        }
        default: {
            tempView.backgroundColor = [UIColor lightGrayColor];
            _label.textColor=[UIColor blackColor];
        }
            break;
    }
    
    
    tempView.layer.cornerRadius = 10;
    tempView.clipsToBounds = YES;
    [tempView addSubview:_label];
    [window addSubview:tempView];
}

- (void)dissmiss{
    if (tempView != nil) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(laterRun) object:nil];
        [tempView removeFromSuperview];
    }
}

//- (void)setViewFrame:(NSString *)viewFrame{
//    UIWindow *window= [[UIApplication sharedApplication].windows objectAtIndex:0];
//
//    _label.alpha = 1;
//    NSArray *arr=[utility StringToArray:viewFrame];
//    if (!arr || arr.count!=4)  return;
//    self.privateLabel.backgroundColor = [UIColor whiteColor];
//    self.privateLabel.frame = CGRectMake([arr[0] floatValue], [arr[1] floatValue], [arr[2] floatValue], [arr[3] floatValue]);
//    window.backgroundColor = [UIColor yellowColor];
////    self.privateLabel.center = window.center;
//    [window addSubview:self.privateLabel];
//}

-(void)setMessage:(NSString *)message{
    _message = message;
    _label.alpha = 1;
    _label.text = message;
}

-(void)setTime:(CGFloat)time{
    _time = time;
    _label.alpha = 1;
    if (time < 1) {
        //n秒后view变淡
        [self performSelector:@selector(laterRun) withObject:nil afterDelay:2];
    }else{
        //n秒后view变淡
        [self performSelector:@selector(laterRun) withObject:nil afterDelay:4];
    }
    
}

-(void)laterRun{
    [UIView animateWithDuration:0.4 animations:^{
         tempView.alpha = 0;
        _label.alpha = 0;
        [_label removeFromSuperview];
        [tempView removeFromSuperview];
    }];
}

//- (void)setTextAlign:(NSString *)textAlign{
//    _textAlign = textAlign;
//    _label.alpha = 1;
//    if ([textAlign isEqualToString:@"left"]) {
//        _label.textAlignment = NSTextAlignmentLeft;
//    }else if ([textAlign isEqualToString:@"right"]) {
//        _label.textAlignment = NSTextAlignmentRight;
//    }else if ([textAlign isEqualToString:@"center"]) {
//        _label.textAlignment = NSTextAlignmentCenter;
//    }
//}

//- (void)setColor:(UIColor *)color{
//    _color = color;
//    _label.alpha = 1;
//    _label.textColor = color;
//}
//
//- (void)setBackgroundColor:(UIColor *)backgroundColor{
//    _label.alpha = 1;
//    _backgroundColor = backgroundColor;
//    _label.backgroundColor = backgroundColor;
//}
//
//- (void)setTextFont:(CGFloat)textFont{
//    _label.alpha = 1;
//    _textFont= textFont;
//    _label.font = [UIFont systemFontOfSize:textFont];
//}

#pragma mark -
#pragma mark testMRToast
/**
 *  MRToastView  测试项目
 *
 *  @param
 */
//- (BOOL)onAttributeChanged:(NSInteger)attr :(NSString *)value {
//    
//    switch (attr) {
//        case TIME: {
//            [self setTime:[value floatValue]];
//            return YES;
//        }
//        case TEXT: {
//            self.message = value;
//            return YES;
//        }
//        case TEXTCOLOR:{
//            [self setColor:[utility colorWithHexString:value]];
//            return YES;
//        }
//        case BACKGROUND: {
//            [self setBackgroundColor:[utility colorWithHexString:value]];
//            return YES;
//        }
//        case TEXTSIZE:{
//            [self setTextFont:[value floatValue]];
//            return YES;
//        }
//        case TEXTALIGN:{
//            [self setTextAlign:value];
//            return YES;
//        }
//        case FRAME:
//            [self setViewFrame:value];
//            return YES;
//        default:
//            break;
//    }
//    return NO;
//    
//}
//- (id)onGetAttribute:(NSString *)attr{
//    NSInteger integer= [[self.propertyManager.properties objectForKey:[attr lowercaseString]] integerValue];
//    switch (integer) {
//        case TEXT: {
//            return self.message;
//        }
//        case TEXTALIGN: {
//            return self.textAlign;
//        }
//        case TEXTSIZE: {
//            return [NSNumber numberWithFloat:self.textFont];
//        }
//        case TINTCOLOR: {
//            return self.color;
//        }
//        case TIME: {
//            return [NSNumber numberWithFloat:self.time];
//        }
//            
//        default:
//            break;
//    }
//    return nil;
//}
//
//- (NSArray*)testItems {
//    
//    return @[@"MRToastFrame",@"MRToastText",@"MRToastTime",@"MRToastColor",@"MRToastBackgroundColor",@"MRToastTextFont",@"MRToastTextAlign"];
//}
//
//- (NSArray*)testMethods {
//    return @[@"setAttribute(\"frame\",\"10 10 200 40\"",@"setAttribute(\"text\",\"raosong\"]",@"setAttribute(\"time\",\"1.0s\"]",@"setAttribute(\"color\",\"redColor\"]",@"setAttribute(\"backgroundColor\",\"blueColor\"]",@"setAttribute(\"textFont\",\"20\"]",@"setAttribute(\"textAlign\",\"right\"]"];
//}
//
//+ (NSString *)developer {
//    return @"raosong";
//}
//
//- (void)MRToastFrame{
//    [self setAttribute:@"frame" fromKeyStr:@"10 10 200 40"];
//}
//
//- (void)MRToastText{
//    [self setAttribute:@"text" fromKeyStr:@"raosong"];
//}
//
//- (void)MRToastTime{
//    [self setAttribute:@"time" fromKeyStr:@"1.0"];
//}
//
//- (void)MRToastColor{
//    //淡红色
//    [self setAttribute:@"textcolor" fromKeyStr:@"#EE82EE"];
//}
//
//- (void)MRToastBackgroundColor{
//    //淡蓝色
//    [self setAttribute:@"background" fromKeyStr:@"#00FFFF"];
//}
//
//- (void)MRToastTextFont{
//    [self setAttribute:@"textsize" fromKeyStr:@"22"];
//}
//
//- (void)MRToastTextAlign{
//    [self setAttribute:@"textalign" fromKeyStr:@"1"];
//}
@end
