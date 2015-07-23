//
//  QRReaderWithSystemLogic.h
//  QRReader
//
//  Created by hexiang on 15/1/28.
//  Copyright (c) 2015年 hexiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@protocol RecognitionCodeLogicDelegate <NSObject>


- (void)didFinishRecognitionWithString:(NSString *)string;

@end

@interface RecognitionCodeLogic : NSObject

+ (BOOL)isCameraAvailable;

- (BOOL)startRunningRecognition;

- (void)stopRunningRccogition;

/**
 *  @brief  嵌入实时预览界面到指定的view
 *
 *  @param aView 被嵌入的view
 */
- (void)embedPreviewInView: (UIView *)aView;

@property (nonatomic, assign)id <RecognitionCodeLogicDelegate> delegate;

@end
