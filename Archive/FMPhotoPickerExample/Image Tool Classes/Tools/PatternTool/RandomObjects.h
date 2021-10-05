//
//  RandomObjects.h
//  UnlimitedEffects
//
//  Created by Kanwarpal Singh on 03/12/15.
//  Copyright © 2015 Kanwarpal Singh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UIColor+HexColors.h"

@interface RandomObjects : NSObject

+(float)getRandomSize:(BOOL)asWindow;
+(float)getRandomSpaceForDoubleLine;
+(float)getRandomSizeThatCanExceed;
+(float)getRandomSizeExceed;
+(float)getRandomRadiusSize;
+(float)getRandomArcRadiusSize;
+(int)getRandomBlendType;

+(NSArray *)getRandomGradientColorArray;
+(NSString *)randomHexString;
+(NSArray *)getRandomGradientColorArrayFoNoShape;

@end
