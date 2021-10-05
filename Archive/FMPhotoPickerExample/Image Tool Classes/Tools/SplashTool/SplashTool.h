//
//  CLSplashTool.h
//
//  Created by sho yakushiji on 2014/06/21.
//  Copyright (c) 2014年 CALACULU. All rights reserved.
//

#import "CLImageToolBase.h"

@interface SplashTool : CLImageToolBase

@property (nonatomic, weak) UIScrollView *menuScrollView;
@property (nonatomic, strong) ToolInfo *currentTool;

@end
