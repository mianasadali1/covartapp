//
//  MemeTool.m
//  BasicFilters
//
//  Created by Kanwarpal Singh on 19/08/17.
//  Copyright © 2017 Kanwarpal Singh. All rights reserved.
//

#import "MemeTool.h"
#import "ToolBarItem.h"
#import "UIView+Frame.h"
#import "UIImage+Utility.h"
#import "FMPhotoPickerExample-Swift.h"

@implementation MemeTool

- (void)initMenuScrollView
{
    if(self.menuScrollView==nil){
        UIScrollView *menuScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.editor.view.width, kMenuBarHeight)];
        menuScroll.top = self.editor.view.height - menuScroll.height;
        menuScroll.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        menuScroll.showsHorizontalScrollIndicator   =   NO;
        menuScroll.showsVerticalScrollIndicator     =   NO;
        
        [self.editor.view addSubview:menuScroll];
        self.menuScrollView = menuScroll;
    }
    self.menuScrollView.transform           =   CGAffineTransformMakeTranslation(0, self.editor.view.height - self.menuScrollView.top);

}

-(UIBarButtonItem *)buttonWithImageName:(NSString *)imageName selector:(SEL)selector{
    UIImage *image = [UIImage imageNamed:imageName];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake( 0, 0, 30, 30 );
    //btn.tintColor   =   [UIColor whiteColor]
    [btn setImage:image forState:UIControlStateNormal];
    btn.clipsToBounds   = true;
    [btn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barBtn = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    return barBtn;
}

- (void)setup
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardWillHideNotification object:nil];
    _thumbnailImage = [_originalImage resize:self.editor.imageView.frame.size];

    [self initMenuScrollView];
    [self setMenu];
    [self addTextViews];
    
    [UIView animateWithDuration:kCLImageToolAnimationDuration
                     animations:^{
                         self.menuScrollView.transform = CGAffineTransformIdentity;
                     }
                     completion:^(BOOL finished) {
                     }];
}

-(void)addTextViews{
    textField                       =   [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    textField.backgroundColor       =   [UIColor clearColor];
    textField.delegate              =   self;
    topTextView                     =   [[UILabel alloc]initWithFrame:CGRectMake(20, 20, self.editor.imageView.frame.size.width - 40, 80)];
    topTextView.textColor           =   [UIColor whiteColor];
    topTextView.backgroundColor     =   [UIColor clearColor];
    topTextView.text                =   @"Top";
    topTextView.textAlignment       =   NSTextAlignmentCenter;
    topTextView.font                =   [UIFont systemFontOfSize:40];
    topTextView.adjustsFontSizeToFitWidth   =   true;
    topTextView.numberOfLines       =   0;
    
    bottomTextView                  =   [[UILabel alloc]initWithFrame:CGRectMake(20, self.editor.imageView.frame.size.height - 100, self.editor.imageView.frame.size.width - 40, 80)];
    bottomTextView.text             =   @"Bottom";
    bottomTextView.textColor        =   [UIColor whiteColor];
    bottomTextView.backgroundColor  =   [UIColor clearColor];
    bottomTextView.textAlignment    =   NSTextAlignmentCenter;
    bottomTextView.font             =   [UIFont systemFontOfSize:40];
    bottomTextView.adjustsFontSizeToFitWidth   =   true;
    bottomTextView.numberOfLines    =   0;

    [self.editor.imageView addSubview:textField];

    [self.editor.imageView addSubview:topTextView];
    [self.editor.imageView addSubview:bottomTextView];
}

-(void)topTapGesture:(UITapGestureRecognizer *)gesture{
    selectedTextView        =   (UILabel *)[gesture view];
    textField.text          =   selectedTextView.text;
    [textField becomeFirstResponder];
}

-(void)bottomGesture:(UITapGestureRecognizer *)gesture{
    selectedTextView        =   (UILabel *)[gesture view];
    textField.text          =   selectedTextView.text;

    [textField becomeFirstResponder];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{

    return true;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView{

    [self.editor.view endEditing:YES];
    
    return true;
}

- (void)keyboardDidShow:(NSNotification *)notification
{
   // isKeyboardShowing   =   YES;
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    // [UIView animateWithDuration:0.0 animations:^{
    CGRect f            =   _toolBarView.frame;
    f.origin.y          =   f.origin.y - keyboardSize.height - f.size.height;
    _toolBarView.frame  =   f;
    //}];
}

-(void)keyboardDidHide:(NSNotification *)notification
{
   // isKeyboardShowing   =   NO;
    
    // [UIView animateWithDuration:0.0 animations:^{
    //        CGRect f            =   _toolBarView.frame;
    //        f.origin.y          =   self.editor.view.frame.size.height;
    //        _toolBarView.frame =    f;
    //}];
}

- (void)textViewDidChange:(UITextView *)textView{
    selectedTextView.text   =   textView.text;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if([text isEqualToString:@"\n"]) {
        _activeTextView.text    = _textView.text;
        [_textView resignFirstResponder];
        [_toolBarView removeFromSuperview];
        [_textView removeFromSuperview];
        [self swapMenuToShowSettings:NO];
        return NO;
    }
    
    return YES;
}

- (void)cleanup
{
    [textField removeFromSuperview];
    [topTextView removeFromSuperview];
    [bottomTextView removeFromSuperview];
    
    self.editor.imageView.userInteractionEnabled = NO;
    self.editor.scrollView.panGestureRecognizer.minimumNumberOfTouches = 1;
    
    [UIView animateWithDuration:kCLImageToolAnimationDuration
                     animations:^{
                         self.menuScrollView.transform = CGAffineTransformMakeTranslation(0, self.editor.view.height-self.menuScrollView.top);
                     }
                     completion:^(BOOL finished) {
                         [self.menuScrollView removeFromSuperview];
                     }];
}

- (void)executeWithCompletionBlock:(void (^)(UIImage *, NSError *, NSDictionary *))completionBlock
{
    [self buildImage:^(UIImage *result) {
        result   =   [UIImage drawImage:result inRect:CGRectMake(0, 0, result.size.width, result.size.height)];

        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock(result, nil, nil);
        });
    }];
}

-(void)buildImage:(void (^)(UIImage *result))completionHandler{
    UIGraphicsBeginImageContextWithOptions(self.editor.imageView.image.size, false, self.editor.view.window.screen.scale);

    dispatch_async(dispatch_get_main_queue(), ^{
        [self.editor.imageView drawViewHierarchyInRect:CGRectMake(0, 0, self.editor.imageView.image.size.width, self.editor.imageView.image.size.height) afterScreenUpdates:true];
        UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        if(completionHandler){
            completionHandler(img);
        }
    });
}

#pragma mark-

- (void)setMenu
{
    for(UIView *v in self.menuScrollView.subviews){
        [v removeFromSuperview];
    }
    
    CGFloat W = 70;
    CGFloat H = self.menuScrollView.height;
    CGFloat x = 0;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        W   =   100;
    }
    
    NSArray *_menu = @[
                       @{@"title":@"Top", @"icon":[UIImage imageNamed:@"top"]},
                       @{@"title":@"Bottom",@"icon":[UIImage imageNamed:@"bottom"]},
                       @{@"title":@"Color", @"icon":[UIImage imageNamed:@"color"]},
                       @{@"title":@"Font",@"icon":[UIImage imageNamed:@"font"]},
                       ];
    
    NSInteger tag = 0;
    for(NSDictionary *obj in _menu){
        ToolBarItem *view = [CLImageEditorTheme menuItemWithFrame:CGRectMake(x, 0, W, H) target:self action:@selector(tappedMenuPanel:) toolInfo:nil isIcon:true];
        view.tag = tag++;
        view.titleLabel.text = obj[@"title"];
        view.iconView.image = obj[@"icon"];
        
        [self.menuScrollView addSubview:view];
        x += W;
    }
    
    self.menuScrollView.contentSize = CGSizeMake(x, 0);
    
    if (self.menuScrollView.contentSize.width < self.editor.menuScrollView.frame.size.width){
        self.menuScrollView.frame   =   CGRectMake(self.menuScrollView.frame.origin.x, self.menuScrollView.frame.origin.y, self.menuScrollView.contentSize.width, self.menuScrollView.frame.size.height);
        self.menuScrollView.center  =   self.editor.menuScrollView.center;
    }
}

- (void)tappedMenuPanel:(UITapGestureRecognizer*)sender
{
    ToolBarItem *view = (ToolBarItem*)sender.view;
    
    switch (view.tag) {
        case 0:
            [self beginTextEditing:topTextView];
            break;
        case 1:
            [self beginTextEditing:bottomTextView];
            break;
        case 2:
            [self addColorPicker];
            break;
        case 3:
            [self addFontPicker];
            break;
    }
    [self swapMenuToShowSettings:YES];
}

- (void)beginTextEditing:(UILabel *)txtView
{
    selectedTextView =
    txtView;
    _activeTextView =   txtView;
    _textView                       =   [[UITextView alloc] initWithFrame:CGRectMake(10, 5, self.editor.view.frame.size.width - 80, 40)];
    _textView.delegate              =   self;
    _textView.backgroundColor       =   self.editor.barColor;
    _textView.layer.cornerRadius    =   5.0f;
    _textView.text                  =   txtView.text;
    _textView.layer.borderColor     =   [UIColor whiteColor].CGColor;
    _textView.layer.borderWidth     =   1;
    _textView.textColor             =   [UIColor whiteColor];
    
    UIButton *doneBtn               =   [UIButton buttonWithType:UIButtonTypeCustom];
    doneBtn.frame                   =   CGRectMake(self.editor.view.frame.size.width - 60, 0, 60, 50);
    [doneBtn setTitle:@"Done" forState:UIControlStateNormal];
    [doneBtn addTarget:self action:@selector(doneTextEnter:) forControlEvents:UIControlEventTouchUpInside];
    [doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
    _toolBarView                    =   [[UIView alloc]initWithFrame:CGRectMake(0, self.editor.view.frame.size.height, self.editor.view.frame.size.width, 50)];
    _toolBarView.backgroundColor    =   self.editor.barColor;
    _toolBarView.layer.borderColor     =   [UIColor whiteColor].CGColor;
    _toolBarView.layer.borderWidth     =   0.5;
    [_toolBarView addSubview:_textView];
    [_toolBarView addSubview:doneBtn];
        
    [self.editor.view addSubview:_toolBarView];
    _textView.text                  =   txtView.text;
    [_textView becomeFirstResponder];
}

-(void)doneTextEnter:(UIButton *)btn{
    _activeTextView.text    = _textView.text;
    [_textView resignFirstResponder];
    [_toolBarView removeFromSuperview];
    [_textView removeFromSuperview];
    [self swapMenuToShowSettings:NO];
}

-(void)addFontPicker{
    _containerView                      =   [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.editor.menuScrollView.frame.size.width, self.menuScrollView.frame.size.height)];
    _containerView.backgroundColor      =   self.editor.barColor;

    [self.menuScrollView addSubview:_containerView];
    
    FontPicker *fontPicker              =   [[FontPicker alloc] initWithFrame:CGRectMake(0, (self.menuScrollView.frame.size.height - 40)/2, _containerView.frame.size.width, 40)];
    fontPicker.delegate                 =   self;
    fontPicker.selectionColor           =   [UIColor whiteColor];
    fontPicker.selectedBorderWidth      =   5;
    fontPicker.cellSpacing              =   10;
    [_containerView addSubview:fontPicker];
    
    UINavigationItem *item  = [[UINavigationItem alloc] initWithTitle:@"Font"];
    item.leftBarButtonItem  =  [self buttonWithImageName:[CLImageEditorTheme localizedString:@"CLImageEditor_BackBtnTitle" withDefault:@"Back"] selector:@selector(crossButtonTapped)];

    [self.editor.navigationBar pushNavigationItem:item animated:true];
    
    _containerView.top = self.editor.view.height ;
    
    [self.editor.view addSubview:_containerView];
    //self.editor.menuScrollView.scrollEnabled   =   false;
}

- (void)didSelectFontAtIndex:(FontPicker *)fontPickerView index:(NSInteger)index font:(NSString *)font{
    selectedFont            =   [UIFont fontWithName:font size:selectedTextView.font.pointSize];
    selectedTextView.font   =  selectedFont;
}

-(void)addColorPicker{
    self.menuScrollView.contentOffset   =    CGPointZero;
    _containerView                      =   [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.editor.menuScrollView.frame.size.width, self.menuScrollView.frame.size.height)];
    _containerView.backgroundColor      =   self.editor.barColor;

    [self.menuScrollView addSubview:_containerView];
    
    MaterialColorPicker *colorPicker    =   [[MaterialColorPicker alloc] initWithFrame:CGRectMake(0, (self.menuScrollView.frame.size.height - 50)/2, _containerView.frame.size.width, 50)];
    colorPicker.delegate                =   self;
    colorPicker.selectionColor          =   [UIColor grayColor];
    colorPicker.selectedBorderWidth     =   5;
    colorPicker.cellSpacing             =   10;
    [_containerView addSubview:colorPicker];
    
    UINavigationItem *item  =   [[UINavigationItem alloc] initWithTitle:@"Color"];
    
    item.leftBarButtonItem  =  [self buttonWithImageName:[CLImageEditorTheme localizedString:@"CLImageEditor_BackBtnTitle" withDefault:@"Back"] selector:@selector(crossButtonTapped)];
    [self.editor.navigationBar pushNavigationItem:item animated:true];
   
    _containerView.top = self.editor.view.height - self.menuScrollView.height;

    [self.editor.view addSubview:_containerView];
}

-(void)swapMenuToShowSettings:(BOOL)showMenu{
    
    if(showMenu){
                
        [UIView animateWithDuration:kCLImageToolAnimationDuration animations:^{
            for(UIView *subView in self.menuScrollView.subviews){
                if ([subView isKindOfClass:[ToolBarItem class]]) {
                    subView.alpha  = 1.0;
                }
            }
        }];
        
        _containerView.frame  = CGRectMake(_containerView.frame.origin.x,  self.menuScrollView.top + _containerView.frame.size.height, _containerView.frame.size.width, _containerView.frame.size.height);
        
        [UIView animateWithDuration:kCLImageToolAnimationDuration
                         animations:^{
                             _containerView.frame  = CGRectMake(_containerView.frame.origin.x, self.menuScrollView.top, _containerView.frame.size.width, _containerView.frame.size.height);
                         }
         ];
    }
    else{
        [UIView animateWithDuration:kCLImageToolAnimationDuration
                         animations:^{
                             for(UIView *subView in self.menuScrollView.subviews){
                                 subView.alpha  = 1.0;
                             }
                         }
         ];
        
        [UIView animateWithDuration:kCLImageToolAnimationDuration
                         animations:^{
                             _containerView.frame  = CGRectMake(_containerView.frame.origin.x, self.menuScrollView.top + _containerView.frame.size.height, _containerView.frame.size.width, _containerView.frame.size.height);
                         } completion:^(BOOL finished) {
                             self.menuScrollView.scrollEnabled   =   true;
                             [_containerView removeFromSuperview];
                         }
         ];
    }
}

- (void)didSelectColorAtIndex:(MaterialColorPicker *)MaterialColorPickerView index:(NSInteger)index color:(UIColor *)color{
    selectedColor = color;
    selectedTextView.textColor              =   selectedColor;
    self.menuScrollView.scrollEnabled       =   true;
}

-(void)crossButtonTapped{
    [self.editor.navigationBar popNavigationItemAnimated:YES];
    self.menuScrollView.scrollEnabled   =   true;
    
    [self swapMenuToShowSettings:NO];
}

@end
