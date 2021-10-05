//
//  BlurTool.m
//  BasicFilters
//
//  Created by Kanwarpal Singh on 07/08/17.
//  Copyright © 2017 Kanwarpal Singh. All rights reserved.
//

#import "BlurTool.h"
#import "UIImage+Utility.h"
#import "UIView+Frame.h"

@interface CLBlurCircle : UIView
@property (nonatomic, strong) UIColor *color;
@end


@interface BlurTool()
<UIGestureRecognizerDelegate>
@property (nonatomic, strong) ToolBarItem *selectedMenu;
@property (nonatomic, strong) UIImage *selectedShape;

@end


@implementation BlurTool
{
    UIImage *_originalImage;
    UIImage *_thumbnailImage;
    UIImage *_origionalBlurImage;
    UIImage *_blurImage;
    UIImage *_blurThumbnailImage;
    
    UISlider *_blurSlider;
    UIScrollView *_menuScroll;
    UIScrollView *_subMenuScroll;
    
    UIView *_handlerView;
    UIView *_containerView;
    
    CLBlurCircle *_circleView;
    CGRect _bandImageRect;
}

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
    pattern                 =   1;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        blurShapesList      =   [NSMutableArray new];
        
        patterenImg    =   [[SelectorsList sharedInstance] getImageByApplyingEffectId:CGSizeMake(_originalImage.size.width/4, _originalImage.size.height/4) effectId:pattern];
        
        for(int i = 56 ; i < 165 ; i++){
            UIImage *image  =   [UIImage imageNamed:[NSString stringWithFormat:@"overlayIcon%d",i]];
            [blurShapesList addObject:image];
        }
    });
    
    lastSliderValue     =   5;
    selectedShapeNumber =   56;
    _originalImage      =   self.editor.imageView.image;
    _thumbnailImage     =   [_originalImage resize:self.editor.imageView.frame.size];
    
    _origionalBlurImage =   [_originalImage gaussBlur:10];
    
    [self generateBlurImageWithPattren];
    
    //_blurThumbnailImage =   [_blurImage resize:_thumbnailImage.size];
    
    [self.editor fixZoomScaleWithAnimated:YES];
    
    _handlerView        =   [[UIView alloc] initWithFrame:self.editor.imageView.frame];
    [self.editor.imageView.superview addSubview:_handlerView];
    [self setHandlerView];
    
    _menuScroll     =   [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.editor.menuScrollView.frame.origin.y - 40, self.editor.menuScrollView.frame.size.width, self.editor.menuScrollView.frame.size.height + 40)];
    _menuScroll.backgroundColor = [UIColor clearColor];
    _menuScroll.showsHorizontalScrollIndicator = NO;
    
    [self.editor.view addSubview:_menuScroll];
    [self initAlphaSliderView];
    
    [self setMainMenu];
    
    _menuScroll.transform = CGAffineTransformMakeTranslation(0, self.editor.view.height-_menuScroll.top);
    [UIView animateWithDuration:kCLImageToolAnimationDuration
                     animations:^{
                         _menuScroll.transform = CGAffineTransformIdentity;
                     }];
    
    [self setDefaultParams];
}

-(void)initAlphaSliderView{
    _blurSlider = [[UISlider alloc] initWithFrame:CGRectMake(10, 0, self.editor.menuScrollView.frame.size.width - 20, 40)];
    
    [_blurSlider setThumbImage:[UIImage imageNamed:@"slider"] forState:UIControlStateNormal];
    
    [_blurSlider setMinimumTrackTintColor:[UIColor whiteColor]];
    [_blurSlider setMaximumTrackTintColor:[UIColor whiteColor]];
    
    _blurSlider.continuous          =   NO;
    [_blurSlider addTarget:self action:@selector(blurSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    _blurSlider.maximumValue        =   100;
    _blurSlider.minimumValue        =   0;
    _blurSlider.value               =   lastSliderValue;
    
    [_menuScroll addSubview:_blurSlider];
}

- (void)blurSliderValueChanged:(UISlider*)slider
{
    lastScrolPoint  =   _blurSlider.value;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        _origionalBlurImage =   [_originalImage gaussBlur:lastScrolPoint*2];
        
        [self generateBlurImageWithPattren];
        
        //_blurThumbnailImage =   [_blurImage resize:size];
        
        //[self buildThumbnailImage];
    });
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
                       @{@"title":@"Blur", @"icon":[UIImage imageNamed:@"blur"]},
                       ];
    
    NSInteger tag = 0;
    for(NSDictionary *obj in _menu){
        ToolBarItem *view   =   [ToolBarItem menuItemWithFrame:CGRectMake(x, 50, W, H) target:self action:@selector(tappedMainMenu:) toolInfo:nil isIcon:true];
        view.tag = tag++;
        view.titleLabel.text    = obj[@"title"];
        view.iconView.image =   obj[@"icon"];
        
        if(self.selectedMenu==nil){
            self.selectedMenu = view;
        }
        
        [_menuScroll addSubview:view];
        x += W;
    }
    _menuScroll.contentSize = CGSizeMake(x, 0);
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
            [self setBlurMenu];
            break;
            
        default:
            break;
    }
    
    [self swapMenuToShowSlider:YES];
}

- (void)initSubMenuScrollView
{
    [_containerView removeFromSuperview];
    _containerView                      =   [[UIView alloc]initWithFrame:CGRectMake(0, _menuScroll.top, self.editor.menuScrollView.frame.size.width, _menuScroll.frame.size.height)];
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


- (void)setDefaultParams
{
    _circleView = [[CLBlurCircle alloc] initWithFrame:CGRectMake(0, 0, _handlerView.width/1.5, _handlerView.width/1.5)];
    _circleView.backgroundColor = [UIColor clearColor];
    _circleView.color = [UIColor whiteColor];
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
    
    for(NSString *patternImg in _overlayColorsImgs){
        ToolBarItem *view       =   [CLImageEditorTheme menuItemWithFrame:CGRectMake(x, 0, W, H) target:self action:@selector(tappedPatternMenu:) toolInfo:nil isIcon:false];
        view.titleLabel.text    =   [NSString stringWithFormat:@"P%ld",tag];
        
        view.tag                =   tag++;
        view.iconView.image     =   [UIImage imageNamed:patternImg];
        view.iconView.layer.borderColor =   [UIColor darkGrayColor].CGColor;
        view.iconView.layer.borderWidth =   1.0;
        [_subMenuScroll addSubview:view];
        x += W;
    }
    
    _subMenuScroll.contentSize = CGSizeMake(MAX(x, _subMenuScroll.frame.size.width+1), 0);
}

-(void)tappedPatternMenu:(UITapGestureRecognizer*)sender{
    UIView *view    =   sender.view;
    pattern         =   view.tag;
    
    patterenImg    =   [[SelectorsList sharedInstance] getImageByApplyingEffectId:CGSizeMake(_blurImage.size.width, _blurImage.size.height) effectId:pattern];
    
    [self generateBlurImageWithPattren];
}

-(void)generateBlurImageWithPattren{
    dispatch_async(dispatch_get_main_queue(), ^{
        [indicator removeFromSuperview];
        indicator = [CLImageEditorTheme indicatorView];
        indicator.center = CGPointMake(_handlerView.width/2, _handlerView.height/2);
        [_handlerView addSubview:indicator];
        [indicator startAnimating];
    });
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        CGBlendMode filterName  =   kCGBlendModeNormal;
        UIImage *bottomImage    = _origionalBlurImage;
        // UIImage *image = blurImage;
        CGSize newSize = CGSizeMake(bottomImage.size.width, bottomImage.size.height);
        UIGraphicsBeginImageContext( newSize );
        [bottomImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
        [patterenImg drawInRect:CGRectMake(0,0,newSize.width,newSize.height) blendMode:filterName alpha:0.2];
        _blurImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        _blurThumbnailImage     =   _blurImage;
        [self buildThumbnailImage];
    });
}

- (void)setBlurMenu
{
    CGFloat W = 70;
    CGFloat H = _subMenuScroll.height;
    CGFloat x = 0;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        W   =   100;
    }
    
    UINavigationItem *item  =   [[UINavigationItem alloc] initWithTitle:@"Blur"];
    item.leftBarButtonItem  =  [self buttonWithImageName:[CLImageEditorTheme localizedString:@"CLImageEditor_BackBtnTitle" withDefault:@"Back"] selector:@selector(crossButtonTapped)];
    [self.editor.navigationBar pushNavigationItem:item animated:true];
    
    NSInteger tag = 0;
    for(UIImage *shapeImage in blurShapesList){
        ToolBarItem *view       =   [ToolBarItem menuItemWithFrame:CGRectMake(x, 0, W, H) target:self action:@selector(tappedBlurMenu:) toolInfo:nil isIcon:false];
        view.tag = tag++;
        
        UIImage *image          =   shapeImage;
        
        view.iconView.image =   image;
        
        [_subMenuScroll addSubview:view];
        x += W;
    }
    
    _subMenuScroll.contentSize = CGSizeMake(x, 0);
    
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
        
        _containerView.frame  = CGRectMake(_containerView.frame.origin.x, _menuScroll.top + _containerView.frame.size.height, _containerView.frame.size.width, _containerView.frame.size.height);
        
        [UIView animateWithDuration:kCLImageToolAnimationDuration
                         animations:^{
                             _containerView.frame  = CGRectMake(_containerView.frame.origin.x, _menuScroll.top + 40, _containerView.frame.size.width, _containerView.frame.size.height);
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

- (void)buildThumbnailImage
{
    static BOOL inProgress = NO;
    
    if(inProgress){ return; }
    
    inProgress = YES;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *image = [self buildResultImage:_thumbnailImage withBlurImage:_blurThumbnailImage];
        image   =   [UIImage drawImage:image inRect:CGRectMake(0, 0, image.size.width, image.size.height)];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [indicator removeFromSuperview];
            self.editor.imageView.image  =   image;
        });
        inProgress = NO;
    });
}

- (UIImage*)buildResultImage:(UIImage*)image withBlurImage:(UIImage*)blurImage
{
    UIImage *result = blurImage;
    
    result = [self circleBlurImage:image withBlurImage:blurImage];
    return result;
}

- (UIImage*)blurImage:(UIImage*)image withBlurImage:(UIImage*)blurImage andMask:(UIImage*)maskImage
{
    UIImage *tmp = [image maskedImage:maskImage];
    
    UIGraphicsBeginImageContext(blurImage.size);
    {
        [blurImage drawAtPoint:CGPointZero];
        [tmp drawInRect:CGRectMake(0, 0, blurImage.size.width, blurImage.size.height)];
        tmp = UIGraphicsGetImageFromCurrentImageContext();
    }
    UIGraphicsEndImageContext();
    
    return tmp;
}

- (UIImage*)circleBlurImage:(UIImage*)image withBlurImage:(UIImage*)blurImage
{
    CGFloat ratio = image.size.width / self.editor.imageView.width;
    CGRect frame  = _circleView.frame;
    frame.size.width  *= ratio;
    frame.size.height *= ratio;
    frame.origin.x *= ratio;
    frame.origin.y *= ratio;
    
    NSString *imgName   =   [NSString stringWithFormat:@"m%ld",selectedShapeNumber];
    
    UIImage *mask       =   [UIImage imageNamed:imgName];
    
    UIGraphicsBeginImageContext(image.size);
    {
        CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext() , [[UIColor whiteColor] CGColor]);
        CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, image.size.width, image.size.height));
        [mask drawInRect:frame];
        mask = UIGraphicsGetImageFromCurrentImageContext();
    }
    UIGraphicsEndImageContext();
    
    return [self blurImage:image withBlurImage:blurImage andMask:mask];
}

#pragma mark- Gesture handler

- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void)tappedBlurMenu:(UITapGestureRecognizer*)sender
{
    UIView *view         =   sender.view;
    selectedShapeNumber  =   view.tag + 56;
    
    //[self swapMenuToShowSlider:true];
    
    view.alpha = 0.2;
    [UIView animateWithDuration:kCLImageToolAnimationDuration
                     animations:^{
                         view.alpha = 1;
                     }
     ];
    
    [_circleView removeFromSuperview];
    [_handlerView addSubview:_circleView];
    _circleView.center  = CGPointMake(_handlerView.frame.size.width/2, _handlerView.frame.size.height/2);
    [_circleView setNeedsDisplay];
    [self buildThumbnailImage];
}

- (void)tapHandlerView:(UITapGestureRecognizer*)sender
{
    if(selectedShapeNumber > 0){
        CGPoint point = [sender locationInView:_handlerView];
        _circleView.center = point;
        [self buildThumbnailImage];
    }
}

- (void)panHandlerView:(UIPanGestureRecognizer*)sender
{
    if(selectedShapeNumber > 0){
        CGPoint point = [sender locationInView:_handlerView];
        _circleView.center = point;
        [self buildThumbnailImage];
    }
}

- (void)pinchHandlerView:(UIPinchGestureRecognizer*)sender
{
    if(selectedShapeNumber > 0){
        static CGRect initialFrame;
        if (sender.state == UIGestureRecognizerStateBegan) {
            initialFrame =  _circleView.frame;
        }
        
        CGFloat scale   =   sender.scale;
        CGRect rct;
        rct.size.width  =   MAX(MIN(initialFrame.size.width*scale, 3*MAX(_handlerView.width, _handlerView.height)), 0.3*MIN(_handlerView.width, _handlerView.height));
        rct.size.height =   rct.size.width;
        rct.origin.x    =   initialFrame.origin.x + (initialFrame.size.width-rct.size.width)/2;
        rct.origin.y    =   initialFrame.origin.y + (initialFrame.size.height-rct.size.height)/2;
        
        _circleView.frame = rct;
        [self buildThumbnailImage];
    }
}

- (void)rotateHandlerView:(UIRotationGestureRecognizer*)sender
{
    //    switch (_blurType) {
    //        case kCLBlurTypeBand:
    //        {
    //            static CGFloat initialRotation;
    //            if (sender.state == UIGestureRecognizerStateBegan) {
    //                initialRotation = _bandView.rotation;
    //            }
    //
    //            _bandView.rotation = MIN(M_PI/2, MAX(-M_PI/2, initialRotation + sender.rotation));
    //            [self buildThumbnailImage];
    //            break;
    //        }
    //        default:
    //            break;
    //    }
    //
}

- (void)executeWithCompletionBlock:(void(^)(UIImage *image, NSError *error, NSDictionary *userInfo))completionBlock
{
    double sliderValue  =   _blurSlider.value;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //_blurImage      =   [_originalImage gaussBlur:sliderValue*5];
        
        UIImage *image  =   [self buildResultImage:_originalImage withBlurImage:_blurImage];
        image   =   [UIImage drawImage:image inRect:CGRectMake(0, 0, image.size.width, image.size.height)];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock(image, nil, nil);
        });
    });
}

- (void)cleanup
{
    [self.editor resetZoomScaleWithAnimated:YES];
    [_blurSlider.superview removeFromSuperview];
    [_handlerView removeFromSuperview];
    
    [UIView animateWithDuration:kCLImageToolAnimationDuration
                     animations:^{
                         _menuScroll.transform = CGAffineTransformMakeTranslation(0, self.editor.view.height-_menuScroll.top);
                     }
                     completion:^(BOOL finished) {
                         [_menuScroll removeFromSuperview];
                     }];
}
@end

#pragma mark- UI components

@implementation CLBlurCircle

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
    
    //CGContextSetStrokeColorWithColor(context, self.color.CGColor);
    // CGContextStrokeEllipseInRect(context, rct);
    
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



