//
//  GradientView.m
//  UnlimitedEffects
//
//  Created by Kanwarpal Singh on 03/09/15.
//  Copyright (c) 2015 Kanwarpal Singh. All rights reserved.
//

#import "GradientView.h"

@implementation GradientView

- (void)drawRect:(CGRect)rect
{
    int rndForColorType = [NSNumber randomIntInLimit:2 endLimit:10];
    
    if(rndForColorType < 7){
        UIColor *firstColor     =   RANDOM_COLOR;
        UIColor *secondColor    =   RANDOM_COLOR;
        UIColor *thirdColor     =   RANDOM_COLOR;
        UIColor *fourthColor    =   RANDOM_COLOR;
        UIColor *fifthColor     =   RANDOM_COLOR;
        UIColor *sixthColor     =   RANDOM_COLOR;
        UIColor *seventhColor   =   RANDOM_COLOR;
        UIColor *eighthColor    =   RANDOM_COLOR;
        
        // Create gradient
        NSArray *colors;
        
        int rndValue = [NSNumber randomIntInLimit:0 endLimit:9];
        
        switch (rndValue) {
            case 0:
                colors = [NSArray arrayWithObjects:(id)firstColor.CGColor, (id)secondColor.CGColor, nil];
                break;
            case 1:
                colors = [NSArray arrayWithObjects:(id)firstColor.CGColor, (id)secondColor.CGColor,(id)thirdColor.CGColor, nil];
                break;
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
                colors = [NSArray arrayWithObjects:(id)firstColor.CGColor, (id)secondColor.CGColor,(id)thirdColor.CGColor, (id)fourthColor.CGColor,(id)fifthColor.CGColor,(id)sixthColor.CGColor,(id)seventhColor, nil];
                break;
                
            case 8:
                colors = [NSArray arrayWithObjects:(id)firstColor.CGColor, (id)secondColor.CGColor,(id)thirdColor.CGColor, (id)fourthColor.CGColor,(id)fifthColor.CGColor,(id)sixthColor.CGColor,(id)seventhColor,(id)eighthColor, nil];
                break;
                
            default:
                break;
        }
        
        
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = self.bounds;
        gradient.colors = colors;
        [self.layer insertSublayer:gradient atIndex:0];
    }
    else{
        NSArray *colors = [NSArray arrayWithObjects:(id)RANDOM_COLOR.CGColor,(id)RANDOM_COLOR.CGColor, nil];
        
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = self.bounds;
        gradient.colors = colors;
        [self.layer insertSublayer:gradient atIndex:0];
    }
}

@end
