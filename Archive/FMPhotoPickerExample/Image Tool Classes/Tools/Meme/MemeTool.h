//
//  MemeTool.h
//  BasicFilters
//
//  Created by Kanwarpal Singh on 19/08/17.
//  Copyright © 2017 Kanwarpal Singh. All rights reserved.
//

#import "CLImageToolBase.h"
#import "FMPhotoPickerExample-Swift.h"

@interface MemeTool : CLImageToolBase<MaterialColorPickerDelegate,FontPickerDelegate,UITextViewDelegate>
{
    UIView *_containerView;
    UILabel* selectedTextView;
    UILabel* topTextView;
    UILabel* bottomTextView;

    UIColor* selectedColor;
    UIFont* selectedFont;
    UITextView *textField;
    UIImage *_thumbnailImage;
    UIImage *_originalImage;
    UITextView *_textView;
    UILabel *_activeTextView;

    UIView *_toolBarView;
}

@property (nonatomic, weak) UIScrollView *menuScrollView;

@end
