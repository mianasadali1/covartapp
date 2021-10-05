//
//  CLEmoticonView.m
//  BasicFilters
//
//  Created by Kanwar on 6/21/18.
//  Copyright © 2018 Kanwarpal Singh. All rights reserved.
//

#import "CLEmoticonView.h"
#import "CLCircleView.h"
#import "UIView+Frame.h"

@implementation CLEmoticonView
{
    UIImageView *_imageView;
    UIButton *_deleteButton;
    CLCircleView *_circleView;
    
    CGFloat _scale;
    CGFloat _minScale;

    CGFloat _arg;
    
    CGPoint _initialPoint;
    CGFloat _initialArg;
    CGFloat _initialScale;
    CLEmoticonView * currentView;
}

-(void)changeStickerAlphaTo:(double)alpha{
    currentView.imageView.alpha = alpha;
}

+ (void)setActiveEmoticonView:(CLEmoticonView*)view
{
    static CLEmoticonView *activeView = nil;
    if(view != activeView){
        [activeView setAvtive:NO];
        activeView = view;
        [activeView setAvtive:YES];
//        currentView = view;
        [activeView.superview bringSubviewToFront:activeView];
    }
}

- (id)initWithImage:(UIImage *)image isSticker:(BOOL)isSticker deleteBlock:(stickerDeleteBlock)deleteBlock
{
    self.deleteBlock = deleteBlock;
    self.isSticker = isSticker;
    
    self = [super initWithFrame:CGRectMake(0, 0, image.size.width+32, image.size.height+32)];
    if(self){
        _imageView = [[UIImageView alloc] initWithImage:image];
        
        _imageView.center = self.center;
        [self addSubview:_imageView];
        
        if (isSticker == true){
            _imageView.layer.borderColor = [[UIColor blackColor] CGColor];
            _imageView.layer.cornerRadius = 3;
            _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
            
            [_deleteButton setImage:[UIImage imageNamed:@"btn_delete"] forState:UIControlStateNormal];
            _deleteButton.frame = CGRectMake(0, 0, 32, 32);
            _deleteButton.center = _imageView.frame.origin;
            [_deleteButton addTarget:self action:@selector(pushedDeleteBtn:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:_deleteButton];
            
            _circleView = [[CLCircleView alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
            _circleView.center = CGPointMake(_imageView.width + _imageView.frame.origin.x, _imageView.height + _imageView.frame.origin.y);
            _circleView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
            _circleView.radius = 0.7;
            _circleView.color = [UIColor whiteColor];
            _circleView.borderColor = [UIColor blackColor];
            _circleView.borderWidth = 5;
            [self addSubview:_circleView];
        }
        
        _scale = 1;
        _arg = 0;
        
        [self initGestures:isSticker];
    }
    return self;
}

- (void)initGestures:(BOOL)isSticker
{
    _imageView.userInteractionEnabled = YES;
    [_imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewDidTap:)]];
    [_imageView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(viewDidPan:)]];
    
    if (isSticker == true){
        [_circleView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(circleViewDidPan:)]];
    }

    UIPinchGestureRecognizer *pinch    = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchHandlerView:)];

    UIRotationGestureRecognizer *rot   = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotateHandlerView:)];
    rot.delegate = self;
    pinch.delegate = self;

    [_imageView addGestureRecognizer:rot];
    [_imageView addGestureRecognizer:pinch];

}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView* view= [super hitTest:point withEvent:event];
    if(view==self){
        return nil;
    }
    return view;
}

- (UIImageView*)imageView
{
    return _imageView;
}

- (void)pushedDeleteBtn:(id)sender
{
    CLEmoticonView *nextTarget = nil;
    
    const NSInteger index = [self.superview.subviews indexOfObject:self];
    
    for(NSInteger i=index+1; i<self.superview.subviews.count; ++i){
        UIView *view = [self.superview.subviews objectAtIndex:i];
        if([view isKindOfClass:[CLEmoticonView class]]){
            nextTarget = (CLEmoticonView*)view;
            break;
        }
    }
    
    if(nextTarget==nil){
        for(NSInteger i=index-1; i>=0; --i){
            UIView *view = [self.superview.subviews objectAtIndex:i];
            if([view isKindOfClass:[CLEmoticonView class]]){
                nextTarget = (CLEmoticonView*)view;
                break;
            }
        }
    }
    
    [[self class] setActiveEmoticonView:nextTarget];
    [self removeFromSuperview];
    
    self.deleteBlock();
}

- (void)setAvtive:(BOOL)active
{
    _deleteButton.hidden = !active;
    _circleView.hidden = !active;
    
    if (self.isSticker ==  true){
        _imageView.layer.borderWidth = (active) ? 1/_scale : 0;
    }
}


- (void)viewDidTap:(UITapGestureRecognizer*)sender
{
    [[self class] setActiveEmoticonView:self];
}

- (void)viewDidPan:(UIPanGestureRecognizer*)sender
{
    [[self class] setActiveEmoticonView:self];
    
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
    NSLog(@"_initialScale ==== %f",(_initialScale * R / tmpR));

    NSLog(@"scale ==== %f",MAX(_initialScale * R / tmpR, _minScale));
    [self setScale:MAX(_initialScale * R / tmpR, _minScale)];
}

- (void)setRotation:(CGFloat)rotation
{
    _rotation = rotation;
    [self calcTransform];
}

- (void)setMinScale:(CGFloat)scale
{
    _minScale = scale;
}

- (void)setScale:(CGFloat)scale
{
    _scale = scale;
    
    self.transform = CGAffineTransformIdentity;
    
    _imageView.transform = CGAffineTransformMakeScale(_scale, _scale);
    
    CGRect rct = self.frame;
    rct.origin.x += (rct.size.width - (_imageView.width + 32)) / 2;
    rct.origin.y += (rct.size.height - (_imageView.height + 32)) / 2;
    rct.size.width  = _imageView.width + 32;
    rct.size.height = _imageView.height + 32;
    self.frame = rct;
    
    _imageView.center = CGPointMake(rct.size.width/2, rct.size.height/2);
    
    self.transform = CGAffineTransformMakeRotation(_arg);
    
    if (self.isSticker ==  true){
        _imageView.layer.borderWidth = 1/_scale;
        _imageView.layer.cornerRadius = 3/_scale;
    }
}

- (void)calcTransform
{
    CGAffineTransform transform = CGAffineTransformIdentity;
    transform = CGAffineTransformTranslate(transform, -self.offset*sin(self.rotation), self.offset*cos(self.rotation));
    transform = CGAffineTransformRotate(transform, self.rotation);
    transform = CGAffineTransformScale(transform, 1, 1);
    self.transform = transform;
}

- (void)rotateHandlerView:(UIRotationGestureRecognizer*)sender
{
    static CGFloat initialRotation;
    if (sender.state == UIGestureRecognizerStateBegan) {
        initialRotation = self.rotation;
    }
    
    self.rotation = MIN(M_PI/2, MAX(-M_PI/2, initialRotation + sender.rotation));
    
}

- (void)pinchHandlerView:(UIPinchGestureRecognizer*)sender
{
  
    static CGFloat initialScale;
    if (sender.state == UIGestureRecognizerStateBegan) {
        initialScale = self.scale;
    }
            
    self.scale = MIN(2, MAX(0.2, initialScale * sender.scale));

}

@end
