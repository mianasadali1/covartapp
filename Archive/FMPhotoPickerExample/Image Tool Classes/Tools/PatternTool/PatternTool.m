//
//  CLBlurTool.m
//
//  Created by sho yakushiji on 2013/10/19.
//  Copyright (c) 2013年 CALACULU. All rights reserved.
//

#import "PatternTool.h"
#import "SelectorsList.h"
#import "UIImage+Utility.h"
#import "UIView+Frame.h"
#import "ToolBarItem.h"
#import "UIView+Toast.h"

static NSString* const kCLBlurToolNormalIconName = @"nonrmalIconAssetsName";
static NSString* const kCLBlurToolCircleIconName = @"circleIconAssetsName";
static NSString* const kCLBlurToolBandIconName = @"bandIconAssetsName";


@interface PatternTool()
<UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIView *selectedMenu;
@end

@implementation PatternTool
{
    UIImage *_originalImage;
    UIImage *_thumbnailImage;
    UIImage *_patternImage;
    UIImage *_patternThumbnailImage;
    UIImage *_lastPatternImage;
    UIImage *_iconImage;
    UIImage *_firstPatternImage;

    UISlider *_alphaSlider;
    UISlider *_blurSlider;

    UIScrollView *_menuScroll;
    UIScrollView *_subMenuScroll;

    UIView *_containerView;

    UIView *_handlerView;
    
    CGRect _bandImageRect;
    
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
    pattern         =   1;
    patternAlpha    =   0.5;

    _originalImage  =   self.editor.imageView.image;
    _thumbnailImage =   [_originalImage resize:CGSizeMake(_originalImage.size.width/2, _originalImage.size.height/2)];
    
    [self.editor fixZoomScaleWithAnimated:YES];
    
    _handlerView = [[UIView alloc] initWithFrame:self.editor.imageView.frame];
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
    
  //  [self setDefaultParams];
    [self updateImage];

    BOOL isInstructionsShown    =   [[NSUserDefaults standardUserDefaults] boolForKey:@"isPatterenInstructionsShown1"];
    
    if(!isInstructionsShown){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [self.editor.view makeToast:@"Tap on photo to change filter and swipe to change color"
                        duration:4.0
                        position:CSToastPositionBottom];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isPatterenInstructionsShown1"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        });
    }
    
    UISwipeGestureRecognizer *swipeLeftRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(changeColorOfImage)];
    [swipeLeftRight setDirection:(UISwipeGestureRecognizerDirectionRight | UISwipeGestureRecognizerDirectionLeft )];
    self.editor.view.userInteractionEnabled    = true;
    [self.editor.view addGestureRecognizer:swipeLeftRight];
}

- (void)cleanup
{
    _patternImage  =   nil;
    _patternThumbnailImage = nil;
    _thumbnailImage = nil;
    _originalImage  = nil;
    
    [self.editor resetZoomScaleWithAnimated:YES];
    [_handlerView removeFromSuperview];
    
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
        [_containerView removeFromSuperview];

        UIActivityIndicatorView *indicator = [CLImageEditorTheme indicatorView];
        indicator.center = CGPointMake(_handlerView.width/2, _handlerView.height/2);
        [_handlerView addSubview:indicator];
        [indicator startAnimating];
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *image  =   [self buildResultImage:_originalImage withBlurImage:_patternImage];
        image           =   [UIImage drawImage:image inRect:CGRectMake(0, 0, image.size.width, image.size.height)];

        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock(image, nil, nil);
        });
    });
}

#pragma mark- 

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

-(void)initBlurSliderView{
    _blurSlider = [[UISlider alloc] initWithFrame:CGRectMake(10, (_menuScroll.frame.size.height - 40)/2, _menuScroll.frame.size.width - 20, 40)];
    
    _blurSlider.continuous          =   NO;
    [_blurSlider addTarget:self action:@selector(blurSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    _blurSlider.maximumValue        =   1;
    _blurSlider.minimumValue        =   0.1;
    _blurSlider.value               =   1;
    
    [_containerView addSubview:_blurSlider];
    
    UINavigationItem *item  = [[UINavigationItem alloc] initWithTitle:@"Alpha"];
    item.rightBarButtonItem  =  [self buttonWithImageName:[CLImageEditorTheme localizedString:@"CLImageEditor_OKBtnTitle" withDefault:@"OK"] selector:@selector(blurOkButtonTapped)];

    item.leftBarButtonItem  =  [self buttonWithImageName:[CLImageEditorTheme localizedString:@"CLImageEditor_BackBtnTitle" withDefault:@"Back"] selector:@selector(crossButtonTapped)];

    [self.editor.navigationBar pushNavigationItem:item animated:true];
}

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

-(void)setPatternMenu{
    NSMutableArray* _overlayColorsImgs      =   [NSMutableArray new];
    
    for(int i = 1 ; i < 18 ; i++){
        [_overlayColorsImgs addObject:[NSString stringWithFormat:@"%d.png",i]];
    }
    
    UINavigationItem *item  =   [[UINavigationItem alloc] initWithTitle:@"Pattern"];
    item.leftBarButtonItem  =  [self buttonWithImageName:[CLImageEditorTheme localizedString:@"CLImageEditor_BackBtnTitle" withDefault:@"Back"] selector:@selector(crossButtonTapped)];
    [self.editor.navigationBar pushNavigationItem:item animated:true];
    
    CGFloat W = 70;
    CGFloat H = _subMenuScroll.height;
    CGFloat x = 0;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        W   =   100;
    }
    
    NSInteger tag = 1;
    
    for(NSString *patternImgPath in _overlayColorsImgs){
        ToolBarItem *view       =   [CLImageEditorTheme menuItemWithFrame:CGRectMake(x, 0, W, H) target:self action:@selector(tappedPatternMenu:) toolInfo:nil isIcon:false];
        view.titleLabel.text    =   [NSString stringWithFormat:@"P%ld",tag];

        view.tag                =   tag++;
        UIImage *patternImage   =   [UIImage imageNamed:patternImgPath];
        UIImage *blendImage     =   [self blendImage:_thumbnailImage withBlurImage:patternImage];
        
        view.iconView.image     =   blendImage;
        view.iconView.layer.borderColor =   [UIColor darkGrayColor].CGColor;
        view.iconView.layer.borderWidth =   1.0;
        [_subMenuScroll addSubview:view];
        x += W;
    }
    
    _subMenuScroll.contentSize = CGSizeMake(MAX(x, _subMenuScroll.frame.size.width+1), 0);
}

- (void)setBlendMenu
{
    UINavigationItem *item  =   [[UINavigationItem alloc] initWithTitle:@"Blend"];
    item.leftBarButtonItem  =   [self buttonWithImageName:[CLImageEditorTheme localizedString:@"CLImageEditor_BackBtnTitle" withDefault:@"Back"] selector:@selector(crossButtonTapped)];
    [self.editor.navigationBar pushNavigationItem:item animated:true];
    
    CGFloat W = 70;
    CGFloat H = _subMenuScroll.height;
    CGFloat x = 0;

    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        W   =   100;
    }
    
    NSArray *_menu = @[
                       @{@"title":@"Normal", @"icon":[UIImage imageNamed:@"add_photo"]},
                       @{@"title":@"Multiply", @"icon":[UIImage imageNamed:@"add_photo"]},
                       @{@"title":@"Color", @"icon":[UIImage imageNamed:@"add_photo"]},
                       @{@"title":@"Screen", @"icon":[UIImage imageNamed:@"add_photo"]},
                       @{@"title":@"Overlay", @"icon":[UIImage imageNamed:@"add_photo"]},
                       @{@"title":@"Darken", @"icon":[UIImage imageNamed:@"add_photo"]},
                       @{@"title":@"Lighten", @"icon":[UIImage imageNamed:@"add_photo"]},
                       @{@"title":@"Dodge", @"icon":[UIImage imageNamed:@"add_photo"]},
                       @{@"title":@"Color Burn", @"icon":[UIImage imageNamed:@"add_photo"]},
                       @{@"title":@"Soft Light", @"icon":[UIImage imageNamed:@"add_photo"]},
                       @{@"title":@"Hard Light", @"icon":[UIImage imageNamed:@"add_photo"]},
                       @{@"title":@"Difference", @"icon":[UIImage imageNamed:@"add_photo"]},
                       @{@"title":@"Exclusion", @"icon":[UIImage imageNamed:@"add_photo"]},
                       @{@"title":@"Hue", @"icon":[UIImage imageNamed:@"add_photo"]},
                       @{@"title":@"Saturation", @"icon":[UIImage imageNamed:@"add_photo"]},
                       @{@"title":@"Luminosity", @"icon":[UIImage imageNamed:@"add_photo"]}
                       ];
    
    NSInteger tag = 0;
    for(NSDictionary *obj in _menu){
        ToolBarItem *view = [CLImageEditorTheme menuItemWithFrame:CGRectMake(x, 0, W, H) target:self action:@selector(tappedBlendMenu:) toolInfo:nil isIcon:false];
        blendMode = tag;
        view.tag = tag++;
        
        UIImage *blendImage     =   [self blendImage:_thumbnailImage withBlurImage:_firstPatternImage];
        
        view.iconView.image             =   blendImage;
        view.iconView.layer.borderColor =   [UIColor darkGrayColor].CGColor;
        view.iconView.layer.borderWidth =   1.0;
        view.titleLabel.text    = obj[@"title"];
        
        [_subMenuScroll addSubview:view];
        x += W;
    }
    _subMenuScroll.contentSize = CGSizeMake(MAX(x, _subMenuScroll.frame.size.width+1), 0);
}

- (void)setMainMenu
{
    CGFloat W = 70;
    CGFloat H = _menuScroll.height;
    CGFloat x = (self.editor.view.frame.size.width - (W*2))/2;

    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        W   =   100;
    }
    
    NSArray *_menu = @[
                       @{@"title":@"Pattern", @"icon":[UIImage imageNamed:@"pattern"]},
                       @{@"title":@"Blend", @"icon":[UIImage imageNamed:@"blend"]}
    ];
    
    NSInteger tag = 0;
    for(NSDictionary *obj in _menu){
        ToolBarItem *view   =   [ToolBarItem menuItemWithFrame:CGRectMake(x, 40, W, H) target:self action:@selector(tappedMainMenu:) toolInfo:nil isIcon:true];
        view.tag = tag++;
        view.titleLabel.text    =   obj[@"title"];
        view.iconView.image     =   obj[@"icon"];
        
        if(self.selectedMenu==nil){
            self.selectedMenu = view;
        }
        
        [_menuScroll addSubview:view];
        x += W;
    }
    //_menuScroll.contentSize = CGSizeMake(MAX(x, _menuScroll.frame.size.width+1), 0);

    _menuScroll.contentSize = CGSizeMake(x, 0);
    
//    if (_menuScroll.contentSize.width < self.editor.menuScrollView.frame.size.width){
//        _menuScroll.frame   =   CGRectMake(_menuScroll.frame.origin.x, _menuScroll.frame.origin.y, _menuScroll.contentSize.width, _menuScroll.frame.size.height);
//        _menuScroll.center  =   self.editor.menuScrollView.center;
//    }
}

- (void)setSelectedMenu:(UIView *)selectedMenu
{
    if(selectedMenu != _selectedMenu){
        _selectedMenu.backgroundColor = [UIColor clearColor];
        _selectedMenu = selectedMenu;
       // _selectedMenu.backgroundColor = [CLImageEditorTheme toolbarSelectedButtonColor];
    }
}

- (void)setHandlerView
{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandlerView:)];
    
    
    tapGesture.delegate = self;
    
    [_handlerView addGestureRecognizer:tapGesture];
}

- (void)alphaSliderValueChanged:(UISlider*)slider
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            patternAlpha    =   slider.value;
        });

        [self buildThumbnailImage];
    });
}

- (void)blurSliderValueChanged:(UISlider*)slider
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
        [self buildThumbnailImage];
    });
}

-(void)blurOkButtonTapped{
    
}

-(void)alphaOkButtonTapped{
    
}

-(void)changeColorOfImage{

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        _patternImage          =   [UIImage changeColorOfImage:_lastPatternImage];
        _patternThumbnailImage =   [_patternImage resize:_thumbnailImage.size];
        [self buildThumbnailImage];
    });
}

- (void)buildThumbnailImage
{
    static BOOL inProgress = NO;
    
    if(inProgress){ return; }
    
    inProgress = YES;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *image = [self buildResultImage:_thumbnailImage withBlurImage:_patternThumbnailImage];
        image   =   [UIImage drawImage:image inRect:CGRectMake(0, 0, image.size.width, image.size.height)];

       
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
    
    result = [self blendImage:image withBlurImage:blurImage ];

    return result;
}

- (UIImage*)blendImage:(UIImage*)image withBlurImage:(UIImage*)blurImage
{
    CGBlendMode filterName    =   [self filterName:blendMode];
    UIImage *bottomImage = image;
       // UIImage *image = blurImage;
    CGSize newSize = CGSizeMake(bottomImage.size.width, bottomImage.size.height);
    UIGraphicsBeginImageContext( newSize );
    [bottomImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
        
    if(patternAlpha > 0.2){
        [blurImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height) blendMode:filterName alpha:patternAlpha - 0.2];
    }
    else{
        [blurImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height) blendMode:filterName alpha:0.2];
    }
    UIImage *blendedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return blendedImage;
}

#pragma mark- Gesture handler

- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

-(void)tappedPatternMenu:(UITapGestureRecognizer*)sender{
    UIView *view    =   sender.view;
    pattern         =   view.tag;
    [self updateImage];
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
            [self setPatternMenu];
            break;
        case 1:
            [self initSubMenuScrollView];
            [self setBlendMenu];
            break;
            
        case 2:
            [self initSubMenuScrollView];
            [self initAlphaSliderView];
            break;
        case 3:
            [self initSubMenuScrollView];
            [self initBlurSliderView];
            break;
        default:
            break;
    }
    
    [self swapMenuToShowSlider:YES];
}

- (void)tapHandlerView:(UITapGestureRecognizer*)sender
{
    [self updateImage];
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
        _patternImage               =   [[SelectorsList sharedInstance] getImageByApplyingEffectId:CGSizeMake(_originalImage.size.width, _originalImage.size.height) effectId:pattern];
        _patternThumbnailImage      =   [_patternImage resize:_thumbnailImage.size];
        _lastPatternImage           =   _patternImage;
        
        if(_firstPatternImage == nil){
            _firstPatternImage = _patternThumbnailImage;
        }
        [self buildThumbnailImage];
    });
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
            [_containerView removeFromSuperview];
            _subMenuScroll = nil;
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
