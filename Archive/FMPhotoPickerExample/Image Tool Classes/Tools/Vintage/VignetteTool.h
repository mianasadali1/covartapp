//
//  VintageTool.h
//  BasicFilters
//
//  Created by Kanwarpal Singh on 19/08/17.
//  Copyright © 2017 Kanwarpal Singh. All rights reserved.
//

#import "CLImageToolBase.h"

@interface VignetteTool : CLImageToolBase
{
    double sliderValue;
}
@property (nonatomic, weak) UIScrollView *menuScrollView;
@end
