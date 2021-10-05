//
//  AdjustmentTool.m
//  BasicFilters
//
//  Created by Kanwarpal Singh on 04/08/17.
//  Copyright © 2017 Kanwarpal Singh. All rights reserved.
//

#import "CLEffectTool.h"
#import "UIView+Frame.h"

@implementation CLEffectTool

- (void)setup
{
    [self updateImagePlaceHolderWithImage:self.editor.imageView.image];
    [self.editor fixZoomScaleWithAnimated:YES];
    
    [self setUpTools];
}

-(void)updateImagePlaceHolderWithImage:(UIImage *)image{
    _originalImage  = image;
    _thumbnailImage = [_originalImage resize:self.editor.imageView.frame.size];
}

- (void)initMenuScrollView
{
    if(self.menuScrollView==nil){
        UIScrollView *menuScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.editor.view.width, kMenuBarHeight)];
        menuScroll.top = self.editor.view.height - menuScroll.height;
        menuScroll.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        menuScroll.showsHorizontalScrollIndicator   =   NO;
        menuScroll.showsVerticalScrollIndicator     =   NO;
        
        [self.editor.view addSubview:menuScroll];
        self.menuScrollView = menuScroll;
    }
    self.menuScrollView.backgroundColor = self.editor.barColor;
}

-(void)initSliderView{
    self.menuScrollView.contentOffset   =   CGPointZero;
    
    self.menuScrollView.scrollEnabled  = false;
    
    _sliderView                 =   [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.menuScrollView.frame.size.width , self.menuScrollView.frame.size.height)];
    _sliderView.backgroundColor =   self.editor.barColor;
    [self.menuScrollView addSubview:_sliderView];
    
    _slider = [[UISlider alloc] initWithFrame:CGRectMake(70, (self.menuScrollView.frame.size.height - 40)/2, self.menuScrollView.frame.size.width - 140, 40)];
    
    _slider.continuous      =   NO;
    [_slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        
    _slider.maximumValue    =   self.currentTool.maxLimit;
    _slider.minimumValue    =   self.currentTool.minLimit;
    _slider.value           =   self.currentTool.maxLimit/2;
    
    [_sliderView addSubview:_slider];
    
    UIButton *crossButton   =   [UIButton buttonWithType:UIButtonTypeCustom];
    crossButton.frame       =   CGRectMake(20, (_sliderView.frame.size.height - kCancelBtnHeightWidth)/2, kCancelBtnHeightWidth, kCancelBtnHeightWidth);
    [crossButton setImage:[UIImage imageNamed:@"cross"] forState:UIControlStateNormal];
    [crossButton addTarget:self action:@selector(crossButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [_sliderView addSubview:crossButton];
    
    UIButton *okButton      =   [UIButton buttonWithType:UIButtonTypeCustom];
    okButton.frame          =   CGRectMake(_sliderView.frame.size.width - 20 - kOkBtnHeightWidth, (_sliderView.frame.size.height - kOkBtnHeightWidth)/2, kOkBtnHeightWidth, kOkBtnHeightWidth);
    [okButton setImage:[UIImage imageNamed:@"tick"] forState:UIControlStateNormal];
    [okButton addTarget:self action:@selector(okButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [_sliderView addSubview:okButton];
    
    [self.menuScrollView addSubview:_sliderView];
}

-(void)sliderValueChanged:(UISlider *)slider{
    if(!self.currentTool){
        return;
    }
    
    static BOOL inProgress = NO;
    
    if(inProgress){ return; }
    inProgress = YES;
    
    Class toolClass = NSClassFromString(self.currentTool.toolName);
    
    if(toolClass){
        id instance = [toolClass alloc];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            if(instance!=nil && [instance isKindOfClass:[EffectSubTool class]]){
                NSLog(@"%f",slider.value);
                UIImage *image = [instance applyFilterOnImage:_originalImage withValue:slider.value];
                [self.editor.imageView performSelectorOnMainThread:@selector(setImage:) withObject:image waitUntilDone:NO];
                inProgress = NO;
            }
        });
    }
}

-(void)crossButtonTapped{
    self.menuScrollView.scrollEnabled  = true;
    self.menuScrollView.contentOffset   =   CGPointMake(lastScrolPoint, 0);
    
    [self swapMenuToShowSlider:false];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.editor.imageView performSelectorOnMainThread:@selector(setImage:) withObject:_originalImage waitUntilDone:NO];
    });
}

-(void)okButtonTapped{
    [self updateImagePlaceHolderWithImage:self.editor.imageView.image];
    
    self.menuScrollView.scrollEnabled  = true;
    self.menuScrollView.contentOffset   =   CGPointMake(lastScrolPoint, 0);
    
    [self swapMenuToShowSlider:false];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.editor.imageView performSelectorOnMainThread:@selector(setImage:) withObject:_originalImage waitUntilDone:NO];
    });
}

- (void)refreshToolSettings
{
    for(UIView *sub in self.menuScrollView.subviews){ [sub removeFromSuperview]; }
    
    CGFloat x = 0;
    CGFloat W = 70;
    CGFloat H = self.menuScrollView.height;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        W   =   100;
    }
    
    NSUInteger toolCount = 0;
    CGFloat padding = 0;
    
    //for(ToolInfo *info in [self editingTools]){
    toolCount = [self editingTools].count;
    // }
    
    CGFloat diff = self.menuScrollView.frame.size.width - toolCount * W;
    if (0<diff && diff<2*W) {
        padding = diff/(toolCount+1);
    }
    
    for(ToolInfo *info in [self editingTools]){
        
        ToolBarItem *view = [ToolBarItem menuItemWithFrame:CGRectMake(x+padding, 0, W, H) target:self action:@selector(tappedMenuView:) toolInfo:info isIcon:true];
        [self.menuScrollView addSubview:view];
        x += W+padding;
    }

    self.menuScrollView.contentSize = CGSizeMake(x, 0);
    
    if (self.menuScrollView.contentSize.width < self.editor.menuScrollView.frame.size.width){
        self.menuScrollView.frame   =   CGRectMake(self.menuScrollView.frame.origin.x, self.menuScrollView.frame.origin.y, self.menuScrollView.contentSize.width, self.menuScrollView.frame.size.height);
        self.menuScrollView.center  =   self.editor.menuScrollView.center;
    }
}

-(void)tappedMenuView:(UITapGestureRecognizer *)gesture{
    ToolBarItem *view   =   (ToolBarItem *)gesture.view;
    self.currentTool    =   view.toolInfo;
    [self swapMenuToShowSlider:true];
}

-(void)swapMenuToShowSlider:(BOOL)showMenu{
    
    if(showMenu){
        lastScrolPoint  =   self.menuScrollView.contentOffset.x;
        
        [self initSliderView];
        
        [UIView animateWithDuration:kCLImageToolAnimationDuration animations:^{
            for(UIView *subView in self.menuScrollView.subviews){
                if ([subView isKindOfClass:[ToolBarItem class]]) {
                    subView.alpha  = 0.0;
                }
            }
        }];
        
        [UIView animateWithDuration:kCLImageToolAnimationDuration
                         animations:^{
                             _sliderView.frame  = CGRectMake(_sliderView.frame.origin.x, 0, _sliderView.frame.size.width, _sliderView.frame.size.height);
                         }
         ];
        
    }
    else{
        [UIView animateWithDuration:kCLImageToolAnimationDuration
                         animations:^{
                             for(UIView *subView in self.menuScrollView.subviews){
                                 subView.alpha  = 1.0;
                             }
                             [_sliderView removeFromSuperview];
                         }
         ];
        
        [UIView animateWithDuration:kCLImageToolAnimationDuration
                         animations:^{
                             _sliderView.frame  = CGRectMake(_sliderView.frame.origin.x, _sliderView.frame.size.height, _sliderView.frame.size.width, _sliderView.frame.size.height);
                         }
         ];
        
    }
}

-(NSArray *)editingTools{
    NSMutableArray *toolsArr        =   [NSMutableArray new];
    
    NSArray *tools                  =   [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Tools" ofType:@"plist"]];
    
    NSString *clasName              =   NSStringFromClass([self class]);
    
    NSArray *filteredTools          =   [tools filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(ToolName == %@)", clasName]];
    
    NSDictionary *currentToolInfo   =   [filteredTools firstObject];
    
    NSArray *subTools               =   [currentToolInfo objectForKey:@"subTools"];
    
    for(NSDictionary *tolDict in subTools){
        ToolInfo *tool              =   [[ToolInfo alloc]init];
        tool.toolId                 =   [tolDict objectForKey:@"ToolId"];
        tool.toolName               =   [tolDict objectForKey:@"ToolName"];
        tool.filterName             =   [tolDict objectForKey:@"FilterName"];
        tool.title                  =   [tolDict objectForKey:@"Title"];
        tool.iconImage              =   [UIImage imageNamed:[tolDict objectForKey:@"ToolIcon"]];
        tool.maxLimit               =   [[tolDict objectForKey:@"Max"] doubleValue];
        tool.minLimit               =   [[tolDict objectForKey:@"Min"] doubleValue];
        
        [toolsArr addObject:tool];
    }
    
    return toolsArr;
}

-(void)setUpTools{
    [self initMenuScrollView];
    [self refreshToolSettings];
}

@end

@interface CLBloomEffect : EffectSubTool
@end
@implementation CLBloomEffect

-(UIImage *)applyFilterOnImage:(UIImage *)image withValue:(double)value {
    CIImage *ciImage = [[CIImage alloc] initWithImage:image];
    CIFilter *filter = [CIFilter filterWithName:@"CIBloom" keysAndValues:kCIInputImageKey, ciImage, nil];
    
    //NSLog(@"%@", [filter attributes]);
    
    [filter setDefaults];
    
    CGFloat R = 0.5 * MIN(image.size.width, image.size.height) * 0.05;
    [filter setValue:[NSNumber numberWithFloat:R] forKey:@"inputRadius"];
    [filter setValue:[NSNumber numberWithFloat:value] forKey:@"inputIntensity"];
    
    CIContext *context = [CIContext contextWithOptions:@{kCIContextUseSoftwareRenderer : @(NO)}];
    CIImage *outputImage = [filter outputImage];
    CGImageRef cgImage = [context createCGImage:outputImage fromRect:[outputImage extent]];
    
    UIImage *result = [UIImage imageWithCGImage:cgImage];
    
    CGImageRelease(cgImage);
    
    CGFloat dW = (result.size.width - image.size.width)/2;
    CGFloat dH = (result.size.height - image.size.height)/2;
    
    CGRect rct = CGRectMake(dW, dH, image.size.width, image.size.height);
    
    return [result crop:rct];

}

@end


@interface CLGloomEffect : EffectSubTool
@end
@implementation CLGloomEffect

-(UIImage *)applyFilterOnImage:(UIImage *)image withValue:(double)value {
    CIImage *ciImage = [[CIImage alloc] initWithImage:image];
    CIFilter *filter = [CIFilter filterWithName:@"CIGloom" keysAndValues:kCIInputImageKey, ciImage, nil];
    
    //NSLog(@"%@", [filter attributes]);
    
    [filter setDefaults];
    
    CGFloat R = 0.5 * MIN(image.size.width, image.size.height) * 0.05;
    [filter setValue:[NSNumber numberWithFloat:R] forKey:@"inputRadius"];
    [filter setValue:[NSNumber numberWithFloat:value] forKey:@"inputIntensity"];
    
    CIContext *context = [CIContext contextWithOptions:@{kCIContextUseSoftwareRenderer : @(NO)}];
    CIImage *outputImage = [filter outputImage];
    CGImageRef cgImage = [context createCGImage:outputImage fromRect:[outputImage extent]];
    
    UIImage *result = [UIImage imageWithCGImage:cgImage];
    
    CGImageRelease(cgImage);
    
    CGFloat dW = (result.size.width - image.size.width)/2;
    CGFloat dH = (result.size.height - image.size.height)/2;
    
    CGRect rct = CGRectMake(dW, dH, image.size.width, image.size.height);
    
    return [result crop:rct];
    
}

@end

@interface CLHighlightShadowEffect : EffectSubTool
@end
@implementation CLHighlightShadowEffect

-(UIImage *)applyFilterOnImage:(UIImage *)image withValue:(double)value {
    CIImage *ciImage = [[CIImage alloc] initWithImage:image];
    CIFilter *filter = [CIFilter filterWithName:@"CIHighlightShadowAdjust" keysAndValues:kCIInputImageKey, ciImage, nil];
    
    //NSLog(@"%@", [filter attributes]);
    
    [filter setDefaults];
    //[filter setValue:[NSNumber numberWithFloat:_highlightSlider.value] forKey:@"inputHighlightAmount"];
    [filter setValue:[NSNumber numberWithFloat:value] forKey:@"inputShadowAmount"];
    //CGFloat R = MAX(image.size.width, image.size.height) * 0.02 * _radiusSlider.value;
    //[filter setValue:[NSNumber numberWithFloat:R] forKey:@"inputRadius"];
    
    CIContext *context = [CIContext contextWithOptions:@{kCIContextUseSoftwareRenderer : @(NO)}];
    CIImage *outputImage = [filter outputImage];
    CGImageRef cgImage = [context createCGImage:outputImage fromRect:[outputImage extent]];
    
    UIImage *result = [UIImage imageWithCGImage:cgImage];
    
    CGImageRelease(cgImage);
    
    return result;
    
}

@end

@interface CLHueEffect : EffectSubTool
@end
@implementation CLHueEffect

-(UIImage *)applyFilterOnImage:(UIImage *)image withValue:(double)value {
    CIImage *ciImage = [[CIImage alloc] initWithImage:image];
    CIFilter *filter = [CIFilter filterWithName:@"CIHueAdjust" keysAndValues:kCIInputImageKey, ciImage, nil];
    
    //NSLog(@"%@", [filter attributes]);
    
    [filter setDefaults];
    [filter setValue:[NSNumber numberWithFloat:value] forKey:@"inputAngle"];
    
    CIContext *context = [CIContext contextWithOptions:@{kCIContextUseSoftwareRenderer : @(NO)}];
    CIImage *outputImage = [filter outputImage];
    CGImageRef cgImage = [context createCGImage:outputImage fromRect:[outputImage extent]];
    
    UIImage *result = [UIImage imageWithCGImage:cgImage];
    
    CGImageRelease(cgImage);
    
    return result;
}

@end

@interface CLPixellateEffect : EffectSubTool
@end
@implementation CLPixellateEffect

-(UIImage *)applyFilterOnImage:(UIImage *)image withValue:(double)value {
    CIImage *ciImage = [[CIImage alloc] initWithImage:image];
    CIFilter *filter = [CIFilter filterWithName:@"CIPixellate" keysAndValues:kCIInputImageKey, ciImage, nil];
    
    //NSLog(@"%@", [filter attributes]);
    
    [filter setDefaults];
    
    CGFloat R = MIN(image.size.width, image.size.height) * 0.1 * value;
    CIVector *vct = [[CIVector alloc] initWithX:image.size.width/2 Y:image.size.height/2];
    [filter setValue:vct forKey:@"inputCenter"];
    [filter setValue:[NSNumber numberWithFloat:R] forKey:@"inputScale"];
    
    CIContext *context = [CIContext contextWithOptions:@{kCIContextUseSoftwareRenderer : @(NO)}];
    CIImage *outputImage = [filter outputImage];
    CGImageRef cgImage = [context createCGImage:outputImage fromRect:[outputImage extent]];
    
    CGRect clippingRect = [self clippingRectForTransparentSpace:cgImage];
    UIImage *result = [UIImage imageWithCGImage:cgImage];
    
    CGImageRelease(cgImage);
    
    return [result crop:clippingRect];
}

#pragma mark-

- (CGRect)clippingRectForTransparentSpace:(CGImageRef)inImage
{
    CGFloat left=0, right=0, top=0, bottom=0;
    
    CFDataRef m_DataRef = CGDataProviderCopyData(CGImageGetDataProvider(inImage));
    UInt8 * m_PixelBuf = (UInt8 *) CFDataGetBytePtr(m_DataRef);
    
    int width  = (int)CGImageGetWidth(inImage);
    int height = (int)CGImageGetHeight(inImage);
    
    BOOL breakOut = NO;
    for (int x = 0;breakOut==NO && x < width; ++x) {
        for (int y = 0; y < height; ++y) {
            int loc = x + (y * width);
            loc *= 4;
            if (m_PixelBuf[loc + 3] != 0) {
                left = x;
                breakOut = YES;
                break;
            }
        }
    }
    
    breakOut = NO;
    for (int y = 0;breakOut==NO && y < height; ++y) {
        for (int x = 0; x < width; ++x) {
            int loc = x + (y * width);
            loc *= 4;
            if (m_PixelBuf[loc + 3] != 0) {
                top = y;
                breakOut = YES;
                break;
            }
            
        }
    }
    
    breakOut = NO;
    for (int y = height-1;breakOut==NO && y >= 0; --y) {
        for (int x = width-1; x >= 0; --x) {
            int loc = x + (y * width);
            loc *= 4;
            if (m_PixelBuf[loc + 3] != 0) {
                bottom = y;
                breakOut = YES;
                break;
            }
            
        }
    }
    
    breakOut = NO;
    for (int x = width-1;breakOut==NO && x >= 0; --x) {
        for (int y = height-1; y >= 0; --y) {
            int loc = x + (y * width);
            loc *= 4;
            if (m_PixelBuf[loc + 3] != 0) {
                right = x;
                breakOut = YES;
                break;
            }
            
        }
    }
    
    CFRelease(m_DataRef);
    
    return CGRectMake(left, top, right-left, bottom-top);
}



@end

@interface CLPosterizeEffect : EffectSubTool
@end
@implementation CLPosterizeEffect

-(UIImage *)applyFilterOnImage:(UIImage *)image withValue:(double)value {
    CIImage *ciImage = [[CIImage alloc] initWithImage:image];
    CIFilter *filter = [CIFilter filterWithName:@"CIColorPosterize" keysAndValues:kCIInputImageKey, ciImage, nil];
    
    //NSLog(@"%@", [filter attributes]);
    
    [filter setDefaults];
    [filter setValue:[NSNumber numberWithFloat:-value] forKey:@"inputLevels"];
    
    CIContext *context = [CIContext contextWithOptions:@{kCIContextUseSoftwareRenderer : @(NO)}];
    CIImage *outputImage = [filter outputImage];
    CGImageRef cgImage = [context createCGImage:outputImage fromRect:[outputImage extent]];
    
    UIImage *result = [UIImage imageWithCGImage:cgImage];
    
    CGImageRelease(cgImage);
    
    return result;
}

@end



