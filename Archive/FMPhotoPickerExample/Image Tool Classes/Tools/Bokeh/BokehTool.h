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
#import "AFDropdownNotification.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"
#import "SSZipArchive.h"


@interface BokehTool : CLImageToolBase<UICollectionViewDelegate,UICollectionViewDataSource>
{
    NSUInteger blendMode;
    NSUInteger pattern;
    double patternAlpha;
    NSUInteger patternblur;
    UIActivityIndicatorView *indicator;
    NSArray* _overlayColorsImgs;
    UIImage *_originalImage;
    UIImage *_thumbnailImage;
    UIImage *_iconImage;

    UIView *_containerView;
    UIScrollView *_subMenuScroll;
    NSUInteger overlayPattern;
}

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) AFDropdownNotification *notification;

@end


