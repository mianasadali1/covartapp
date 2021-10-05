//
//  BumpTool.m
//  BasicFilters
//
//  Created by Kanwarpal Singh on 04/08/17.
//  Copyright © 2017 Kanwarpal Singh. All rights reserved.
//

#import "DistortionTool.h"
#import "DistortionSubTool.h"
#import "UIView+Frame.h"

@implementation DistortionTool

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
    
    _handlerView = [[UIView alloc] initWithFrame:self.editor.imageView.frame];
    [self.editor.imageView.superview addSubview:_handlerView];
    [self setHandlerView];
    [self setUpTools];
    centerPoint = CGPointMake(self.editor.imageView.image.size.width/2, self.editor.imageView.image.size.height/2);
}

- (void)setHandlerView
{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandlerView:)];
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panHandlerView:)];
    
    panGesture.maximumNumberOfTouches = 1;
    
    [_handlerView addGestureRecognizer:tapGesture];
    [_handlerView addGestureRecognizer:panGesture];
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
    self.menuScrollView.backgroundColor = [UIColor whiteColor];
}

-(void)initSliderView:(NSString *)navigationText{
    self.menuScrollView.contentOffset   =   CGPointZero;
    
    self.menuScrollView.scrollEnabled   =   false;
    
    _sliderView                         =   [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.menuScrollView.frame.size.width , self.menuScrollView.frame.size.height)];
    _sliderView.backgroundColor =   [UIColor whiteColor];
    [self.menuScrollView addSubview:_sliderView];
    
    _slider1 = [[UISlider alloc] initWithFrame:CGRectMake(10, (self.menuScrollView.frame.size.height - 40)/2, self.menuScrollView.frame.size.width - 20, 40)];
    
    _slider1.continuous          =   NO;
    [_slider1 addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    _slider1.maximumValue        =   self.currentTool.maxLimit;
    _slider1.minimumValue        =   self.currentTool.minLimit;
    _slider1.value               =   self.currentTool.maxLimit/2;
    
    [_sliderView addSubview:_slider1];
    
    UINavigationItem *item  = [[UINavigationItem alloc] initWithTitle:navigationText];
    item.leftBarButtonItem  =  [self buttonWithImageName:[CLImageEditorTheme localizedString:@"CLImageEditor_BackBtnTitle" withDefault:@"Back"] selector:@selector(crossButtonTapped)];

    item.rightBarButtonItem  =  [self buttonWithImageName:[CLImageEditorTheme localizedString:@"CLImageEditor_OKBtnTitle" withDefault:@"OK"] selector:@selector(okButtonTapped)];

    [self.editor.navigationBar pushNavigationItem:item animated:true];
    
    [self.menuScrollView addSubview:_sliderView];
}

-(void)sliderValueChanged:(UISlider *)slider{
    [self buildImage];
}

- (void)executeWithCompletionBlock:(void(^)(UIImage *image, NSError *error, NSDictionary *userInfo))completionBlock
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        UIImage *image  =   self.editor.imageView.image;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock(image, nil, nil);
        });
    });
}

-(void)buildImage{
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
            if(instance!=nil && [instance isKindOfClass:[DistortionSubTool class]]){
                UIImage *image = [instance applyFilterOnImage:_originalImage withValue:_slider1.value withCenter:centerPoint withRadius:0];
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
    
    [self initSliderView:view.titleLabel.text];

    [self swapMenuToShowSlider:true];
}

-(void)swapMenuToShowSlider:(BOOL)showMenu{
    
    if(showMenu){
        lastScrolPoint  =   self.menuScrollView.contentOffset.x;
        
        [UIView animateWithDuration:kCLImageToolAnimationDuration animations:^{
            for(UIView *subView in self.menuScrollView.subviews){
                if ([subView isKindOfClass:[ToolBarItem class]]) {
                    subView.alpha  = 0.0;
                }
            }
        }];
        
        _sliderView.frame  = CGRectMake(_sliderView.frame.origin.x, _sliderView.frame.size.height, _sliderView.frame.size.width, _sliderView.frame.size.height);
        
        [UIView animateWithDuration:kCLImageToolAnimationDuration
                         animations:^{
                             _sliderView.frame  = CGRectMake(_sliderView.frame.origin.x, 0, _sliderView.frame.size.width, _sliderView.frame.size.height);
                         }
         ];
        
    }
    else{
        [self.editor.navigationBar popNavigationItemAnimated:YES];

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

- (void)tapHandlerView:(UITapGestureRecognizer*)sender
{
   // centerPoint = [sender locationInView:_handlerView];
    [self buildImage];
}

- (void)panHandlerView:(UIPanGestureRecognizer*)sender
{
    //centerPoint = [sender locationInView:_handlerView];
    [self buildImage];
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


@end


@interface ConvexTool : DistortionSubTool
@end
@implementation ConvexTool

-(UIImage *)applyFilterOnImage:(UIImage *)origionalImage withValue:(double)value withCenter:(CGPoint)center withRadius:(double)radius{
    CIImage *ciImage        =   [[CIImage alloc] initWithImage:origionalImage];
    
    CIFilter * filter       =   [CIFilter filterWithName:@"CIBumpDistortion" keysAndValues:kCIInputImageKey, ciImage, nil];
    [filter setDefaults];
    
    [filter setValue:ciImage forKey:@"inputImage"];
    [filter setValue:[CIVector vectorWithX:center.x  Y:center.y]  forKey:@"inputCenter"];
   // [filter setValue:@(300)  forKey:@"inputRadius"];

    [filter setValue:@(value) forKey:@"inputScale"];
    
    CIContext *context      =   [CIContext contextWithOptions:@{kCIContextUseSoftwareRenderer : @(NO)}];
    CIImage *outputImage    =   [filter outputImage];
    CGImageRef cgImage      =   [context createCGImage:outputImage fromRect:[outputImage extent]];
    
    UIImage *result         =   [UIImage imageWithCGImage:cgImage];
    
    CGImageRelease(cgImage);
    
    return result;
}


@end

@interface LightTunnelTool : DistortionSubTool
@end
@implementation LightTunnelTool

-(UIImage *)applyFilterOnImage:(UIImage *)origionalImage withValue:(double)value withCenter:(CGPoint)center withRadius:(double)radius{
    CIImage *ciImage        =   [[CIImage alloc] initWithImage:origionalImage];
    
    CIFilter * filter       =   [CIFilter filterWithName:@"CILightTunnel" keysAndValues:kCIInputImageKey, ciImage, nil];
    [filter setDefaults];
    
    [filter setValue:ciImage forKey:@"inputImage"];
    [filter setValue:[CIVector vectorWithX:center.x  Y:center.y]  forKey:@"inputCenter"];
    [filter setValue:@(0.1) forKey:@"inputRotation"];

   // [filter setValue:@(0.1) forKey:@"inputRadius"];
    
    CIContext *context      =   [CIContext contextWithOptions:@{kCIContextUseSoftwareRenderer : @(NO)}];
    CIImage *outputImage    =   [filter outputImage];
    CGImageRef cgImage      =   [context createCGImage:outputImage fromRect:[outputImage extent]];
    
    UIImage *result         =   [UIImage imageWithCGImage:cgImage];
    
    CGImageRelease(cgImage);
    
    return result;
}


@end

@interface GlassTool : DistortionSubTool
@end
@implementation GlassTool

-(UIImage *)applyFilterOnImage:(UIImage *)origionalImage withValue:(double)value withCenter:(CGPoint)center withRadius:(double)radius{
    CIImage *ciImage        =   [[CIImage alloc] initWithImage:origionalImage];
    CIImage *glassImage     =   [[CIImage alloc] initWithImage:[UIImage imageNamed:@"glass.jpeg"]];

    CIFilter * filter       =   [CIFilter filterWithName:@"CIGlassDistortion" keysAndValues:kCIInputImageKey, ciImage, nil];
    [filter setDefaults];
    
    [filter setValue:ciImage forKey:@"inputImage"];
    [filter setValue:glassImage forKey:@"inputTexture"];
   // [filter setValue:[CIVector vectorWithX:center.x  Y:center.y]  forKey:@"inputCenter"];

    [filter setValue:@(value) forKey:@"inputScale"];

    CIContext *context      =   [CIContext contextWithOptions:@{kCIContextUseSoftwareRenderer : @(NO)}];
    CIImage *outputImage    =   [filter outputImage];
    CGImageRef cgImage      =   [context createCGImage:outputImage fromRect:[outputImage extent]];
    
    UIImage *result         =   [UIImage imageWithCGImage:cgImage];
    
    CGImageRelease(cgImage);
    
    return result;
}

@end

@interface HoleDistortionTool : DistortionSubTool
@end
@implementation HoleDistortionTool

-(UIImage *)applyFilterOnImage:(UIImage *)origionalImage withValue:(double)value withCenter:(CGPoint)center withRadius:(double)radius{
    CIImage *ciImage        =   [[CIImage alloc] initWithImage:origionalImage];
    
    CIFilter * filter       =   [CIFilter filterWithName:@"CIHoleDistortion" keysAndValues:kCIInputImageKey, ciImage, nil];
    [filter setDefaults];
    
    [filter setValue:ciImage forKey:@"inputImage"];
    [filter setValue:[CIVector vectorWithX:center.x  Y:center.y]  forKey:@"inputCenter"];
   // [filter setValue:@(0.1) forKey:@"inputRotation"];
    
   // [filter setValue:@(20) forKey:@"inputRadius"];
    
    CIContext *context      =   [CIContext contextWithOptions:@{kCIContextUseSoftwareRenderer : @(NO)}];
    CIImage *outputImage    =   [filter outputImage];
    CGImageRef cgImage      =   [context createCGImage:outputImage fromRect:[outputImage extent]];
    
    UIImage *result         =   [UIImage imageWithCGImage:cgImage];
    
    CGImageRelease(cgImage);
    
    return result;
}


@end

@interface PinchDistortionTool : DistortionSubTool
@end
@implementation PinchDistortionTool

-(UIImage *)applyFilterOnImage:(UIImage *)origionalImage withValue:(double)value withCenter:(CGPoint)center withRadius:(double)radius{
    CIImage *ciImage        =   [[CIImage alloc] initWithImage:origionalImage];
    
    
    CIFilter * filter       =   [CIFilter filterWithName:@"CIPinchDistortion" keysAndValues:kCIInputImageKey, ciImage, nil];
    [filter setDefaults];
    
    [filter setValue:ciImage forKey:@"inputImage"];
    [filter setValue:[CIVector vectorWithX:center.x  Y:center.y]  forKey:@"inputCenter"];
    // [filter setValue:@(0.1) forKey:@"inputRotation"];
    
   // [filter setValue:@(500) forKey:@"inputRadius"];
    [filter setValue:@(value) forKey:@"inputScale"];

    CIContext *context      =   [CIContext contextWithOptions:@{kCIContextUseSoftwareRenderer : @(NO)}];
    CIImage *outputImage    =   [filter outputImage];
    CGImageRef cgImage      =   [context createCGImage:outputImage fromRect:[outputImage extent]];
    
    UIImage *result         =   [UIImage imageWithCGImage:cgImage];
    
    CGImageRelease(cgImage);
    
    return result;
}


@end

@interface TwirlDistortionTool : DistortionSubTool
@end
@implementation TwirlDistortionTool

-(UIImage *)applyFilterOnImage:(UIImage *)origionalImage withValue:(double)value withCenter:(CGPoint)center withRadius:(double)radius{
    CIImage *ciImage        =   [[CIImage alloc] initWithImage:origionalImage];
    
    CIFilter * filter       =   [CIFilter filterWithName:@"CITwirlDistortion" keysAndValues:kCIInputImageKey, ciImage, nil];
    [filter setDefaults];
    
    [filter setValue:ciImage forKey:@"inputImage"];
    [filter setValue:[CIVector vectorWithX:center.x  Y:center.y]  forKey:@"inputCenter"];
    [filter setValue:@(value) forKey:@"inputAngle"];
    
    //[filter setValue:@(250) forKey:@"inputRadius"];
    
    CIContext *context      =   [CIContext contextWithOptions:@{kCIContextUseSoftwareRenderer : @(NO)}];
    CIImage *outputImage    =   [filter outputImage];
    CGImageRef cgImage      =   [context createCGImage:outputImage fromRect:[outputImage extent]];
    
    UIImage *result         =   [UIImage imageWithCGImage:cgImage];
    
    CGImageRelease(cgImage);
    
    return result;
}

@end

@interface VortexDistortionTool : DistortionSubTool
@end
@implementation VortexDistortionTool

-(UIImage *)applyFilterOnImage:(UIImage *)origionalImage withValue:(double)value withCenter:(CGPoint)center withRadius:(double)radius{
    CIImage *ciImage        =   [[CIImage alloc] initWithImage:origionalImage];
    
    CIFilter * filter       =   [CIFilter filterWithName:@"CIVortexDistortion" keysAndValues:kCIInputImageKey, ciImage, nil];
    [filter setDefaults];
    
    [filter setValue:ciImage forKey:@"inputImage"];
    [filter setValue:[CIVector vectorWithX:center.x  Y:center.y]  forKey:@"inputCenter"];
    [filter setValue:@(value) forKey:@"inputAngle"];
    
    [filter setValue:@(800) forKey:@"inputRadius"];
    
    CIContext *context      =   [CIContext contextWithOptions:@{kCIContextUseSoftwareRenderer : @(NO)}];
    CIImage *outputImage    =   [filter outputImage];
    CGImageRef cgImage      =   [context createCGImage:outputImage fromRect:[outputImage extent]];
    
    UIImage *result         =   [UIImage imageWithCGImage:cgImage];
    
    CGImageRelease(cgImage);
    
    return result;
}

@end
