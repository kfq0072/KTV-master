// UIImage+Resize.h
// Created by Trevor Harmon on 8/5/09.
// Free for personal or commercial use, with or without modification.
// No warranty is expressed or implied.

// Extends the UIImage class to support resizing/cropping
#import <UIKit/UIKit.h>

@interface UIImage (Resize)
- (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize;
+ (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize;
- (UIImage*)captureView:(UIView *)theView;
@end
