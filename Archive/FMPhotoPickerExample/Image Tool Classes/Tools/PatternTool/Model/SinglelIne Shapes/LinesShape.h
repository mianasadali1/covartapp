//
//  LinesShape.h
//  UnlimitedEffects
//
//  Created by Kanwarpal Singh on 05/12/15.
//  Copyright © 2015 Kanwarpal Singh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "NSNumber+RandomNumberGenrator.h"
#import "RandomObjects.h"
#import "UIColor+HexColors.h"
#import "NSString+RandomStringGenrator.h"

@interface LinesShape : NSObject

+(UIImage *)generateImage:(CGSize)sourceImg effectId:(NSUInteger)effectId;

@end
