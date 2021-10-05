//
//  AdjustmentTool.h
//  BasicFilters
//
//  Created by Kanwarpal Singh on 04/08/17.
//  Copyright © 2017 Kanwarpal Singh. All rights reserved.
//

#import "CLImageToolBase.h"
#import "UIImage+Utility.h"
#import "EffectSubTool.h"

@interface CLEffectTool : CLImageToolBase
{
    UIImage *_originalImage;
    UIImage *_thumbnailImage;
    NSUInteger lastScrolPoint;
    NSMutableArray* _overlayColorsImgs;
    double  patternAlpha;

}

@property (nonatomic, weak) UIScrollView *menuScrollView;
@property (nonatomic, strong) UIView *sliderView;
@property (nonatomic, strong) UISlider *slider;
@property (nonatomic, strong) ToolInfo *currentTool;

@end
