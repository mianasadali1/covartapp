//
//  BlendLayersTool.h
//  BasicFilters
//
//  Created by Kanwarpal Singh on 21/08/17.
//  Copyright © 2017 Kanwarpal Singh. All rights reserved.
//

#import "CLImageToolBase.h"

#define kOverlayAlpha  0.05


@interface BlendLayersTool : CLImageToolBase<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,UIGestureRecognizerDelegate>
@property (nonatomic, weak) UIScrollView *menuScrollView;
@property (nonatomic, strong) UIView *sliderView;

@end
