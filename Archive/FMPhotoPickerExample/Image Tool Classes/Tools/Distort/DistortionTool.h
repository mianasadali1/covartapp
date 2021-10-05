//
//  BumpTool.h
//  BasicFilters
//
//  Created by Kanwarpal Singh on 04/08/17.
//  Copyright © 2017 Kanwarpal Singh. All rights reserved.
//

#import "CLImageToolBase.h"
#import "UIImage+Utility.h"

@interface DistortionTool : CLImageToolBase
{
    UIImage *_originalImage;
    UIImage *_thumbnailImage;
    NSUInteger lastScrolPoint;
    UIView *_handlerView;
    CGPoint centerPoint;
}

@property (nonatomic, weak) UIScrollView *menuScrollView;
@property (nonatomic, strong) UIView *sliderView;
@property (nonatomic, strong) UISlider *slider1;
//@property (nonatomic, strong) UISlider *slider2;

@property (nonatomic, strong) ToolInfo *currentTool;

@end
