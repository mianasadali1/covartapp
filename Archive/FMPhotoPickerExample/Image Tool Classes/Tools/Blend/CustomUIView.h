//
//  CustomUIView.h
//  BasicFilters
//
//  Created by Kanwarpal Singh on 28/08/17.
//  Copyright © 2017 Kanwarpal Singh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>
@interface CustomUIView : UIView

@property(nonatomic,retain) UIImage *origionalImage;
@property(nonatomic) CGBlendMode blendMode;

@end
