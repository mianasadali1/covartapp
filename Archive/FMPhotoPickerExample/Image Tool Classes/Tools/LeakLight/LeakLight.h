//
//  EffectsTool.h
//  BasicFilters
//
//  Created by Kanwar on 2/1/18.
//  Copyright © 2018 Kanwarpal Singh. All rights reserved.
//

#import "CLImageToolBase.h"
#import "RandomObjects.h"
#import "UIImage+ImageEffects.h"
#import "UIImage+Utility.h"
#import "MKStoreKit.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"
#import "SSZipArchive.h"
#import "PurchaseViewController.h"

@interface LeakLight : CLImageToolBase<UICollectionViewDelegate,UICollectionViewDataSource,SubscriptionDelegate>
{
    NSUInteger blendMode;
    NSUInteger pattern;
    double patternAlpha;
    NSUInteger patternblur;
    UIActivityIndicatorView *indicator;
    NSArray* _overlayColorsImgs;
    UIImage *_originalImage;
    UIImage *_thumbnailImage;
    UIView *_containerView;
    UIScrollView *_subMenuScroll;
    NSUInteger overlayPattern;
    UIImage *_iconImage;

}

@property (nonatomic, strong) UICollectionView *collectionView;

@end


