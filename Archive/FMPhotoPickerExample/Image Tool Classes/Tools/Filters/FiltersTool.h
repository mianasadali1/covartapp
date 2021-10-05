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

#import "CLCircleView.h"
#import "CLEmoticonView.h"
#import "CIFilter+Filter.h"

static NSString* const kCLEmoticonToolEmoticonPathKey = @"EmoticonPath";
static NSString* const kCLEmoticonToolDeleteIconName = @"deleteIconAssetsName";


@interface FiltersTool : CLImageToolBase
{
    NSUInteger blendMode;
    NSUInteger pattern;
    double patternAlpha;
    NSUInteger patternblur;
    UIActivityIndicatorView *indicator;
    UIView *_workingView;
//    NSMutableArray* _bokehImgs;
    NSArray *_filtersMenu;
    NSMutableArray *_filtersImages;


}
@end
