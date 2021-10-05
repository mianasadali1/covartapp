//
//  CLSplashTool.m
//
//  Created by sho yakushiji on 2014/06/21.
//  Copyright (c) 2014年 CALACULU. All rights reserved.
//

#import "SplashTool.h"
#import "ToolBarItem.h"
#import "UIView+Frame.h"
#import "UIImage+Utility.h"

static NSString* const kCLSplashToolEraserIconName = @"eraserIconAssetsName";

@implementation SplashTool
{
    UIImageView *_drawingView;
    UIImage *_maskImage;
    UIImage *_grayImage;
    CGSize _originalImageSize;
    
    CGPoint _prevDraggingPosition;
    UIImageView *_eraserIcon;
    BOOL isDrawing;
    ToolBarItem *_colorBtn;
}

#pragma mark- implementation

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
    self.menuScrollView.backgroundColor     =   self.editor.barColor;
    self.menuScrollView.transform           =   CGAffineTransformMakeTranslation(0, self.editor.view.height - self.menuScrollView.top);
}

- (void)setup
{
    [self initMenuScrollView];
    [self setMenu];
    
    isDrawing                   =   true;
    _originalImageSize          =   self.editor.imageView.image.size;
    
    _drawingView                =   [[UIImageView alloc] initWithFrame:self.editor.imageView.bounds];
    _drawingView.contentMode    =   UIViewContentModeScaleAspectFit;
    
    _grayImage                  =   [[self.editor.imageView.image aspectFit:CGSizeMake(_drawingView.width*2, _drawingView.height*2)] grayScaleImage];
    _drawingView.image          =   _grayImage;
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(drawingViewDidPan:)];
    panGesture.maximumNumberOfTouches = 1;
    
    _drawingView.userInteractionEnabled = YES;
    [_drawingView addGestureRecognizer:panGesture];
    
    [self.editor.imageView addSubview:_drawingView];
    self.editor.imageView.userInteractionEnabled = YES;
    self.editor.scrollView.panGestureRecognizer.minimumNumberOfTouches  =   2;
    self.editor.scrollView.panGestureRecognizer.delaysTouchesBegan      =   NO;
    self.editor.scrollView.pinchGestureRecognizer.delaysTouchesBegan    =   NO;
    
    [UIView animateWithDuration:kCLImageToolAnimationDuration
                     animations:^{
                         self.menuScrollView .transform = CGAffineTransformIdentity;
                     }
                     completion:^(BOOL finished) {
                     }];
}

- (void)cleanup
{
    [_drawingView removeFromSuperview];
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
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *image = [self buildImage];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock(image, nil, nil);
        });
    });
}

#pragma mark-

- (void)setMenu
{
    for(UIView *sub in self.menuScrollView.subviews){ [sub removeFromSuperview]; }
    
    CGFloat W = 70;
    CGFloat H = self.menuScrollView.height;
    CGFloat x = (self.editor.view.frame.size.width - (W*2))/2;;

    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        W   =   100;
    }
    
    NSUInteger toolCount = 0;
    CGFloat padding = 0;
    
    //for(ToolInfo *info in [self editingTools]){
    toolCount = [self editingTools].count;
    // }
    
    CGFloat diff = self.menuScrollView.frame.size.width - toolCount * W;
    if (0<diff && diff<2*W) {
        padding = diff/(toolCount+1);
    }
    
    for(ToolInfo *info in [self editingTools]){
        
        ToolBarItem *view = [ToolBarItem menuItemWithFrame:CGRectMake(x+padding, 0, W, H) target:self action:@selector(tappedMenuView:) toolInfo:info isIcon:true];
        [self.menuScrollView addSubview:view];
        x += W+padding;
        
        if(self.currentTool == nil){
            self.currentTool    = info;
        }
    }
    
    self.menuScrollView.contentSize = CGSizeMake(x, 0);
    
//    if (self.menuScrollView.contentSize.width < self.editor.menuScrollView.frame.size.width){
//        self.menuScrollView.frame   =   CGRectMake(self.menuScrollView.frame.origin.x, self.menuScrollView.frame.origin.y, self.menuScrollView.contentSize.width, self.menuScrollView.frame.size.height);
//        self.menuScrollView.center  =   self.editor.menuScrollView.center;
//    }
}

-(void)tappedMenuView:(UITapGestureRecognizer *)gesture{
    ToolBarItem *view   =   (ToolBarItem *)gesture.view;
    self.currentTool    =   view.toolInfo;
}

-(NSArray *)editingTools{
    NSMutableArray *toolsArr        =   [NSMutableArray new];
    
    NSArray *tools                  =   [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Tools" ofType:@"plist"]];
    
    NSString *clasName              =   NSStringFromClass([self class]);
    
    NSArray *filteredTools          =   [tools filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(ToolName == %@)", clasName]];
    
    NSDictionary *currentToolInfo   =   [filteredTools firstObject];
    
    NSArray *subTools               =   [currentToolInfo objectForKey:@"subTools"];
    
    for(NSDictionary *tolDict in subTools){
        ToolInfo *tool              =   [[ToolInfo alloc]init];
        tool.toolId                 =   [tolDict objectForKey:@"ToolId"];
        tool.toolName               =   [tolDict objectForKey:@"ToolName"];
        tool.filterName             =   [tolDict objectForKey:@"FilterName"];
        tool.title                  =   [tolDict objectForKey:@"Title"];
        tool.iconImage              =   [UIImage imageNamed:[tolDict objectForKey:@"ToolIcon"]];
        tool.maxLimit               =   [[tolDict objectForKey:@"Max"] doubleValue];
        tool.minLimit               =   [[tolDict objectForKey:@"Min"] doubleValue];
        
        [toolsArr addObject:tool];
    }
    
    return toolsArr;
}


- (void)strokePreviewDidTap:(UITapGestureRecognizer*)sender
{
    _eraserIcon.hidden = !_eraserIcon.hidden;
}

- (void)drawingViewDidPan:(UIPanGestureRecognizer*)sender
{
    CGPoint currentDraggingPosition = [sender locationInView:_drawingView];
    
    if(sender.state == UIGestureRecognizerStateBegan){
        _prevDraggingPosition = currentDraggingPosition;
    }
    
    if(sender.state != UIGestureRecognizerStateEnded){
        [self drawLine:_prevDraggingPosition to:currentDraggingPosition];
        _drawingView.image = [_grayImage maskedImage:_maskImage];
    }
    _prevDraggingPosition = currentDraggingPosition;
}

-(void)drawLine:(CGPoint)from to:(CGPoint)to
{
    CGSize size = _drawingView.frame.size;
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGFloat strokeWidth = 20;
    
    if(_maskImage==nil){
        CGContextSetFillColorWithColor(context, [[UIColor blackColor] CGColor]);
        CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height));
    }
    else{
        [_maskImage drawAtPoint:CGPointZero];
    }
    
    CGContextSetLineWidth(context, strokeWidth);
    CGContextSetLineCap(context, kCGLineCapRound);
    
    if(![self.currentTool.toolName isEqualToString:@"SplashColorTool"]){
        CGContextSetStrokeColorWithColor(context, [[UIColor blackColor] CGColor]);
    }
    else{
        CGContextSetStrokeColorWithColor(context, [[UIColor whiteColor] CGColor]);
    }
    
    CGContextMoveToPoint(context, from.x, from.y);
    CGContextAddLineToPoint(context, to.x, to.y);
    CGContextStrokePath(context);
    
    _maskImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
}

- (UIImage*)buildImage
{
    _grayImage = [self.editor.imageView.image grayScaleImage];
    
    UIGraphicsBeginImageContextWithOptions(_originalImageSize, NO, self.editor.imageView.image.scale);
    
    [self.editor.imageView.image drawAtPoint:CGPointZero];
    [[_grayImage maskedImage:_maskImage] drawInRect:CGRectMake(0, 0, _originalImageSize.width, _originalImageSize.height)];
    
    UIImage *tmp = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return tmp;
}

@end
