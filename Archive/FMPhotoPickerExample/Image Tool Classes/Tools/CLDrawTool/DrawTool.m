//
//  CLDrawTool.m
//
//  Created by sho yakushiji on 2014/06/20.
//  Copyright (c) 2014年 CALACULU. All rights reserved.
//

#import "DrawTool.h"
#import "UIView+Frame.h"
#import "ToolBarItem.h"
#import "UIImage+Utility.h"
#import "FMPhotoPickerExample-Swift.h"

typedef enum {
    kFreeStyle,
    kLineStyle,
    kEmptyCircleStyle,
    kFilledCircleStyle,
    kEmptyEclipseStyle,
    kFilledEclipseStyle,
    kEmptySquareStyle,
    kFilledSquareStyle,
    kEmptyRectangleStyle,
    kFilledRectangleStyle
} DrawingShapeType;

static NSString* const kCLDrawToolEraserIconName = @"eraserIconAssetsName";

@implementation DrawTool
{
    ACEDrawingView *_drawingView;
    CGSize _originalImageSize;
    
    CGPoint _prevDraggingPosition;
    UISlider *_widthSlider;
    UIImageView *_eraserIcon;
    UIScrollView *_menuScroll;
    UIScrollView *_subMenuScroll;

    ToolBarItem *_colorBtn;
    UIView *_containerView;
    
    UIColor *selectedColor;
    double selectedWidth;
    double selectedHardness;
    
    BOOL isErasing;
    DrawingShapeType drawingShapeType;

    UIButton *undoBtn;
    UIButton *redoBtn;
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

- (void)setup
{
    [self initMenuScrollView];
    [self setMenu];
    
    _originalImageSize      =   self.editor.imageView.image.size;
    
    _drawingView            =   [[ACEDrawingView alloc] initWithFrame:self.editor.imageView.bounds];
    _drawingView.delegate   =   self;

    [self.editor.imageView addSubview:_drawingView];
    self.editor.imageView.userInteractionEnabled = YES;
    self.editor.scrollView.panGestureRecognizer.minimumNumberOfTouches = 2;
    self.editor.scrollView.panGestureRecognizer.delaysTouchesBegan = NO;
    self.editor.scrollView.pinchGestureRecognizer.delaysTouchesBegan = NO;
    
    selectedColor           =   [UIColor whiteColor];
    _drawingView.lineWidth  =   10;
    _drawingView.lineColor  =   [UIColor darkGrayColor];
    
    [UIView animateWithDuration:kCLImageToolAnimationDuration
                     animations:^{
                         _menuScroll.transform = CGAffineTransformIdentity;
                     }
                     completion:^(BOOL finished) {
                     }];
}

- (void)cleanup
{
    [_drawingView removeFromSuperview];
    [_containerView removeFromSuperview];

    self.editor.imageView.userInteractionEnabled = NO;
    self.editor.scrollView.panGestureRecognizer.minimumNumberOfTouches = 1;
    
    [UIView animateWithDuration:kCLImageToolAnimationDuration
                     animations:^{
                         _menuScroll.transform = CGAffineTransformMakeTranslation(0, self.editor.view.height-_menuScroll.top);
                     }
                     completion:^(BOOL finished) {
                         [_menuScroll removeFromSuperview];
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

-(void)swapMenuToShowSetting:(BOOL)showMenu{
    
    if(showMenu){
        //lastScrolPoint  =   _menuScroll.contentOffset.x;
        
        [UIView animateWithDuration:kCLImageToolAnimationDuration animations:^{
            for(UIView *subView in _menuScroll.subviews){
                if ([subView isKindOfClass:[ToolBarItem class]]) {
                    subView.alpha  = 0.0;
                }
            }
        }];
        
        _containerView.frame  = CGRectMake(_containerView.frame.origin.x,  _menuScroll.top + _containerView.frame.size.height, _containerView.frame.size.width, _containerView.frame.size.height);
        
        [UIView animateWithDuration:kCLImageToolAnimationDuration
                         animations:^{
                             _containerView.frame  = CGRectMake(_containerView.frame.origin.x, _menuScroll.top, _containerView.frame.size.width, _containerView.frame.size.height);
                         }
         ];
    }
    else{
        [UIView animateWithDuration:kCLImageToolAnimationDuration
                         animations:^{
                             for(UIView *subView in _menuScroll.subviews){
                                 subView.alpha  = 1.0;
                             }
                         }
         ];
        
        [UIView animateWithDuration:kCLImageToolAnimationDuration
                         animations:^{
                             _containerView.frame  = CGRectMake(_containerView.frame.origin.x, _menuScroll.top + _containerView.frame.size.height, _containerView.frame.size.width, _containerView.frame.size.height);
                         } completion:^(BOOL finished) {
                             _menuScroll.scrollEnabled   =   true;
                             [_containerView removeFromSuperview];
                             [_subMenuScroll removeFromSuperview];
                             _subMenuScroll = nil;
                         }
         ];
    }
}


#pragma mark-

- (UISlider*)defaultSliderWithWidth:(CGFloat)width
{
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(0, 0, width, 34)];
    [slider setThumbImage:[UIImage imageNamed:@"slider"] forState:UIControlStateNormal];
    
    [slider setMinimumTrackTintColor:[UIColor whiteColor]];
    [slider setMaximumTrackTintColor:[UIColor whiteColor]];
    [slider setMaximumTrackImage:[UIImage new] forState:UIControlStateNormal];
    [slider setMinimumTrackImage:[UIImage new] forState:UIControlStateNormal];
    [slider setThumbImage:[UIImage new] forState:UIControlStateNormal];
    slider.thumbTintColor = [UIColor whiteColor];
    
    return slider;
}

- (void)setMenu
{
    for(UIView *v in _menuScroll.subviews){
        [v removeFromSuperview];
    }
    
    CGFloat W = 70;
    CGFloat H = _menuScroll.height;
    CGFloat x = 0;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        W   =   100;
    }
    
    NSArray *_menu = @[
                       @{@"title":@"Color", @"icon":[UIImage imageNamed:@"color"]},
                       @{@"title":@"Brush", @"icon":[UIImage imageNamed:@"brush"]},
                       @{@"title":@"Style", @"icon":[UIImage imageNamed:@"drawing-style"]},
                       @{@"title":@"Size",  @"icon":[UIImage imageNamed:@"brush-size"]},
                       @{@"title":@"Erase", @"icon":[UIImage imageNamed:@"eraser"]},
                       ];
    
    NSInteger tag = 0;
    for(NSDictionary *obj in _menu){
        ToolBarItem *view = [CLImageEditorTheme menuItemWithFrame:CGRectMake(x, 0, W, H) target:self action:@selector(tappedMenuPanel:) toolInfo:nil isIcon:true];
        view.tag = tag++;
        view.titleLabel.text = obj[@"title"];
        view.iconView.image = obj[@"icon"];
        
        [_menuScroll addSubview:view];
        x += W;
    }

    _menuScroll.contentSize = CGSizeMake(x, 0);
    _menuScroll.clipsToBounds = NO;
    
//    if (_menuScroll.contentSize.width < self.editor.menuScrollView.frame.size.width){
//        _menuScroll.frame   =   CGRectMake(_menuScroll.frame.origin.x, _menuScroll.frame.origin.y, _menuScroll.contentSize.width, _menuScroll.frame.size.height);
//        _menuScroll.center  =   self.editor.menuScrollView.center;
//    }
}

- (void)setBrushTypeMenu
{
    CGFloat W = 70;
    CGFloat H = _subMenuScroll.height;
    CGFloat x = 0;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        W   =   100;
    }
    
    NSArray *_menu = @[
                       @{@"title":@"Simple", @"icon":[UIImage imageNamed:@"draw"]},
                       @{@"title":@"Dots",@"icon":[UIImage imageNamed:@"dot"]}
//                       @{@"title":@"Dash", @"icon":[UIImage imageNamed:@"dash"]},
                       ];
    
    NSInteger tag = 0;
    for(NSDictionary *obj in _menu){
        ToolBarItem *view = [CLImageEditorTheme menuItemWithFrame:CGRectMake(x, 0, W, H) target:self action:@selector(tappedBrushTypeMenuPanel:) toolInfo:nil isIcon:true];
        view.tag = tag++;
        view.titleLabel.text = obj[@"title"];
        view.iconView.image = obj[@"icon"];
        
        [_subMenuScroll addSubview:view];
        x += W;
    }
    
    _subMenuScroll.contentSize = CGSizeMake(x, 0);
    _subMenuScroll.clipsToBounds = NO;
    
    [_containerView addSubview:_subMenuScroll];
    
    if (_subMenuScroll.contentSize.width < self.editor.menuScrollView.frame.size.width){
        _subMenuScroll.frame   =   CGRectMake(_subMenuScroll.frame.origin.x, _subMenuScroll.frame.origin.y, _subMenuScroll.contentSize.width, _subMenuScroll.frame.size.height);
        _subMenuScroll.center  =   CGPointMake(_containerView.center.x, _containerView.frame.size.height/2);
    }
}

- (void)setDrawingTypeMenu
{
    CGFloat W = 70;
    CGFloat H = _subMenuScroll.height;
    CGFloat x = 0;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        W   =   100;
    }
    
    NSArray *_menu = @[
                       @{@"title":@"Free", @"icon":[UIImage imageNamed:@"free-style"]},
                       @{@"title":@"Line",@"icon":[UIImage imageNamed:@"line"]},
                       @{@"title":@"Empty Circle", @"icon":[UIImage imageNamed:@"circle-empty"]},
                       @{@"title":@"Filled Circle", @"icon":[UIImage imageNamed:@"circle-filled"]},
                       @{@"title":@"Empty Square", @"icon":[UIImage imageNamed:@"square-epmty"]},
                       @{@"title":@"Filled Square", @"icon":[UIImage imageNamed:@"square-filled"]},
                       ];
    
    NSInteger tag = 0;
    for(NSDictionary *obj in _menu){
        ToolBarItem *view = [CLImageEditorTheme menuItemWithFrame:CGRectMake(x, 0, W, H) target:self action:@selector(tappedDrawingTypeMenuPanel:) toolInfo:nil isIcon:true];
        view.tag = tag++;
        view.titleLabel.text = obj[@"title"];
        view.iconView.image = obj[@"icon"];
        
        [_subMenuScroll addSubview:view];
        x += W;
    }
    
    _subMenuScroll.contentSize = CGSizeMake(x, 0);
    _subMenuScroll.clipsToBounds = NO;
    [_containerView addSubview:_subMenuScroll];

    if (_subMenuScroll.contentSize.width < self.editor.menuScrollView.frame.size.width){
        _subMenuScroll.frame   =   CGRectMake(_subMenuScroll.frame.origin.x, _subMenuScroll.frame.origin.y, _subMenuScroll.contentSize.width, _subMenuScroll.frame.size.height);
        _subMenuScroll.center  =   CGPointMake(_containerView.center.x, _containerView.frame.size.height/2);
    }
}

- (void)tappedDrawingTypeMenuPanel:(UITapGestureRecognizer*)sender
{
    ToolBarItem *view = (ToolBarItem*)sender.view;
    [self.editor.navigationBar popNavigationItemAnimated:YES];

    switch (view.tag) {
        case 0:
            _drawingView.drawTool = ACEDrawingToolTypePen;
            break;
        case 1:
            _drawingView.drawTool = ACEDrawingToolTypeLine;
            break;
        case 2:
            _drawingView.drawTool = ACEDrawingToolTypeEllipseStroke;
            break;
        case 3:
            _drawingView.drawTool = ACEDrawingToolTypeEllipseFill;
            break;
        case 4:
            _drawingView.drawTool = ACEDrawingToolTypeRectagleStroke;
            break;
        case 5:
            _drawingView.drawTool = ACEDrawingToolTypeRectagleFill;
            break;
    }
    
    [self swapMenuToShowSetting:NO];
}

- (void)tappedBrushTypeMenuPanel:(UITapGestureRecognizer*)sender
{
    [self setMenu];
    
    ToolBarItem *view = (ToolBarItem*)sender.view;
   // [self pushNavBarWithText:view.titleLabel.text];
    [self.editor.navigationBar popNavigationItemAnimated:YES];

    switch (view.tag) {
        case 0:
            _drawingView.brushType = ACEDrawingToolBrushTypeSimple;
            break;
        case 1:
            _drawingView.brushType = ACEDrawingToolBrushTypeDots;
            break;
        case 2:
            _drawingView.brushType = ACEDrawingToolBrushTypeDashs;
            break;
    }
    [self swapMenuToShowSetting:NO];
}

- (void)tappedMenuPanel:(UITapGestureRecognizer*)sender
{
    ToolBarItem *view = (ToolBarItem*)sender.view;
    
    switch (view.tag) {
        case 0:
            [self addColorPicker];
            break;
        case 1:
            [self initSubMenuScrollView];
            [self setBrushTypeMenu];
            break;
        case 2:
            [self initSubMenuScrollView];
            [self setDrawingTypeMenu];
            break;
        case 3:
            [self addSizeSlider];
            break;
        case 4:
            if(isErasing){
                self.editor.navigationBar.topItem.title = @"Draw";
                view.titleLabel.text    =   @"Erase";
                _drawingView.drawTool   =   ACEDrawingToolTypePen;
                isErasing               =   false;
            }
            else{
                self.editor.navigationBar.topItem.title = @"Erase";
                view.titleLabel.text    =   @"Draw";
                _drawingView.drawTool   =   ACEDrawingToolTypeEraser;
                isErasing               =   true;
            }
            break;
        case 5:
            [self addHardnessPicker];
            
            break;
    }
    
    if(view.tag != 4){
        [self pushNavBarWithText:view.titleLabel.text];
        [self swapMenuToShowSetting:YES];
    }
}

-(void)pushNavBarWithText:(NSString *)text{
    UINavigationItem *item  = [[UINavigationItem alloc] initWithTitle:text];
    item.leftBarButtonItem  =  [self buttonWithImageName:[CLImageEditorTheme localizedString:@"CLImageEditor_BackBtnTitle" withDefault:@"Back"] selector:@selector(crossButtonTapped)];

    [self.editor.navigationBar pushNavigationItem:item animated:true];
}

-(void)addColorPicker{
    _menuScroll.contentOffset           =    CGPointZero;
    _containerView                      =   [[UIView alloc]initWithFrame:CGRectMake(0, _menuScroll.top, self.editor.menuScrollView.frame.size.width, _menuScroll.frame.size.height)];
    _containerView.backgroundColor      =   self.editor.barColor;

    MaterialColorPicker *colorPicker    =   [[MaterialColorPicker alloc] initWithFrame:CGRectMake(0, (_menuScroll.frame.size.height - 50)/2, _containerView.frame.size.width, 50)];
    colorPicker.delegate                =   self;
    colorPicker.selectionColor          =   [UIColor grayColor];
    colorPicker.selectedBorderWidth     =   5;
    colorPicker.cellSpacing             =   10;
    [_containerView addSubview:colorPicker];
    
    [self.editor.view addSubview:_containerView];
    _menuScroll.scrollEnabled           =   false;
}

- (void)didSelectColorAtIndex:(MaterialColorPicker *)MaterialColorPickerView index:(NSInteger)index color:(UIColor *)color{
    selectedColor = color;
    _drawingView.lineColor   = selectedColor;
    _menuScroll.scrollEnabled               =   true;
    [_containerView removeFromSuperview];
    [self.editor.navigationBar popNavigationItemAnimated:YES];
    [self swapMenuToShowSetting:NO];

}

-(void)addSizeSlider{
    
    _containerView                      =   [[UIView alloc]initWithFrame:CGRectMake(0, _menuScroll.top, self.editor.menuScrollView.frame.size.width, _menuScroll.frame.size.height)];
    _containerView.backgroundColor      =   self.editor.barColor;

    SizePicker *colorPicker             =   [[SizePicker alloc] initWithFrame:CGRectMake(0, (_menuScroll.frame.size.height - 50)/2, _containerView.frame.size.width , 50)];
    colorPicker.delegate                =   self;
    colorPicker.selectionColor          =   [UIColor darkGrayColor];
    colorPicker.selectedBorderWidth     =   2;
    colorPicker.cellSpacing             =   10;
    [_containerView addSubview:colorPicker];
    
    [self.editor.view addSubview:_containerView];
    //_menuScroll.scrollEnabled           =   false;
}

- (void)didSelectSizeAtIndex:(SizePicker *)fontPickerView index:(NSInteger)index size:(NSInteger)size{
    selectedWidth                           =   MAX(0.05, size);
    _drawingView.lineWidth                  =   selectedWidth;
    //_menuScroll.scrollEnabled               =   true;
    [_containerView removeFromSuperview];
    [self.editor.navigationBar popNavigationItemAnimated:YES];
    [self swapMenuToShowSetting:NO];

}

- (void)didSelectHardnessAtIndex:(HardnessPicker *)fontPickerView index:(NSInteger)index hardness:(double)hardness{
     selectedColor = [selectedColor colorWithAlphaComponent:hardness];
    _menuScroll.scrollEnabled               =   true;
    [_containerView removeFromSuperview];
}

-(void)addStylePicker{
    [self setBrushTypeMenu];
}

-(void)addHardnessPicker{
    _menuScroll.contentOffset           =    CGPointZero;
    _containerView                      =   [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.editor.menuScrollView.frame.size.width, _menuScroll.frame.size.height)];
    _containerView.backgroundColor      =   self.editor.barColor;

    [_menuScroll addSubview:_containerView];
    
    HardnessPicker *hardnessPicker          =   [[HardnessPicker alloc] initWithFrame:CGRectMake(0, (_menuScroll.frame.size.height - 50)/2, _containerView.frame.size.width , 50)];
    hardnessPicker.delegate                 =   self;
    hardnessPicker.selectionColor           =   [UIColor darkGrayColor];
    hardnessPicker.selectedBorderWidth      =   2;
    hardnessPicker.cellSpacing              =   10;
    [_containerView addSubview:hardnessPicker];
    
    [_menuScroll addSubview:_containerView];
    _menuScroll.scrollEnabled               =   false;
}

- (void)initMenuScrollView
{
    if(_menuScroll==nil){
        UIScrollView *menuScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.editor.view.width, kMenuBarHeight)];
        menuScroll.top = self.editor.view.height - menuScroll.height;
        menuScroll.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        menuScroll.showsHorizontalScrollIndicator   =   NO;
        menuScroll.showsVerticalScrollIndicator     =   NO;
        
        [self.editor.view addSubview:menuScroll];
        _menuScroll = menuScroll;
    }
    _menuScroll.backgroundColor = self.editor.barColor;
    
    _menuScroll.transform           =   CGAffineTransformMakeTranslation(0, self.editor.view.height - _menuScroll.top);
}

- (void)initSubMenuScrollView
{
    _containerView                      =   [[UIView alloc]initWithFrame:CGRectMake(0, _menuScroll.top, self.editor.menuScrollView.frame.size.width, _menuScroll.frame.size.height)];
    _containerView.backgroundColor      =   self.editor.barColor;

    [self.editor.view addSubview:_containerView];
    
    if(_subMenuScroll==nil){
        UIScrollView *menuScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.editor.view.width, kMenuBarHeight)];
        //menuScroll.top = self.editor.view.height - menuScroll.height;
        menuScroll.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        menuScroll.showsHorizontalScrollIndicator   =   NO;
        menuScroll.showsVerticalScrollIndicator     =   NO;
        
        [_containerView addSubview:menuScroll];
        _subMenuScroll = menuScroll;
    }
    _subMenuScroll.backgroundColor = self.editor.barColor;
    
}

-(void)crossButtonTapped{
    [self.editor.navigationBar popNavigationItemAnimated:YES];
    [self setMenu];
    [self swapMenuToShowSetting:NO];
}

- (void)updateButtonStatus
{
    undoBtn.enabled = [_drawingView canUndo];
    redoBtn.enabled = [_drawingView canRedo];
}

- (IBAction)undo:(id)sender
{
    [_drawingView undoLatestStep];
    [self updateButtonStatus];
}

- (IBAction)redo:(id)sender
{
    [_drawingView redoLatestStep];
    [self updateButtonStatus];
}

- (IBAction)clear:(id)sender
{
    [_drawingView clear];
    [self updateButtonStatus];
}

#pragma mark - ACEDrawing View Delegate

- (void)drawingView:(ACEDrawingView *)view didEndDrawUsingTool:(id<ACEDrawingTool>)tool;
{
    [self updateButtonStatus];
}

@end
