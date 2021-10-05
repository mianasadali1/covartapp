//
//  CLRotateTool.m
//
//  Created by sho yakushiji on 2013/11/08.
//  Copyright (c) 2013年 CALACULU. All rights reserved.
//

#import "CLRotateTool.h"
#import "UIImage+Utility.h"
#import "UIView+Frame.h"
#import "ToolBarItem.h"
#import "RotateViewController.h"
#import "UIRotateImageView.h"

static NSString* const kCLRotateToolRotateIconName              =   @"rotateIconAssetsName";
static NSString* const kCLRotateToolFlipHorizontalIconName      =   @"flipHorizontalIconAssetsName";
static NSString* const kCLRotateToolFlipVerticalIconName        =   @"flipVerticalIconAssetsName";
static NSString* const kCLRotateToolFineRotationEnabled         =   @"fineRotationEnabled";
static NSString* const kCLRotateToolCropRotate                  =   @"cropRotateEnabled";


@interface CLRotatePanel : UIView
@property(nonatomic, strong) UIColor *bgColor;
@property(nonatomic, strong) UIColor *gridColor;
@property(nonatomic, assign) CGRect gridRect;

- (id)initWithSuperview:(UIView*)superview frame:(CGRect)frame;

@end


@implementation CLRotateTool
{
    UISlider *_rotateSlider;
    UIScrollView *_menuScroll;
    CGRect _initialRect;
    
    BOOL _executed;

    BOOL _fineRotationEnabled;

    CGFloat _rotationArg;
    CGFloat _orientation;
    NSInteger _flipState1;
    NSInteger _flipState2;
    UIImage *_origionalImage;
    
    UIView *containerView;
}

+ (NSString*)defaultTitle
{
    return [CLImageEditorTheme localizedString:@"CLRotateTool_DefaultTitle" withDefault:@"Rotate"];
}

#pragma mark- optional info

+ (NSDictionary*)optionalInfo
{
    return @{
             kCLRotateToolRotateIconName : @"",
             kCLRotateToolFlipHorizontalIconName : @"",
             kCLRotateToolFlipVerticalIconName : @"",
             kCLRotateToolFineRotationEnabled : @NO,
             kCLRotateToolCropRotate : @NO
             };
}

#pragma mark-

- (void)setup
{
    [self.editor fixZoomScaleWithAnimated:YES];
    _initialRect                    =   self.editor.imageView.frame;
    _origionalImage                 =   self.editor.imageView.image;
    
    _menuScroll                     =   [[UIScrollView alloc] initWithFrame:self.editor.menuScrollView.frame];
    _menuScroll.backgroundColor     =   self.editor.menuScrollView.backgroundColor;
    _menuScroll.showsHorizontalScrollIndicator  =   NO;
    [self.editor.view addSubview:_menuScroll];
    [self setMenu];
    
    _menuScroll.transform           =   CGAffineTransformMakeTranslation(0, self.editor.view.height-_menuScroll.top);
    self.editor.imageView.hidden    =   YES;

    [UIView animateWithDuration:kCLImageToolAnimationDuration
                     animations:^{
                         _menuScroll.transform = CGAffineTransformIdentity;
                     }
                     completion:^(BOOL finished) {
                     }];
    
    containerView           =   [[UIView alloc]initWithFrame:CGRectMake(self.editor.imageView.frame.origin.x, 100, self.editor.imageView.frame.size.width, self.editor.imageView.frame.size.height)];
    containerView.clipsToBounds = YES;
    containerView.center    =   self.editor.view.center;
    
    self.imgvPhoto          =   [[UIRotateImageView alloc]initWithFrame:CGRectMake(self.editor.imageView.frame.origin.x, self.editor.imageView.frame.origin.y, self.editor.imageView.frame.size.width, self.editor.imageView.frame.size.height)];
    self.imgvPhoto.image    =   self.editor.imageView.image;
    [containerView addSubview:self.imgvPhoto];
    
    self.viewLayer   =   [[UIView alloc]initWithFrame:CGRectMake(self.editor.imageView.frame.origin.x, self.editor.imageView.frame.origin.y, self.editor.imageView.frame.size.width, self.editor.imageView.frame.size.height)];
    [containerView addSubview:self.viewLayer];
    
    self.viewLayer.layer.borderColor = [UIColor whiteColor].CGColor;
    self.viewLayer.layer.borderWidth = 1.0;
    
    [self.editor.view addSubview:containerView];
    
    self.view1  =   [[UIView alloc]initWithFrame:CGRectZero];
    self.view2  =   [[UIView alloc]initWithFrame:CGRectZero];
    self.view1.backgroundColor  =   [UIColor colorWithWhite:0 alpha:0.8];
    self.view2.backgroundColor  =   [UIColor colorWithWhite:0 alpha:0.8];

    [self adjustPossition];
    
    float sliderMaxima              =   _fineRotationEnabled ? 0.5 : 1;
    _rotateSlider                   =   [self sliderWithValue:0 minimumValue:-sliderMaxima maximumValue:sliderMaxima];
    _rotateSlider.superview.center  =   CGPointMake(self.editor.view.width/2, self.editor.menuScrollView.top-30);

}

- (void)adjustPossition
{
    CGAffineTransform saveState = self.imgvPhoto.transform;
    
    self.imgvPhoto.transform = CGAffineTransformIdentity;
    
    [self.imgvPhoto setFrameToFitImage];
    
    self.viewLayer.frame = self.imgvPhoto.frame;
    
    [self setBlankSpaceView];
    
    self.imgvPhoto.transform = saveState;
}

- (void)setBlankSpaceView
{
    if(self.imgvPhoto.imageHeight <= self.imgvPhoto.imageWidth)
    {
        self.view1.frame = CGRectMake(0, 0, CGRectGetWidth(self.editor.view.frame), CGRectGetMinY(self.imgvPhoto.frame));
        self.view2.frame = CGRectMake(0, CGRectGetMaxY(self.imgvPhoto.frame), CGRectGetWidth(self.editor.view.frame), CGRectGetMinY(self.imgvPhoto.frame));
    }
    else
    {
        self.view1.frame = CGRectMake(0, 0, CGRectGetMinX(self.imgvPhoto.frame), CGRectGetHeight(self.imgvPhoto.frame));
        self.view2.frame = CGRectMake(CGRectGetMaxX(self.imgvPhoto.frame), 0, CGRectGetMinX(self.imgvPhoto.frame), CGRectGetHeight(self.imgvPhoto.frame));
    }
    [containerView addSubview:self.view1];
    [containerView addSubview:self.view2];
}

- (void)cleanup
{
    [_rotateSlider.superview removeFromSuperview];
    [containerView removeFromSuperview];
    
    [self.editor resetZoomScaleWithAnimated:NO];
    
    [_menuScroll removeFromSuperview];
    self.editor.imageView.hidden = NO;

    [UIView animateWithDuration:kCLImageToolAnimationDuration
                     animations:^{
                         _menuScroll.transform = CGAffineTransformMakeTranslation(0, self.editor.view.height-_menuScroll.top);
                     }
                     completion:^(BOOL finished) {
                         [_menuScroll removeFromSuperview];
                     }];
}

- (void)executeWithCompletionBlock:(void(^)(UIImage *image, NSError *error, NSDictionary *userInfo))completionBlock
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIActivityIndicatorView *indicator = [CLImageEditorTheme indicatorView];
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //UIImage *image = [self buildImage];
        UIImage *image  =   [self.imgvPhoto finalImage];
        image           =   [UIImage drawImage:image inRect:CGRectMake(0, 0, image.size.width, image.size.height)];

        dispatch_async(dispatch_get_main_queue(), ^{
            _executed = YES;
            completionBlock(image, nil, nil);
        });
    });
}

#pragma mark-

- (void)setMenu
{
    CGFloat W = 70;
    CGFloat H = _menuScroll.height;
    CGFloat x = (self.editor.view.frame.size.width - (W*5))/2;;

    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        W   =   100;
    }
    
    NSArray *_menu = @[
                       @{@"title":@"Left", @"icon":[UIImage imageNamed:@"r-left"]},
                       @{@"title":@"Right", @"icon":[UIImage imageNamed:@"r-right"]},
                       @{@"title":@"Vertical", @"icon":[UIImage imageNamed:@"r-verticale"]},
                       @{@"title":@"Horizontal", @"icon":[UIImage imageNamed:@"r-horizontal"]},
                       @{@"title":@"Reset", @"icon":[UIImage imageNamed:@"reset"]},
                       ];
    
    NSInteger tag = 0;
    for(NSDictionary *obj in _menu){
        ToolBarItem *view = [CLImageEditorTheme menuItemWithFrame:CGRectMake(x, 0, W, H) target:self action:@selector(tappedMenu:) toolInfo:nil isIcon:true];
        view.tag = tag++;
        view.iconView.image     = obj[@"icon"];
        view.titleLabel.text    = obj[@"title"];
        
        [_menuScroll addSubview:view];
        x += W;
    }
    
    _menuScroll.contentSize = CGSizeMake(x, 0);

//    if (_menuScroll.contentSize.width < self.editor.menuScrollView.frame.size.width){
//        _menuScroll.frame   =   CGRectMake(_menuScroll.frame.origin.x, _menuScroll.frame.origin.y, _menuScroll.contentSize.width, _menuScroll.frame.size.height);
//        _menuScroll.center  =   self.editor.menuScrollView.center;
//    }
}

- (void)tappedMenu:(UITapGestureRecognizer*)sender
{
    sender.view.alpha = 0.2;
    [UIView animateWithDuration:kCLImageToolAnimationDuration
                     animations:^{
                         sender.view.alpha = 1;
                     }
     ];
    
    switch (sender.view.tag) {
        case 0:
            [self.imgvPhoto rotateAtPosition:kRotateLeft];
            [self adjustPossition];

            break;
        case 1:
            [self.imgvPhoto rotateAtPosition:kRotateRight];
            [self adjustPossition];

            break;
        case 2:
            [self.imgvPhoto flipVertically];
            [self adjustPossition];

            break;
        case 3:
            [self.imgvPhoto flipHorizontally];
            [self adjustPossition];

            break;
        case 4:
            [self resetPhoto];
            [self adjustPossition];

            break;
        default:
            break;
    }
    
    [UIView animateWithDuration:kCLImageToolAnimationDuration
                     animations:^{

                     }
                     completion:^(BOOL finished) {
                     }
     ];
}

- (UISlider*)sliderWithValue:(CGFloat)value minimumValue:(CGFloat)min maximumValue:(CGFloat)max
{
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(10, 0, self.editor.view.frame.size.width - 20, 30)];
    [slider setThumbImage:[UIImage imageNamed:@"slider"] forState:UIControlStateNormal];
    
    [slider setMinimumTrackTintColor:[UIColor whiteColor]];
    [slider setMaximumTrackTintColor:[UIColor whiteColor]];
    UIView *container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.editor.view.frame.size.width, slider.height)];
    container.backgroundColor = [UIColor clearColor];
    container.layer.cornerRadius = slider.height/2;
    
    slider.continuous   =   YES;
    [slider addTarget:self action:@selector(sliderDidChange:) forControlEvents:UIControlEventValueChanged];

    slider.maximumValue =   45;
    slider.minimumValue =   -45;
    slider.value = value;
    
    [container addSubview:slider];
    [self.editor.view addSubview:container];
    
    return slider;
}

-(void)resetPhoto{
    self.imgvPhoto.image    = _origionalImage;
}

- (void)sliderDidChange:(UISlider*)slider
{
    [self.imgvPhoto rotateWithAngle:slider.value];
}


@end

