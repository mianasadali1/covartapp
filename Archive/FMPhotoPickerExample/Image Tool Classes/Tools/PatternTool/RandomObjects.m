//
//  RandomObjects.m
//  UnlimitedEffects
//
//  Created by Kanwarpal Singh on 03/12/15.
//  Copyright © 2015 Kanwarpal Singh. All rights reserved.
//

#import "RandomObjects.h"
#import "NSNumber+RandomNumberGenrator.h"
#import "UIColor+HexColors.h"

@implementation RandomObjects

+(float)getRandomSize:(BOOL)asWindow{
    if(asWindow){
        return [self getRandomSizeExceed];
    }
    NSArray *blendTypes = [[NSArray alloc]initWithObjects:@"0.75",@"0.80",@"0.85",@"0.90", nil];
    NSString *blendType = [blendTypes objectAtIndex:arc4random()%[blendTypes count]];
    return [blendType floatValue];
}

+(float)getRandomSpaceForDoubleLine{
    NSArray *blendTypes = [[NSArray alloc]initWithObjects:@"20",@"25",@"30",@"35",@"40",@"45",@"50",@"55", nil];
    NSString *blendType = [blendTypes objectAtIndex:arc4random()%[blendTypes count]];
    return [blendType floatValue];
}

+(float)getRandomSizeThatCanExceed{
    NSArray *blendTypes = [[NSArray alloc]initWithObjects:@"0.75",@"0.80",@"0.85",@"0.90",@"0.95",@"1.00", nil];
    NSString *blendType = [blendTypes objectAtIndex:arc4random()%[blendTypes count]];
    return [blendType floatValue];
}

+(float)getRandomSizeExceed{
    NSArray *blendTypes = [[NSArray alloc]initWithObjects:@"1.40",@"1.50",@"1.60",@"1.70",@"1.80",@"1.90", nil];
    NSString *blendType = [blendTypes objectAtIndex:arc4random()%[blendTypes count]];
    return [blendType floatValue];
}

+(float)getRandomRadiusSize{
    NSArray *blendTypes = [[NSArray alloc]initWithObjects:@"0.10",@"0.15",@"0.20",@"0.25",@"0.30", nil];
    NSString *blendType = [blendTypes objectAtIndex:arc4random()%[blendTypes count]];
    return [blendType floatValue];
}

+(float)getRandomArcRadiusSize{
    NSArray *blendTypes = [[NSArray alloc]initWithObjects:@"0.20",@"0.30",@"0.40",@"0.50",@"0.60",@"0.70",@"0.80", nil];
    NSString *blendType = [blendTypes objectAtIndex:arc4random()%[blendTypes count]];
    return [blendType floatValue];
}

+(int)getRandomBlendType{
    NSArray *blendTypes = [[NSArray alloc]initWithObjects:@"1",@"4", nil];
    NSString *blendType = [blendTypes objectAtIndex:arc4random()%[blendTypes count]];
    return [blendType intValue];
}

+(NSArray *)getRandomGradientColorArray{
    
    // Create gradient
    NSArray *colors;
    
    int rndValue = 2;
    
    if(rndValue < 7){
        
        UIColor *firstColor = [UIColor colorWithHexString:[self randomHexString]];
        UIColor *secondColor = [UIColor colorWithHexString:[self randomHexString]];
        UIColor *thirdColor = [UIColor colorWithHexString:[self randomHexString]];
        UIColor *fourthColor = [UIColor colorWithHexString:[self randomHexString]];
        
        UIColor *fifthColor = [UIColor colorWithHexString:[self randomHexString]];
        UIColor *sixthColor = [UIColor colorWithHexString:[self randomHexString]];
        
        switch (rndValue) {
            case 2:
                colors = [NSArray arrayWithObjects:(id)firstColor.CGColor, (id)secondColor.CGColor, nil];
                break;
            case 3:
                colors = [NSArray arrayWithObjects:(id)firstColor.CGColor, (id)secondColor.CGColor,(id)thirdColor.CGColor, nil];
                break;
                
            case 4:
                colors = [NSArray arrayWithObjects:(id)firstColor.CGColor, (id)secondColor.CGColor,(id)thirdColor.CGColor, (id)fourthColor.CGColor, nil];
                break;
                
            case 5:
                colors = [NSArray arrayWithObjects:(id)firstColor.CGColor, (id)secondColor.CGColor,(id)thirdColor.CGColor, (id)fourthColor.CGColor,(id)fifthColor.CGColor, nil];
                break;
                
            case 6:
                colors = [NSArray arrayWithObjects:(id)firstColor.CGColor, (id)secondColor.CGColor,(id)thirdColor.CGColor, (id)fourthColor.CGColor,(id)fifthColor.CGColor,(id)sixthColor.CGColor, nil];
                break;
                
                
            default:
                break;
        }
    }
    else{
        UIColor *firstColor = [UIColor colorWithHexString:[self randomHexString]];
        colors = [NSArray arrayWithObjects:(id)firstColor.CGColor,(id)firstColor.CGColor, nil];
    }
    
    return colors;
}

+(NSArray *)getRandomGradientColorArrayFoNoShape{
    
    // Create gradient
    NSArray *colors;
    
    int rndValue = [NSNumber randomIntInLimit:0 endLimit:8];
    
    if(rndValue > 1){
        UIColor *firstColor = [UIColor colorWithHexString:[self randomHexString]];
        UIColor *secondColor = [UIColor colorWithHexString:[self randomHexString]];
        UIColor *thirdColor = [UIColor colorWithHexString:[self randomHexString]];
        UIColor *fourthColor = [UIColor colorWithHexString:[self randomHexString]];
        
        UIColor *fifthColor = [UIColor colorWithHexString:[self randomHexString]];
        UIColor *sixthColor = [UIColor colorWithHexString:[self randomHexString]];
        UIColor *seventhColor = [UIColor colorWithHexString:[self randomHexString]];
        UIColor *eighthColor = [UIColor colorWithHexString:[self randomHexString]];
        
        switch (rndValue) {
            case 2:
                colors = [NSArray arrayWithObjects:(id)firstColor.CGColor, (id)secondColor.CGColor, nil];
                break;
            case 3:
                colors = [NSArray arrayWithObjects:(id)firstColor.CGColor, (id)secondColor.CGColor,(id)thirdColor.CGColor, nil];
                break;
                
            case 4:
                colors = [NSArray arrayWithObjects:(id)firstColor.CGColor, (id)secondColor.CGColor,(id)thirdColor.CGColor, (id)fourthColor.CGColor, nil];
                break;
                
            case 5:
                colors = [NSArray arrayWithObjects:(id)firstColor.CGColor, (id)secondColor.CGColor,(id)thirdColor.CGColor, (id)fourthColor.CGColor,(id)fifthColor.CGColor, nil];
                break;
                
            case 6:
                colors = [NSArray arrayWithObjects:(id)firstColor.CGColor, (id)secondColor.CGColor,(id)thirdColor.CGColor, (id)fourthColor.CGColor,(id)fifthColor.CGColor,(id)sixthColor.CGColor, nil];
                break;
                
            case 7:
                colors = [NSArray arrayWithObjects:(id)firstColor.CGColor, (id)secondColor.CGColor,(id)thirdColor.CGColor, (id)fourthColor.CGColor,(id)fifthColor.CGColor,(id)sixthColor.CGColor,(id)seventhColor.CGColor, nil];
                break;
            case 8:
                colors = [NSArray arrayWithObjects:(id)firstColor.CGColor, (id)secondColor.CGColor,(id)thirdColor.CGColor, (id)fourthColor.CGColor,(id)fifthColor.CGColor,(id)sixthColor.CGColor,(id)seventhColor.CGColor,(id)eighthColor.CGColor, nil];
                break;
                
            default:
                colors = [NSArray arrayWithObjects:(id)firstColor.CGColor, (id)firstColor.CGColor, nil];
                break;
        }
    }
    else{
        UIColor *firstColor = [UIColor colorWithHexString:[self randomHexString]];
        colors = [NSArray arrayWithObjects:(id)firstColor.CGColor,(id)firstColor.CGColor, nil];
    }
    
    return colors;
}



+(NSString *)randomHexString{
    NSString *colorsListPath = [[NSBundle mainBundle] pathForResource:@"ColorList"  ofType:@"plist"];
    NSArray *colorsArr = [[NSArray alloc]initWithContentsOfFile:colorsListPath];
    
    NSString *colorHex = [colorsArr objectAtIndex:arc4random()%[colorsArr count]];
    return colorHex;
}
@end
