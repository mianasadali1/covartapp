//
//  CLTextTool.h
//
//  Created by sho yakushiji on 2013/12/15.
//  Copyright (c) 2013年 CALACULU. All rights reserved.
//

#import "CLImageToolBase.h"
#import "FMPhotoPickerExample-Swift.h"
#import "NSAttributedString+DVSTracking.h"

@interface CLTextTool : CLImageToolBase<UICollectionViewDelegate,UICollectionViewDataSource>
{
    TZSegmentedControl *seg;
    NSMutableArray *_quotesMenu;
    NSArray *_quotesList;

    NSUInteger selectedIndex;
    int textSpacing;
    
}

@property (nonatomic, strong) UICollectionView *quotesCollectionView;
@property (nonatomic, strong) UIView *quotesContainerView;

@end
