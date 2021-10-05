//
//  ReflectionTool.m
//  BasicFilters
//
//  Created by Kanwarpal Singh on 07/08/17.
//  Copyright © 2017 Kanwarpal Singh. All rights reserved.
//

#import "ReflectionTool.h"
#import "UIImage+Utility.h"
#import "UIView+Frame.h"
#import "NYXImagesHelper.h"

@implementation ReflectionTool

- (void)setup
{
    [self updateImagePlaceHolderWithImage:self.editor.imageView.image];
    [self.editor fixZoomScaleWithAnimated:YES];
    
    [self setUpTools];
}

-(void)updateImagePlaceHolderWithImage:(UIImage *)image{
    _originalImage  =   image;
    tempImage       =   image;
    _thumbnailImage =   [_originalImage resize:self.editor.imageView.frame.size];
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

-(void)initSliderView{
    self.menuScrollView.contentOffset   =   CGPointZero;
    self.menuScrollView.scrollEnabled   =   false;
    
    _sliderView                 =   [[UIView alloc]initWithFrame:CGRectMake(0, self.menuScrollView.frame.size.height, self.menuScrollView.frame.size.width , self.menuScrollView.frame.size.height)];
    _sliderView.backgroundColor =   [UIColor whiteColor];
    [self.menuScrollView addSubview:_sliderView];
    
    _slider = [[UISlider alloc] initWithFrame:CGRectMake(70, (self.menuScrollView.frame.size.height - 40)/2, self.menuScrollView.frame.size.width - 140, 40)];
    _slider.tag             =   [self.currentTool.title  isEqual: @"Tranparency"] ? 0 : 1;
    _slider.continuous      =   NO;
    [_slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    CIFilter * filter = [CIFilter filterWithName:self.currentTool.filterName];
    
    NSLog(@"%@",filter.attributes);
    
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
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if([self.currentTool.title isEqualToString:@"Tranparency"]){
            self.transparencySliderValue    =   slider.value;
        }
        else{
            self.heightSliderValue          =   slider.value;
        }
        
        self.transparencySliderValue        =   self.transparencySliderValue == 0 ? 0.2 : self.transparencySliderValue;

        tempImage                           =   [_originalImage copy];
        
        tempImage                           =   [self imageWithReflectionWithScale:self.heightSliderValue onImage:tempImage gap:0 alpha:self.transparencySliderValue];
        self.editor.imageView.contentMode   =   UIViewContentModeScaleAspectFit;
        [self.editor.imageView performSelectorOnMainThread:@selector(setImage:) withObject:tempImage waitUntilDone:NO];
        
        inProgress = NO;
    });
}

-(void)crossButtonTapped{
    self.menuScrollView.scrollEnabled  = true;
    
    [self swapMenuToShowSlider:false];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.editor.imageView performSelectorOnMainThread:@selector(setImage:) withObject:_originalImage waitUntilDone:NO];
    });
}

-(void)okButtonTapped{
    //[self updateImagePlaceHolderWithImage:self.editor.imageView.image];
    
    self.menuScrollView.scrollEnabled  = true;
    
    [self swapMenuToShowSlider:false];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.editor.imageView performSelectorOnMainThread:@selector(setImage:) withObject:tempImage waitUntilDone:NO];
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
    
    toolCount = [self editingTools].count;
    
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
        [self initSliderView];
        
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
    NSMutableArray  *toolsArr       =   [NSMutableArray new];
    ToolInfo *tranparencyTool       =   [[ToolInfo alloc]init];
    tranparencyTool.toolId          =   @"Tranparency";
    tranparencyTool.toolName        =   @"Tranparency";
    tranparencyTool.filterName      =   @"Tranparency";
    tranparencyTool.title           =   @"Tranparency";
    tranparencyTool.iconImage       =   [UIImage imageNamed:@""];
    tranparencyTool.maxLimit        =   1;
    tranparencyTool.minLimit        =   0.1;

    ToolInfo *heightTool            =   [[ToolInfo alloc]init];
    heightTool.toolId               =   @"Height";
    heightTool.toolName             =   @"Height";
    heightTool.filterName           =   @"Height";
    heightTool.title                =   @"Height";
    heightTool.iconImage            =   [UIImage imageNamed:@""];
    heightTool.maxLimit             =   1;
    heightTool.minLimit             =   0.1;
    
    [toolsArr addObject:tranparencyTool];
    [toolsArr addObject:heightTool];

    return toolsArr;
}

-(void)setUpTools{
    [self initMenuScrollView];
    [self refreshToolSettings];
}

- (UIImage *)imageWithReflectionWithScale:(CGFloat)scale onImage:(UIImage *)image gap:(CGFloat)gap alpha:(CGFloat)alpha
{
    //get reflected image
    UIImage *reflection = [self reflectedImageWithScale:scale onImage:image];
    CGFloat reflectionOffset = reflection.size.height + gap;
    
    //create drawing context
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(image.size.width, image.size.height + reflectionOffset * 2.0f), NO, 0.0f);
    
    //draw reflection
    [reflection drawAtPoint:CGPointMake(0.0f, reflectionOffset + image.size.height + gap) blendMode:kCGBlendModeNormal alpha:alpha];
    
    //draw image
    [image drawAtPoint:CGPointMake(0.0f, reflectionOffset)];
    
    //capture resultant image
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //return image
    return image;
}

- (UIImage *)reflectedImageWithScale:(CGFloat)scale onImage:(UIImage *)image
{
    //get reflection dimensions
    CGFloat height = ceil(image.size.height * scale);
    CGSize size = CGSizeMake(image.size.width, height);
    CGRect bounds = CGRectMake(0.0f, 0.0f, size.width, size.height);
    
    //create drawing context
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //clip to gradient
    CGContextClipToMask(context, bounds, [self gradientMask]);
    
    //draw reflected image
    CGContextScaleCTM(context, 1.0f, -1.0f);
    CGContextTranslateCTM(context, 0.0f, -image.size.height);
    [image drawInRect:CGRectMake(0.0f, 0.0f, image.size.width, image.size.height)];
    
    //capture resultant image
    UIImage *reflection = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //return reflection image
    return reflection;
}

- (CGImageRef)gradientMask
{
    static CGImageRef sharedMask = NULL;
    if (sharedMask == NULL)
    {
        //create gradient mask
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(1, 256), YES, 0.0);
        CGContextRef gradientContext = UIGraphicsGetCurrentContext();
        CGFloat colors[] = {0.0, 1.0, 1.0, 1.0};
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
        CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, colors, NULL, 2);
        CGPoint gradientStartPoint = CGPointMake(0, 0);
        CGPoint gradientEndPoint = CGPointMake(0, 256);
        CGContextDrawLinearGradient(gradientContext, gradient, gradientStartPoint,
                                    gradientEndPoint, kCGGradientDrawsAfterEndLocation);
        sharedMask = CGBitmapContextCreateImage(gradientContext);
        CGGradientRelease(gradient);
        CGColorSpaceRelease(colorSpace);
        UIGraphicsEndImageContext();
    }
    return sharedMask;
}


@end



