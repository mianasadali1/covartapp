//
//  CLEffectBase.m
//
//  Created by sho yakushiji on 2013/10/23.
//  Copyright (c) 2013年 CALACULU. All rights reserved.
//

#import "CLEffectBase.h"

@implementation CLEffectBase

#pragma mark-



#pragma mark-

- (id)initWithSuperView:(UIView*)superview imageViewFrame:(CGRect)frame toolInfo:(ToolInfo*)info
{
    self = [super init];
    if(self){
        self.toolInfo = info;
    }
    return self;
}

- (void)cleanup
{
    
}

- (BOOL)needsThumbnailPreview
{
    return YES;
}

- (UIImage*)applyEffect:(UIImage*)image
{
    return image;
}

@end
