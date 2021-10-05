//
//  AdjustmentTool.h
//  BasicFilters
//
//  Created by Kanwarpal Singh on 04/08/17.
//  Copyright © 2017 Kanwarpal Singh. All rights reserved.
//

#import "CLImageToolBase.h"
#import "UIImage+Utility.h"
#import "AdjustmentSubTool.h"

@interface AdjustmentTool : CLImageToolBase
{
    UIImage *_originalImage;
    UIImage *_thumbnailImage;
    NSUInteger lastScrolPoint;
    
    double brightnessValue;
    double exposureValue;
    double contrastValue;
    double saturationValue;
    double vibranceValue;
    double highlightValue;
    double shadowsToolValue;
    double tintValue;
    double gamaValue;
    double hueValue;
    double monochromevalue;
    double posterizeValue;
}

@property (nonatomic, weak) UIScrollView *menuScrollView;
@property (nonatomic, strong) UIView *sliderView;
@property (nonatomic, strong) UISlider *slider;
@property (nonatomic, strong) ToolInfo *currentTool;

@end
