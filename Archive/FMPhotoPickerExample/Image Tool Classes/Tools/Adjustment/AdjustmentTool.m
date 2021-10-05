//
//  AdjustmentTool.m
//  BasicFilters
//
//  Created by Kanwarpal Singh on 04/08/17.
//  Copyright © 2017 Kanwarpal Singh. All rights reserved.
//

#import "AdjustmentTool.h"
#import "UIView+Frame.h"

@implementation AdjustmentTool

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
    [self updateImagePlaceHolderWithImage:self.editor.imageView.image];
    [self.editor fixZoomScaleWithAnimated:YES];
    
    [self setUpTools];
    
    [UIView animateWithDuration:kCLImageToolAnimationDuration
                     animations:^{
                         self.menuScrollView.transform = CGAffineTransformIdentity;
                     }
                     completion:^(BOOL finished) {
                     }];
}

-(void)updateImagePlaceHolderWithImage:(UIImage *)image{
    _originalImage  = image;
}

- (void)initMenuScrollView
{
    if(self.menuScrollView==nil){
        UIScrollView *menuScroll    =   [[UIScrollView alloc] initWithFrame:self.editor.menuScrollView.frame];
        menuScroll.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        menuScroll.showsHorizontalScrollIndicator   =   NO;
        menuScroll.showsVerticalScrollIndicator     =   NO;
        
        [self.editor.view addSubview:menuScroll];
        self.menuScrollView =   menuScroll;
    }
    
    self.menuScrollView.backgroundColor =   self.editor.barColor;
    
    self.menuScrollView.transform       =   CGAffineTransformMakeTranslation(0, self.editor.view.height - self.menuScrollView.top);
    [UIView animateWithDuration:kCLImageToolAnimationDuration
                     animations:^{
                         self.menuScrollView.transform = CGAffineTransformIdentity;
                     }];
}

-(void)initSliderView{
    
    _sliderView                 =   [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.menuScrollView.frame.size.width , self.menuScrollView.frame.size.height)];
    _sliderView.backgroundColor =   self.editor.barColor;
    [self.editor.view addSubview:_sliderView];
    
    _slider = [[UISlider alloc] initWithFrame:CGRectMake(10, (self.menuScrollView.frame.size.height - 40)/2, self.menuScrollView.frame.size.width - 20, 40)];
    [_slider setThumbImage:[UIImage imageNamed:@"slider"] forState:UIControlStateNormal];
    
    [_slider setMinimumTrackTintColor:[UIColor whiteColor]];
    [_slider setMaximumTrackTintColor:[UIColor whiteColor]];
    _slider.continuous          =   NO;
    [_slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    _slider.maximumValue        =   self.currentTool.maxLimit;
    _slider.minimumValue        =   self.currentTool.minLimit;
    _slider.value               =   self.currentTool.maxLimit/2;
    
    [_sliderView addSubview:_slider];

    UINavigationItem *item  =   [[UINavigationItem alloc] initWithTitle:self.currentTool.title];
    item.rightBarButtonItem =   [self buttonWithImageName:[CLImageEditorTheme localizedString:@"CLImageEditor_OKBtnTitle" withDefault:@"OK"] selector:@selector(okButtonTapped)];
    item.leftBarButtonItem  =   [self buttonWithImageName:[CLImageEditorTheme localizedString:@"CLImageEditor_BackBtnTitle" withDefault:@"Back"] selector:@selector(crossButtonTapped)];

    [self.editor.navigationBar pushNavigationItem:item animated:true];
}

-(void)sliderValueChanged:(UISlider *)slider{
    if(!self.currentTool){
        return;
    }

    static BOOL inProgress = NO;
    
    if(inProgress){ return; }
    inProgress = YES;
    
    Class toolClass = NSClassFromString(self.currentTool.toolName);
    float sliderValue   =   slider.value;
    if(toolClass){
        id instance = [toolClass alloc];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            if(instance!=nil && [instance isKindOfClass:[AdjustmentSubTool class]]){
                
                UIImage *image      =   [instance applyFilterOnImage:_originalImage withValue:sliderValue];
                
               // image           =   [UIImage drawImage:image inRect:CGRectMake(0, 0, image.size.width, image.size.height)];

                [self.editor.imageView performSelectorOnMainThread:@selector(setImage:) withObject:image waitUntilDone:NO];
                inProgress = NO;
            }
        });
    }
}

-(void)crossButtonTapped{
    [self.editor.navigationBar popNavigationItemAnimated:YES];

    self.menuScrollView.scrollEnabled   =   true;

    [self swapMenuToShowSlider:false];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [self.editor.imageView performSelectorOnMainThread:@selector(setImage:) withObject:_originalImage waitUntilDone:NO];
    });
}

-(void)okButtonTapped{
    [self.editor.navigationBar popNavigationItemAnimated:YES];

    [self updateImagePlaceHolderWithImage:self.editor.imageView.image];

    self.menuScrollView.scrollEnabled   =   true;

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
    [self initSliderView];

    [self swapMenuToShowSlider:true];
}

-(void)swapMenuToShowSlider:(BOOL)showMenu{
    if(showMenu){
        
        [UIView animateWithDuration:kCLImageToolAnimationDuration animations:^{
            for(UIView *subView in self.menuScrollView.subviews){
                if ([subView isKindOfClass:[ToolBarItem class]]) {
                    subView.alpha  = 0.0;
                }
            }
        }];
        
        _sliderView.frame  = CGRectMake(_sliderView.frame.origin.x, self.menuScrollView.top + _sliderView.frame.size.height, _sliderView.frame.size.width, _sliderView.frame.size.height);
        
        [UIView animateWithDuration:kCLImageToolAnimationDuration
                         animations:^{
                             _sliderView.frame  = CGRectMake(_sliderView.frame.origin.x, self.menuScrollView.top, _sliderView.frame.size.width, _sliderView.frame.size.height);
                         }
         ];
    }
    else{
        [UIView animateWithDuration:kCLImageToolAnimationDuration
                         animations:^{
                             for(UIView *subView in self.menuScrollView.subviews){
                                 subView.alpha  = 1.0;
                             }
                         }
         ];
        
        [UIView animateWithDuration:kCLImageToolAnimationDuration
                         animations:^{
                             _sliderView.frame  = CGRectMake(_sliderView.frame.origin.x, self.menuScrollView.top + _sliderView.frame.size.height, _sliderView.frame.size.width, _sliderView.frame.size.height);
                         } completion:^(BOOL finished) {
                             [_sliderView removeFromSuperview];
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

- (void)cleanup
{
    [self.editor resetZoomScaleWithAnimated:YES];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [_menuScrollView removeFromSuperview];
    
    [UIView animateWithDuration:kCLImageToolAnimationDuration
                     animations:^{
                         _menuScrollView.transform = CGAffineTransformMakeTranslation(0, self.editor.view.height-_menuScrollView.top);
                     }
                     completion:^(BOOL finished) {
                         [_menuScrollView removeFromSuperview];
                     }];
}

- (void)executeWithCompletionBlock:(void(^)(UIImage *image, NSError *error, NSDictionary *userInfo))completionBlock
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIImage *image  =   self.editor.imageView.image;
        image           =   [UIImage drawImage:image inRect:CGRectMake(0, 0, image.size.width, image.size.height)];

        completionBlock(image, nil, nil);
    });
}

@end

@interface BrightnessTool : AdjustmentSubTool
@end
@implementation BrightnessTool

-(UIImage *)applyFilterOnImage:(UIImage *)origionalImage withValue:(double)value {
    CIImage *ciImage = [[CIImage alloc] initWithImage:origionalImage];
    
    CIFilter * filter = [CIFilter filterWithName:@"CIColorControls" keysAndValues:kCIInputImageKey, ciImage, nil];
    [filter setDefaults];
    CGFloat brightness = value;
    
    [filter setValue:@(brightness) forKey:@"inputBrightness"];
    
    CIContext *context      =   [CIContext contextWithOptions:@{kCIContextUseSoftwareRenderer : @(NO)}];
    CIImage *outputImage    =   [filter outputImage];
    CGImageRef cgImage      =   [context createCGImage:outputImage fromRect:[outputImage extent]];
    
    UIImage *result         =   [UIImage imageWithCGImage:cgImage];
    
    CGImageRelease(cgImage);
    
    return result;
}

@end

@interface ExposureTool : AdjustmentSubTool
@end
@implementation ExposureTool

-(UIImage *)applyFilterOnImage:(UIImage *)origionalImage withValue:(double)value {
    CIImage *ciImage = [[CIImage alloc] initWithImage:origionalImage];
    
    CIFilter * filter = [CIFilter filterWithName:@"CIExposureAdjust" keysAndValues:kCIInputImageKey, ciImage, nil];
    [filter setDefaults];
    
    CGFloat exposure = value;
    
    [filter setValue:@(exposure) forKey:@"inputEV"];
    
    CIContext *context = [CIContext contextWithOptions:@{kCIContextUseSoftwareRenderer : @(NO)}];
    CIImage *outputImage = [filter outputImage];
    CGImageRef cgImage = [context createCGImage:outputImage fromRect:[outputImage extent]];
    
    UIImage *result = [UIImage imageWithCGImage:cgImage];
    
    CGImageRelease(cgImage);
    
    return result;
}

@end

@interface ContrastTool : AdjustmentSubTool
@end
@implementation ContrastTool

-(UIImage *)applyFilterOnImage:(UIImage *)origionalImage withValue:(double)value {
    CIImage *ciImage = [[CIImage alloc] initWithImage:origionalImage];
    
    CIFilter * filter = [CIFilter filterWithName:@"CIColorControls" keysAndValues:kCIInputImageKey, ciImage, nil];
    [filter setDefaults];
    CGFloat contrast = value;
    
    [filter setValue:@(contrast) forKey:@"inputContrast"];
    
    CIContext *context = [CIContext contextWithOptions:@{kCIContextUseSoftwareRenderer : @(NO)}];
    CIImage *outputImage = [filter outputImage];
    CGImageRef cgImage = [context createCGImage:outputImage fromRect:[outputImage extent]];
    
    UIImage *result = [UIImage imageWithCGImage:cgImage];
    
    CGImageRelease(cgImage);
    
    return result;
}

@end

@interface WarmthTool : AdjustmentSubTool
@end
@implementation WarmthTool
@end

@interface SaturationTool : AdjustmentSubTool
@end
@implementation SaturationTool

-(UIImage *)applyFilterOnImage:(UIImage *)origionalImage withValue:(double)value {
    CIImage *ciImage = [[CIImage alloc] initWithImage:origionalImage];
    
    CIFilter * filter = [CIFilter filterWithName:@"CIColorControls" keysAndValues:kCIInputImageKey, ciImage, nil];
    [filter setDefaults];
    CGFloat saturation = value;
    
    [filter setValue:@(saturation) forKey:@"inputSaturation"];
    
    CIContext *context = [CIContext contextWithOptions:@{kCIContextUseSoftwareRenderer : @(NO)}];
    CIImage *outputImage = [filter outputImage];
    CGImageRef cgImage = [context createCGImage:outputImage fromRect:[outputImage extent]];
    
    UIImage *result = [UIImage imageWithCGImage:cgImage];
    
    CGImageRelease(cgImage);
    
    return result;
}

@end

@interface VibranceTool : AdjustmentSubTool
@end
@implementation VibranceTool

-(UIImage *)applyFilterOnImage:(UIImage *)origionalImage withValue:(double)value {
    CIImage *ciImage = [[CIImage alloc] initWithImage:origionalImage];
    
    CIFilter * filter = [CIFilter filterWithName:@"CIVibrance" keysAndValues:kCIInputImageKey, ciImage, nil];
    [filter setDefaults];
    CGFloat vibrance = value;
    
    [filter setValue:@(vibrance) forKey:@"inputAmount"];
    
    CIContext *context = [CIContext contextWithOptions:@{kCIContextUseSoftwareRenderer : @(NO)}];
    CIImage *outputImage = [filter outputImage];
    CGImageRef cgImage = [context createCGImage:outputImage fromRect:[outputImage extent]];
    
    UIImage *result = [UIImage imageWithCGImage:cgImage];
    
    CGImageRelease(cgImage);
    
    return result;
}

@end

@interface HighlightTool : AdjustmentSubTool
@end
@implementation HighlightTool

-(UIImage *)applyFilterOnImage:(UIImage *)origionalImage withValue:(double)value {
    CIImage *ciImage = [[CIImage alloc] initWithImage:origionalImage];
    
    CIFilter * filter = [CIFilter filterWithName:@"CIHighlightShadowAdjust" keysAndValues:kCIInputImageKey, ciImage, nil];
    [filter setDefaults];
    CGFloat highlightAmount = value;
    
    [filter setValue:@(highlightAmount) forKey:@"inputHighlightAmount"];
    [filter setValue:@(5) forKey:@"inputRadius"];

    CIContext *context = [CIContext contextWithOptions:@{kCIContextUseSoftwareRenderer : @(NO)}];
    CIImage *outputImage = [filter outputImage];
    CGImageRef cgImage = [context createCGImage:outputImage fromRect:[outputImage extent]];
    
    UIImage *result = [UIImage imageWithCGImage:cgImage];
    
    CGImageRelease(cgImage);
    
    return result;
}

@end

@interface ShadowsTool : AdjustmentSubTool
@end
@implementation ShadowsTool

-(UIImage *)applyFilterOnImage:(UIImage *)origionalImage withValue:(double)value {
    CIImage *ciImage = [[CIImage alloc] initWithImage:origionalImage];
    
    CIFilter * filter = [CIFilter filterWithName:@"CIHighlightShadowAdjust" keysAndValues:kCIInputImageKey, ciImage, nil];
    [filter setDefaults];
    CGFloat shadowAmount = value;
    
    [filter setValue:@(shadowAmount) forKey:@"inputShadowAmount"];
    [filter setValue:@(5) forKey:@"inputRadius"];

    CIContext *context = [CIContext contextWithOptions:@{kCIContextUseSoftwareRenderer : @(NO)}];
    CIImage *outputImage = [filter outputImage];
    CGImageRef cgImage = [context createCGImage:outputImage fromRect:[outputImage extent]];
    
    UIImage *result = [UIImage imageWithCGImage:cgImage];
    
    CGImageRelease(cgImage);
    
    return result;
}

@end

@interface TintTool : AdjustmentSubTool
@end
@implementation TintTool

-(UIImage *)applyFilterOnImage:(UIImage *)origionalImage withValue:(double)value {
    CIImage *ciImage        =   [[CIImage alloc] initWithImage:origionalImage];
    
    CIFilter * filter       =   [CIFilter filterWithName:@"CIMultiplyCompositing"];

    CIFilter * colorFilter  =   [CIFilter filterWithName:@"CIConstantColorGenerator"];

    UIColor *randomColor    =   [UIColor colorWithRed:value/255.0 green:255-value/255.0 blue:100/255.0 alpha:1.0];
    CIColor *color = [CIColor colorWithCGColor:[randomColor CGColor]];
    [colorFilter setValue:color forKey:kCIInputColorKey];
    
    CIImage *colorOutputImage = [colorFilter outputImage];
    
    [filter setValue:colorOutputImage forKey:kCIInputImageKey];
    [filter setValue:ciImage forKey:kCIInputBackgroundImageKey];

    CIContext *context = [CIContext contextWithOptions:@{kCIContextUseSoftwareRenderer : @(NO)}];
    CIImage *outputImage = [filter outputImage];
    CGImageRef cgImage = [context createCGImage:outputImage fromRect:[outputImage extent]];
    
    UIImage *result = [UIImage imageWithCGImage:cgImage];
    
    CGImageRelease(cgImage);
    
    return result;
}

@end

@interface GamaTool : AdjustmentSubTool
@end
@implementation GamaTool

-(UIImage *)applyFilterOnImage:(UIImage *)origionalImage withValue:(double)value {
    CIImage *ciImage = [[CIImage alloc] initWithImage:origionalImage];
    
    CIFilter * filter = [CIFilter filterWithName:@"CIGammaAdjust" keysAndValues:kCIInputImageKey, ciImage, nil];
    [filter setDefaults];
    CGFloat power = value;
    
    [filter setValue:@(power) forKey:@"inputPower"];
    
    CIContext *context = [CIContext contextWithOptions:@{kCIContextUseSoftwareRenderer : @(NO)}];
    CIImage *outputImage = [filter outputImage];
    CGImageRef cgImage = [context createCGImage:outputImage fromRect:[outputImage extent]];
    
    UIImage *result = [UIImage imageWithCGImage:cgImage];
    
    CGImageRelease(cgImage);
    
    return result;
}

@end

@interface HueTool : AdjustmentSubTool
@end
@implementation HueTool

-(UIImage *)applyFilterOnImage:(UIImage *)origionalImage withValue:(double)value {
    CIImage *ciImage = [[CIImage alloc] initWithImage:origionalImage];
    
    CIFilter * filter = [CIFilter filterWithName:@"CIHueAdjust" keysAndValues:kCIInputImageKey, ciImage, nil];
    [filter setDefaults];
    CGFloat angle = value;
    
    [filter setValue:@(angle) forKey:@"inputAngle"];
    
    CIContext *context = [CIContext contextWithOptions:@{kCIContextUseSoftwareRenderer : @(NO)}];
    CIImage *outputImage = [filter outputImage];
    CGImageRef cgImage = [context createCGImage:outputImage fromRect:[outputImage extent]];
    
    UIImage *result = [UIImage imageWithCGImage:cgImage];
    
    CGImageRelease(cgImage);
    
    return result;
}

@end


@interface MonochromeTool : AdjustmentSubTool
@end
@implementation MonochromeTool

-(UIImage *)applyFilterOnImage:(UIImage *)origionalImage withValue:(double)value {
    CIImage *ciImage = [[CIImage alloc] initWithImage:origionalImage];
    
    CIFilter * filter       =   [CIFilter filterWithName:@"CIColorMonochrome" keysAndValues:kCIInputImageKey, ciImage, nil];
    [filter setDefaults];
    
    UIColor *randomColor    =   [UIColor colorWithRed:value/255.0 green:255-value/255.0 blue:100/255.0 alpha:1.0];
    CIColor *color          =   [CIColor colorWithCGColor:[randomColor CGColor]];
    
    [filter setValue:color forKey:@"inputColor"];
    [filter setValue:@(value) forKey:@"inputIntensity"];

    CIContext *context      =   [CIContext contextWithOptions:@{kCIContextUseSoftwareRenderer : @(NO)}];
    CIImage *outputImage    =   [filter outputImage];
    CGImageRef cgImage      =   [context createCGImage:outputImage fromRect:[outputImage extent]];
    
    UIImage *result         =   [UIImage imageWithCGImage:cgImage];
    
    CGImageRelease(cgImage);
    
    return result;
}


@end


@interface PosterizeTool : AdjustmentSubTool
@end
@implementation PosterizeTool

-(UIImage *)applyFilterOnImage:(UIImage *)origionalImage withValue:(double)value {
    CIImage *ciImage = [[CIImage alloc] initWithImage:origionalImage];
    
    CIFilter * filter       =   [CIFilter filterWithName:@"CIColorPosterize" keysAndValues:kCIInputImageKey, ciImage, nil];
    [filter setDefaults];
        
    [filter setValue:@(value) forKey:@"inputLevels"];
    
    CIContext *context      =   [CIContext contextWithOptions:@{kCIContextUseSoftwareRenderer : @(NO)}];
    CIImage *outputImage    =   [filter outputImage];
    CGImageRef cgImage      =   [context createCGImage:outputImage fromRect:[outputImage extent]];
    
    UIImage *result         =   [UIImage imageWithCGImage:cgImage];
    
    CGImageRelease(cgImage);
    
    return result;
}

@end

