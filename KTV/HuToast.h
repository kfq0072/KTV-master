
//
#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, KMessageStyle) {
    KMessageStyleDefault,
    KMessageStyleError,
    KMessageSuccess,
    KMessageStyleInfo,
    KMessageWarning
};
@interface HuToast :UIView
@property (nonatomic, readonly) UILabel *label;
- (void)setToastWithMessage:(NSString *)message WithTimeDismiss:(NSString *)time messageType:(KMessageStyle)style;
- (void)dissmiss;
//-(void)show;
@end
