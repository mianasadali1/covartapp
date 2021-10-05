//
//  CLBlurTool.m
//
//  Created by sho yakushiji on 2013/10/19.
//  Copyright (c) 2013年 CALACULU. All rights reserved.
//

#import "SmokeTool.h"
#import "SelectorsList.h"
#import "UIImage+Utility.h"
#import "UIView+Frame.h"
#import "UIView+Toast.h"
#import "InAppPurchases.h"
#import "Constant.h"

static NSString* const kCLBlurToolNormalIconName = @"nonrmalIconAssetsName";
static NSString* const kCLBlurToolCircleIconName = @"circleIconAssetsName";
static NSString* const kCLBlurToolBandIconName = @"bandIconAssetsName";

typedef NS_ENUM(NSUInteger, CLBlurType)
{
    kCLBlurTypeNormal = 0,
    kCLBlurTypeCircle,
    kCLBlurTypeBand,
};


@interface CLBlurCircleOverlaySmoke : UIView
@property (nonatomic, strong) UIColor *color;
@end

@interface CLBlurBandOverlaySmoke : UIView
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, assign) CGFloat rotation;
@property (nonatomic, assign) CGFloat scale;
@property (nonatomic, assign) CGFloat offset;
@end



@interface SmokeTool()<UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIView *selectedMenu;
@end

@implementation SmokeTool
{
    UIImage *_patternImage;
    UIImage *_lastPatternImage;
    UISlider *_alphaSlider;
    UIScrollView *_menuScroll;
    
    UIView *_handlerView;
    
    CLBlurCircleOverlaySmoke *_circleView;
    CLBlurBandOverlaySmoke *_bandView;
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

-(NSArray *)getImagesFromEffectFolder{
    NSString * resourcePath = [[NSBundle mainBundle] resourcePath];
    NSString * bokehPath = [resourcePath stringByAppendingPathComponent:@"Smoke"];
    
    NSError * error;
    NSArray * directoryContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:bokehPath error:&error];
    
    NSMutableArray*filterImages      =   [NSMutableArray new];
    
    for(NSString *imageName in directoryContents){
        NSString *imagePath = [bokehPath stringByAppendingPathComponent:imageName];
        
        [filterImages addObject:imagePath];
    }
    
    return filterImages;
}

- (void)setup{
    _overlayColorsImgs = [self loadStickersFromDirectory:@"LightLeaks"];
    
    if (_overlayColorsImgs.count == 0){
        [self downloadFlares];
    }
    
    patternAlpha    =   1;
    _blurType       =   kCLBlurTypeNormal;
    _originalImage  =   self.editor.imageView.image;
    _thumbnailImage =   [_originalImage resize:CGSizeMake(_originalImage.size.width/2, _originalImage.size.height/2)];
    _iconImage      =   [_originalImage resize:CGSizeMake(_originalImage.size.width/5, _originalImage.size.height/5)];

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
    
    [self setDefaultParams];
    if (_overlayColorsImgs.count != 0){
        _patternImage   =   [UIImage imageWithContentsOfFile:[_overlayColorsImgs objectAtIndex:0]];
        _patternImage   =   [_patternImage resize:CGSizeMake(_patternImage.size.width, _patternImage.size.height)];
        [self buildThumbnailImage];
        [self resizeSticker:1];
    }

    
    self.editor.view.userInteractionEnabled    = true;
}

-(void)downloadFlares{
    BOOL isStickerAvailable = [[NSUserDefaults standardUserDefaults] boolForKey:@"Smoke"];
    
    if (isStickerAvailable == false){
        // show downloaing View
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.editor.view animated:YES];
        hud.mode = MBProgressHUDModeAnnularDeterminate;
        hud.label.text = @"Downloading";
        
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
        
        NSURL *URL = [NSURL URLWithString:kSmokeAndDustAssets];
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
            
            [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"Smoke"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [hud removeFromSuperview];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                _overlayColorsImgs = [self loadStickersFromDirectory:@"Smoke"];
                
                _patternImage   =   [UIImage imageWithContentsOfFile:[_overlayColorsImgs objectAtIndex:0]];
                _patternImage   =   [_patternImage resize:CGSizeMake(_patternImage.size.width, _patternImage.size.height)];
                [self buildThumbnailImage];
                [self resizeSticker:1];
                
                [self.collectionView reloadData];
            });
        }];
        [downloadTask resume];
    }
    else{
        _overlayColorsImgs = [self loadStickersFromDirectory:@"Smoke"];
        [self.collectionView reloadData];
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

- (void)cleanup
{
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

-(void)addColelctionView{
    [self.collectionView removeFromSuperview];
    
    UICollectionViewFlowLayout *collectionViewLayout    =   [[UICollectionViewFlowLayout alloc] init];
    collectionViewLayout.sectionInset                   =   UIEdgeInsetsMake(0, 0, 0, 0);
    collectionViewLayout.minimumInteritemSpacing        =   0;
    collectionViewLayout.minimumLineSpacing             =   0;
    collectionViewLayout.scrollDirection                =   UICollectionViewScrollDirectionHorizontal;
    self.collectionView                                 =   [[UICollectionView alloc] initWithFrame:CGRectMake(0, _menuScroll.frame.size.height - 80, _menuScroll.frame.size.width, 70) collectionViewLayout:collectionViewLayout];
    
    [self.collectionView setDataSource:self];
    [self.collectionView setDelegate:self];
    [self.collectionView setBackgroundColor:self.editor.barColor];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    [_menuScroll addSubview:self.collectionView];
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGSize cellSize = CGSizeMake(70 , 70 );
    
    return cellSize;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _overlayColorsImgs.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier         =   @"Cell";
    
    UICollectionViewCell *cell          =   [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    for(UIView *v1 in [cell.contentView subviews]){
        [v1 removeFromSuperview];
    }
    
    NSString *currentStickerPath    =   [_overlayColorsImgs objectAtIndex:indexPath.row];
    __block UIImage *stickerImg = [UIImage imageWithContentsOfFile:currentStickerPath];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        stickerImg  = [stickerImg resize:CGSizeMake(stickerImg.size.width, stickerImg.size.height)];
        UIImage *stickerImgIcon   =   [stickerImg resize:CGSizeMake(_iconImage.size.width, _iconImage.size.height)];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            UIImageView *stickerImgView     =   [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, cell.frame.size.width - 10, cell.frame.size.height - 10)];
            
            patternAlpha = 1;
            stickerImgView.clipsToBounds       =   true;
            stickerImgView.image    = stickerImgIcon;
            
            stickerImgView.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
            stickerImgView.layer.borderWidth = 1;
            
            //stickerImgView.backgroundColor = [UIColor purpleColor];
            [cell.contentView addSubview:stickerImgView];
        });
    });
    
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    _patternImage   =   [UIImage imageWithContentsOfFile:[_overlayColorsImgs objectAtIndex:indexPath.row]];
    _patternImage = [_patternImage resize:CGSizeMake(_patternImage.size.width, _patternImage.size.height)];

    [self buildThumbnailImage];
}


-(void)purchaseProduct:(NSString *)inAppId{
    [[MKStoreKit sharedKit] initiatePaymentRequestForProductWithIdentifier:Pro_In_App_Id];
    [[NSNotificationCenter defaultCenter] addObserverForName:kMKStoreKitProductPurchasedNotification
                                                      object:nil
                                                       queue:[[NSOperationQueue alloc] init]
                                                  usingBlock:^(NSNotification *note) {
                                                      
                                                      NSLog(@"Purchased/Subscribed to product with id: %@", [note object]);
                                                      
                                                      NSLog(@"%@", [[MKStoreKit sharedKit] valueForKey:@"purchaseRecord"]);
                                                      
                                                      
                                                      dispatch_async(dispatch_get_main_queue(), ^{
                                                          [self.collectionView reloadData];
                                                      });
                                                  }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:kMKStoreKitProductPurchaseFailedNotification
                                                      object:nil
                                                       queue:[[NSOperationQueue alloc] init]
                                                  usingBlock:^(NSNotification *note) {
                                                      // purchase failed
                                                  }];
    
}


- (void)setMainMenu
{
    [self addColelctionView];
}

-(void)tappedOverlayPatternMenu:(UITapGestureRecognizer*)sender{
    UIView *view    =   sender.view;
    overlayPattern  =   view.tag;
    _patternImage   =   [UIImage imageWithContentsOfFile:[_overlayColorsImgs objectAtIndex:view.tag]];

    [self buildThumbnailImage];
}

- (void)setSelectedMenu:(UIView *)selectedMenu{
    if(selectedMenu != _selectedMenu){
        _selectedMenu.backgroundColor = [UIColor clearColor];
        _selectedMenu = selectedMenu;
        //_selectedMenu.backgroundColor = [CLImageEditorTheme toolbarSelectedButtonColor];
    }
}

- (void)setHandlerView
{
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panHandlerView:)];
    UIPinchGestureRecognizer *pinch    = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchHandlerView:)];
    UIRotationGestureRecognizer *rot   = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotateHandlerView:)];
    
    panGesture.maximumNumberOfTouches = 1;
    
    pinch.delegate = self;
    rot.delegate = self;
    
    [_handlerView addGestureRecognizer:panGesture];
    [_handlerView addGestureRecognizer:pinch];
    [_handlerView addGestureRecognizer:rot];
}

- (void)setDefaultParams
{
    _circleView = [[CLBlurCircleOverlaySmoke alloc] initWithFrame:self.editor.imageView.bounds];
    _circleView.backgroundColor = [UIColor clearColor];
    _circleView.color = [UIColor whiteColor];
    
    CGFloat H = _handlerView.height;
    CGFloat R = sqrt((_handlerView.width*_handlerView.width) + (_handlerView.height*_handlerView.height));
    
    _bandView = [[CLBlurBandOverlaySmoke alloc] initWithFrame:CGRectMake(0, 0, R, H)];
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

- (void)buildThumbnailImage{
    static BOOL inProgress = NO;
    
    if(inProgress){ return; }
    
    inProgress = YES;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *image  =   [self buildResultImage:_thumbnailImage withBlurImage:_patternImage];
        
        [self.editor.imageView performSelectorOnMainThread:@selector(setImage:) withObject:image waitUntilDone:NO];
        inProgress = NO;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [indicator stopAnimating];
            [indicator removeFromSuperview];
        });
    });
}

- (UIImage*)buildResultImage:(UIImage*)image withBlurImage:(UIImage*)blurImage{
    UIImage *result = blurImage;
    result = [self circleBlurImage:image withBlurImage:blurImage];
    
    return result;
}

- (UIImage*)blendImage:(UIImage*)image withBlurImage:(UIImage*)blurImage
{
    CGBlendMode filterName  =   [self filterName:blendMode];
    
    UIImage *bottomImage = image;
    //UIImage *image = blurImage;
    
    CGSize newSize = CGSizeMake(bottomImage.size.width, bottomImage.size.height);
    UIGraphicsBeginImageContext( newSize );
    [bottomImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    [blurImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height) blendMode:filterName alpha:patternAlpha];
    
    UIImage *blendedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return blendedImage;
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

- (UIImage*)circleBlurImage:(UIImage*)image withBlurImage:(UIImage*)blurImage{
    
    CGFloat ratio = image.size.width / self.editor.imageView.width;
    CGRect frame  = _circleView.frame;
    frame.size.width  *= ratio;
    frame.size.height *= ratio;
    frame.origin.x *= ratio;
    frame.origin.y *= ratio;
    
    UIImage *mask       =   blurImage;
    UIGraphicsBeginImageContext(image.size);
    {
        CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext() , [[UIColor blackColor] CGColor]);
        CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, image.size.width, image.size.height));
        [mask drawInRect:frame];
        mask = UIGraphicsGetImageFromCurrentImageContext();
    }
    UIGraphicsEndImageContext();
    
    return [self blendImage:image withBlurImage:mask];
}

#pragma mark- Gesture handler

- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
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
    return kCGBlendModeScreen;
}

@end


#pragma mark- UI components

@implementation CLBlurCircleOverlaySmoke

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




@implementation CLBlurBandOverlaySmoke

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

