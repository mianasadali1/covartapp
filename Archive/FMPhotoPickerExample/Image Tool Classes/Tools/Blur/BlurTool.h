//
//  BlurTool.h
//  BasicFilters
//
//  Created by Kanwarpal Singh on 07/08/17.
//  Copyright © 2017 Kanwarpal Singh. All rights reserved.
//

#import "CLImageToolBase.h"
#import "SelectorsList.h"

@interface BlurTool : CLImageToolBase
{
    NSUInteger lastScrolPoint;
    NSUInteger selectedShapeNumber;
    NSUInteger lastSliderValue;
    NSMutableArray* blurShapesList;
    NSUInteger pattern;
    UIActivityIndicatorView *indicator;
    double  patternAlpha;
    UIImage *patterenImg;
    
}

@property (nonatomic, strong) UIView *sliderView;

@end
