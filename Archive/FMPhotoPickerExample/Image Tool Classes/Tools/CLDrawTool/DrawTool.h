//
//  CLDrawTool.h
//
//  Created by sho yakushiji on 2014/06/20.
//  Copyright (c) 2014年 CALACULU. All rights reserved.
//

#import "CLImageToolBase.h"
#import "FMPhotoPickerExample-Swift.h"
#import "ACEDrawingView.h"


@interface DrawTool : CLImageToolBase<MaterialColorPickerDelegate,SizePickerDelegate,HardnessPickerDelegate,ACEDrawingViewDelegate>

@end
