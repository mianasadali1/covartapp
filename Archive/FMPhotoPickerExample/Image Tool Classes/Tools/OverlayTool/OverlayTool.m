//
//  CLBlurTool.m
//
//  Created by sho yakushiji on 2013/10/19.
//  Copyright (c) 2013年 CALACULU. All rights reserved.
//

#import "OverlayTool.h"
#import "SelectorsList.h"
#import "UIImage+Utility.h"
#import "UIView+Frame.h"
#import "UIView+Toast.h"

static NSString* const kCLBlurToolNormalIconName = @"nonrmalIconAssetsName";
static NSString* const kCLBlurToolCircleIconName = @"circleIconAssetsName";
static NSString* const kCLBlurToolBandIconName = @"bandIconAssetsName";

typedef NS_ENUM(NSUInteger, CLBlurType)
{
    kCLBlurTypeNormal = 0,
    kCLBlurTypeCircle,
    kCLBlurTypeBand,
};


@interface CLBlurCircleOverlay : UIView
@property (nonatomic, strong) UIColor *color;
@end

@interface CLBlurBandOverlay : UIView
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, assign) CGFloat rotation;
@property (nonatomic, assign) CGFloat scale;
@property (nonatomic, assign) CGFloat offset;
@end



@interface OverlayTool()
<UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIView *selectedMenu;
@end

@implementation OverlayTool
{
    UIImage *_originalImage;
    UIImage *_thumbnailImage;
    UIImage *_patternImage;
    UIImage *_patternThumbnailImage;
    UIImage *_lastPatternImage;
    UISlider *_alphaSlider;
    UIScrollView *_menuScroll;
    
    UIView *_handlerView;
    
    CLBlurCircleOverlay *_circleView;
    CLBlurBandOverlay *_bandView;
    CGRect _bandImageRect;
    
    CLBlurType _blurType;
}

#pragma mark-

+ (NSString*)defaultTitle
{
    return [CLImageEditorTheme localizedString:@"CLBlurEffect_DefaultTitle" withDefault:@"Blur & Focus"];
}

#pragma mark- optional info

+ (NSDictionary*)optionalInfo
{
    return @{
             kCLBlurToolNormalIconName : @"",
             kCLBlurToolCircleIconName : @"",
             kCLBlurToolBandIconName : @""
             };
}

#pragma mark-

-(UIBarButtonItem *)buttonWithImageName:(NSString *)imageName selector:(SEL)selector{
    UIImage *image = [UIImage imageNamed:imageName];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake( 0, 0, 30, 30 );
    //btn.tintColor   =   [UIColor whiteColor]
    [btn setImage:image forState:UIControlStateNormal];
    btn.clipsToBounds   = true;
    [btn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barBtn = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    return barBtn;
}
- (void)setup
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        _overlayColorsImgs      =   [NSMutableArray new];
        
        for(int i = 1 ; i <= 10 ; i++){
            UIImage *img    =  [UIImage imageNamed:[NSString stringWithFormat:@"OverlayImage%d",i]];
            [_overlayColorsImgs addObject:img];
        }
//        for(int i = 56 ; i < 165 ; i++){
//            UIImage *img    =  [UIImage imageNamed:[NSString stringWithFormat:@"overlayIcon%d",i]];
//            [_overlayColorsImgs addObject:img];
//        }
        
    });
    
    overlayPattern  =   1;
    patternAlpha    =   0.5;
    _blurType       =   kCLBlurTypeNormal;
    _originalImage  =   self.editor.imageView.image;
    _thumbnailImage =   [_originalImage resize:CGSizeMake(_originalImage.size.width/2, _originalImage.size.height/2)];
    
    [self.editor fixZoomScaleWithAnimated:YES];
    
    _handlerView    =  [[UIView alloc] initWithFrame:self.editor.imageView.frame];
    [self.editor.imageView.superview addSubview:_handlerView];
    [self setHandlerView];
    
    _menuScroll     =   [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.editor.menuScrollView.frame.origin.y - 40, self.editor.menuScrollView.frame.size.width, self.editor.menuScrollView.frame.size.height + 40)];

    _menuScroll.backgroundColor = self.editor.menuScrollView.backgroundColor;
    _menuScroll.showsHorizontalScrollIndicator = NO;
    [self.editor.view addSubview:_menuScroll];
    [self setMainMenu];
    [self initAlphaSliderView];

    _menuScroll.transform = CGAffineTransformMakeTranslation(0, self.editor.view.height-_menuScroll.top);
    [UIView animateWithDuration:kCLImageToolAnimationDuration
                     animations:^{
                         _menuScroll.transform = CGAffineTransformIdentity;
                     }];
    _patternImage          =   [self generateNoShapeImage];
    _patternThumbnailImage =   [_patternImage resize:_thumbnailImage.size];

    [self setDefaultParams];
    [self buildThumbnailImage];
    [self resizeSticker:1];
    
//    BOOL isInstructionsShown    =   [[NSUserDefaults standardUserDefaults] boolForKey:@"isOverlayInstructionsShown1"];
    
//    if(!isInstructionsShown){
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
//            [self.editor.view makeToast:@"Tap on photo to change filter, swipe outside image to change color, drag overlay to change its position, pinch to change overlay size"
//                               duration:4.0
//                               position:CSToastPositionBottom];
//            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isOverlayInstructionsShown1"];
//            [[NSUserDefaults standardUserDefaults] synchronize];
//        });
//    }
    
    UISwipeGestureRecognizer *swipeLeftRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(changeColorOfImage)];
    [swipeLeftRight setDirection:(UISwipeGestureRecognizerDirectionRight | UISwipeGestureRecognizerDirectionLeft )];
    self.editor.view.userInteractionEnabled    = true;
    [self.editor.view addGestureRecognizer:swipeLeftRight];
}

- (void)cleanup
{
    [self.editor resetZoomScaleWithAnimated:YES];
    [_handlerView removeFromSuperview];
    
    [UIView animateWithDuration:kCLImageToolAnimationDuration
                     animations:^{
                         _menuScroll.transform = CGAffineTransformMakeTranslation(0, self.editor.view.height-_menuScroll.top);
                     }
                     completion:^(BOOL finished) {
        [self.editor.navigationBar popNavigationItemAnimated:YES];
        [self swapMenuToShowSlider:false];

//                         [_menuScroll removeFromSuperview];
//                [_subMenuScroll removeFromSuperview];
                     }];
}

- (void)executeWithCompletionBlock:(void(^)(UIImage *image, NSError *error, NSDictionary *userInfo))completionBlock
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [_containerView removeFromSuperview];

        UIActivityIndicatorView *indicator = [CLImageEditorTheme indicatorView];
        indicator.center = CGPointMake(_handlerView.width/2, _handlerView.height/2);
        [_handlerView addSubview:indicator];
        [indicator startAnimating];
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *image = [self buildResultImage:_originalImage withBlurImage:_patternImage];
       // image   =   [UIImage drawImage:image inRect:CGRectMake(0, 0, image.size.width, image.size.height)];

        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock(image, nil, nil);
        });
    });
}

#pragma mark- 
- (void)initSubMenuScrollView
{
    [_containerView removeFromSuperview];
    _containerView                      =   [[UIView alloc]initWithFrame:CGRectMake(0, self.editor.menuScrollView.top, self.editor.menuScrollView.frame.size.width, self.editor.menuScrollView.frame.size.height)];
    _containerView.backgroundColor      =   self.editor.barColor;

    [self.editor.view addSubview:_containerView];
    
    if(_subMenuScroll==nil){
        UIScrollView *menuScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.editor.view.width, kMenuBarHeight)];
        //menuScroll.top = self.editor.view.height - menuScroll.height;
        menuScroll.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        menuScroll.showsHorizontalScrollIndicator   =   NO;
        menuScroll.showsVerticalScrollIndicator     =   NO;
        
        [_containerView addSubview:menuScroll];
        _subMenuScroll = menuScroll;
    }
    _subMenuScroll.backgroundColor = self.editor.barColor;
}

-(void)initAlphaSliderView{
    _alphaSlider = [[UISlider alloc] initWithFrame:CGRectMake(10, 0, self.editor.menuScrollView.frame.size.width - 20, 40)];

    [_alphaSlider setThumbImage:[UIImage imageNamed:@"slider"] forState:UIControlStateNormal];

    [_alphaSlider setMinimumTrackTintColor:[UIColor whiteColor]];
    [_alphaSlider setMaximumTrackTintColor:[UIColor whiteColor]];

    _alphaSlider.continuous          =   NO;
    [_alphaSlider addTarget:self action:@selector(alphaSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    _alphaSlider.maximumValue        =   1;
    _alphaSlider.minimumValue        =   0.1;
    _alphaSlider.value               =   patternAlpha;
    
    [_menuScroll addSubview:_alphaSlider];
    
//    UINavigationItem *item  = [[UINavigationItem alloc] initWithTitle:@"Alpha"];
//
//    item.leftBarButtonItem  =  [self buttonWithImageName:[CLImageEditorTheme localizedString:@"CLImageEditor_BackBtnTitle" withDefault:@"Back"] selector:@selector(crossButtonTapped)];
//
//    [self.editor.navigationBar pushNavigationItem:item animated:true];
}

- (void)alphaSliderValueChanged:(UISlider*)slider{
    patternAlpha    =   slider.value;

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self buildThumbnailImage];
    });
}

- (void)setOverlayMenu
{
    UINavigationItem *item      =   [[UINavigationItem alloc] initWithTitle:@"Pattern"];
    
    item.leftBarButtonItem      =   [self buttonWithImageName:[CLImageEditorTheme localizedString:@"CLImageEditor_BackBtnTitle" withDefault:@"Back"] selector:@selector(crossButtonTapped)];
    
    [self.editor.navigationBar pushNavigationItem:item animated:true];
    
    CGFloat W = 70;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        W   =   100;
    }
    CGFloat H = _subMenuScroll.height;
    CGFloat x = 0;
    
    NSInteger tag = 1;
    
    for(UIImage *patternImg in _overlayColorsImgs){
        ToolBarItem *view       =   [CLImageEditorTheme menuItemWithFrame:CGRectMake(x, 0, W, H) target:self action:@selector(tappedOverlayPatternMenu:) toolInfo:nil isIcon:false];
        view.tag                =   tag;
//        UIImage *blendImage     =   [self blendImage:_thumbnailImage withBlurImage:patternImg];
        
        view.iconView.image     =   patternImg;
        view.titleLabel.text    =   [NSString stringWithFormat:@"P%ld",tag];
        [_subMenuScroll addSubview:view];
        tag = tag + 1;
        x += W;
    }
    _subMenuScroll.contentSize = CGSizeMake(MAX(x, _subMenuScroll.frame.size.width+1), 0);
}

- (void)setMainMenu
{
    CGFloat W = 70;
    CGFloat H = _menuScroll.height;
    CGFloat x = (self.editor.view.frame.size.width - (W*3))/2;

    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        W   =   100;
    }
    
    NSArray *_menu = @[
                       @{@"title":@"Overlay", @"icon":[UIImage imageNamed:@"icOverlay"]},
//                       @{@"title":@"Pattern", @"icon":[UIImage imageNamed:@"pattern"]},
//                       @{@"title":@"Blend", @"icon":[UIImage imageNamed:@"blend"]}
                       ];
    
    NSInteger tag = 0;

    [self initSubMenuScrollView];
    [self setOverlayMenu];

//    for(NSDictionary *obj in _menu){
//        ToolBarItem *view   =   [ToolBarItem menuItemWithFrame:CGRectMake(x, 40, W, H) target:self action:@selector(tappedMainMenu:) toolInfo:nil isIcon:true];
//        view.tag = tag++;
//        view.titleLabel.text    = obj[@"title"];
//        view.iconView.image =   obj[@"icon"];
//
//        if(self.selectedMenu==nil){
//            self.selectedMenu = view;
//        }
//
//        [_menuScroll addSubview:view];
//        x += W;
//    }
    _menuScroll.contentSize = CGSizeMake(x, 0);
}

-(void)tappedOverlayPatternMenu:(UITapGestureRecognizer*)sender{
    UIView *view    =   sender.view;
    overlayPattern  =   view.tag;
    [self buildThumbnailImage];

}

-(void)tappedBlendMenu:(UITapGestureRecognizer*)sender{
    UIView *view    =   sender.view;
    blendMode       =   view.tag;
    [self buildThumbnailImage];
}

- (void)tappedMainMenu:(UITapGestureRecognizer*)sender
{
    UIView *view = sender.view;
    switch (view.tag) {
        case 0:
            [self initSubMenuScrollView];
            [self setOverlayMenu];
            break;
        default:
            break;
    }
    
    [self swapMenuToShowSlider:YES];
}

-(void)changeColorOfImage{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        _patternImage          =   [UIImage changeColorOfImage:_lastPatternImage];
        _patternThumbnailImage =   [_patternImage resize:_thumbnailImage.size];
        [self buildThumbnailImage];
    });
}

-(void)updateImage{
    dispatch_async(dispatch_get_main_queue(), ^{
        [indicator removeFromSuperview];
        indicator = [CLImageEditorTheme indicatorView];
        indicator.center = CGPointMake(_handlerView.width/2, _handlerView.height/2);
        [_handlerView addSubview:indicator];
        [indicator startAnimating];
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if(pattern == 0){
            _patternImage      =   [self generateNoShapeImage];
        }
        else{
            _patternImage      =   [[SelectorsList sharedInstance] getImageByApplyingEffectId:CGSizeMake(_originalImage.size.width, _originalImage.size.height) effectId:pattern];
        }
        
        _patternThumbnailImage      =   [_patternImage resize:_thumbnailImage.size];
        
        _lastPatternImage           =   _patternImage;

        [self buildThumbnailImage];
        
    });
}

- (void)setSelectedMenu:(UIView *)selectedMenu
{
    if(selectedMenu != _selectedMenu){
        _selectedMenu.backgroundColor = [UIColor clearColor];
        _selectedMenu = selectedMenu;
        //_selectedMenu.backgroundColor = [CLImageEditorTheme toolbarSelectedButtonColor];
    }
}

- (void)setHandlerView
{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandlerView:)];
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panHandlerView:)];
    UIPinchGestureRecognizer *pinch    = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchHandlerView:)];
    UIRotationGestureRecognizer *rot   = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotateHandlerView:)];
    
    panGesture.maximumNumberOfTouches = 1;
    
    tapGesture.delegate = self;
    //panGesture.delegate = self;
    pinch.delegate = self;
    rot.delegate = self;
    
    [_handlerView addGestureRecognizer:tapGesture];
    [_handlerView addGestureRecognizer:panGesture];
    [_handlerView addGestureRecognizer:pinch];
    [_handlerView addGestureRecognizer:rot];
}

- (void)setDefaultParams
{
    CGFloat W = 1.5*MIN(_handlerView.width, _handlerView.height);
    
    _circleView = [[CLBlurCircleOverlay alloc] initWithFrame:self.editor.imageView.bounds];
    _circleView.backgroundColor = [UIColor clearColor];
    _circleView.color = [UIColor whiteColor];
    
    CGFloat H = _handlerView.height;
    CGFloat R = sqrt((_handlerView.width*_handlerView.width) + (_handlerView.height*_handlerView.height));
    
    _bandView = [[CLBlurBandOverlay alloc] initWithFrame:CGRectMake(0, 0, R, H)];
    _bandView.center = CGPointMake(_handlerView.width/2, _handlerView.height/2);
    _bandView.backgroundColor = [UIColor clearColor];
    _bandView.color = [UIColor whiteColor];
    
    CGFloat ratio = _originalImage.size.width / self.editor.imageView.width;
    _bandImageRect = _bandView.frame;
    _bandImageRect.size.width  *= ratio;
    _bandImageRect.size.height *= ratio;
    _bandImageRect.origin.x *= ratio;
    _bandImageRect.origin.y *= ratio;
    
}

-(UIImage *)generateNoShapeImage{
    UIGraphicsBeginImageContextWithOptions(_originalImage.size, YES, [[UIScreen mainScreen] scale]);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    NSArray *colorsArr = [RandomObjects getRandomGradientColorArrayFoNoShape];
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef mountainGrad = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colorsArr, NULL);
    CGContextDrawLinearGradient(ctx, mountainGrad, CGPointMake(0,0), CGPointMake(0, _originalImage.size.height), 0);

    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return result;
}

- (void)buildThumbnailImage
{
    static BOOL inProgress = NO;
    
    if(inProgress){ return; }
    
    inProgress = YES;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        UIImage *image  =   [self buildResultImage:_thumbnailImage withBlurImage:_patternThumbnailImage];
        UIImage *image  =   [self buildResultImage:_thumbnailImage withBlurImage:_patternThumbnailImage];

        [self.editor.imageView performSelectorOnMainThread:@selector(setImage:) withObject:image waitUntilDone:NO];
        inProgress = NO;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [indicator stopAnimating];
            [indicator removeFromSuperview];
        });
    });
}

- (UIImage*)buildResultImage:(UIImage*)image withBlurImage:(UIImage*)blurImage
{
    UIImage *result = blurImage;
    
    result = [self circleBlurImage:image withBlurImage:blurImage];

    return result;
}

- (UIImage*)blendImage:(UIImage*)image withBlurImage:(UIImage*)blurImage andMask:(UIImage*)maskImage
{
    CGBlendMode filterName  =   [self filterName:blendMode];
    UIImage *tmp            =   [image maskedImage:maskImage];
    
    UIImage *bottomImage = image;
    //UIImage *image = blurImage;
    
    CGSize newSize = CGSizeMake(bottomImage.size.width, bottomImage.size.height);
    UIGraphicsBeginImageContext( newSize );
    [bottomImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    [blurImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height) blendMode:filterName alpha:patternAlpha];
    
    [tmp drawInRect:CGRectMake(0,0,newSize.width,newSize.height) blendMode:kCGBlendModeNormal alpha:1];
    
    UIImage *blendedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return blendedImage;
}

- (UIImage*)mergeImage:(UIImage*)first withImage:(UIImage*)second
{
    // get size of the second image
    CGImageRef secondImageRef = second.CGImage;
    CGFloat secondWidth = CGImageGetWidth(secondImageRef);
    CGFloat secondHeight = CGImageGetHeight(secondImageRef);
    
    float offsetwt,offsetht,offset;
    
    offset      =   20;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        offset  =   offset/2;
    }
    offsetht=(secondHeight   * (secondWidth+offset)) /secondWidth;
    offsetwt=secondWidth+offset;
    
    // build merged size
    CGSize mergedSize = CGSizeMake(offsetwt,offsetht);
    
    // capture image context ref
    UIGraphicsBeginImageContext(mergedSize);
    
    //Draw images onto the context
    [first drawInRect:CGRectMake(0, 0, offsetwt, offsetht)];
    [second drawInRect:CGRectMake(offset/2, offset/2, secondWidth, secondHeight) blendMode:kCGBlendModeNormal alpha:1.0];
    
    // assign context to new UIImage
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // end context
    UIGraphicsEndImageContext();
    
    return  newImage;
}

- (UIImage*)circleBlurImage:(UIImage*)image withBlurImage:(UIImage*)blurImage{
    
    CGFloat ratio = image.size.width / self.editor.imageView.width;
    CGRect frame  = _circleView.frame;
    frame.size.width  *= ratio;
    frame.size.height *= ratio;
    frame.origin.x *= ratio;
    frame.origin.y *= ratio;
    
    NSString *imgName   =   [NSString stringWithFormat:@"OverlayImage%ld",overlayPattern];

    UIImage *mask       =   [UIImage imageNamed:imgName];
    UIGraphicsBeginImageContext(image.size);
    {
        CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext() , [[UIColor whiteColor] CGColor]);
        CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, image.size.width, image.size.height));
        [mask drawInRect:frame];
        mask = UIGraphicsGetImageFromCurrentImageContext();
    }
    UIGraphicsEndImageContext();
    
    return [self blendImage:image withBlurImage:blurImage andMask:mask];
}

#pragma mark- Gesture handler

- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void)tapHandlerView:(UITapGestureRecognizer*)sender
{
    [self updateImage];
}

- (void)panHandlerView:(UIPanGestureRecognizer*)sender
{
    CGPoint point = [sender locationInView:_handlerView];
    _circleView.center = point;
    [self buildThumbnailImage];
}

-(void) resizeSticker:(float)scaleFactor{
    CGRect initialFrame = _circleView.frame;
    
    CGFloat scale = scaleFactor;
    CGRect rct;
    rct.size.width  = MAX(MIN(initialFrame.size.width*scale, 3*MAX(_handlerView.width, _handlerView.height)), 0.3*MIN(_handlerView.width, _handlerView.height));
    rct.size.height = rct.size.width;
    rct.origin.x = initialFrame.origin.x + (initialFrame.size.width-rct.size.width)/2;
    rct.origin.y = initialFrame.origin.y + (initialFrame.size.height-rct.size.height)/2;
    
    _circleView.frame = rct;
    [self buildThumbnailImage];
}

- (void)pinchHandlerView:(UIPinchGestureRecognizer*)sender
{
    static CGRect initialFrame;
    if (sender.state == UIGestureRecognizerStateBegan) {
        initialFrame = _circleView.frame;
    }
            
    CGFloat scale = sender.scale;
    CGRect rct;
    rct.size.width  = MAX(MIN(initialFrame.size.width*scale, 3*MAX(_handlerView.width, _handlerView.height)), 0.3*MIN(_handlerView.width, _handlerView.height));
    rct.size.height = rct.size.width;
    rct.origin.x = initialFrame.origin.x + (initialFrame.size.width-rct.size.width)/2;
    rct.origin.y = initialFrame.origin.y + (initialFrame.size.height-rct.size.height)/2;
            
    _circleView.frame = rct;
    [self buildThumbnailImage];
}

- (void)rotateHandlerView:(UIRotationGestureRecognizer*)sender{
    
}

-(void)crossButtonTapped{
    [self.editor.navigationBar popNavigationItemAnimated:YES];
    [self swapMenuToShowSlider:false];
}

-(void)swapMenuToShowSlider:(BOOL)showMenu{
    if(showMenu){
        [UIView animateWithDuration:kCLImageToolAnimationDuration animations:^{
            for(UIView *subView in _menuScroll.subviews){
                if ([subView isKindOfClass:[ToolBarItem class]]) {
                    subView.alpha  = 0.0;
                }
            }
        }];
        
        _containerView.frame  = CGRectMake(_containerView.frame.origin.x, self.editor.menuScrollView.top + _containerView.frame.size.height, _containerView.frame.size.width, _containerView.frame.size.height);
        
        [UIView animateWithDuration:kCLImageToolAnimationDuration
                         animations:^{
                             _containerView.frame  = CGRectMake(_containerView.frame.origin.x, self.editor.menuScrollView.top - _containerView.frame.size.height, _containerView.frame.size.width, _containerView.frame.size.height);
                         }
         ];
        
    }
    else{
        [UIView animateWithDuration:kCLImageToolAnimationDuration
                         animations:^{
                             for(UIView *subView in _menuScroll.subviews){
                                 subView.alpha  = 1.0;
                             }
                         }
         ];
        
        [UIView animateWithDuration:kCLImageToolAnimationDuration animations:^{
            _containerView.frame  = CGRectMake(_containerView.frame.origin.x,  self.editor.view.bottom, _containerView.frame.size.width, _containerView.frame.size.height);
        } completion:^(BOOL finished) {
            _subMenuScroll = nil;

            [_containerView removeFromSuperview];
        }];
    }
}

-(CGBlendMode)filterName:(NSInteger)filterId{
    switch(filterId){
        case 0  :
            return kCGBlendModeNormal;
            break;
        case 1  :
            return kCGBlendModeMultiply;
            break;
        case 2  :
            return kCGBlendModeColor;
            break;
        case 3  :
            return kCGBlendModeScreen;
            break;
        case 4  :
            return kCGBlendModeOverlay;
            break;
        case 5  :
            return kCGBlendModeDarken;
            break;
        case 6  :
            return kCGBlendModeLighten;
            break;
        case 7  :
            return kCGBlendModeColorDodge;
            break;
        case 8  :
            return kCGBlendModeColorBurn;
            break;
        case 9  :
            return kCGBlendModeSoftLight;
            break;
        case 10  :
            return kCGBlendModeHardLight;
            break;
        case 11  :
            return kCGBlendModeDifference;
            break;
        case 12  :
            return kCGBlendModeExclusion;
            break;
        case 13  :
            return kCGBlendModeHue;
            break;
        case 14  :
            return kCGBlendModeSaturation;
            break;
        case 15  :
            return kCGBlendModeLuminosity;
            break;
            
        default :
            return kCGBlendModeOverlay;
    }
}


@end


#pragma mark- UI components

@implementation CLBlurCircleOverlay

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self setNeedsDisplay];
}

- (void)setCenter:(CGPoint)center
{
    [super setCenter:center];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGRect rct = self.bounds;
    rct.origin.x = 0.35*rct.size.width;
    rct.origin.y = 0.35*rct.size.height;
    rct.size.width *= 0.3;
    rct.size.height *= 0.3;
    
    CGContextSetStrokeColorWithColor(context, self.color.CGColor);
    CGContextStrokeEllipseInRect(context, rct);
    
    self.alpha = 1;
    [UIView animateWithDuration:kCLImageToolFadeoutDuration
                          delay:1
                        options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         self.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         
                     }
     ];
}

@end




@implementation CLBlurBandOverlay

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        _scale    = 1;
        _rotation = 0;
        _offset   = 0;
    }
    return self;
}

- (void)setScale:(CGFloat)scale
{
    _scale = scale;
    [self calcTransform];
}

- (void)setRotation:(CGFloat)rotation
{
    _rotation = rotation;
    [self calcTransform];
}

- (void)setOffset:(CGFloat)offset
{
    _offset = offset;
    [self calcTransform];
}

- (void)calcTransform
{
    CGAffineTransform transform = CGAffineTransformIdentity;
    transform = CGAffineTransformTranslate(transform, -self.offset*sin(self.rotation), self.offset*cos(self.rotation));
    transform = CGAffineTransformRotate(transform, self.rotation);
    transform = CGAffineTransformScale(transform, 1, self.scale);
    self.transform = transform;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self setNeedsDisplay];
}

- (void)setCenter:(CGPoint)center
{
    [super setCenter:center];
    [self setNeedsDisplay];
}

- (void)setTransform:(CGAffineTransform)transform
{
    [super setTransform:transform];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGRect rct = self.bounds;
    rct.origin.y = 0.3*rct.size.height;
    rct.size.height *= 0.4;
    
    CGContextSetLineWidth(context, 1/self.scale);
    CGContextSetStrokeColorWithColor(context, self.color.CGColor);
    CGContextStrokeRect(context, rct);
    
    self.alpha = 1;
    [UIView animateWithDuration:kCLImageToolFadeoutDuration
                          delay:1
                        options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         self.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         
                     }
     ];
}

@end
