//
//  CLRotateTool.h
//
//  Created by sho yakushiji on 2013/11/08.
//  Copyright (c) 2013年 CALACULU. All rights reserved.
//

#import "CLImageToolBase.h"
#import "UIRotateImageView.h"

#define kRotateRight -M_PI/2
#define kRotateLeft  M_PI/2

@interface CLRotateTool : CLImageToolBase

@property (strong, nonatomic) UIRotateImageView *imgvPhoto;
@property (strong, nonatomic) UIView *viewLayer;
@property (strong, nonatomic) UIView *view1;
@property (strong, nonatomic) UIView *view2;

@end
