//
//  ViewController.m
//  GLViewPagerViewController
//
//  Created by Yanci on 17/4/18.
//  Copyright © 2017年 Yanci. All rights reserved.
//

#import "StartPageViewController.h"
#import "FMPhotoPickerExample-Swift.h"
#import "ViewController.h"


@interface GLPresentViewController : UIViewController
- (id)initWithTitle:(NSString *)title;
@end


@interface GLPresentViewController()
@property (nonatomic,strong)UILabel *presentLabel;
@end

@implementation GLPresentViewController {
    NSString *_title;
    BOOL _setupSubViews;
}
- (id)initWithTitle:(NSString *)title {
    if (self = [super init]) {
        _title = title;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillLayoutSubviews {
}

- (UILabel *)presentLabel {
    if (!_presentLabel) {
        _presentLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    }
    return _presentLabel;
}

@end

@interface StartPageViewController ()<GLViewPagerViewControllerDataSource,GLViewPagerViewControllerDelegate>
@property (nonatomic,strong)NSArray *viewControllers;
@property (nonatomic,strong)NSArray *tagTitles;


@property (nonatomic,assign)BOOL fullfillTabs;  /** Fullfilltabs when tabs width less than view width */
@end

@implementation StartPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Paged Tabs";
    // Do any additional setup after loading the view.
    /// 设置数据源
    self.dataSource = self;
    /// 设置数据委托
    self.delegate = self;
    /// 是否固定标签宽度
    self.fixTabWidth = false;
    /// Tab之间边距
    self.padding = 0;
    /// 是否填充tabs满屏幕
    self.fullfillTabs = NO;
    /// 固定指示器宽度
    self.fixIndicatorWidth = false;
    /// 指示器宽度
    self.indicatorWidth = 0;
    /// 指示器颜色
    self.indicatorColor = [UIColor clearColor];
    /// 头边距
    self.leadingPadding = 0;
    /// 尾边距
    self.trailingPadding = 0;
    /// 默认显示页
    self.defaultDisplayPageIndex = 0;
    /// Tab动画
    self.tabAnimationType = GLTabAnimationType_whileScrolling;
    /// 是否支持阿拉伯，如果是阿拉伯则反转
    self.supportArabic = NO;
    
    self.btnNext.hidden = YES;

    /** 设置内容视图 */
    self.viewControllers = @[
        [[OpalImagePickerRootViewController alloc] init],
        [[ColorListController alloc] init]
        //                             [[GradientsViewController alloc] init]
    ];
    /** 设置标签标题 */
    //    self.tagTitles = @[
    //                       @"Photos",
    //                       @"Colors",
    //                       @"Gradients"
    //                       ];
    self.tagTitles = @[
        @"MY PHOTO",
        @"COLORS"/*,
                  @"Gradients"*/
    ];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(photoSelected:) name:@"photoselectedForEditing" object:nil];
}

//-(void)viewDidDisappear:(BOOL)animated {
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"photoselectedForEditing" object:nil];
//}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = true;
    
    
    [[NSNotificationCenter defaultCenter] addObserverForName:kMKStoreKitProductPurchasedNotification
                                                      object:nil
                                                       queue:[[NSOperationQueue alloc] init]
                                                  usingBlock:^(NSNotification *note) {
        NSLog(@"Purchased/Subscribed to product with id: %@", [note object]);
        NSLog(@"%@", [[MKStoreKit sharedKit] valueForKey:@"purchaseRecord"]);
        [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"IsPro"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self dismissViewControllerAnimated:true completion:^{
                [hud removeFromSuperview];
                [self showDialogMessgae:@"Restore Complete"];
                
            }];
        });
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:kMKStoreKitProductPurchaseFailedNotification
                                                      object:nil
                                                       queue:[[NSOperationQueue alloc] init]
                                                  usingBlock:^(NSNotification *note) {
        // purchase failed
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud removeFromSuperview];
            
            [self showDialogMessgae:@"Purchase failed.. Please try again later"];
        });
    }];
    
    if(self.isSelectingImage == YES) {
        self.viewImage.hidden = YES;
        self.viewImageHeightConstraint.constant = 0;
        self.topLayoutGuide = 80;
        self.btnClose.hidden = NO;
    } else {
        self.viewImage.hidden = NO;
        self.viewImageHeightConstraint.constant = 260;
        self.topLayoutGuide = 265;
        self.btnClose.hidden = YES;
    }
    
}


-(void)showDialogMessgae:(NSString*)message{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@""
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
        
    }];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
    
    
}

-(IBAction)openCamera:(id)sender{
    CameraManager *manager = [CameraManager new];
    [manager openCameraFromView:self completion:^(UIImage * _Nullable image) {
        
        if (image != nil){
            [manager imageEditorWithView:self image:image];
        }
    }];
}

-(IBAction)restorePurchase:(id)sender{
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"Restoring.. Please wait";
    [[MKStoreKit sharedKit] restorePurchases];
}

-(IBAction)openSettings:(id)sender{
    NSString * storyboardName                   =   @"Main";
    NSString * viewControllerID                 =   @"PurchaseViewController";
    UIStoryboard * storyboard                   =   [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    PurchaseViewController * controller         =   [storyboard instantiateViewControllerWithIdentifier:viewControllerID];
    [self presentViewController:controller animated:YES completion:nil];
    
}

- (IBAction)actionButtonNext:(UIButton *)sender {
    NSString * storyboardName = @"Main";
    NSString * viewControllerID = @"ViewController";
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    
    ViewController *controller = [storyboard instantiateViewControllerWithIdentifier:viewControllerID];
    controller.originalImage = _selectedImage.image;
    [self.navigationController pushViewController:controller animated:true];
}

- (IBAction)actionButtonClose:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

-(void)photoSelected:(NSNotification *)notif{
    UIImage *photo = (UIImage *)notif.object;
    self.selectedImage.image = photo;
    self.btnNext.hidden = NO;
    
    if(self.isSelectingImage == YES) {
        [self dismissViewControllerAnimated:YES completion:^{
            [self.sdelegate selecteNewImageGallery:photo];
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"ImageChangedNotification" object:photo];
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - GLViewPagerViewControllerDataSource
- (NSUInteger)numberOfTabsForViewPager:(GLViewPagerViewController *)viewPager {
    return self.viewControllers.count;
}

- (UIView *)viewPager:(GLViewPagerViewController *)viewPager
      viewForTabIndex:(NSUInteger)index {
    UILabel *label = [[UILabel alloc]init];
    label.text = [self.tagTitles objectAtIndex:index];
    label.font = [UIFont systemFontOfSize:16.0];
    /** 默认紫色 */
    if(viewPager.defaultDisplayPageIndex == index) {
        label.textColor = [UIColor colorWithRed:239.0/255.0 green:128.0/255.0 blue:13.0/255.0 alpha:1.0];
    } else {
        label.textColor = [UIColor whiteColor];
    }
    
    label.textAlignment = NSTextAlignmentCenter;
#if 0
    label.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
#endif
    return label;
}

- (UIViewController *)viewPager:(GLViewPagerViewController *)viewPager
contentViewControllerForTabAtIndex:(NSUInteger)index {
    return self.viewControllers[index];
}
#pragma mark - GLViewPagerViewControllerDelegate
- (void)viewPager:(GLViewPagerViewController *)viewPager didChangeTabToIndex:(NSUInteger)index fromTabIndex:(NSUInteger)fromTabIndex {
    UILabel *prevLabel = (UILabel *)[viewPager tabViewAtIndex:fromTabIndex];
    UILabel *currentLabel = (UILabel *)[viewPager tabViewAtIndex:index];
#if 0
    prevLabel.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
    currentLabel.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
#endif
    /* 紫色默认颜色 */
    prevLabel.textColor = [UIColor whiteColor];
    
    /* 灰色高亮颜色 */
    currentLabel.textColor =   [UIColor colorWithRed:239.0/255.0 green:128.0/255.0 blue:13.0/255.0 alpha:1.0];
    
    //    prevLabel.textColor = [UIColor groupTableViewBackgroundColor];
    //
    //    /* 灰色高亮颜色 */
    //    currentLabel.textColor =   [UIColor whiteColor];
}

- (void)viewPager:(GLViewPagerViewController *)viewPager willChangeTabToIndex:(NSUInteger)index fromTabIndex:(NSUInteger)fromTabIndex withTransitionProgress:(CGFloat)progress {
    
    if (fromTabIndex == index) {
        return;
    }
    UILabel *prevLabel = (UILabel *)[viewPager tabViewAtIndex:fromTabIndex];
    UILabel *currentLabel = (UILabel *)[viewPager tabViewAtIndex:index];
    
#if 0
    prevLabel.transform = CGAffineTransformScale(CGAffineTransformIdentity,
                                                 1.0 - (0.1 * progress),
                                                 1.0 - (0.1 * progress));
    currentLabel.transform = CGAffineTransformScale(CGAffineTransformIdentity,
                                                    0.9 + (0.1 * progress),
                                                    0.9 + (0.1 * progress));
    
#endif
    
    currentLabel.textColor =[UIColor colorWithRed:239.0/255.0 green:128.0/255.0 blue:13.0/255.0 alpha:1.0];
    prevLabel.textColor =[UIColor whiteColor];
    
    //    currentLabel.textColor =[UIColor whiteColor];
    //    prevLabel.textColor =[UIColor groupTableViewBackgroundColor];
}

- (CGFloat)viewPager:(GLViewPagerViewController *)viewPager widthForTabIndex:(NSUInteger)index {
    
    return  self.view.frame.size.width / self.viewControllers.count;
    
    static UILabel *prototypeLabel ;
    if (!prototypeLabel) {
        prototypeLabel = [[UILabel alloc]init];
    }
    prototypeLabel.text = [self.tagTitles objectAtIndex:index];
    prototypeLabel.textAlignment = NSTextAlignmentCenter;
    prototypeLabel.font = [UIFont systemFontOfSize:16.0];
#if 0
    prototypeLabel.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
#endif
    return prototypeLabel.intrinsicContentSize.width + (self.fullfillTabs == YES ?  [self tabsFulFillToScreenWidthInset] : 0);
}

#pragma mark - funcs

- (CGFloat)tabsFulFillToScreenWidthInset {
    if ([self isTabsWidthGreaterThanScreenWidth]) {
        return 0.0;
    }
    
    return [self screenleftWidthForTabs] / self.tagTitles.count;
}

- (CGFloat)estimateTabsWidthInView {
    static UILabel *prototypeLabel ;
    if (!prototypeLabel) {
        prototypeLabel = [[UILabel alloc]init];
    }
    prototypeLabel.textAlignment = NSTextAlignmentCenter;
    prototypeLabel.font = [UIFont systemFontOfSize:16.0];
    
    CGFloat estimateTabsWidth = 0.0;
    estimateTabsWidth += self.leadingPadding;
    
    for (NSUInteger i = 0; i < self.tagTitles.count; i++) {
        prototypeLabel.text = [self.tagTitles objectAtIndex:i];
        estimateTabsWidth += prototypeLabel.intrinsicContentSize.width;
        if (i == self.tagTitles.count - 1) {
            estimateTabsWidth += 0;
        }
        else {
            estimateTabsWidth += self.padding;
        }
    }
    estimateTabsWidth+=self.trailingPadding;
    return estimateTabsWidth;
}

- (CGFloat)screenleftWidthForTabs {
    CGFloat tabsWidth = [self estimateTabsWidthInView];
    return self.view.bounds.size.width - tabsWidth;
}

- (BOOL)isTabsWidthGreaterThanScreenWidth {
    return [self screenleftWidthForTabs] < 0 ? true : false;
}

@end
