//
//  CustomUIView.m
//  BasicFilters
//
//  Created by Kanwarpal Singh on 28/08/17.
//  Copyright © 2017 Kanwarpal Singh. All rights reserved.
//

#import "CustomUIView.h"
#import "UIView+Frame.h"

@implementation CustomUIView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.


- (void)drawRect:(CGRect)rect {
    // Drawing code

    double widthScaleFactor             =   1;
    double heightScaleFactor            =   1;
    
    CGRect updatedRect                  =   CGRectMake(0, 0, self.superview.superview.frame.size.width/widthScaleFactor,self.superview.superview.frame.size.height/heightScaleFactor);
    
    for(UIImageView *imgv in self.subviews){
        CGRect expectedFrame            =   CGRectMake(imgv.left/widthScaleFactor, imgv.top/heightScaleFactor, imgv.width / widthScaleFactor, imgv.height / heightScaleFactor);
            
        CGRect visibleRect              =   CGRectMake(expectedFrame.origin.x - updatedRect.origin.x,expectedFrame.origin.y - updatedRect.origin.y, imgv.width / widthScaleFactor,imgv.height / heightScaleFactor);
            
        [imgv.image drawInRect:visibleRect blendMode:self.blendMode alpha:1.0];
    }
    [super drawRect:rect];
}

@end
