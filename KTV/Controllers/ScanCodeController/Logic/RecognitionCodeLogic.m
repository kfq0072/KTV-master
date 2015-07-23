//
//  QRReaderWithSystemLogic.m
//  QRReader
//
//  Created by hexiang on 15/1/28.
//  Copyright (c) 2015年 hexiang. All rights reserved.
//

#import "RecognitionCodeLogic.h"

#import <AVFoundation/AVFoundation.h>

@interface RecognitionCodeLogic()<AVCaptureMetadataOutputObjectsDelegate>
{

}

@property (nonatomic, retain) AVCaptureDevice *device;
@property (nonatomic, retain) AVCaptureDeviceInput *input;
@property (nonatomic, retain) AVCaptureMetadataOutput *output;
@property (nonatomic, retain) AVCaptureSession *session;
@property (nonatomic, retain) AVCaptureVideoPreviewLayer *preview;

@end

@implementation RecognitionCodeLogic

- (instancetype)init{
    if ( self = [super init] ) {
    }
    return self;
}

+ (BOOL)isCameraAvailable
{
    NSArray *videoDevices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if ([videoDevices count] == 0) {
        NSLog(@"ERROR : 没有设备");
        return FALSE;
    }else if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        NSLog(@"ERROR : 没有访问相机权限");
        return FALSE;
    }
    return TRUE;
}

- (void)setupCamera
{
    // Device
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Input
    _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    
    // Output
    _output = [[AVCaptureMetadataOutput alloc]init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    // Session
    _session = [[AVCaptureSession alloc]init];
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    if ([_session canAddInput:self.input])
    {
        [_session addInput:self.input];
    }
    
    if ([_session canAddOutput:self.output])
    {
        [_session addOutput:self.output];
    }
    
    // 条码类型 AVMetadataObjectTypeQRCode (设置前必须addOutput设备，否则此处会崩溃)
    _output.metadataObjectTypes = @[AVMetadataObjectTypeCode128Code,AVMetadataObjectTypeUPCECode,AVMetadataObjectTypeCode39Code,AVMetadataObjectTypeCode39Mod43Code,AVMetadataObjectTypeEAN13Code,AVMetadataObjectTypeEAN8Code,AVMetadataObjectTypeCode93Code,AVMetadataObjectTypePDF417Code,AVMetadataObjectTypeQRCode,AVMetadataObjectTypeAztecCode,AVMetadataObjectTypeInterleaved2of5Code,AVMetadataObjectTypeITF14Code,AVMetadataObjectTypeDataMatrixCode];
    
    // Preview
//    _preview =[AVCaptureVideoPreviewLayer layerWithSession:self.session];
//    _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
//    _preview.frame =CGRectMake(20,110,280,280);
//    
//    AVCaptureConnection *con = self.preview.connection;
//    con.videoOrientation = AVCaptureVideoOrientationLandscapeLeft;
    
    //[self.view.layer insertSublayer:self.preview atIndex:0];
    
    // Start
    //[_session startRunning];
}

#pragma mark - Interface Methods

- (BOOL)startRunningRecognition{
    if( [RecognitionCodeLogic isCameraAvailable] ){
        [self setupCamera];
        [_session startRunning];
        return TRUE;
    }else{
        return FALSE;
    }
}

- (void)stopRunningRccogition{
    [_session stopRunning];
}

- (void)embedPreviewInView: (UIView *)aView {
    if (!self.session)
        return;
    //设置取景
    self.preview = [AVCaptureVideoPreviewLayer layerWithSession: self.session];
    self.preview.frame = aView.bounds;
    self.preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [aView.layer insertSublayer:self.preview atIndex:0];
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    
    NSString *stringValue;
    
    if ([metadataObjects count] >0)
    {
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        if (nil == metadataObject.stringValue ) {
            NSLog(@"ERROR");
        }
        stringValue = metadataObject.stringValue;
    }
    
    [_session stopRunning];
    
    if ([stringValue canBeConvertedToEncoding:NSUTF8StringEncoding]) {
        stringValue = [stringValue stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    if ( nil != _delegate && [_delegate respondsToSelector:@selector(didFinishRecognitionWithString:)]) {
        [_delegate didFinishRecognitionWithString:stringValue];
    }

}
/*
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    CGRect highlightViewRect = CGRectZero;
    AVMetadataMachineReadableCodeObject *barCodeObject;
    NSString *detectionString = nil;
    NSArray *barCodeTypes = @[AVMetadataObjectTypeUPCECode, AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeCode39Mod43Code,
                              AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode93Code, AVMetadataObjectTypeCode128Code,
                              AVMetadataObjectTypePDF417Code, AVMetadataObjectTypeQRCode, AVMetadataObjectTypeAztecCode];
    
    for (AVMetadataObject *metadata in metadataObjects) {
        for (NSString *type in barCodeTypes) {
            if ([metadata.type isEqualToString:type])
            {
                barCodeObject = (AVMetadataMachineReadableCodeObject *)[self.preview transformedMetadataObjectForMetadataObject:(AVMetadataMachineReadableCodeObject *)metadata];
                highlightViewRect = barCodeObject.bounds;
                detectionString = [(AVMetadataMachineReadableCodeObject *)metadata stringValue];
                break;
            }
        }
        
        if (detectionString != nil)
        {
            if ( nil != _delegate && [_delegate respondsToSelector:@selector(didFinishRecognitionWithString:)]) {
                [_delegate didFinishRecognitionWithString:detectionString];
            }
            break;
        }
    }

}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    for(AVMetadataObject *current in metadataObjects) {
        if([current isKindOfClass:[AVMetadataMachineReadableCodeObject class]]) {
            NSString *scannedValue = [((AVMetadataMachineReadableCodeObject *) current) stringValue];
            if (scannedValue != nil)
            {
                if ( nil != _delegate && [_delegate respondsToSelector:@selector(didFinishRecognitionWithString:)]) {
                    [_delegate didFinishRecognitionWithString:scannedValue];
                }
                break;
            }
        }
    }
}
*/

#pragma mark - Helper Methods

/**
 *  @brief  设置闪光灯开启
 *
 *  @param aStatus yes - On
 */
- (void)setTorch:(BOOL)aStatus
{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    [device lockForConfiguration:nil];
    if ( [device hasTorch] ) {
        if ( aStatus ) {
            [device setTorchMode:AVCaptureTorchModeOn];
        } else {
            [device setTorchMode:AVCaptureTorchModeOff];
        }
    }
    [device unlockForConfiguration];
}


- (void)focus:(CGPoint)aPoint
{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if([device isFocusPointOfInterestSupported] &&
       [device isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        double screenWidth = screenRect.size.width;
        double screenHeight = screenRect.size.height;
        double focus_x = aPoint.x/screenWidth;
        double focus_y = aPoint.y/screenHeight;
        if([device lockForConfiguration:nil]) {
            /*
            if([self.delegate respondsToSelector:@selector(scanViewController:didTapToFocusOnPoint:)]) {
                [self.delegate scanViewController:self didTapToFocusOnPoint:aPoint];
            }
             */
            [device setFocusPointOfInterest:CGPointMake(focus_x,focus_y)];
            [device setFocusMode:AVCaptureFocusModeAutoFocus];
            if ([device isExposureModeSupported:AVCaptureExposureModeAutoExpose]){
                [device setExposureMode:AVCaptureExposureModeAutoExpose];
            }
            [device unlockForConfiguration];
        }
    }
}


@end
