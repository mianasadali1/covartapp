//
//  CLTextTool.m
//
//  Created by sho yakushiji on 2013/12/15.
//  Copyright (c) 2013年 CALACULU. All rights reserved.
//

#import "CLTextTool.h"

#import "CLCircleView.h"
#import "CLColorPickerView.h"
#import "CLFontPickerView.h"
#import "CLTextLabel.h"
#import "FMPhotoPickerExample-Swift.h"

#import "CLTextSettingView.h"
#import "UIView+Frame.h"
#import "ToolBarItem.h"
#import "ViewController.h"

static NSString* const CLTextViewActiveViewDidChangeNotification = @"CLTextViewActiveViewDidChangeNotificationString";
static NSString* const CLTextViewActiveViewDidTapNotification = @"CLTextViewActiveViewDidTapNotificationString";

static NSString* const CLTextViewColorSection = @"CLTextViewColorSection";

static NSString* const kCLTextToolDeleteIconName        =   @"deleteIconAssetsName";
static NSString* const kCLTextToolCloseIconName         =   @"closeIconAssetsName";
static NSString* const kCLTextToolNewTextIconName       =   @"newTextIconAssetsName";
static NSString* const kCLTextToolEditTextIconName      =   @"editTextIconAssetsName";
static NSString* const kCLTextToolFontIconName          =   @"fontIconAssetsName";
static NSString* const kCLTextToolAlignLeftIconName     =   @"alignLeftIconAssetsName";
static NSString* const kCLTextToolAlignCenterIconName   =   @"alignCenterIconAssetsName";
static NSString* const kCLTextToolAlignRightIconName    =   @"alignRightIconAssetsName";


@interface _CLTextView : UIView
@property (nonatomic, strong) NSAttributedString *text;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong) UIColor *fillColor;
@property (nonatomic, strong) UIColor *borderColor;
@property (nonatomic, assign) CGFloat borderWidth;
@property (nonatomic, assign) NSTextAlignment textAlignment;

+ (void)setActiveTextView:(_CLTextView*)view;
- (id)initWithTool:(CLTextTool*)tool;
- (void)setScale:(CGFloat)scale;
- (void)sizeToFitWithMaxWidth:(CGFloat)width lineHeight:(CGFloat)lineHeight;
- (void)setShadowColor:(UIColor *)color;
- (void)setOutlineColor:(UIColor *)color;
- (void)setOutlineWidth:(NSUInteger )width;
- (void)setShadowWidth:(NSUInteger )width;
@end



@interface CLTextTool()
<CLColorPickerViewDelegate, CLFontPickerViewDelegate, UITextViewDelegate, CLTextSettingViewDelegate,MaterialColorPickerDelegate,FontPickerDelegate>
@property (nonatomic, strong) _CLTextView *selectedTextView;
@end

@implementation CLTextTool
{
    UIImage *_originalImage;
    UIView *_workingView;
    
    ToolBarItem *_textBtn;
    ToolBarItem *_colorBtn;
    ToolBarItem *_fontBtn;
    
    ToolBarItem *_alignBtn;
//    ToolBarItem *_alignCenterBtn;
//    ToolBarItem *_alignRightBtn;
    
    UIScrollView *_menuScroll;
    UITextView *_textView;
    UIView *_containerView;
    UIView *_toolBarView;
    BOOL isKeyboardShowing;
}

#pragma mark- implementation

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

+ (NSDictionary*)optionalInfo
{
    return @{
             kCLTextToolDeleteIconName : @"btn_delete.png"
             };
}

- (void)setup
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardWillHideNotification object:nil];

    _originalImage = self.editor.imageView.image;
    
    [self.editor fixZoomScaleWithAnimated:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(activeTextViewDidChange:) name:CLTextViewActiveViewDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(activeTextViewDidTap:) name:CLTextViewActiveViewDidTapNotification object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textToolColorSelected:) name:CLTextViewColorSection object:nil];

    _menuScroll = [[UIScrollView alloc] initWithFrame:self.editor.menuScrollView.frame];
    _menuScroll.backgroundColor = self.editor.menuScrollView.backgroundColor;
    _menuScroll.showsHorizontalScrollIndicator = NO;
    [self.editor.view addSubview:_menuScroll];
    
    _workingView = [[UIView alloc] initWithFrame:[self.editor.view convertRect:self.editor.imageView.frame fromView:self.editor.imageView.superview]];
    _workingView.clipsToBounds = YES;
    [self.editor.view addSubview:_workingView];
    
    [self setMenu];
    
    self.selectedTextView = nil;
    
    _menuScroll.transform = CGAffineTransformMakeTranslation(0, self.editor.view.height-_menuScroll.top);
    [UIView animateWithDuration:kCLImageToolAnimationDuration
                     animations:^{
                         _menuScroll.transform = CGAffineTransformIdentity;
                     }];
}

-(void)addColorPicker{
    [_containerView removeFromSuperview];
    _containerView = nil;
    
    if(_containerView == nil){
        _containerView                      =   [[UIView alloc]initWithFrame:CGRectMake(0,  _menuScroll.top - _menuScroll.frame.size.height, self.editor.view.frame.size.width, _menuScroll.frame.size.height)];
        _containerView.backgroundColor      =   self.editor.barColor;
        
        [self.editor.view addSubview:_containerView];
    }
    else{
        for(UIView *v in _containerView.subviews){
            if([v isKindOfClass:[FontPicker class]] || [v isKindOfClass:[MaterialColorPicker class]] || [v isKindOfClass:[UISlider class]]  || [v isKindOfClass:[TextureColorList class]]){
                [v removeFromSuperview];
            }
        }
    }

    
    MaterialColorPicker *colorPicker    =   [[MaterialColorPicker alloc] initWithFrame:CGRectMake(0, (_menuScroll.frame.size.height - 50)/2, self.editor.view.frame.size.width , 50)];
    
    colorPicker.delegate                =   self;
    colorPicker.selectionColor          =   [UIColor grayColor];
    colorPicker.selectedBorderWidth     =   2;
    colorPicker.cellSpacing             =   10;
    colorPicker.callingClass = @"color";
    [_containerView addSubview:colorPicker];
    
    UINavigationItem *item              =   [[UINavigationItem alloc] initWithTitle:@"COLOR"];
    item.leftBarButtonItem              =   [self buttonWithImageName:[CLImageEditorTheme localizedString:@"CLImageEditor_BackBtnTitle" withDefault:@"Back"] selector:@selector(crossButtonTapped)];
  
    //[self.editor.navigationBar pushNavigationItem:item animated:true];
    
//    _menuScroll.scrollEnabled           =   false;
}

-(void)initShadowSettingView{
    [_containerView removeFromSuperview];
    _containerView = nil;
    
    if(_containerView == nil){
        _containerView                      =   [[UIView alloc]initWithFrame:CGRectMake(0,  _menuScroll.top - (2 *_menuScroll.frame.size.height), self.editor.view.frame.size.width, (2 *_menuScroll.frame.size.height))];
        _containerView.backgroundColor      =   self.editor.barColor;
        
        [self.editor.view addSubview:_containerView];
    }
    else{
        for(UIView *v in _containerView.subviews){
            if([v isKindOfClass:[FontPicker class]] || [v isKindOfClass:[MaterialColorPicker class]] || [v isKindOfClass:[UISlider class]]  || [v isKindOfClass:[TextureColorList class]]){
                [v removeFromSuperview];
            }
        }
    }

    
    UISlider *_shadowSlider = [[UISlider alloc] initWithFrame:CGRectMake(10, 0, self.editor.menuScrollView.frame.size.width - 20, _containerView.frame.size.height/2)];
    
    [_shadowSlider setThumbImage:[UIImage imageNamed:@"slider"] forState:UIControlStateNormal];
    
    [_shadowSlider setMinimumTrackTintColor:[UIColor whiteColor]];
    [_shadowSlider setMaximumTrackTintColor:[UIColor whiteColor]];
    [_shadowSlider setContinuous:NO];

    //_alphaSlider.continuous          =   NO;
    [_shadowSlider addTarget:self action:@selector(shadowSliderChange:) forControlEvents:UIControlEventValueChanged];
    
    _shadowSlider.maximumValue        =   500;
    _shadowSlider.minimumValue        =   0;
    _shadowSlider.value               =   0;
    
    [_containerView addSubview:_shadowSlider];
    
    
    MaterialColorPicker *colorPicker    =   [[MaterialColorPicker alloc] initWithFrame:CGRectMake(0, _containerView.frame.size.height/2, self.editor.view.frame.size.width , _containerView.frame.size.height/2)];
    
    colorPicker.delegate                =   self;
    colorPicker.selectionColor          =   [UIColor grayColor];
    colorPicker.selectedBorderWidth     =   2;
    colorPicker.cellSpacing             =   10;
    colorPicker.tag                     =   2;
    colorPicker.callingClass = @"shadow";
    [_containerView addSubview:colorPicker];
    
}

-(void)initOutlineSettingView{
    [_containerView removeFromSuperview];
    _containerView = nil;
    
    if(_containerView == nil){
        _containerView                      =   [[UIView alloc]initWithFrame:CGRectMake(0,  _menuScroll.top - (2 *_menuScroll.frame.size.height), self.editor.view.frame.size.width, (2 *_menuScroll.frame.size.height))];
        _containerView.backgroundColor      =   self.editor.barColor;
        
        [self.editor.view addSubview:_containerView];
    }
    else{
        for(UIView *v in _containerView.subviews){
            if([v isKindOfClass:[FontPicker class]] || [v isKindOfClass:[MaterialColorPicker class]] || [v isKindOfClass:[UISlider class]]  || [v isKindOfClass:[TextureColorList class]]){
                [v removeFromSuperview];
            }
        }
    }
    
    
    UISlider *_outlineSlider = [[UISlider alloc] initWithFrame:CGRectMake(10, 0, self.editor.menuScrollView.frame.size.width - 20, _containerView.frame.size.height/2)];
    
    [_outlineSlider setThumbImage:[UIImage imageNamed:@"slider"] forState:UIControlStateNormal];
    
    [_outlineSlider setMinimumTrackTintColor:[UIColor whiteColor]];
    [_outlineSlider setMaximumTrackTintColor:[UIColor whiteColor]];
    [_outlineSlider setContinuous:NO];

    //_alphaSlider.continuous          =   NO;
    [_outlineSlider addTarget:self action:@selector(oulineSliderChange:) forControlEvents:UIControlEventValueChanged];
    
    _outlineSlider.maximumValue        =   100;
    _outlineSlider.minimumValue        =   0;
    _outlineSlider.value               =   0;
    
    [_containerView addSubview:_outlineSlider];
    
    
    MaterialColorPicker *colorPicker    =   [[MaterialColorPicker alloc] initWithFrame:CGRectMake(0, (_containerView.frame.size.height/2) + ((_containerView.frame.size.height/2) - 50)/2, self.editor.view.frame.size.width , 50)];

    
   // MaterialColorPicker *colorPicker    =   [[MaterialColorPicker alloc] initWithFrame:CGRectMake(0, _containerView.frame.size.height/2, self.editor.view.frame.size.width , _containerView.frame.size.height/2)];
    
    colorPicker.delegate                =   self;
    colorPicker.selectionColor          =   [UIColor grayColor];
    colorPicker.selectedBorderWidth     =   2;
    colorPicker.cellSpacing             =   10;
    colorPicker.tag                     =   4;
    [_containerView addSubview:colorPicker];
    
}

-(void)oulineSliderChange:(UISlider *)slider{
    [self.selectedTextView setOutlineWidth:slider.value];
}

-(void)shadowSliderChange:(UISlider *)slider{
    [self.selectedTextView setShadowWidth:slider.value];
}

-(void)spacingSliderChange:(UISlider *)slider{
    self.selectedTextView.text = [NSAttributedString dvs_attributedStringWithString:self.selectedTextView.text.string
                                                                          tracking:slider.value
                                                                              font:self.selectedTextView.font];
    
}

-(void)addTextureColorPicker{
    [_containerView removeFromSuperview];
    _containerView = nil;
    
    if(_containerView == nil){
        _containerView                      =   [[UIView alloc]initWithFrame:CGRectMake(0,  _menuScroll.top - _menuScroll.frame.size.height, self.editor.view.frame.size.width, _menuScroll.frame.size.height)];
        _containerView.backgroundColor      =   self.editor.barColor;
        
        [self.editor.view addSubview:_containerView];
    }
    else{
        for(UIView *v in _containerView.subviews){
            if([v isKindOfClass:[FontPicker class]] || [v isKindOfClass:[MaterialColorPicker class]] || [v isKindOfClass:[UISlider class]]  || [v isKindOfClass:[TextureColorList class]]){
                [v removeFromSuperview];
            }
        }
    }

    TextureColorList *colorPicker    =   [[TextureColorList alloc] initWithFrame:CGRectMake(0, (_menuScroll.frame.size.height - 50)/2, self.editor.view.frame.size.width , 50)];
    
    colorPicker.delegate                =   self;
    colorPicker.selectionColor          =   [UIColor grayColor];
    colorPicker.selectedBorderWidth     =   2;
    colorPicker.cellSpacing             =   10;
    
    [_containerView addSubview:colorPicker];
    
    UINavigationItem *item              =   [[UINavigationItem alloc] initWithTitle:@"METALLIC COLOR"];
    item.leftBarButtonItem              =   [self buttonWithImageName:[CLImageEditorTheme localizedString:@"CLImageEditor_BackBtnTitle" withDefault:@"Back"] selector:@selector(crossButtonTapped)];
    
    //[self.editor.navigationBar pushNavigationItem:item animated:true];
    
//    _menuScroll.scrollEnabled           =   false;
}

-(void)addFontPicker{
    [_containerView removeFromSuperview];
    _containerView = nil;
    
    if(_containerView == nil){
        _containerView                      =   [[UIView alloc]initWithFrame:CGRectMake(0,  _menuScroll.top - _menuScroll.frame.size.height, self.editor.view.frame.size.width, _menuScroll.frame.size.height)];
        _containerView.backgroundColor      =   self.editor.barColor;
        
        [self.editor.view addSubview:_containerView];
    }
    else{
        for(UIView *v in _containerView.subviews){
            if([v isKindOfClass:[FontPicker class]] || [v isKindOfClass:[MaterialColorPicker class]] || [v isKindOfClass:[UISlider class]]  || [v isKindOfClass:[TextureColorList class]]){
                [v removeFromSuperview];
            }
        }
    }

    
    FontPicker *fontPicker              =   [[FontPicker alloc] initWithFrame:CGRectMake(0, (_menuScroll.frame.size.height - 40)/2, self.editor.view.frame.size.width , 40)];
    fontPicker.delegate                 =   self;
    fontPicker.selectionColor           =   [UIColor clearColor];
    fontPicker.selectedBorderWidth      =   5;
    fontPicker.cellSpacing              =   10;
    [_containerView addSubview:fontPicker];
    
    UINavigationItem *item              =   [[UINavigationItem alloc] initWithTitle:@"FONT"];
    item.leftBarButtonItem              =   [self buttonWithImageName:[CLImageEditorTheme localizedString:@"CLImageEditor_BackBtnTitle" withDefault:@"Back"] selector:@selector(crossButtonTapped)];
    //[self.editor.navigationBar pushNavigationItem:item animated:true];
    
//    _menuScroll.scrollEnabled           =   false;
}

-(void)crossButtonTapped{
//    _menuScroll.scrollEnabled           =   true;
    [_textView resignFirstResponder];
    [_toolBarView removeFromSuperview];
    [_textView removeFromSuperview];
    _textView   =   nil;
//    [self swapMenuToShowSettings:NO];
    
    [_containerView removeFromSuperview];
    _containerView =  nil;
}

-(void)swapMenuToShowSettings:(BOOL)showMenu{
    
    if(showMenu){
        
//        [UIView animateWithDuration:kCLImageToolAnimationDuration animations:^{
//            for(UIView *subView in _menuScroll.subviews){
//                if ([subView isKindOfClass:[ToolBarItem class]]) {
//                    subView.alpha  = 0.0;
//                }
//            }
//        }];
        
        _containerView.frame  = CGRectMake(_containerView.frame.origin.x,  _menuScroll.top + _containerView.frame.size.height, _containerView.frame.size.width, _containerView.frame.size.height);
        
        [UIView animateWithDuration:kCLImageToolAnimationDuration
                         animations:^{
                             _containerView.frame  = CGRectMake(_containerView.frame.origin.x, _menuScroll.top - _containerView.frame.size.height, _containerView.frame.size.width, _containerView.frame.size.height);
                         }
         ];
    }
    else{
//        [self.editor.navigationBar popNavigationItemAnimated:YES];
//
//        [UIView animateWithDuration:kCLImageToolAnimationDuration
//                         animations:^{
//                             for(UIView *subView in _menuScroll.subviews){
//                                 subView.alpha  = 1.0;
//                             }
//                         }
//         ];
        
        [UIView animateWithDuration:kCLImageToolAnimationDuration
                         animations:^{
                             _containerView.frame  = CGRectMake(_containerView.frame.origin.x, _menuScroll.top + _containerView.frame.size.height, _containerView.frame.size.width, _containerView.frame.size.height);
                         } completion:^(BOOL finished) {
                             _menuScroll.scrollEnabled   =   true;
                             [_containerView removeFromSuperview];
                             _containerView =  nil;
                         }
         ];
    }
}

- (void)cleanup{
    [self.editor resetZoomScaleWithAnimated:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    [_workingView removeFromSuperview];
    [_menuScroll removeFromSuperview];
    [_quotesContainerView removeFromSuperview];
    [_containerView removeFromSuperview];
    _containerView = nil;
    
    [UIView animateWithDuration:kCLImageToolAnimationDuration
                     animations:^{
                         _menuScroll.transform = CGAffineTransformMakeTranslation(0, self.editor.view.height-_menuScroll.top);
                         _quotesContainerView.transform = CGAffineTransformMakeTranslation(0, self.editor.view.height-_menuScroll.top);

                     }
                     completion:^(BOOL finished) {
                         
                     }];
    
}

- (void)executeWithCompletionBlock:(void (^)(UIImage *, NSError *, NSDictionary *))completionBlock
{
    [_CLTextView setActiveTextView:nil];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *image = [self buildImage:_originalImage];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock(image, nil, nil);
        });
    });
}

#pragma mark-

- (UIImage*)buildImage:(UIImage*)image
{
    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
    
    [image drawAtPoint:CGPointZero];
    
    CGFloat scale = image.size.width / _workingView.width;
    CGContextScaleCTM(UIGraphicsGetCurrentContext(), scale, scale);
    [_workingView.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *tmp = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return tmp;
}

- (void)setMenuBtnEnabled:(BOOL)enabled
{
    //_textBtn.userInteractionEnabled =
    //_colorBtn.userInteractionEnabled =
    _fontBtn.userInteractionEnabled =
    _alignBtn.userInteractionEnabled = enabled;
}

- (void)setSelectedTextView:(_CLTextView *)selectedTextView
{
    if(selectedTextView != _selectedTextView){
        _selectedTextView = selectedTextView;
    }
    
    [self setMenuBtnEnabled:(_selectedTextView!=nil)];
}

- (void)activeTextViewDidChange:(NSNotification*)notification
{
    self.selectedTextView = notification.object;
    if(self.selectedTextView){
//       NSAttributedString *attStr  = [NSAttributedString dvs_attributedStringWithString:textView.text
//                                                                               tracking:textSpacing
//                                                                                   font:self.selectedTextView.font];
        [self beginTextEditing:_selectedTextView.text.string];
    }
    else{
        [self.editor.view endEditing:YES];
        [_textView resignFirstResponder];
        [_toolBarView removeFromSuperview];
        [_textView removeFromSuperview];
        _textView   =   nil;
        //[self.editor.navigationBar popNavigationItemAnimated:true];
        
        if(_containerView != nil){
            [_containerView removeFromSuperview];
            _containerView =  nil;
            
            //[self swapMenuToShowSettings:false];
        }
    }
}

- (void)textToolColorSelected:(NSNotification*)notification
{
    UIColor *color = notification.object;
    self.selectedTextView.fillColor     =   color;
}

- (void)activeTextViewDidTap:(NSNotification*)notification
{
    [self beginTextEditing:_selectedTextView.text.string];
}

- (void)setMenu
{
    CGFloat W = 70;
    CGFloat H = _menuScroll.height;
    CGFloat x = (self.editor.view.frame.size.width - (W*5))/2;;

    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        W   =   100;
    }
    
//    var arrOptions: [[String : Any]] = [
//                                        ["icon": "icTextStyle", "iconSel": "icTextStyleSel", "title": "Style"],
//                                        ["icon": "icTextColor", "iconSel": "icTextColorSel", "title": "Color"],
//                                        ["icon": "icTextWatermark", "iconSel": "icTextWatermarkSel", "title": "Watermark"],
//                                        ["icon": "icShadow", "iconSel": "icShadowSel", "title": "Shadow"],
//                                        ["icon": "icTextAlign", "iconSel": "icTextAlignSel", "title": "Align"]
//                                        ]

    NSArray *_menu = @[
                        @{@"title":@"Add", @"icon":[UIImage imageNamed:@"add-text"]},
                       @{@"title":@"Style", @"icon":[UIImage imageNamed:@"icTextStyle"], @"iconSel":[UIImage imageNamed:@"icTextStyleSel"]},
                        @{@"title":@"Color", @"icon":[UIImage imageNamed:@"icTextColor"] },
                        @{@"title":@"Watermark", @"icon":[UIImage imageNamed:@"icTextWatermark"]},
                        @{@"title":@"Shadow", @"icon":[UIImage imageNamed:@"icShadow"]},
                        @{@"title":@"Alignment", @"icon":[UIImage imageNamed:@"icTextAlign"]},
//                        @{@"title":@"Alignment", @"icon":[UIImage imageNamed:@"icTextAlign"]}
//                       @{@"title":@"Quotes", @"icon":[UIImage imageNamed:@"quotes"]},
//                       @{@"title":@"Add", @"icon":[UIImage imageNamed:@"add-text"]},
//                       @{@"title":@"Color", @"icon":[UIImage imageNamed:@"color"] },
//                       @{@"title":@"Metallic", @"icon":[UIImage imageNamed:@"splash"] },
//                       @{@"title":@"Font", @"icon":[UIImage imageNamed:@"font"]},
//                       @{@"title":@"Outline", @"icon":[UIImage imageNamed:@"outline"]},
//                       @{@"title":@"Alignment", @"icon":[UIImage imageNamed:@"t-l"]}

//    NSArray *_menu = @[
//                       @{@"title":@"Captions", @"icon":[UIImage imageNamed:@"caption"]},
//                       @{@"title":@"Quotes", @"icon":[UIImage imageNamed:@"quotes"]},
//                       @{@"title":@"Add", @"icon":[UIImage imageNamed:@"add-text"]},
//                       @{@"title":@"Color", @"icon":[UIImage imageNamed:@"color"] },
//                       @{@"title":@"Metallic", @"icon":[UIImage imageNamed:@"splash"] },
//                       @{@"title":@"Font", @"icon":[UIImage imageNamed:@"font"]},
//                       @{@"title":@"Outline", @"icon":[UIImage imageNamed:@"outline"]},
//                       @{@"title":@"Alignment", @"icon":[UIImage imageNamed:@"t-l"]}

//                       ,
//                       @{@"title":@"Shadow", @"icon":[UIImage imageNamed:@"t-l"]},
                       ];
    
    NSInteger tag = 0;
    for(NSDictionary *obj in _menu){
        ToolBarItem *view = [CLImageEditorTheme menuItemWithFrame:CGRectMake(x, 0, W, H) target:self action:@selector(tappedMenuPanel:) toolInfo:nil isIcon:true];
        view.tag = tag++;
        view.titleLabel.text = obj[@"title"];
        view.iconView.image = obj[@"icon"];
        
        switch (view.tag) {
            case 2:
                //_textBtn = view;
                //_colorBtn   =   view;
                //_colorBtn.iconView.layer.borderWidth = 2;
                //_colorBtn.iconView.layer.borderColor = [[UIColor blackColor] CGColor];
                break;
            case 3:
                _fontBtn    =   view;
                break;
            case 4:
                _alignBtn   = view;
                break;
        }
        
        [_menuScroll addSubview:view];
        x += W;
    }
    
    _menuScroll.contentSize = CGSizeMake(x, 0);
    
//    if (_menuScroll.contentSize.width < self.editor.menuScrollView.frame.size.width){
//        _menuScroll.frame   =   CGRectMake(_menuScroll.frame.origin.x, _menuScroll.frame.origin.y, _menuScroll.contentSize.width, _menuScroll.frame.size.height);
//        _menuScroll.center  =   self.editor.menuScrollView.center;
//    }
}

- (void)tappedMenuPanel:(UITapGestureRecognizer*)sender
{
    ToolBarItem *view = (ToolBarItem*)sender.view;
    
    switch (view.tag) {
        case 0:
            [self addNewText:@"TITLE"];
            break;
        case 1:
            if(self.selectedTextView){
                [self addFontPicker];
            }
            break;
        case 2:
            if(self.selectedTextView){
                [self addColorPicker];
            }
            break;
        case 3:
            if(self.selectedTextView){
                [_containerView removeFromSuperview];
                _containerView = nil;
                [self.editor waterMark];
            }
            break;
        case 4:
            if(self.selectedTextView){
                [self initShadowSettingView];
            }
            break;
        case 5:
            if(self.selectedTextView){
                [_containerView removeFromSuperview];
                _containerView = nil;
                [self.editor alignmentStateChange];
            }
            break;
        case 6:
            if(self.selectedTextView){
                [self initOutlineSettingView];
            }
            break;

        case 7:
            if(self.selectedTextView){
                [self setTextAlignment:view];
            }
            break;

        case 8:
            if(self.selectedTextView){
                [self initShadowSettingView];
            }
            break;

        case 9:
            if(self.selectedTextView){
               // [self initShadowSettingView];
            }
            break;
    }
}

-(void)openQuotes:(BOOL)isCaption{
    self.quotesContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.editor.view.frame.size.height, self.editor.view.frame.size.width, self.editor.view.frame.size.height - 40)];
    
    self.quotesContainerView.backgroundColor = [UIColor whiteColor];
    
    [self.editor.view addSubview:self.quotesContainerView];
    [self addColelctionView];
    
    if(isCaption){
        _quotesMenu = [[NSUserDefaults standardUserDefaults] objectForKey:@"captionCategoryList"];
    }
    else{
        NSString *optionSelected = [[NSUserDefaults standardUserDefaults] objectForKey:@"optionSelected"];
        
        if ([optionSelected isEqualToString:@"topics"]){
            _quotesMenu = [[[NSUserDefaults standardUserDefaults] objectForKey:@"quoteCategoryList"] mutableCopy];
            [_quotesMenu insertObject:@"RECENT" atIndex:0];
            [_quotesMenu insertObject:@"TOP" atIndex:1];
        }
        else{
            _quotesMenu = [[[NSUserDefaults standardUserDefaults] objectForKey:@"quoteAutherList"] mutableCopy];
            [_quotesMenu insertObject:@"RECENT" atIndex:0];
        }
    }
    
    NSArray *categoryText           =   _quotesMenu;
    seg                             =   [[TZSegmentedControl alloc] init];
    seg.frame                       =   CGRectMake(0, 0, self.quotesContainerView.frame.size.width, 40);
    seg.backgroundColor             =   self.editor.barColor;
    seg.sectionTitles               =   categoryText;
    seg.indicatorWidthPercent       =   0.8;
    seg.borderColor                 =   [UIColor clearColor];
    seg.borderWidth                 =   0.5;
    seg.verticalDividerEnabled      =   false;
    seg.verticalDividerWidth        =   0.5;
    seg.verticalDividerColor        =   [UIColor lightGrayColor];
    seg.selectionIndicatorColor     =   [UIColor whiteColor];
    seg.selectionIndicatorHeight    =   5.0;
    seg.selectedSegmentIndex        =   0;
    
    [self.quotesContainerView addSubview:seg];
    selectedIndex   =   1;
    seg.selectedSegmentIndex = 1;
    [self setStickersListMenu:selectedIndex isCaption:isCaption];
    [self showHideQuoteListView:YES ];

    seg.indexChangeBlock = ^ (NSInteger index) {
        selectedIndex   = index;
        [self showHideQuoteListView:YES ];
        [self setStickersListMenu:selectedIndex isCaption:isCaption];
    };
}

-(void)showHideQuoteListView:(BOOL)toShow {
    if(toShow){
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut  animations:^{
            self.quotesContainerView.frame  =   CGRectMake(0, 40, self.quotesContainerView.frame.size.width, self.quotesContainerView.frame.size.height);
            
        } completion:^(BOOL finished) {
            
        }];
    }
    else{
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveLinear  animations:^{
            
            self.quotesContainerView.frame  =   CGRectMake(0, self.editor.view.frame.size.height, self.quotesContainerView.frame.size.width, self.quotesContainerView.frame.size.height);
        } completion:^(BOOL finished) {
            
        }];
    }
}

-(void)setStickersListMenu:(NSUInteger)viewTag isCaption:(BOOL)isCaption{
    
    if (isCaption == true){
        self.quotesCollectionView.tag = 0;
    }
    else{
        self.quotesCollectionView.tag = 1;
    }
    
    if(viewTag >0){
        NSString *fileName = [[_quotesMenu objectAtIndex:viewTag] lowercaseString];
        
        if (isCaption == true){
            fileName = [NSString stringWithFormat:@"c_%@",fileName];
        }
        NSString *quoteCategoryName = fileName;
        NSString *path = [[NSBundle mainBundle] pathForResource:quoteCategoryName ofType:@"json"];
        
        NSData *data = [NSData dataWithContentsOfFile:path];
        _quotesList = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        
        [self.quotesCollectionView reloadData];
        
        NSUInteger numberofItems = [self.quotesCollectionView numberOfItemsInSection:0];
        
        if (numberofItems > 0){
            [self.quotesCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionTop animated:true];
        }
    
    }
    else{
        
        if (isCaption == true){
            _quotesList = [[NSUserDefaults standardUserDefaults] objectForKey:@"recentUsedCaptionList"];
        }
        else{
            _quotesList = [[NSUserDefaults standardUserDefaults] objectForKey:@"recentUsedQuoteList"];

        }
        [self.quotesCollectionView reloadData];
        
        NSUInteger numberofItems = [self.quotesCollectionView numberOfItemsInSection:0];
        
        if (numberofItems > 0){
            [self.quotesCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionTop animated:true];
        }
    }
}

-(void)addColelctionView{
    [self.quotesCollectionView removeFromSuperview];
    
    UICollectionViewFlowLayout *collectionViewLayout    =   [[UICollectionViewFlowLayout alloc] init];
    collectionViewLayout.sectionInset                   =   UIEdgeInsetsMake(0, 0, 0, 0);
    collectionViewLayout.minimumInteritemSpacing        =   0;
    collectionViewLayout.minimumLineSpacing             =   0;
    
    self.quotesCollectionView                                 =   [[UICollectionView alloc] initWithFrame:CGRectMake(0, 40, self.quotesContainerView.frame.size.width, self.quotesContainerView.frame.size.height - 80) collectionViewLayout:collectionViewLayout];
    
    [self.quotesCollectionView setDataSource:self];
    [self.quotesCollectionView setDelegate:self];
    [self.quotesCollectionView setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    [self.quotesCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    [self.quotesContainerView addSubview:self.quotesCollectionView];
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(0, self.quotesContainerView.frame.size.height - 40, self.quotesContainerView.frame.size.width, 40);
    [closeBtn setTitle:@"X" forState:UIControlStateNormal];
    [closeBtn setTintColor:[UIColor whiteColor]];
    [closeBtn setBackgroundColor:[UIColor blackColor]];
    [closeBtn addTarget:self action:@selector(closeStickerView) forControlEvents:UIControlEventTouchUpInside];
    [self.quotesContainerView addSubview:closeBtn];
}

-(void)closeStickerView{
    [self showHideQuoteListView:false];

//    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveLinear  animations:^{
//        self.quotesContainerView.frame  =   CGRectMake(0, self.editor.view.frame.size.height - 40, self.quotesContainerView.frame.size.width, self.quotesContainerView.frame.size.height);
//    } completion:^(BOOL finished) {
//        
//    }];
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGSize cellSize = CGSizeMake((self.editor.view.frame.size.width) , 60);
    
    return cellSize;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _quotesList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier         =   @"Cell";
    
    UICollectionViewCell *cell          =   [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    for(UIView *v1 in [cell.contentView subviews]){
        [v1 removeFromSuperview];
    }
    
    
    UILabel *quoteLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, self.editor.view.frame.size.width - 10, 60)];
    quoteLabel.backgroundColor = [UIColor clearColor];
    quoteLabel.textColor = [UIColor darkGrayColor];
//    quoteLabel.font = [CLImageEditorTheme toolbarTextFont];
    quoteLabel.numberOfLines = 0;
    quoteLabel.textAlignment = NSTextAlignmentLeft;
    
    if(collectionView.tag == 0){
        quoteLabel.text = [_quotesList objectAtIndex:indexPath.row];
    }
    else{
        NSDictionary *currentQuote    =   [_quotesList objectAtIndex:indexPath.row];
        quoteLabel.text = [currentQuote objectForKey:@"qoute"];
    }
    
    [cell.contentView addSubview:quoteLabel];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *textStr;
    if(collectionView.tag == 0){
        textStr = [_quotesList objectAtIndex:indexPath.row];
    }
    else{
        NSDictionary *currentQuote    =   [_quotesList objectAtIndex:indexPath.row];

        textStr = [currentQuote objectForKey:@"qoute"];

    }
    [self showHideQuoteListView:false];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self addNewText:textStr];
    });
    
    if(collectionView.tag == 0){
        NSMutableArray *recentUsedQuoteList = [[[NSUserDefaults standardUserDefaults] objectForKey:@"recentUsedCaptionList"] mutableCopy];
        
        if(recentUsedQuoteList == nil){
            recentUsedQuoteList = [NSMutableArray new];
        }
        if([recentUsedQuoteList containsObject:textStr]){
            [recentUsedQuoteList removeObject:textStr];
        }
        [recentUsedQuoteList insertObject:textStr atIndex:0];
        
        [[NSUserDefaults standardUserDefaults] setObject:recentUsedQuoteList forKey:@"recentUsedCaptionList"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else{
        NSDictionary *currentQuote    =   [_quotesList objectAtIndex:indexPath.row];
        NSMutableArray *recentUsedQuoteList = [[[NSUserDefaults standardUserDefaults] objectForKey:@"recentUsedQuoteList"] mutableCopy];
        
        if(recentUsedQuoteList == nil){
            recentUsedQuoteList = [NSMutableArray new];
        }
        if([recentUsedQuoteList containsObject:currentQuote]){
            [recentUsedQuoteList removeObject:currentQuote];
        }
        [recentUsedQuoteList insertObject:currentQuote atIndex:0];
        
        [[NSUserDefaults standardUserDefaults] setObject:recentUsedQuoteList forKey:@"recentUsedQuoteList"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
   
}

- (void)addNewText:(NSString*)withText{
    _CLTextView *view = [[_CLTextView alloc] initWithTool:self];
    [self setSelectedTextView:view];
    
    CGFloat ratio = MIN( (0.8 * _workingView.width) / view.width, (0.2 * _workingView.height) / view.height);
    [view setScale:ratio];
    view.center = CGPointMake(_workingView.width/2, view.height/2 + 10);
    
    [_workingView addSubview:view];
    [_CLTextView setActiveTextView:view];
    
    [self beginTextEditing:withText];
    self.selectedTextView.text = [[NSAttributedString alloc]initWithString:withText];

    
//    UINavigationItem *item              =   [[UINavigationItem alloc] initWithTitle:@"ENTER TEXT"];
//    item.leftBarButtonItem              =   [self buttonWithImageName:[CLImageEditorTheme localizedString:@"CLImageEditor_BackBtnTitle" withDefault:@"Back"] selector:@selector(crossButtonTapped)];
//    
//    [self.editor.navigationBar pushNavigationItem:item animated:true];
    
}

- (void)showSettingViewWithMenuIndex:(NSInteger)index
{
//    if(_settingView.hidden){
//        _settingView.hidden = NO;
//        [_settingView showSettingMenuWithIndex:index animated:NO];
//    }
//    else{
//        [_settingView showSettingMenuWithIndex:index animated:YES];
//    }
}

- (void)beginTextEditing:(NSString *)withText
{
    if(!isKeyboardShowing){
        UINavigationItem *item  =   [[UINavigationItem alloc] initWithTitle:@""];
        item.leftBarButtonItem  =  [self buttonWithImageName:[CLImageEditorTheme localizedString:@"CLImageEditor_BackBtnTitle" withDefault:@"Back"] selector:@selector(crossButtonTapped)];
        //[self.editor.navigationBar pushNavigationItem:item animated:true];
    }

    if(!_textView){
        _textView                       =   [[UITextView alloc] initWithFrame:CGRectMake(10, 5, self.editor.view.frame.size.width - 80, 40)];
        _textView.delegate              =   self;
        _textView.backgroundColor       =   self.editor.barColor;
        _textView.layer.cornerRadius    =   5.0f;
        _textView.text                  =   withText;
        _textView.layer.borderColor     =   [UIColor whiteColor].CGColor;
        _textView.layer.borderWidth     =   1;
        _textView.textColor             =   [UIColor whiteColor];
        UIButton *doneBtn               =   [UIButton buttonWithType:UIButtonTypeCustom];
        doneBtn.frame                   =   CGRectMake(self.editor.view.frame.size.width - 60, 0, 60, 50);
        [doneBtn setTitle:@"Done" forState:UIControlStateNormal];
        [doneBtn addTarget:self action:@selector(doneTextEnter:) forControlEvents:UIControlEventTouchUpInside];
        //doneBtn.backgroundColor         =   [UIColor yellowColor];
        [doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        _toolBarView                    =   [[UIView alloc]initWithFrame:CGRectMake(0, self.editor.view.frame.size.height, self.editor.view.frame.size.width, 50)];
        _toolBarView.backgroundColor    =   self.editor.barColor;
        _toolBarView.layer.borderColor     =   self.editor.barColor.CGColor;
        _toolBarView.layer.borderWidth     =   0.5;
        [_toolBarView addSubview:_textView];
        [_toolBarView addSubview:doneBtn];

        [self.editor.view addSubview:_toolBarView];
       // [_textView becomeFirstResponder];
    }
    _textView.text                  =   withText;
    [_textView becomeFirstResponder];

}

-(void)doneTextEnter:(UIButton *)btn{
    //[self.editor.navigationBar popNavigationItemAnimated:YES];

    [_textView resignFirstResponder];
    [_toolBarView removeFromSuperview];
    [_textView removeFromSuperview];
    _textView   =   nil;
}

- (void)keyboardDidShow:(NSNotification *)notification
{
    isKeyboardShowing   =   YES;
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;

   // [UIView animateWithDuration:0.0 animations:^{
        CGRect f            =   _toolBarView.frame;
        f.origin.y          =   f.origin.y - keyboardSize.height - f.size.height;
        _toolBarView.frame  =   f;
    //}];
}

-(void)keyboardDidHide:(NSNotification *)notification
{
    isKeyboardShowing   =   NO;

   // [UIView animateWithDuration:0.0 animations:^{
//        CGRect f            =   _toolBarView.frame;
//        f.origin.y          =   self.editor.view.frame.size.height;
//        _toolBarView.frame =    f;
    //}];
}

-(void)doneWithNumberPad{
    [_textView resignFirstResponder];
}

- (void)setTextAlignment:(ToolBarItem *)tool
{
    switch (self.selectedTextView.textAlignment) {
        case NSTextAlignmentLeft:
            self.selectedTextView.textAlignment =   NSTextAlignmentCenter;
            tool.iconView.image                 =   [UIImage imageNamed:@"t-a"];
            break;
        case NSTextAlignmentCenter:
            self.selectedTextView.textAlignment =   NSTextAlignmentRight;
            tool.iconView.image                 =   [UIImage imageNamed:@"t-r"];
            break;
        case NSTextAlignmentRight:
            self.selectedTextView.textAlignment =   NSTextAlignmentLeft;
            tool.iconView.image                 =   [UIImage imageNamed:@"t-l"];

            break;
        default:
            break;
    }
}

- (void)pushedButton:(UIButton*)button
{
//    if(_settingView.isFirstResponder){
//        [_settingView resignFirstResponder];
//    }
//    else{
//        [self hideSettingView];
//    }
}

#pragma mark- UITextView delegate

- (void)textViewDidChange:(UITextView *)textView{
    self.selectedTextView.text = [NSAttributedString dvs_attributedStringWithString:textView.text
                                                                           tracking:textSpacing
                                                                               font:self.selectedTextView.font];
    
//    self.selectedTextView.text = textView.text;
    [self.selectedTextView sizeToFitWithMaxWidth:0.8*_workingView.width lineHeight:0.2*_workingView.height];
}

- (void)textSettingView:(CLTextSettingView *)settingView didChangeText:(NSString *)text
{
    // set text
    self.selectedTextView.text = [NSAttributedString dvs_attributedStringWithString:text
                                                                           tracking:textSpacing
                                                                               font:self.selectedTextView.font];
//    self.selectedTextView.text = text;
    [self.selectedTextView sizeToFitWithMaxWidth:0.8*_workingView.width lineHeight:0.2*_workingView.height];
}

- (void)didSelectFontAtIndex:(FontPicker *)fontPickerView index:(NSInteger)index font:(NSString *)font{
    self.selectedTextView.font = [UIFont fontWithName:font size:15];
    [self.selectedTextView sizeToFitWithMaxWidth:0.8*_workingView.width lineHeight:0.2*_workingView.height];
}

- (void)didSelectColorAtIndex:(MaterialColorPicker *)MaterialColorPickerView index:(NSInteger)index color:(UIColor *)color{
   // _colorBtn.iconView.backgroundColor  =   color;
    if(MaterialColorPickerView.tag == 4){
        [self.selectedTextView setOutlineColor:color];
    }
    else if (MaterialColorPickerView.tag == 2){
        [self.selectedTextView setShadowColor:color];
    }
    else{
        if (index == 1000) {
                NSString * storyboardName                   =   @"Main";
                NSString * viewControllerID                 =   @"ColorPickerOne";
                UIStoryboard * storyboard                   =   [UIStoryboard storyboardWithName:storyboardName bundle:nil];
                ColorPickerOne * startPage         =   [storyboard instantiateViewControllerWithIdentifier:viewControllerID];
                [self.editor presentViewController:startPage animated:true completion:nil];
        } else {
            self.selectedTextView.fillColor     =   color;
        }
    }
}

- (void)didSelectTextureColorAtIndex:(TextureColorList *)TextureColorPickerView index:(NSInteger)index color:(UIColor *)color{
    // _colorBtn.iconView.backgroundColor  =   color;
    self.selectedTextView.fillColor     =   color;
}

- (void)textSettingView:(CLTextSettingView*)settingView didChangeBorderColor:(UIColor*)borderColor
{
   // _colorBtn.iconView.layer.borderColor = borderColor.CGColor;
    self.selectedTextView.borderColor = borderColor;
}

- (void)textSettingView:(CLTextSettingView*)settingView didChangeBorderWidth:(CGFloat)borderWidth
{
    //_colorBtn.iconView.layer.borderWidth = MAX(2, 10*borderWidth);
    self.selectedTextView.borderWidth = borderWidth;
}

- (void)textSettingView:(CLTextSettingView *)settingView didChangeFont:(UIFont *)font
{
    self.selectedTextView.font = font;
    [self.selectedTextView sizeToFitWithMaxWidth:0.8*_workingView.width lineHeight:0.2*_workingView.height];
}

@end



const CGFloat MAX_FONT_SIZE = 200.0;


#pragma mark- _CLTextView

@implementation _CLTextView
{
    CLTextLabel *_label;
    UIButton *_deleteButton;
    CLCircleView *_circleView;
    
    CGFloat _scale;
    CGFloat _arg;
    
    CGPoint _initialPoint;
    CGFloat _initialArg;
    CGFloat _initialScale;
}

+ (void)setActiveTextView:(_CLTextView*)view
{
    static _CLTextView *activeView = nil;
    if(view != activeView){
        [activeView setAvtive:NO];
        activeView = view;
        [activeView setAvtive:YES];
        
        [activeView.superview bringSubviewToFront:activeView];
        
        NSNotification *n = [NSNotification notificationWithName:CLTextViewActiveViewDidChangeNotification object:view userInfo:nil];
        [[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:n waitUntilDone:NO];
    }
}

- (id)initWithTool:(CLTextTool*)tool
{
    self = [super initWithFrame:CGRectMake(0, 0, 132, 132)];
    if(self){
        _label = [[CLTextLabel alloc] init];
        [_label setTextColor:[CLImageEditorTheme toolbarTextColor]];
        _label.numberOfLines = 0;
        _label.backgroundColor = [UIColor clearColor];
        _label.layer.borderColor = [[UIColor orangeColor] CGColor];
        _label.layer.cornerRadius = 3;
        _label.font = [UIFont systemFontOfSize:MAX_FONT_SIZE];
        _label.minimumScaleFactor = 1/MAX_FONT_SIZE;
        _label.adjustsFontSizeToFitWidth = YES;
        _label.textAlignment = NSTextAlignmentCenter;
        self.text = [NSAttributedString dvs_attributedStringWithString:@"TITLE"
                                                                              tracking:0
                                                                                  font:[UIFont systemFontOfSize:MAX_FONT_SIZE]];
        [self addSubview:_label];
        
        CGSize size = [_label sizeThatFits:CGSizeMake(FLT_MAX, FLT_MAX)];
        _label.frame = CGRectMake(16, 16, size.width, size.height);
        self.frame = CGRectMake(0, 0, size.width + 32, size.height + 32);
        
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteButton setImage:[UIImage imageNamed:@"icCancel"] forState:UIControlStateNormal];
        _deleteButton.frame = CGRectMake(0, 0, 32, 32);
        _deleteButton.center = _label.frame.origin;
        [_deleteButton addTarget:self action:@selector(pushedDeleteBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_deleteButton];
        
        _circleView = [[CLCircleView alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
        _circleView.center = CGPointMake(_label.width + _label.left, _label.height + _label.top);
        _circleView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
        _circleView.radius = 0.7;
        _circleView.color = [UIColor orangeColor];
        _circleView.borderColor = [UIColor orangeColor];
        _circleView.borderWidth = 5;
        [self addSubview:_circleView];
        
        _arg = 0;
        [self setScale:1];
        
        [self initGestures];
    }
    return self;
}

- (void)initGestures
{
    _label.userInteractionEnabled = YES;
    [_label addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewDidTap:)]];
    [_label addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(viewDidPan:)]];
    [_circleView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(circleViewDidPan:)]];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView* view= [super hitTest:point withEvent:event];
    if(view==self){
        return nil;
    }
    return view;
}

#pragma mark- Properties

- (void)setAvtive:(BOOL)active
{
    _deleteButton.hidden = !active;
    _circleView.hidden = !active;
    _label.layer.borderWidth = (active) ? 1/_scale : 0;
}

- (BOOL)active
{
    return !_deleteButton.hidden;
}

- (void)sizeToFitWithMaxWidth:(CGFloat)width lineHeight:(CGFloat)lineHeight
{
    self.transform = CGAffineTransformIdentity;
    _label.transform = CGAffineTransformIdentity;
    
    CGSize size = [_label sizeThatFits:CGSizeMake(width / (15/MAX_FONT_SIZE), FLT_MAX)];
    _label.frame = CGRectMake(16, 16, size.width, size.height);
    
    CGFloat viewW = (_label.width + 32);
    CGFloat viewH = _label.font.lineHeight;
    
    CGFloat ratio = MIN(width / viewW, lineHeight / viewH);
    [self setScale:ratio];
}

- (void)setScale:(CGFloat)scale
{
    _scale = scale;
    
    self.transform = CGAffineTransformIdentity;
    
    _label.transform = CGAffineTransformMakeScale(_scale, _scale);
    
    CGRect rct = self.frame;
    rct.origin.x += (rct.size.width - (_label.width + 32)) / 2;
    rct.origin.y += (rct.size.height - (_label.height + 32)) / 2;
    rct.size.width  = _label.width + 32;
    rct.size.height = _label.height + 32;
    self.frame = rct;
    
    _label.center = CGPointMake(rct.size.width/2, rct.size.height/2);
    
    self.transform = CGAffineTransformMakeRotation(_arg);
    
    _label.layer.borderWidth = 1/_scale;
    _label.layer.cornerRadius = 3/_scale;
}

- (void)setFillColor:(UIColor *)fillColor
{
    _label.textColor = fillColor;
}

- (UIColor*)fillColor
{
    return _label.textColor;
}

- (void)setBorderColor:(UIColor *)borderColor
{
    _label.outlineColor = borderColor;
}

- (UIColor*)borderColor
{
    return _label.outlineColor;
}

- (void)setBorderWidth:(CGFloat)borderWidth
{
    _label.outlineWidth = borderWidth;
}

- (CGFloat)borderWidth
{
    return _label.outlineWidth;
}

- (void)setFont:(UIFont *)font
{
    _label.font = [font fontWithSize:MAX_FONT_SIZE];
}

- (UIFont*)font
{
    return _label.font;
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment
{
    _label.textAlignment = textAlignment;
}

- (NSTextAlignment)textAlignment
{
    return _label.textAlignment;
}

- (void)setOutlineWidth:(NSUInteger )width
{
    _label.outlineWidth = width;
    [_label setNeedsLayout];
}

- (void)setOutlineColor:(UIColor *)color
{
    _label.outlineColor = color;
    [_label setNeedsLayout];
}

- (void)setShadowColor:(UIColor *)color
{
    [_label setShadowColor:color];
//    _label.shadowColor = color;
    [_label setNeedsLayout];
}

- (void)setShadowWidth:(NSUInteger )width
{
    _label.shadowWidth = CGSizeMake(width, width);
    [_label setNeedsLayout];
}

- (void)setText:(NSAttributedString *)text
{
    //if(![text.string isEqualToString:_text.string]){
        _text = text;
        _label.attributedText = (_text.string.length>0) ? _text : [[NSAttributedString alloc] initWithString:@"TEXT"];
   // }
}

#pragma mark- gesture events

- (void)pushedDeleteBtn:(id)sender
{
    _CLTextView *nextTarget = nil;
    
    const NSInteger index = [self.superview.subviews indexOfObject:self];
    
    for(NSInteger i=index+1; i<self.superview.subviews.count; ++i){
        UIView *view = [self.superview.subviews objectAtIndex:i];
        if([view isKindOfClass:[_CLTextView class]]){
            nextTarget = (_CLTextView*)view;
            break;
        }
    }
    
    if(nextTarget==nil){
        for(NSInteger i=index-1; i>=0; --i){
            UIView *view = [self.superview.subviews objectAtIndex:i];
            if([view isKindOfClass:[_CLTextView class]]){
                nextTarget = (_CLTextView*)view;
                break;
            }
        }
    }
    
    [[self class] setActiveTextView:nextTarget];
    [self removeFromSuperview];
}

- (void)viewDidTap:(UITapGestureRecognizer*)sender
{
    if(self.active){
        NSNotification *n = [NSNotification notificationWithName:CLTextViewActiveViewDidTapNotification object:self userInfo:nil];
        [[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:n waitUntilDone:NO];
    }
    [[self class] setActiveTextView:self];
}

- (void)viewDidPan:(UIPanGestureRecognizer*)sender
{
    [[self class] setActiveTextView:self];
    
    CGPoint p = [sender translationInView:self.superview];
    
    if(sender.state == UIGestureRecognizerStateBegan){
        _initialPoint = self.center;
    }
    self.center = CGPointMake(_initialPoint.x + p.x, _initialPoint.y + p.y);
}

- (void)circleViewDidPan:(UIPanGestureRecognizer*)sender
{
    CGPoint p = [sender translationInView:self.superview];
    
    static CGFloat tmpR = 1;
    static CGFloat tmpA = 0;
    if(sender.state == UIGestureRecognizerStateBegan){
        _initialPoint = [self.superview convertPoint:_circleView.center fromView:_circleView.superview];
        
        CGPoint p = CGPointMake(_initialPoint.x - self.center.x, _initialPoint.y - self.center.y);
        tmpR = sqrt(p.x*p.x + p.y*p.y);
        tmpA = atan2(p.y, p.x);
        
        _initialArg = _arg;
        _initialScale = _scale;
    }
    
    p = CGPointMake(_initialPoint.x + p.x - self.center.x, _initialPoint.y + p.y - self.center.y);
    CGFloat R = sqrt(p.x*p.x + p.y*p.y);
    CGFloat arg = atan2(p.y, p.x);
    
    _arg   = _initialArg + arg - tmpA;
    [self setScale:MAX(_initialScale * R / tmpR, 15/MAX_FONT_SIZE)];
}

@end


