//
//  UIColor+HexColors.h
//  Watermark
//
//  Created by Graycell on 17/03/15.
//  Copyright (c) 2015 Graycell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RandomObjects.h"

#define RANDOM_COLOR [UIColor colorWithHexString:[NSString randomHexString]]

@interface UIColor (HexColors)
- (NSUInteger)colorCode;

+(UIColor*)colorWithHexString:(NSString*)hex;
@end
