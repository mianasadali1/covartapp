//
//  EffectsTool.h
//  BasicFilters
//
//  Created by Kanwar on 2/1/18.
//  Copyright © 2018 Kanwarpal Singh. All rights reserved.
//

#import "CLImageToolBase.h"
#import "RandomObjects.h"
#import "UIImage+Utility.h"
#import "CLCircleView.h"
#import "CLEmoticonView.h"
#import "SSZipArchive.h"
#import "MBProgressHUD.h"
#import "DEStoreKitManager.h"
#import "FMPhotoPickerExample-Swift.h"
#import "PieChartView.h"
#import "AFNetworking.h"
#import "PurchaseViewController.h"

static NSString* const kCLEmoticonToolEmoticonPathKey = @"EmoticonPath";
static NSString* const kCLEmoticonToolDeleteIconName = @"deleteIconAssetsName";

@interface StickersTool : CLImageToolBase<NSURLConnectionDataDelegate,UICollectionViewDelegate,UICollectionViewDataSource,MaterialColorPickerDelegate,MaterialColorPickerDataSource,SubscriptionDelegate>
{
    NSUInteger blendMode;
    NSUInteger pattern;
    double patternAlpha;
    NSUInteger patternblur;
    UIActivityIndicatorView *indicator;
    UIView *_workingView;
    NSArray *_strickerMenu;
    NSString *currentSticker;
    DEStoreKitManager *storeKit ;
    TZSegmentedControl *seg;
    TZSegmentedControl *settingSeg;

    NSUInteger selectedIndex;
    NSArray *stickerList;
    CLEmoticonView *eView;
    NSUInteger noofColors;
    NSArray *presetList;
    NSArray*dominentColors;
    UIImage *origionalSticker;
    NSString *subscriptionPrice;
    NSArray *categoryText;
}

@property (nonatomic) BOOL isStickerAvailable;
@property (nonatomic, strong) NSString *inAppId;
@property (nonatomic, strong) NSString *currentStickerCategoryName;

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIView *stickersOptionsContainerView;
@property (nonatomic, strong) UIView *stickersSettingContainerView;

@end
