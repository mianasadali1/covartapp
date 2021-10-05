//
//  RedEyeCorrectionTool.m
//  BasicFilters
//
//  Created by Kanwarpal Singh on 29/08/17.
//  Copyright © 2017 Kanwarpal Singh. All rights reserved.
//

#import "RedEyeCorrectionTool.h"

@implementation RedEyeCorrectionTool

- (void)setup
{
    _originalImage  =   self.editor.imageView.image;
}

- (void)cleanup
{
    self.editor.imageView.userInteractionEnabled = NO;
    self.editor.scrollView.panGestureRecognizer.minimumNumberOfTouches = 1;
    
    [UIView animateWithDuration:kCLImageToolAnimationDuration
                     animations:^{
                     }
                     completion:^(BOOL finished) {
                     }];
}

- (void)executeWithCompletionBlock:(void (^)(UIImage *, NSError *, NSDictionary *))completionBlock
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *image = [self redEyeCorrection];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock(image, nil, nil);
        });
    });
}

-(UIImage*)redEyeCorrection
{
    /// No Core Image, return original image
    if (![CIImage class])
        return _originalImage;
    
    CIImage* ciImage = [[CIImage alloc] initWithCGImage:_originalImage.CGImage];
    
    NSArray* adjustments = [ciImage autoAdjustmentFiltersWithOptions:
                            [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:kCIImageAutoAdjustRedEye]];
    
    for (CIFilter* filter in adjustments)
    {
        [filter setValue:ciImage forKey:kCIInputImageKey];
        ciImage = filter.outputImage;
    }
    
    CIContext* ctx = [CIContext contextWithOptions:nil];
    CGImageRef cgImage = [ctx createCGImage:ciImage fromRect:[ciImage extent]];
    UIImage* final = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    return final;
}

@end
