//
//  EffectsTool.m
//  BasicFilters
//
//  Created by Kanwar on 2/1/18.
//  Copyright © 2018 Kanwarpal Singh. All rights reserved.
//

#import "FiltersTool.h"
#import "PatternTool.h"
#import "SelectorsList.h"
#import "UIImage+Utility.h"
#import "UIView+Frame.h"
#import "ToolBarItem.h"
#import "UIView+Toast.h"

static NSString* const kCLBlurToolNormalIconName1 = @"nonrmalIconAssetsName";
static NSString* const kCLBlurToolCircleIconName1 = @"circleIconAssetsName";
static NSString* const kCLBlurToolBandIconName1 = @"bandIconAssetsName";

@interface FiltersTool()<UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIView *selectedMenu;
@end

@implementation FiltersTool
{
    UIImage *_originalImage;
    UIImage *_smallThumbnailImage;

    UIImage *_thumbnailImage;
    UIImage *_patternImage;
    UIImage *_patternThumbnailImage;
    UIImage *_lastPatternImage;
    
    UISlider *_alphaSlider;
    
    UIScrollView *_menuScroll;
    UIScrollView *_subMenuScroll;
    
    UIView *_containerView;
    
    UIView *_handlerView;
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
             kCLBlurToolNormalIconName1 : @"",
             kCLBlurToolCircleIconName1 : @"",
             kCLBlurToolBandIconName1 : @""
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

-(NSArray *)getImagesFromFilterCetegoryFolder:(NSString *)folderName{
    NSString * resourcePath = [[NSBundle mainBundle] resourcePath];
    NSString * bokehPath = [resourcePath stringByAppendingPathComponent:folderName];
    
    NSError * error;
    NSArray * directoryContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:bokehPath error:&error];
    
    NSMutableArray*filterImages      =   [NSMutableArray new];
    
    for(NSString *imageName in directoryContents){
        NSString *imagePath = [bokehPath stringByAppendingPathComponent:imageName];
        
        [filterImages addObject:imagePath];
    }
    
    return filterImages;
}

-(void)addFilterCetagory:(NSString *)category filtersList:(NSArray *)filtersList{
    NSMutableArray *filterCategory1 = [NSMutableArray new];
    NSArray *filterCategory1Images = [self getImagesFromFilterCetegoryFolder:category];
    for (NSString *imgpath in filterCategory1Images){
         for(NSString *filterName in filtersList){
             NSMutableDictionary *filterDetail = [NSMutableDictionary new];
             [filterDetail setObject:filterName forKey:@"filterName"];
             [filterDetail setObject:imgpath forKey:@"image"];
             [filterCategory1 addObject:filterDetail];
         }
    }
    [_filtersImages addObject:filterCategory1];
}

-(void)addFiltersImages{
    
    //[self addFilterCetagory:@"filter1"];
//    [self addFilterCetagory:@"filter2"];
//    [self addFilterCetagory:@"filter3"];
//    [self addFilterCetagory:@"filter4"];
//    [self addFilterCetagory:@"filter5"];
//    [self addFilterCetagory:@"filter6"];
//    [self addFilterCetagory:@"filter7"];

}

- (void)setup
{
    _filtersImages = [NSMutableArray new];

    pattern         =   1;
    patternAlpha    =   0.5;

    _originalImage  =   self.editor.imageView.image;
    _thumbnailImage =   [_originalImage resize:CGSizeMake(_originalImage.size.width/2, _originalImage.size.height/2)];
    _smallThumbnailImage    = [_originalImage resize:CGSizeMake(50, 50)];
    [self.editor fixZoomScaleWithAnimated:YES];
    
    _workingView = [[UIView alloc] initWithFrame:[self.editor.view convertRect:self.editor.imageView.frame fromView:self.editor.imageView.superview]];
    _workingView.clipsToBounds = YES;
    [self.editor.view addSubview:_workingView];
    
    _handlerView = [[UIView alloc] initWithFrame:self.editor.imageView.frame];
    [self.editor.imageView.superview addSubview:_handlerView];
    
    _menuScroll     =   [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.editor.menuScrollView.frame.origin.y - 40, self.editor.menuScrollView.frame.size.width, self.editor.menuScrollView.frame.size.height + 40)];

    _menuScroll.backgroundColor = self.editor.menuScrollView.backgroundColor;
    _menuScroll.showsHorizontalScrollIndicator = NO;
    [self.editor.view addSubview:_menuScroll];
    
    [self setMainMenu];

    _menuScroll.transform = CGAffineTransformMakeTranslation(0, self.editor.view.height-_menuScroll.top);
    [UIView animateWithDuration:kCLImageToolAnimationDuration
                     animations:^{
                         _menuScroll.transform = CGAffineTransformIdentity;
                     }];

    BOOL isInstructionsShown    =   [[NSUserDefaults standardUserDefaults] boolForKey:@"isEffectsInstructionsShown1"];
    
    if(!isInstructionsShown){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [self.editor.view makeToast:@"Swipe to change filter color"
                               duration:4.0
                               position:CSToastPositionBottom];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isEffectsInstructionsShown1"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        });
    }
}

- (void)cleanup
{
    _patternImage  =   nil;
    _patternThumbnailImage = nil;
    _thumbnailImage = nil;
    _originalImage  = nil;
    [_workingView removeFromSuperview];

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
//        UIImage *image  =   [self buildResultImage:_originalImage];
//        image           =   [UIImage drawImage:image inRect:CGRectMake(0, 0, image.size.width, image.size.height)];
        UIImage *image = self.editor.imageView.image;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock(image, nil, nil);
           // [eView removeFromSuperview];
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

-(void)setPatternMenu:(NSArray*)filterImgsList{

    UINavigationItem *item  =   [[UINavigationItem alloc] initWithTitle:@"Effects"];
    item.leftBarButtonItem  =  [self buttonWithImageName:[CLImageEditorTheme localizedString:@"CLImageEditor_BackBtnTitle" withDefault:@"Back"] selector:@selector(crossButtonTapped)];
    
    [self.editor.navigationBar pushNavigationItem:item animated:true];
    
    CGFloat W = 70;
    CGFloat H = _subMenuScroll.height;
    CGFloat x = 0;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        W   =   100;
    }
    
    NSInteger tag = 0;
    
    for(int i = 0 ; i < filterImgsList.count; i++){
        NSMutableDictionary *filterDetail= [filterImgsList objectAtIndex:i ];
        NSString *filterImgName = [filterDetail objectForKey:@"image"];
        NSString *filterName = [filterDetail objectForKey:@"filterName"];

        UIImage *filterImg = [UIImage imageWithContentsOfFile:filterImgName];
        NSLog(@"%@",filterImgName);
        ToolBarItem *view       =   [CLImageEditorTheme menuItemWithFrame:CGRectMake(x, 0, W, H) target:self action:@selector(tappedPatternMenu:) toolInfo:nil isIcon:false];
        view.titleLabel.text    =   [NSString stringWithFormat:@"B%ld",tag];
        view.filterObjects      =   filterImgsList;
        view.tag                =   tag++;
        view.iconView.image     =   [self applyFilterImage:filterImg onImage:_smallThumbnailImage withAlpha:0.4 withSelecter:filterName];
        view.iconView.layer.borderColor =   [UIColor darkGrayColor].CGColor;
        view.iconView.layer.borderWidth =   1.0;
        [_subMenuScroll addSubview:view];
        view.iconView.layer.masksToBounds = true;
        view.iconView.clipsToBounds = true;
        
        view.layer.masksToBounds = true;
        view.clipsToBounds = true;
        x += W;
    }
    
    _subMenuScroll.contentSize = CGSizeMake(MAX(x, _subMenuScroll.frame.size.width+1), 0);
}

-(UIImage*)applyFilterImage:(UIImage *)filterImg onImage:(UIImage *)onImage withAlpha:(double)alpha withSelecter:(NSString *)selecterName{
    UIImage *filterImage;
    
    if ([selecterName isEqualToString:@"filter1"]){
        filterImage = [CIFilter filter1:filterImg onImage:onImage withAlpha:alpha];
    }
    else if ([selecterName isEqualToString:@"filter2"]){
        filterImage = [CIFilter filter2:filterImg onImage:onImage withAlpha:alpha];
    }
    else if ([selecterName isEqualToString:@"filter3"]){
        filterImage = [CIFilter filter3:filterImg onImage:onImage withAlpha:alpha];
    }
    else if ([selecterName isEqualToString:@"filter4"]){
        filterImage = [CIFilter filter4:filterImg onImage:onImage withAlpha:alpha];
    }
    else if ([selecterName isEqualToString:@"filter5"]){
        filterImage = [CIFilter filter5:filterImg onImage:onImage withAlpha:alpha];
    }
    else if ([selecterName isEqualToString:@"filter6"]){
        filterImage = [CIFilter filter6:filterImg onImage:onImage withAlpha:alpha];
    }
    
    if ([selecterName isEqualToString:@"filter7"]){
        filterImage = [CIFilter filter7:filterImg onImage:onImage withAlpha:alpha];
    }
    else if ([selecterName isEqualToString:@"filter8"]){
        filterImage = [CIFilter filter8:filterImg onImage:onImage withAlpha:alpha];
    }
    else if ([selecterName isEqualToString:@"filter9"]){
        filterImage = [CIFilter filter9:filterImg onImage:onImage withAlpha:alpha];
    }
    else if ([selecterName isEqualToString:@"filter10"]){
        filterImage = [CIFilter filter10:filterImg onImage:onImage withAlpha:alpha];
    }
    else if ([selecterName isEqualToString:@"filter11"]){
        filterImage = [CIFilter filter11:filterImg onImage:onImage withAlpha:alpha];
    }
    else if ([selecterName isEqualToString:@"filter12"]){
        filterImage = [CIFilter filter12:filterImg onImage:onImage withAlpha:alpha];
    }
    
    if ([selecterName isEqualToString:@"filter13"]){
        filterImage = [CIFilter filter13:filterImg onImage:onImage withAlpha:alpha];
    }
    else if ([selecterName isEqualToString:@"filter14"]){
        filterImage = [CIFilter filter14:filterImg onImage:onImage withAlpha:alpha];
    }
    else if ([selecterName isEqualToString:@"filter15"]){
        filterImage = [CIFilter filter15:filterImg onImage:onImage withAlpha:alpha];
    }
    else if ([selecterName isEqualToString:@"filter16"]){
        filterImage = [CIFilter filter16:filterImg onImage:onImage withAlpha:alpha];
    }
    else if ([selecterName isEqualToString:@"filter17"]){
        filterImage = [CIFilter filter17:filterImg onImage:onImage withAlpha:alpha];
    }
    else if ([selecterName isEqualToString:@"filter18"]){
        filterImage = [CIFilter filter18:filterImg onImage:onImage withAlpha:alpha];
    }
    
    
    if ([selecterName isEqualToString:@"filter19"]){
        filterImage = [CIFilter filter19:filterImg onImage:onImage withAlpha:alpha];
    }
    else if ([selecterName isEqualToString:@"filter20"]){
        filterImage = [CIFilter filter20:filterImg onImage:onImage withAlpha:alpha];
    }
    else if ([selecterName isEqualToString:@"filter21"]){
        filterImage = [CIFilter filter21:filterImg onImage:onImage withAlpha:alpha];
    }
    else if ([selecterName isEqualToString:@"filter22"]){
        filterImage = [CIFilter filter22:filterImg onImage:onImage withAlpha:alpha];
    }
    else if ([selecterName isEqualToString:@"filter23"]){
        filterImage = [CIFilter filter23:filterImg onImage:onImage withAlpha:alpha];
    }
    else if ([selecterName isEqualToString:@"filter24"]){
        filterImage = [CIFilter filter24:filterImg onImage:onImage withAlpha:alpha];
    }
    
    if ([selecterName isEqualToString:@"filter25"]){
        filterImage = [CIFilter filter25:filterImg onImage:onImage withAlpha:alpha];
    }
    else if ([selecterName isEqualToString:@"filter25"]){
        filterImage = [CIFilter filter25:filterImg onImage:onImage withAlpha:alpha];
    }
    else if ([selecterName isEqualToString:@"filter27"]){
        filterImage = [CIFilter filter27:filterImg onImage:onImage withAlpha:alpha];
    }
    else if ([selecterName isEqualToString:@"filter28"]){
        filterImage = [CIFilter filter28:filterImg onImage:onImage withAlpha:alpha];
    }
    else if ([selecterName isEqualToString:@"filter29"]){
        filterImage = [CIFilter filter29:filterImg onImage:onImage withAlpha:alpha];
    }
    else if ([selecterName isEqualToString:@"filter30"]){
        filterImage = [CIFilter filter30:filterImg onImage:onImage withAlpha:alpha];
    }
    
    if ([selecterName isEqualToString:@"filter31"]){
        filterImage = [CIFilter filter31:filterImg onImage:onImage withAlpha:alpha];
    }
    else if ([selecterName isEqualToString:@"filter32"]){
        filterImage = [CIFilter filter32:filterImg onImage:onImage withAlpha:alpha];
    }
    else if ([selecterName isEqualToString:@"filter33"]){
        filterImage = [CIFilter filter33:filterImg onImage:onImage withAlpha:alpha];
    }
    else if ([selecterName isEqualToString:@"filter34"]){
        filterImage = [CIFilter filter34:filterImg onImage:onImage withAlpha:alpha];
    }
    else if ([selecterName isEqualToString:@"filter35"]){
        filterImage = [CIFilter filter35:filterImg onImage:onImage withAlpha:alpha];
    }
    else if ([selecterName isEqualToString:@"filter37"]){
        filterImage = [CIFilter filter37:filterImg onImage:onImage withAlpha:alpha];
    }
    
    if ([selecterName isEqualToString:@"filter37"]){
        filterImage = [CIFilter filter37:filterImg onImage:onImage withAlpha:alpha];
    }
    else if ([selecterName isEqualToString:@"filter38"]){
        filterImage = [CIFilter filter38:filterImg onImage:onImage withAlpha:alpha];
    }
    else if ([selecterName isEqualToString:@"filter39"]){
        filterImage = [CIFilter filter39:filterImg onImage:onImage withAlpha:alpha];
    }
    else if ([selecterName isEqualToString:@"filter40"]){
        filterImage = [CIFilter filter40:filterImg onImage:onImage withAlpha:alpha];
    }
    else if ([selecterName isEqualToString:@"filter41"]){
        filterImage = [CIFilter filter41:filterImg onImage:onImage withAlpha:alpha];
    }
    else if ([selecterName isEqualToString:@"filter42"]){
        filterImage = [CIFilter filter42:filterImg onImage:onImage withAlpha:alpha];
    }

    return filterImage;
}

- (void)setMainMenu
{
    CGFloat W = 70;
    CGFloat H = _menuScroll.height;
    CGFloat x = 0;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        W   =   100;
    }
    
    _filtersMenu = @[
                     @{@"title":@"filter1", @"icon":[UIImage imageNamed:@"effects"] ,@"filtersList": @[@"filter1",@"filter2",@"filter3",@"filter4"]},
                      @{@"title":@"filter2", @"icon":[UIImage imageNamed:@"effects"],@"filtersList": @[@"filter5",@"filter6",@"filter7",@"filter8"] },
                      
                      ];
    
    NSInteger tag = 0;
    for(NSDictionary *obj in _filtersMenu){

        NSString *filterPackName = [[obj objectForKey:@"title"] lowercaseString];

        [self addFilterCetagory:filterPackName filtersList:[obj objectForKey:@"filtersList"]];

        BOOL isFilterPackNameAvailable = [[NSUserDefaults standardUserDefaults] boolForKey:filterPackName];
        SubToolBarItem *view       =   [CLImageEditorTheme subMenuItemWithFrame:CGRectMake(x, 40, W, H) target:self action:@selector(tappedMainMenu:) toolInfo:nil isIcon:true isPro:!isFilterPackNameAvailable];
        
        view.tag = tag++;
        view.titleLabel.text    =   obj[@"title"];
        view.iconView.image     =   obj[@"icon"];
        
        if(self.selectedMenu==nil){
            self.selectedMenu = view;
        }
        
        [_menuScroll addSubview:view];
        x += W;
    }
    _menuScroll.contentSize = CGSizeMake(x, 0);
}

- (void)setSelectedMenu:(UIView *)selectedMenu{
    if(selectedMenu != _selectedMenu){
        _selectedMenu.backgroundColor = [UIColor clearColor];
        _selectedMenu = selectedMenu;
        // _selectedMenu.backgroundColor = [CLImageEditorTheme toolbarSelectedButtonColor];
    }
}

#pragma mark- Gesture handler

- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

-(void)tappedPatternMenu:(UITapGestureRecognizer*)sender{
    ToolBarItem *view    =   (ToolBarItem*)sender.view;
    
    NSMutableDictionary *filterDetail= [view.filterObjects objectAtIndex:view.tag];
    NSString *filterImgName = [filterDetail objectForKey:@"image"];
    NSString *filterName = [filterDetail objectForKey:@"filterName"];
    UIImage *filterImg = [UIImage imageWithContentsOfFile:filterImgName];

    UIImage *finalImage = [self applyFilterImage:filterImg onImage:_originalImage withAlpha:0.3 withSelecter:filterName];
    
    self.editor.imageView.image = finalImage;
}

- (void)tappedMainMenu:(UITapGestureRecognizer*)sender{
    SubToolBarItem *view = (SubToolBarItem*)sender.view;
    NSArray *filtersImagesList = [_filtersImages objectAtIndex:view.tag];

    [self initSubMenuScrollView];
    [self setPatternMenu:filtersImagesList];
    [self swapMenuToShowSlider:YES];
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

@end


