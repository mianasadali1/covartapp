//
//  VintageTool.m
//  BasicFilters
//
//  Created by Kanwarpal Singh on 19/08/17.
//  Copyright © 2017 Kanwarpal Singh. All rights reserved.
//

#import "VignetteTool.h"
#import "UIView+Frame.h"
#import "UIImage+Utility.h"

@implementation VignetteTool
{
    UIView  *_containerView;
    UISlider  *_slider;
    UIImage *_originalImage;
    UIImage *_thumbnailImage;

}

- (void)setup
{
    _originalImage  =   self.editor.imageView.image;
    _thumbnailImage = [_originalImage resize:self.editor.imageView.frame.size];

    [self initMenuScrollView];
    [self initSliderView];
    self.editor.imageView.userInteractionEnabled = YES;
    self.editor.scrollView.panGestureRecognizer.minimumNumberOfTouches = 2;
    self.editor.scrollView.panGestureRecognizer.delaysTouchesBegan = NO;
    self.editor.scrollView.pinchGestureRecognizer.delaysTouchesBegan = NO;
    
    [UIView animateWithDuration:kCLImageToolAnimationDuration
                     animations:^{
                         self.menuScrollView .transform = CGAffineTransformIdentity;
                     }
                     completion:^(BOOL finished) {
                     }];
}

- (void)initMenuScrollView
{
    if(self.menuScrollView==nil){
        UIScrollView *menuScroll    =   [[UIScrollView alloc] initWithFrame:self.editor.menuScrollView.frame];
        menuScroll.autoresizingMask =   UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        menuScroll.showsHorizontalScrollIndicator   =   NO;
        menuScroll.showsVerticalScrollIndicator     =   NO;
        
        [self.editor.view addSubview:menuScroll];
        self.menuScrollView             =   menuScroll;
    }
    self.menuScrollView.backgroundColor =   self.editor.barColor;
    self.menuScrollView.transform       =   CGAffineTransformMakeTranslation(0, self.editor.view.height - self.menuScrollView.top);
    
    [UIView animateWithDuration:kCLImageToolAnimationDuration
                     animations:^{
                         self.menuScrollView.transform  =   CGAffineTransformIdentity;
                     }];
}

-(void)initSliderView{
    self.menuScrollView.contentOffset   =   CGPointZero;
    self.menuScrollView.scrollEnabled   =   false;
    
    _containerView                      =   [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.menuScrollView.frame.size.width , self.menuScrollView.frame.size.height)];
    _containerView.backgroundColor      =   self.editor.barColor;
    [self.menuScrollView addSubview:_containerView];
    
    _slider = [[UISlider alloc] initWithFrame:CGRectMake(10, (self.menuScrollView.frame.size.height - 40)/2, self.menuScrollView.frame.size.width - 20, 40)];
    [_slider setThumbImage:[UIImage imageNamed:@"slider"] forState:UIControlStateNormal];
    
    [_slider setMinimumTrackTintColor:[UIColor whiteColor]];
    [_slider setMaximumTrackTintColor:[UIColor whiteColor]];
    _slider.continuous                  =   NO;
    [_slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    _slider.maximumValue                =   10;
    _slider.minimumValue                =   -10;
    _slider.value                       =   0;
    
    [_containerView addSubview:_slider];
    
    [self.menuScrollView addSubview:_containerView];
}

-(void)sliderValueChanged:(UISlider *)slider{
   
    static BOOL inProgress = NO;
    
    if(inProgress){ return; }
    inProgress = YES;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *image = [self applyFilterOnImage:_thumbnailImage withValue:slider.value];
        image   =   [UIImage drawImage:image inRect:CGRectMake(0, 0, image.size.width, image.size.height)];

        [self.editor.imageView performSelectorOnMainThread:@selector(setImage:) withObject:image waitUntilDone:NO];
        inProgress = NO;
    });
}

-(UIImage *)applyFilterOnImage:(UIImage *)origionalImage withValue:(double)value {
    sliderValue         =   value;
    CIImage *ciImage    =   [[CIImage alloc] initWithImage:origionalImage];
    
    CIFilter * filter = [CIFilter filterWithName:@"CIVignette" keysAndValues:kCIInputImageKey, ciImage, nil];
    
    [filter setDefaults];
    
    [filter setValue:@(2)       forKey:@"inputRadius"];
    [filter setValue:@(value)   forKey:@"inputIntensity"];

    CIContext *context = [CIContext contextWithOptions:@{kCIContextUseSoftwareRenderer : @(NO)}];
    CIImage *outputImage = [filter outputImage];
    CGImageRef cgImage = [context createCGImage:outputImage fromRect:[outputImage extent]];
    
    UIImage *result = [UIImage imageWithCGImage:cgImage];
    
    CGImageRelease(cgImage);
    
    return result;
}

- (void)cleanup
{
    [_containerView removeFromSuperview];
    
    self.editor.imageView.userInteractionEnabled = NO;
    self.editor.scrollView.panGestureRecognizer.minimumNumberOfTouches = 1;
    
    [UIView animateWithDuration:kCLImageToolAnimationDuration
                     animations:^{
                         self.menuScrollView.transform = CGAffineTransformMakeTranslation(0, self.editor.view.height-self.menuScrollView.top);
                     }
                     completion:^(BOOL finished) {
                         [self.menuScrollView removeFromSuperview];
                     }];
}

- (void)executeWithCompletionBlock:(void (^)(UIImage *, NSError *, NSDictionary *))completionBlock
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        UIImage *image = [self applyFilterOnImage:_originalImage withValue:sliderValue];
        image   =   [UIImage drawImage:image inRect:CGRectMake(0, 0, image.size.width, image.size.height)];

        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock(image, nil, nil);
        });
    });
}

@end
