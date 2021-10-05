//
//  EffectsTool.m
//  BasicFilters
//
//  Created by Kanwar on 2/1/18.
//  Copyright © 2018 Kanwarpal Singh. All rights reserved.
//

#import "TextArtTool.h"

#import "UIImage+Utility.h"
#import "UIView+Frame.h"
#import "ToolBarItem.h"
#import "UIView+Toast.h"
#import "FMPhotoPickerExample-Swift.h"
#import "PurchaseViewController.h"

static NSString* const kCLBlurToolNormalIconName1 = @"nonrmalIconAssetsName";
static NSString* const kCLBlurToolCircleIconName1 = @"circleIconAssetsName";
static NSString* const kCLBlurToolBandIconName1 = @"bandIconAssetsName";

@interface TextArtTool()<UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIView *selectedMenu;
@end

@implementation TextArtTool
{
    UIImage *_originalImage;
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

+ (NSString*)defaultTitle{
    return [CLImageEditorTheme localizedString:@"CLBlurEffect_DefaultTitle" withDefault:@"Blur & Focus"];
}

#pragma mark- optional info

+ (NSDictionary*)optionalInfo{
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

- (void)setup{
//    [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"Pack 1"];
//    [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"Pack 2"];

    [[NSUserDefaults standardUserDefaults] synchronize];
    
    pattern         =   1;
    patternAlpha    =   0.5;
    
    _originalImage  =   self.editor.imageView.image;
    _thumbnailImage =   [_originalImage resize:CGSizeMake(_originalImage.size.width/2, _originalImage.size.height/2)];
    
    [self.editor fixZoomScaleWithAnimated:YES];
    
    _workingView = [[UIView alloc] initWithFrame:[self.editor.view convertRect:self.editor.imageView.frame fromView:self.editor.imageView.superview]];
    _workingView.clipsToBounds = YES;
    [self.editor.view addSubview:_workingView];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped)];
    tapGesture.numberOfTouchesRequired = 1;
    tapGesture.numberOfTapsRequired = 1;
    _workingView.userInteractionEnabled = true;
    
    [_workingView addGestureRecognizer:tapGesture];
    
    _handlerView = [[UIView alloc] initWithFrame:self.editor.imageView.frame];
    [self.editor.imageView.superview addSubview:_handlerView];
    [self setMainMenu];
    
    _stickersOptionsContainerView.transform = CGAffineTransformMakeTranslation(0, self.editor.view.height-_menuScroll.top);
    [UIView animateWithDuration:kCLImageToolAnimationDuration
                     animations:^{
                         _stickersOptionsContainerView.transform = CGAffineTransformIdentity;
                     }];
    
    [self initMenuScrollView];
    
}

-(void)addColelctionView{
    [self.collectionView removeFromSuperview];
    
    UICollectionViewFlowLayout *collectionViewLayout    =   [[UICollectionViewFlowLayout alloc] init];
    collectionViewLayout.sectionInset                   =   UIEdgeInsetsMake(0, 0, 0, 0);
    collectionViewLayout.minimumInteritemSpacing        =   0;
    collectionViewLayout.minimumLineSpacing             =   0;
    
    self.collectionView                                 =   [[UICollectionView alloc] initWithFrame:CGRectMake(0, 40, self.stickersOptionsContainerView.frame.size.width, 230) collectionViewLayout:collectionViewLayout];
    
    [self.collectionView setDataSource:self];
    [self.collectionView setDelegate:self];
    [self.collectionView setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    [self.stickersOptionsContainerView addSubview:self.collectionView];
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(0, self.stickersOptionsContainerView.frame.size.height - 40, self.stickersOptionsContainerView.frame.size.width, 40);
    [closeBtn setTitle:@"X" forState:UIControlStateNormal];
    [closeBtn setTintColor:[UIColor whiteColor]];
    [closeBtn setBackgroundColor:[UIColor blackColor]];
    [closeBtn addTarget:self action:@selector(closeStickerView) forControlEvents:UIControlEventTouchUpInside];
    [self.stickersOptionsContainerView addSubview:closeBtn];
}

-(void)closeStickerView{
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveLinear  animations:^{
        self.stickersOptionsContainerView.frame  =   CGRectMake(0, self.editor.view.frame.size.height - 40, self.stickersOptionsContainerView.frame.size.width, self.stickersOptionsContainerView.frame.size.height);
            } completion:^(BOOL finished) {
                
            }];
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGSize cellSize = CGSizeMake((self.editor.view.frame.size.width/4) , (self.editor.view.frame.size.width/4) );
    
    return cellSize;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return stickerList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier         =   @"Cell";
    
    UICollectionViewCell *cell          =   [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    for(UIView *v1 in [cell.contentView subviews]){
        [v1 removeFromSuperview];
    }
    
    NSString *currentStickerPath    =   [stickerList objectAtIndex:indexPath.row];
    UIImage *stickerImg = [UIImage imageWithContentsOfFile:currentStickerPath];

    UIImageView *stickerImgView     =   [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, cell.frame.size.width - 20, cell.frame.size.height - 20)];
    stickerImgView.contentMode         =   UIViewContentModeScaleAspectFit;
    stickerImgView.clipsToBounds       =   true;
    stickerImgView.image    = stickerImg;
    [cell.contentView addSubview:stickerImgView];
    
//    [cell addBottomBorder:[UIColor lightGrayColor] width:1];
//    [cell addRightBorder:[UIColor lightGrayColor] width:1];
//    [cell addTopBorder:[UIColor lightGrayColor] width:1];

    if(indexPath.item > 3 ){
//        if([now compare:monthlySubscriptiondate] == NSOrderedDescending|| [now compare:yearlySubscriptiondate] == NSOrderedDescending) {
        BOOL IsPro = [[NSUserDefaults standardUserDefaults] boolForKey:@"IsPro"];
        if(IsPro == false){
            UIImageView *proIconView    =   [[UIImageView alloc]initWithFrame:CGRectMake(cell.frame.size.width - 25, 0, 20, 20)];
            proIconView.contentMode     =   UIViewContentModeScaleAspectFit;
            proIconView.clipsToBounds   =   true;
            proIconView.image           =   [UIImage imageNamed:@"star"];
            //[cell.contentView addSubview:proIconView];
        }
        else{
            
        }
    }

    cell.backgroundColor = [UIColor lightTextColor];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *currentStickerPath    =   [stickerList objectAtIndex:indexPath.row];
    UIImage *stickerImg = [UIImage imageWithContentsOfFile:currentStickerPath];
    origionalSticker = stickerImg;
    
    if(indexPath.item > 3 ){
        BOOL IsPro = [[NSUserDefaults standardUserDefaults] boolForKey:@"IsPro"];
        if(IsPro == false){
            
            if([SKStoreReviewController respondsToSelector:@selector(requestReview)]){
                UIAlertController* alert = [UIAlertController alertControllerWithTitle:@""
                                                                               message:@"Do you want to unlock all content by just posting a positive review?"
                                                                        preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* rateAction = [UIAlertAction actionWithTitle:@"OK, I will Rate" style:UIAlertActionStyleDefault
                                                                   handler:^(UIAlertAction * action) {
                                                                       
                                                                       [SKStoreReviewController requestReview];
                                                                       [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"IsPro"];
                                                                       [[NSUserDefaults standardUserDefaults] synchronize];
                                                                       
                                                                       double delayInSeconds = 10.0;
                                                                       dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                                                                       dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                                                                           [self.collectionView reloadData];
                                                                       });
                                                                   }];
                
                UIAlertAction* buyAction = [UIAlertAction actionWithTitle:@"No, I will Buy it" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {
                                                                      [self openPurchaseView];
                                                                  }];
                
                [alert addAction:rateAction];
                [alert addAction:buyAction];
                
                [self.editor presentViewController:alert animated:YES completion:nil];
            }
            else{
                [self openPurchaseView];
            }
        }
        else{
            eView = [[CLEmoticonView alloc] initWithImage:stickerImg isSticker:true deleteBlock:^{
                
                if(self.editor.navigationBar.items.count == 4){
                    [self.editor.navigationBar popNavigationItemAnimated:YES];
                    [self showHideSubMenu:false];
                }
                [self.editor.navigationBar popNavigationItemAnimated:YES];
                [self showHideSettingsView:false];
            }];
            CGFloat ratio = MIN((0.2 * _workingView.width) / eView.width, (0.2 * _workingView.height) / eView.height);
            
            [CLEmoticonView setActiveEmoticonView:eView];
            [eView setMinScale:ratio];
            [eView setScale:ratio*2];
            eView.imageView.alpha = 1;
            eView.center = CGPointMake(_workingView.width/2, _workingView.height/2);
            [_workingView addSubview:eView];
            [self setSettingsMenu];
        }
    }
    else{
        eView = [[CLEmoticonView alloc] initWithImage:stickerImg isSticker:true deleteBlock:^{
            if(self.editor.navigationBar.items.count == 4){
                [self.editor.navigationBar popNavigationItemAnimated:YES];
                [self showHideSubMenu:false];
            }
            [self.editor.navigationBar popNavigationItemAnimated:YES];
            [self showHideSettingsView:false];
        }];
        
        CGFloat ratio = MIN((0.2 * _workingView.width) / eView.width, (0.2 * _workingView.height) / eView.height);
        
        [CLEmoticonView setActiveEmoticonView:eView];
        [eView setMinScale:ratio];
        [eView setScale:ratio*2];
        eView.imageView.alpha = 1;
        eView.center = CGPointMake(_workingView.width/2, _workingView.height/2);
        [_workingView addSubview:eView];
        [self setSettingsMenu];
    }
}

-(void)openPurchaseView{
    NSString * storyboardName                   =   @"Main";
    NSString * viewControllerID                 =   @"PurchaseViewController";
    UIStoryboard * storyboard                   =   [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    PurchaseViewController * controller         =   [storyboard instantiateViewControllerWithIdentifier:viewControllerID];
    controller.delegate = self;
    [self.editor presentViewController:controller animated:YES completion:nil];
}

-(void)setupStickerCateoryList{
    self.stickersOptionsContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.editor.view.frame.size.height - 40, self.editor.view.frame.size.width, 310)];
    
    self.stickersOptionsContainerView.backgroundColor = [UIColor whiteColor];
    
    [self.editor.view addSubview:self.stickersOptionsContainerView];
    [self addColelctionView];
    
    categoryText = [_strickerMenu valueForKey:@"title"];
    
    seg                             =   [[TZSegmentedControl alloc] init];
    seg.frame                       =   CGRectMake(0, 0, self.stickersOptionsContainerView.frame.size.width, 40);
    seg.backgroundColor             =   self.editor.barColor;
    seg.sectionTitles               =   categoryText;
    seg.indicatorWidthPercent       =   0.8;
    seg.borderColor                 =   [UIColor clearColor];
    seg.borderWidth                 =   0.5;
    seg.verticalDividerEnabled      =   false;
    seg.verticalDividerWidth        =   0.5;
    seg.verticalDividerColor        =   [UIColor lightGrayColor];
    seg.selectionIndicatorColor     =   [UIColor blueColor];
    seg.selectionIndicatorHeight    =   2.0;
    seg.selectedSegmentIndex        =   0;
    NSDictionary *attrDict          =   @{NSForegroundColorAttributeName : [UIColor whiteColor] };
    
    //seg.selectedTitleTextAttributes = attrDict;
//    [seg addBottomBorder:[UIColor groupTableViewBackgroundColor] width:1];

    NSDictionary *attrDict1         =   @{ NSForegroundColorAttributeName : [UIColor whiteColor],  NSFontAttributeName : [UIFont systemFontOfSize:15] };
    
    //seg.titleTextAttributes = attrDict1;
    
    [self.stickersOptionsContainerView addSubview:seg];
    selectedIndex   =   0;
    [self setStickersListMenu:selectedIndex];
    
    [self manageSticker];
    
    seg.indexChangeBlock = ^ (NSInteger index) {
        selectedIndex   = index;
        [self manageSticker];
    };
}

-(void)manageSticker{
    NSString *stickerName = [categoryText objectAtIndex:selectedIndex];
    
    BOOL isStickerAvailable = [[NSUserDefaults standardUserDefaults] boolForKey:stickerName];
    
    if(isStickerAvailable == true){
        [self showHideStickerListView:YES];
    }
    else{
        
    }
    [self setStickersListMenu:selectedIndex];
}

-(void)showHideStickerListView:(BOOL)toShow{
    if(toShow){
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut  animations:^{
            self.stickersOptionsContainerView.frame  =   CGRectMake(0, self.editor.view.frame.size.height - self.stickersOptionsContainerView.frame.size.height, self.stickersOptionsContainerView.frame.size.width, self.stickersOptionsContainerView.frame.size.height);
            
        } completion:^(BOOL finished) {
            
        }];
    }
    else{
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveLinear  animations:^{
            
            self.stickersOptionsContainerView.frame  =   CGRectMake(0, self.editor.view.frame.size.height - 40, self.stickersOptionsContainerView.frame.size.width, self.stickersOptionsContainerView.frame.size.height);
        } completion:^(BOOL finished) {
            
        }];
    }
}

-(void)showHideSettingsView:(BOOL)toShow{
    if(toShow){
        
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveLinear  animations:^{
            
            self.stickersOptionsContainerView.frame  =   CGRectMake(0, self.editor.view.frame.size.height, self.stickersOptionsContainerView.frame.size.width, self.stickersOptionsContainerView.frame.size.height);
        } completion:^(BOOL finished) {
            
            [UIView animateWithDuration:kCLImageToolAnimationDuration
                             animations:^{
                                 _menuScroll.frame  =   CGRectMake(_menuScroll.frame.origin.x, self.editor.view.height - _menuScroll.frame.size.height, _menuScroll.frame.size.width, _menuScroll.frame.size.height);
                             }
                             completion:^(BOOL finished) {
                             }];
        }];
    }
    else{
        [UIView animateWithDuration:kCLImageToolAnimationDuration
                         animations:^{
                             _menuScroll.frame  =   CGRectMake(_menuScroll.frame.origin.x, self.editor.view.height, _menuScroll.frame.size.width, _menuScroll.frame.size.height);
                         }
                         completion:^(BOOL finished) {
                             [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveLinear  animations:^{
                                 
                                 self.stickersOptionsContainerView.frame  =   CGRectMake(0, self.editor.view.frame.size.height - 40, self.stickersOptionsContainerView.frame.size.width, self.stickersOptionsContainerView.frame.size.height);
                             } completion:^(BOOL finished) {
                                 
                                 
                             }];
                         }];
    }
}

- (void)setMainMenu{

    CGFloat W = 70;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        W   =   100;
    }
    
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"textart" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    _strickerMenu = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    [self setupStickerCateoryList];
}

- (void)initSubMenuScrollView{
    _containerView                      =   [[UIView alloc]initWithFrame:CGRectMake(0, _menuScroll.top, self.editor.menuScrollView.frame.size.width, _menuScroll.frame.size.height)];
    [self.editor.view addSubview:_containerView];
}

- (void)initMenuScrollView
{
    if(_menuScroll==nil){
        UIScrollView *menuScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.editor.view.width, kMenuBarHeight)];
        menuScroll.top = self.editor.view.height;
        menuScroll.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        menuScroll.showsHorizontalScrollIndicator   =   NO;
        menuScroll.showsVerticalScrollIndicator     =   NO;
        
        [self.editor.view addSubview:menuScroll];
        _menuScroll = menuScroll;
    }
    _menuScroll.backgroundColor = self.editor.barColor;
    //[self showHideSettingsView:false];
}

- (void)setSettingsMenu{
    UINavigationItem *item  =   [[UINavigationItem alloc] initWithTitle:@"SETTINGS"];
    item.leftBarButtonItem  =  [self buttonWithImageName:[CLImageEditorTheme localizedString:@"CLImageEditor_BackBtnTitle" withDefault:@"Back"] selector:@selector(settingsCrossButtonTapped)];
    [self.editor.navigationBar pushNavigationItem:item animated:true];
    
    [self showHideSettingsView:true];
    for(UIView *v in _menuScroll.subviews){
        [v removeFromSuperview];
    }
    
    CGFloat W = 70;
    CGFloat H = _menuScroll.height;
    CGFloat x = (self.editor.view.frame.size.width - (W*2))/2;

    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        W   =   100;
    }
    NSArray *_menu;
    
//    if(dominentColors.count > 1){
//        _menu = @[
//                  @{@"title":@"Presets", @"icon":[UIImage imageNamed:@"draw"]},
//                  @{@"title":@"Color",@"icon":[UIImage imageNamed:@"dot"]},
//                  @{@"title":@"Transparency", @"icon":[UIImage imageNamed:@"dash"]}
//                  ];
//    }
//    else{
        _menu = @[
                  @{@"title":@"Color",@"icon":[UIImage imageNamed:@"dot"]},
                  @{@"title":@"Transparency", @"icon":[UIImage imageNamed:@"dash"]}
                  ];
   // }
    
    NSInteger tag = 0;
    for(NSDictionary *obj in _menu){
        ToolBarItem *view = [CLImageEditorTheme menuItemWithFrame:CGRectMake(x, 0, W, H) target:self action:@selector(tappedSettingMenuPanel:) toolInfo:nil isIcon:true];
        view.tag = tag++;
        view.titleLabel.text = obj[@"title"];
        view.iconView.image = obj[@"icon"];
        
        [_menuScroll addSubview:view];
        x += W;
    }
    
    _menuScroll.contentSize = CGSizeMake(x, 0);
//    _menuScroll.clipsToBounds = NO;
//
//    if (_menuScroll.contentSize.width < self.editor.menuScrollView.frame.size.width){
//        _menuScroll.frame   =   CGRectMake(_menuScroll.frame.origin.x, _menuScroll.frame.origin.y, _menuScroll.contentSize.width, _menuScroll.frame.size.height);
//        _menuScroll.center  =   CGPointMake(self.editor.menuScrollView.center.x, _menuScroll.center.y) ;
//    }
}

- (void)tappedSettingMenuPanel:(UITapGestureRecognizer*)sender{
    ToolBarItem *view = (ToolBarItem*)sender.view;
    UINavigationItem *item  =   [[UINavigationItem alloc] initWithTitle:[view.titleLabel.text uppercaseString]];
    item.leftBarButtonItem  =  [self buttonWithImageName:[CLImageEditorTheme localizedString:@"CLImageEditor_BackBtnTitle" withDefault:@"Back"] selector:@selector(crossButtonTapped)];
    [self.editor.navigationBar pushNavigationItem:item animated:true];
    
    switch (view.tag) {
//        case 0:
//            [self initSubMenuScrollView];
//            [self addPresets];
//            break;
        case 0:
            [self initSubMenuScrollView];
            [self addColorPicker];

            break;
        case 1:
            [self initSubMenuScrollView];
            [self initAlphaSliderView];
            break;
    }
    [self showHideSubMenu:YES];
}

-(void)addPresets{
    
    if(_subMenuScroll==nil){
        UIScrollView *menuScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.editor.view.width, kMenuBarHeight)];
        menuScroll.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        menuScroll.showsHorizontalScrollIndicator   =   NO;
        menuScroll.showsVerticalScrollIndicator     =   NO;
    
        [_containerView addSubview:menuScroll];
        _subMenuScroll = menuScroll;
    }
    _subMenuScroll.backgroundColor = self.editor.barColor;
    
    NSString *fileName = @"";
    if(noofColors == 2){
        fileName = @"2color";
    }
    if(noofColors == 3){
        fileName = @"3color";
    }
    if(noofColors == 4){
        fileName = @"4color";
    }
    
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    presetList = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    CGFloat W = 70;
    CGFloat x = 0;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        W   =   100;
    }
    
    NSInteger tag = 0;

    for(NSArray *preset in presetList){
        NSMutableArray *colors = [NSMutableArray new];
        
        for(NSMutableDictionary *colorCodes in preset){
            int r = [[colorCodes objectForKey:@"r"] intValue];
            int g = [[colorCodes objectForKey:@"g"] intValue];
            int b = [[colorCodes objectForKey:@"b"] intValue];

            UIColor *color = [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0];
            [colors addObject:color];
        }
        
        PieChartView *pieChartView = [[PieChartView alloc] initWithFrame:CGRectMake(x, (_subMenuScroll.frame.size.height - 40)/2, 40, 40)];
        pieChartView.colors = colors;
        pieChartView.tag = tag;
        [pieChartView reloadData];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = pieChartView.frame;
        [btn addTarget:self action:@selector(presetBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = tag;
        
        [_subMenuScroll addSubview:pieChartView];
        [_subMenuScroll addSubview:btn];

        x += W;
        tag++;
    }
    _subMenuScroll.contentSize = CGSizeMake(MAX(x, _subMenuScroll.frame.size.width+1), 0);
}

-(void)presetBtnClicked:(UIButton *)btn{
    NSArray *preset = [presetList objectAtIndex:btn.tag];
    
    NSMutableArray *withColor = [NSMutableArray new];
    
    for(NSMutableDictionary *colorCodes in preset){
        int r = [[colorCodes objectForKey:@"r"] intValue];
        int g = [[colorCodes objectForKey:@"g"] intValue];
        int b = [[colorCodes objectForKey:@"b"] intValue];
        
        UIColor *color = [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0];
        [withColor addObject:color];
    }
    
    eView.imageView.image = [self replaceStickerColors:eView.imageView.image colorsToReplace:dominentColors withColor:withColor];
    dominentColors =  withColor;

}

-(void)addColorPicker{
    
    MaterialColorPicker *colorPicker    =   [[MaterialColorPicker alloc] initWithFrame:CGRectMake(0, (_menuScroll.frame.size.height - 50)/2, _containerView.frame.size.width, 50)];
    colorPicker.delegate                =   self;
    colorPicker.selectionColor          =   [UIColor grayColor];
    colorPicker.selectedBorderWidth     =   5;
    colorPicker.cellSpacing             =   10;
    [_containerView addSubview:colorPicker];
}

- (void)didSelectColorAtIndex:(MaterialColorPicker *)MaterialColorPickerView index:(NSInteger)index color:(UIColor *)color{
    eView.imageView.image = [eView.imageView.image imageWithTint:color];
}

-(void)initAlphaSliderView{
    _alphaSlider = [[UISlider alloc] initWithFrame:CGRectMake(10, 0, self.editor.menuScrollView.frame.size.width - 20, _containerView.frame.size.height)];
    
    [_alphaSlider setThumbImage:[UIImage imageNamed:@"slider"] forState:UIControlStateNormal];
    
    [_alphaSlider setMinimumTrackTintColor:[UIColor whiteColor]];
    [_alphaSlider setMaximumTrackTintColor:[UIColor whiteColor]];
    [_alphaSlider setContinuous:NO];
    //_alphaSlider.continuous          =   NO;
    [_alphaSlider addTarget:self action:@selector(alphaSliderChange:) forControlEvents:UIControlEventValueChanged];
    
    _alphaSlider.maximumValue        =   1;
    _alphaSlider.minimumValue        =   0.2;
    _alphaSlider.value               =   1;
    
    [_containerView addSubview:_alphaSlider];
}

-(void)alphaSliderChange:(UISlider *)slider{
    eView.imageView.alpha = slider.value;
}

-(void)showHideSubMenu:(BOOL)showMenu{
    if(showMenu){
        [UIView animateWithDuration:kCLImageToolAnimationDuration animations:^{
            for(UIView *subView in _menuScroll.subviews){
                if ([subView isKindOfClass:[ToolBarItem class]]) {
                    subView.alpha  = 0.0;
                }
            }
        }];
        
        _containerView.frame  = CGRectMake(_containerView.frame.origin.x,  _menuScroll.top + _containerView.frame.size.height, _containerView.frame.size.width, _containerView.frame.size.height);
        
        [UIView animateWithDuration:kCLImageToolAnimationDuration
                         animations:^{
                             _containerView.frame  = CGRectMake(_containerView.frame.origin.x, _menuScroll.top, _containerView.frame.size.width, _containerView.frame.size.height);
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
        
        [UIView animateWithDuration:kCLImageToolAnimationDuration
                         animations:^{
                             _containerView.frame  = CGRectMake(_containerView.frame.origin.x, _menuScroll.top + _containerView.frame.size.height, _containerView.frame.size.width, _containerView.frame.size.height);
                         } completion:^(BOOL finished) {
                             _menuScroll.scrollEnabled   =   true;
                             [_containerView removeFromSuperview];
                         }
         ];
    }
}


-(void)imageTapped{
    [CLEmoticonView setActiveEmoticonView:nil];
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
                         _stickersOptionsContainerView.transform = CGAffineTransformMakeTranslation(0, self.editor.view.height-_menuScroll.top);
                     }
                     completion:^(BOOL finished) {
                         [_stickersOptionsContainerView removeFromSuperview];
                     }];
}

- (void)executeWithCompletionBlock:(void(^)(UIImage *image, NSError *error, NSDictionary *userInfo))completionBlock
{
    [CLEmoticonView setActiveEmoticonView:nil];

    dispatch_async(dispatch_get_main_queue(), ^{
        [_containerView removeFromSuperview];
        
        UIActivityIndicatorView *indicator = [CLImageEditorTheme indicatorView];
        indicator.center = CGPointMake(_handlerView.width/2, _handlerView.height/2);
        [_handlerView addSubview:indicator];
        [indicator startAnimating];
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *image  =   [self buildResultImage:_originalImage];
        image           =   [UIImage drawImage:image inRect:CGRectMake(0, 0, image.size.width, image.size.height)];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock(image, nil, nil);
        });
    });
}

-(void)setStickersListMenu:(NSUInteger)viewTag{
    NSDictionary *stickerInfo = [_strickerMenu objectAtIndex:viewTag];
    NSString *stickerName = [stickerInfo objectForKey:@"title"] ;
    
    NSString *stickersPath = [stickerInfo objectForKey:@"path"];
    NSString *inAppId = [stickerInfo objectForKey:@"inAppId"];

    currentSticker = stickerName;
    
    BOOL isStickerAvailable = [[NSUserDefaults standardUserDefaults] boolForKey:stickerName];
    
    NSString * resourcePath = [[NSBundle mainBundle] resourcePath];
    NSString * bokehPath    = [resourcePath stringByAppendingPathComponent:stickerName];
    NSError * error;
    NSArray * directoryContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:bokehPath error:&error];
    NSMutableArray* stickerList      =   [NSMutableArray new];

    if (isStickerAvailable == false){
        if (directoryContents.count > 0){

            for(NSString *imageName in directoryContents){
                NSString *imagePath = [bokehPath stringByAppendingPathComponent:imageName];
                
                [stickerList addObject:imagePath];
            }
            [self addStickersMenu:stickerList isStickerAvailable:isStickerAvailable inAppId:inAppId toolname:stickerName];
        }
        else{
            // show downloaing View
            
            stickerList = [self loadStickersFromDirectory:stickerName];
            
            if (stickerList.count > 0){
                [self addStickersMenu:stickerList isStickerAvailable:isStickerAvailable inAppId:inAppId toolname:stickerName];
            }
            else{

                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.editor.view animated:YES];
                hud.mode = MBProgressHUDModeAnnularDeterminate;
                hud.label.text = @"Downloading";

                NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
                AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
                
                NSURL *URL = [NSURL URLWithString:stickersPath];
                NSURLRequest *request = [NSURLRequest requestWithURL:URL];
                
                NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
                    NSLog(@"%@",downloadProgress);
                    
                    hud.progressObject = downloadProgress;

                } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
                    NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
                    return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
                } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
                    NSLog(@"File downloaded to: %@", filePath);
                    
                    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                    NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory

                    [SSZipArchive unzipFileAtPath:filePath.path toDestination:documentsPath];
                    
                    NSFileManager *fileM = [NSFileManager defaultManager];
                    
                    [fileM removeItemAtPath:filePath.path error:nil];
                    
                    [[NSUserDefaults standardUserDefaults] setBool:true forKey:stickerName];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    [hud removeFromSuperview];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self showHideStickerListView:YES];

                        NSArray *stickersList = [self loadStickersFromDirectory:stickerName];
                        [self addStickersMenu:stickersList isStickerAvailable:isStickerAvailable inAppId:inAppId toolname:stickerName];
                    });
                }];
                [downloadTask resume];
            }
        }
    }
    else{
        if (directoryContents.count > 0){
            for(NSString *imageName in directoryContents){
                NSString *imagePath = [bokehPath stringByAppendingPathComponent:imageName];
                
                [stickerList addObject:imagePath];
            }
        }
        else{
            stickerList = [self loadStickersFromDirectory:stickerName];
        }

        [self addStickersMenu:stickerList isStickerAvailable:isStickerAvailable inAppId:inAppId toolname:stickerName];
    }
}

-(NSArray *)loadStickersFromDirectory:(NSString *)stickerName{
    NSMutableArray *_overlayColorsImgs = [NSMutableArray new];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
    NSString *filePath = [documentsPath stringByAppendingPathComponent:stickerName];
    NSError *error;
    NSArray * directoryContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:filePath error:&error];
    
    for(NSString *imageName in directoryContents){
        if(![imageName isEqualToString:@".DS_Store"]){
            NSString *imagePath = [filePath stringByAppendingPathComponent:imageName];
            
            [_overlayColorsImgs addObject:imagePath];
        }
    }
    
    return _overlayColorsImgs;
}

-(void)addStickersMenu:(NSArray *)stickersImages isStickerAvailable:(BOOL)isStickerAvailable inAppId:(NSString *)inAppId toolname:(NSString *)toolname{
    
    self.isStickerAvailable = isStickerAvailable;
    self.inAppId = inAppId;
    self.currentStickerCategoryName = toolname;
    stickerList = stickersImages;
    [self.collectionView reloadData];
    
    NSUInteger numberofItems = [self.collectionView numberOfItemsInSection:0];
    
    if (numberofItems > 0){
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionTop animated:true];

    }
}

- (void)setSelectedMenu:(UIView *)selectedMenu{
    if(selectedMenu != _selectedMenu){
        _selectedMenu.backgroundColor = [UIColor clearColor];
        _selectedMenu = selectedMenu;
    }
}

- (UIImage*)buildResultImage:(UIImage*)image{
    __block CALayer *layer = nil;
    __block CGFloat scale = 1;
    
    //safe_dispatch_sync_main(^{
        scale = image.size.width / _workingView.width;
        layer = _workingView.layer;
    //});
    
    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
    
    [image drawAtPoint:CGPointZero];
    
    CGContextScaleCTM(UIGraphicsGetCurrentContext(), scale, scale);
    [layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *tmp = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return tmp;
}

#pragma mark- Gesture handler

- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

- (void)tappedMainMenu:(UITapGestureRecognizer*)sender
{
    UIView *view = sender.view;
    [self setStickersListMenu:view.tag];
}

-(void)settingsCrossButtonTapped{
    [self.editor.navigationBar popNavigationItemAnimated:YES];
    [self showHideSettingsView:false];
}

-(void)crossButtonTapped{
    [self.editor.navigationBar popNavigationItemAnimated:YES];
    [self showHideSubMenu:false];
}

- (UIImage *)imageWithImage:(UIImage *)image convertToSize:(CGSize)size {
    UIGraphicsBeginImageContextWithOptions(size, true, 1);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return destImage;
}

-(UIImage *)replaceStickerColors:(UIImage *)sticker colorsToReplace:(NSArray *)colorsToReplace withColor:(NSArray*)colors{
    
    CGContextRef ctx;
    CGImageRef imageRef = [sticker CGImage];
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char *rawData = malloc(height * width * 4);
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate(rawData, width, height,
                                                 bitsPerComponent, bytesPerRow, colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    CGContextRelease(context);
    
    // Now your rawData contains the image data in the RGBA8888 pixel format.
    int byteIndex = (bytesPerRow * 0) + 0 * bytesPerPixel;
    
    
    for (int ii = 0 ; ii < width * height ; ++ii)
    {
        // Get color values to construct a UIColor
        CGFloat red   = (rawData[byteIndex]     * 1.0) ;
        CGFloat green = (rawData[byteIndex + 1] * 1.0);
        CGFloat blue  = (rawData[byteIndex + 2] * 1.0) ;
        CGFloat alpha = (rawData[byteIndex + 3] * 1.0) ;
        
        for(int i = 0 ; i < colorsToReplace.count ; i++){
            UIColor *colorToReplace = colorsToReplace[i];
            UIColor *withColor = colors[i];
            
            CGFloat targetRed = 0.0, targetGreen = 0.0, targetBlue = 0.0, alpha1 = 0.0;
            [withColor getRed:&targetRed green:&targetGreen blue:&targetBlue alpha:&alpha1];
            
            CGFloat sourceRed = 0.0, sourceGreen = 0.0, sourceBlue = 0.0, sourcealpha1 = 0.0;
            [colorToReplace getRed:&sourceRed green:&sourceGreen blue:&sourceBlue alpha:&sourcealpha1];
            
            if(red > 0 && green > 0 && blue > 0){
                
                if((red  - (sourceRed * 255) < 2 && (red  - (sourceRed * 255)) > -2) && ((green  - (sourceGreen * 255)) < 2 && (green  - (sourceGreen * 255)) > -2) && ((blue  - (sourceBlue * 255)) < 2 && (blue  - (sourceBlue * 255)) > -2) ){
                    rawData[byteIndex] = (char) (targetRed * 255);
                    rawData[byteIndex+1] = (char) (targetGreen * 255);
                    rawData[byteIndex+2] = (char) (targetBlue * 255);
                }
            }
        }
        
        byteIndex += 4;
    }
    
    ctx = CGBitmapContextCreate(rawData,
                                CGImageGetWidth( imageRef ),
                                CGImageGetHeight( imageRef ),
                                8,
                                CGImageGetBytesPerRow( imageRef ),
                                CGImageGetColorSpace( imageRef ),
                                kCGImageAlphaPremultipliedLast );
    
    imageRef = CGBitmapContextCreateImage (ctx);
    UIImage* rawImage = [UIImage imageWithCGImage:imageRef];
    
    CGContextRelease(ctx);
    free(rawData);
    return rawImage;
}

-(NSArray *)getDominentColors:(UIImage *)sticker{
    //sticker = [self imageWithImage:sticker convertToSize:CGSizeMake(sticker.size.width/20, sticker.size.height/20)];
    CGContextRef ctx;
    CGImageRef imageRef = [sticker CGImage];
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char *rawData = malloc(height * width * 4);
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate(rawData, width, height,
                                                 bitsPerComponent, bytesPerRow, colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    CGContextRelease(context);
    
    // Now your rawData contains the image data in the RGBA8888 pixel format.
    int byteIndex = (bytesPerRow * 0) + 0 * bytesPerPixel;
    
    NSMutableDictionary *colorDict = [[NSMutableDictionary alloc]init];
    
    NSMutableArray *allColors = [NSMutableArray new];
    
    for (int ii = 0 ; ii < width * height ; ++ii)
    {
        // Get color values to construct a UIColor
        int red   = (rawData[byteIndex]     * 1.0) ;
        int green = (rawData[byteIndex + 1] * 1.0);
        int blue  = (rawData[byteIndex + 2] * 1.0) ;
        int alpha = (rawData[byteIndex + 3] * 1.0) ;
        
        if(red > 0 && green > 0 && blue > 0){
            NSString *string = [NSString stringWithFormat:@"%d_%d_%d",red,green,blue];
            
            NSNumber *existingColorsCount = [colorDict objectForKey:string];
            NSUInteger count = [existingColorsCount integerValue];
            count = count + 1;
            
            [colorDict setObject:[NSNumber numberWithInteger:count] forKey:string];
        }
        
        byteIndex += 4;
    }
    
    
    ctx = CGBitmapContextCreate(rawData,
                                CGImageGetWidth( imageRef ),
                                CGImageGetHeight( imageRef ),
                                8,
                                CGImageGetBytesPerRow( imageRef ),
                                CGImageGetColorSpace( imageRef ),
                                kCGImageAlphaPremultipliedLast );
    
    imageRef = CGBitmapContextCreateImage (ctx);
    //UIImage* rawImage = [UIImage imageWithCGImage:imageRef];
    
    CGContextRelease(ctx);
    
    free(rawData);
    
    NSArray *myArray;
    
    myArray = [colorDict keysSortedByValueUsingComparator: ^(id obj1, id obj2) {
        
        if ([obj1 integerValue] > [obj2 integerValue]) {
            
            return (NSComparisonResult)NSOrderedAscending;
        }
        if ([obj1 integerValue] < [obj2 integerValue]) {
            
            return (NSComparisonResult)NSOrderedDescending;
        }
        
        return (NSComparisonResult)NSOrderedSame;
    }];
    
    NSMutableArray *dominentColors = [NSMutableArray new];
    
    NSUInteger minQty = myArray.count*0.08;
    
    for(NSString *colorString in myArray){
        NSNumber *counterNumber = [colorDict objectForKey:colorString];
        
        NSUInteger count = [counterNumber integerValue];
        
        if(count < minQty){
            break;
        }
        NSArray *colors = [colorString componentsSeparatedByString:@"_"];
        NSUInteger r = [[colors objectAtIndex:0] integerValue];
        NSUInteger g = [[colors objectAtIndex:1] integerValue];
        NSUInteger b = [[colors objectAtIndex:2] integerValue];
        
        UIColor *applicableColor = [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0];
        
        [dominentColors addObject:applicableColor];
    }
    
    if(dominentColors.count > 4){
        dominentColors = [[dominentColors subarrayWithRange:NSMakeRange(0, 3)] mutableCopy];
    }
    
    if(dominentColors.count < 2){
        dominentColors = [NSMutableArray new];
        for(NSString *colorString in myArray){
            NSArray *colors = [colorString componentsSeparatedByString:@"_"];
            NSUInteger r = [[colors objectAtIndex:0] integerValue];
            NSUInteger g = [[colors objectAtIndex:1] integerValue];
            NSUInteger b = [[colors objectAtIndex:2] integerValue];
            
            UIColor *applicableColor = [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0];
            
            [dominentColors addObject:applicableColor];
        }
        dominentColors = [[dominentColors subarrayWithRange:NSMakeRange(0, 3)] mutableCopy];
        
    }
    
    return dominentColors;
}

-(UIImage *)symmeterizeColor:(UIImage *)sticker dominentColors:(NSArray *)dominentColors {
    
    CGContextRef ctx;
    CGImageRef imageRef = [sticker CGImage];
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char *rawData = malloc(height * width * 4);
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate(rawData, width, height,
                                                 bitsPerComponent, bytesPerRow, colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    CGContextRelease(context);
    
    // Now your rawData contains the image data in the RGBA8888 pixel format.
    int byteIndex = (bytesPerRow * 0) + 0 * bytesPerPixel;
    
    
    for (int ii = 0 ; ii < width * height ; ++ii)
    {
        // Get color values to construct a UIColor
        CGFloat red   = (rawData[byteIndex]     * 1.0) ;
        CGFloat green = (rawData[byteIndex + 1] * 1.0);
        CGFloat blue  = (rawData[byteIndex + 2] * 1.0) ;
        CGFloat alpha = (rawData[byteIndex + 3] * 1.0) ;
        
        for(int i = 0 ; i < dominentColors.count ; i++){
            UIColor *colorToReplace = dominentColors[i];
            //UIColor *withColor = colors[i];
            
//            CGFloat targetRed = 0.0, targetGreen = 0.0, targetBlue = 0.0, alpha1 = 0.0;
//            [withColor getRed:&targetRed green:&targetGreen blue:&targetBlue alpha:&alpha1];
            
            CGFloat sourceRed = 0.0, sourceGreen = 0.0, sourceBlue = 0.0, sourcealpha1 = 0.0;
            [colorToReplace getRed:&sourceRed green:&sourceGreen blue:&sourceBlue alpha:&sourcealpha1];
            
            NSUInteger d =  sqrt(pow((red-(sourceRed * 255)), 2) + pow((green-(sourceGreen * 255)), 2) + pow((blue-(sourceBlue * 255)), 2));
            if(red > 0 && green > 0 && blue > 0){
            
                if(d < 50){
                    NSLog(@"distance ==== %d",d);

                    rawData[byteIndex] = (char) (sourceRed * 255);
                    rawData[byteIndex+1] = (char) (sourceGreen * 255);
                    rawData[byteIndex+2] = (char) (sourceBlue * 255);
                }
            }
        }
        
        byteIndex += 4;
    }
    
    ctx = CGBitmapContextCreate(rawData,
                                CGImageGetWidth( imageRef ),
                                CGImageGetHeight( imageRef ),
                                8,
                                CGImageGetBytesPerRow( imageRef ),
                                CGImageGetColorSpace( imageRef ),
                                kCGImageAlphaPremultipliedLast );
    
    imageRef = CGBitmapContextCreateImage (ctx);
    UIImage* rawImage = [UIImage imageWithCGImage:imageRef];
    
    CGContextRelease(ctx);
    free(rawData);
    return rawImage;
}

- (void)subscriptionSuccesFull{
    [self.collectionView reloadData];
}

@end


