//
//  ReflectionTool.h
//  BasicFilters
//
//  Created by Kanwarpal Singh on 07/08/17.
//  Copyright © 2017 Kanwarpal Singh. All rights reserved.
//

#import "CLImageToolBase.h"
#import "UIImage+Reflection.h"

@interface ReflectionTool : CLImageToolBase
{
    UIImage *_originalImage;
    UIImage *_thumbnailImage;
    UIImage *tempImage;
}

@property (nonatomic, weak) UIScrollView *menuScrollView;
@property (nonatomic, strong) UIView *sliderView;
@property (nonatomic, strong) UISlider *slider;

@property (nonatomic, strong) ToolInfo *currentTool;

@property (nonatomic) double transparencySliderValue;;
@property (nonatomic) double heightSliderValue;;

@end
