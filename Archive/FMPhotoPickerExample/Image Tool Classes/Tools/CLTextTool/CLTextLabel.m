//
//  CLTextLabel.m
//
//  Created by sho yakushiji on 2013/12/16.
//  Copyright (c) 2013年 CALACULU. All rights reserved.
//

#import "CLTextLabel.h"

@implementation CLTextLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setOutlineColor:(UIColor *)outlineColor
{
    if(outlineColor != _outlineColor){
        _outlineColor = outlineColor;
        [self setNeedsDisplay];
    }
}

- (void)setOutlineWidth:(CGFloat)outlineWidth
{
    if(outlineWidth != _outlineWidth){
        _outlineWidth = outlineWidth;
        [self setNeedsDisplay];
    }
}

- (void)drawTextInRect:(CGRect)rect
{
    CGSize shadowOffset = self.shadowOffset;
    UIColor *textColor = self.textColor;
    
    CGContextRef c = UIGraphicsGetCurrentContext();
    
    //    CGContextSaveGState(c);
    //    CGContextRotateCTM(c, -(M_PI/2));
    //
    CGContextSetLineWidth(c, self.outlineWidth);
    CGContextSetLineJoin(c, kCGLineJoinRound);
    CGContextSetLineCap(c, kCGLineCapRound);
    //CGContextSetLineDash(c, 5, 20, 4);
    
    
    CGContextSetTextDrawingMode(c, kCGTextStroke);
    // self.textColor =    [UIColor colorWithHue:drand48() saturation:1.0 brightness:1.0 alpha:1.0];
    self.textColor =    self.outlineColor == nil ? [UIColor clearColor] : self.outlineColor;
    
    [super drawTextInRect:rect];
    
    CGContextSetTextDrawingMode(c, kCGTextFill);
    self.textColor = textColor;
//    self.shadowOffset = CGSizeMake(0, 0);
    //self.shadowColor = self.shadowColor == nil ? [UIColor clearColor] : self.shadowColor;
    [super drawTextInRect:rect];
    
    self.shadowOffset = shadowOffset;
}

@end
