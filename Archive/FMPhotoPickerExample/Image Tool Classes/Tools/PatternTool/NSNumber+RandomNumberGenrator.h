//
//  NSNumber+RandomNumberGenrator.h
//  UnlimitedEffects
//
//  Created by Kanwarpal Singh on 05/09/15.
//  Copyright (c) 2015 Kanwarpal Singh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNumber (RandomNumberGenrator)

+(int)randomIntInLimit:(int)startLimit endLimit:(int)eLimit;
+(float)randomFloatInLimit:(float)startLimit endLimit:(float)eLimit;
+(float)randomFloatInLimit1:(float)startLimit endLimit:(float)eLimit;
@end
