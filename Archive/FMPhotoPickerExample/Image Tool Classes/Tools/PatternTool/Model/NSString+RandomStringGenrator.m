//
//  NSString+RandomStringGenrator.m
//  UnlimitedEffects
//
//  Created by Kanwarpal Singh on 05/09/15.
//  Copyright (c) 2015 Kanwarpal Singh. All rights reserved.
//

#import "NSString+RandomStringGenrator.h"

@implementation NSString (RandomStringGenrator)

+(NSString *)randomHexString{

    NSString *colorsListPath = [[NSBundle mainBundle] pathForResource:@"ColorList"  ofType:@"plist"];
    NSArray *colorsArr = [[NSArray alloc]initWithContentsOfFile:colorsListPath];
    
    NSString *colorHex = [colorsArr objectAtIndex:arc4random()%[colorsArr count]];
    return colorHex;
}


@end
