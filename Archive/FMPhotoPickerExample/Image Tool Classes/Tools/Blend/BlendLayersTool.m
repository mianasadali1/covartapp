//
//  BlendLayersTool.m
//  BasicFilters
//
//  Created by Kanwarpal Singh on 21/08/17.
//  Copyright © 2017 Kanwarpal Singh. All rights reserved.
//

#import "BlendLayersTool.h"
#import "UIView+Frame.h"
#import "UIImage+Utility.h"
#import "CustomUIView.h"

@implementation BlendLayersTool
{
    UIScrollView    *_containerScrollView;

    CustomUIView    *_containerView;
    UISlider        *_slider;
    UIImage         *_originalImage;
    UITableView     *_tableView;
    UIButton        *_addBtn;
    
    NSMutableArray  *_allImages;
    NSMutableArray  *_allImageViews;
    
    NSInteger       selectedIndex;
    UIPinchGestureRecognizer *pinch;
    UIPanGestureRecognizer *panGesture;
    NSUInteger blendMode;

}

- (void)setup
{
    _allImages                      =   [NSMutableArray new];
    _allImageViews                  =   [NSMutableArray new];
    _originalImage                  =   self.editor.imageView.image;
    
    _containerScrollView                  =   [[UIScrollView alloc] initWithFrame:self.editor.imageView.bounds];
    _containerScrollView.delegate         =   self;
    _containerScrollView.backgroundColor  =   [UIColor clearColor];
    
    _containerView                  =   [[CustomUIView alloc] initWithFrame:self.editor.imageView.bounds];
    _containerView.blendMode        =   kCGBlendModeNormal;
    _containerView.origionalImage   =   _originalImage;
    _containerView.backgroundColor      =   self.editor.barColor;
    [_containerScrollView addSubview:_containerView];

    [self.editor.imageView addSubview:_containerScrollView];
    
    [self addBaseImage];
    [self initMenuScrollView];
    [self setMenu];
    [self addPlusBtn];
    [self addTableView];
    [self initSliderView];
    
    self.editor.imageView.userInteractionEnabled                        =   YES;
    self.editor.scrollView.panGestureRecognizer.minimumNumberOfTouches  =   2;
    self.editor.scrollView.panGestureRecognizer.delaysTouchesBegan      =   NO;
    self.editor.scrollView.pinchGestureRecognizer.delaysTouchesBegan    =   NO;
}

-(void)initSliderView{
    
    _sliderView                 =   [[UIView alloc]initWithFrame:CGRectMake(0, _menuScrollView.frame.origin.y - _menuScrollView.frame.size.width, _menuScrollView.frame.size.width , _menuScrollView.frame.size.height)];
    _sliderView.backgroundColor =   self.editor.barColor;
    [_menuScrollView addSubview:_sliderView];
    
    _slider = [[UISlider alloc] initWithFrame:CGRectMake(10, (_menuScrollView.frame.size.height - 40)/2, _menuScrollView.frame.size.width - 20, 40)];
    
    _slider.continuous          =   NO;
    [_slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    _slider.maximumValue        =   1;
    _slider.minimumValue        =   0;
    _slider.value               =   0.2;
    
    [_sliderView addSubview:_slider];
    
    [_menuScrollView addSubview:_sliderView];
    _sliderView.hidden          =   true;
}

- (void)sliderValueChanged:(UISlider*)slider
{
    UIImageView *imgView    =   [_allImageViews objectAtIndex:selectedIndex];
    imgView.alpha           =   slider.value;
    
    [_allImageViews replaceObjectAtIndex:selectedIndex withObject:imgView];
    [_containerView setNeedsDisplay];

}

-(void)addBaseImage{
    UIImageView *_imageView         =   [UIImageView new];
    _imageView.image                =   _originalImage;
    _imageView.contentMode          =   UIViewContentModeScaleAspectFit;
    _imageView.tag                  =   100;
    _imageView.alpha                =   0.0;
    _imageView.layer.borderColor    =   [UIColor blueColor].CGColor;
    _imageView.layer.borderWidth    =   2.0;
    
    [_containerView addSubview:_imageView];
    [self resetImageViewFrame:_imageView];
    
    self.editor.imageView.image =   nil;
}

-(void)addPlusBtn{
    _addBtn                 =   [UIButton buttonWithType:UIButtonTypeCustom];
    _addBtn.frame           =   CGRectMake(self.editor.view.width - 50, 65, 50, 50);
    [_addBtn setBackgroundImage:[UIImage imageNamed:@"add_photo"] forState:UIControlStateNormal];
    [_addBtn addTarget:self action:@selector(addImage:) forControlEvents:UIControlEventTouchUpInside];
    [self.editor.view addSubview:_addBtn];
}

-(void)addTableView{
    
    _tableView                  =   [[UITableView alloc]initWithFrame:CGRectMake(_addBtn.left, _addBtn.top + _addBtn.height, 65, self.editor.view.height - _addBtn.top - _addBtn.height - self.menuScrollView.height) style:UITableViewStylePlain];
    _tableView.delegate         =   self;
    _tableView.backgroundColor  =   self.editor.barColor;
    //_tableView.backgroundView   =   [[UIView alloc]initWithFrame:CGRectZero];
    _tableView.dataSource       =   self;
    _tableView.editing          =   true;
    _tableView.layer.borderColor    =   [UIColor darkGrayColor].CGColor;
    _tableView.layer.borderWidth    =   2.0;
    [self.editor.view addSubview:_tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _allImages.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier =   @"cellIdentifier";
    UITableViewCell *cell           =   [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.backgroundColor            =   [UIColor clearColor];
    cell.backgroundView             =   [[UIView alloc]initWithFrame:CGRectZero];
    
    UIImage *img                    =   [_allImages objectAtIndex:indexPath.row];

    UIImageView *imgView            =   [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 60, 60)];
    imgView.image                   =   img;
    imgView.contentMode             =   UIViewContentModeScaleAspectFill;
    imgView.layer.borderColor       =   [UIColor clearColor].CGColor;
    
    if(indexPath.row == selectedIndex){
        imgView.layer.borderColor   =   [UIColor blueColor].CGColor;
    }
    else{
        imgView.layer.borderColor   =   [UIColor darkGrayColor].CGColor;
    }
    
    imgView.layer.borderWidth       =   1.0;
    [cell.contentView addSubview:imgView];
    cell.showsReorderControl        =   false;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    selectedIndex   =   indexPath.row;
    [_tableView reloadData];
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    
    selectedIndex           =   sourceIndexPath.row;

    UIImage *img            =   [_allImages objectAtIndex:sourceIndexPath.row];
    UIImageView *imgV       =   [_allImageViews objectAtIndex:sourceIndexPath.row];

    [_allImages removeObject:img];
    [_allImages insertObject:img atIndex:destinationIndexPath.row];
    
    [_allImageViews removeObject:imgV];
    [_allImageViews insertObject:imgV atIndex:destinationIndexPath.row];
    
    [_tableView reloadData];
    
    [self reArrangeAllImages];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableview shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath  {
    return YES;
}

-(void)addImage:(id)sender{
    UIImagePickerController *picker =   [[UIImagePickerController alloc] init];
    picker.delegate                 =   self;
    picker.allowsEditing            =   NO;
    picker.sourceType               =   UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self.editor presentViewController:picker animated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    [self addImageView:image];
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

-(void)reArrangeAllImages{
    for(UIView *v in _containerView.subviews){
        if(v.tag == 9999){
            [v removeFromSuperview];
        }
    }
    
    for(UIImageView *imgV in _allImageViews){
        imgV.layer.borderColor    =   [UIColor blueColor].CGColor;
        imgV.layer.borderWidth    =   2.0;
        [_containerView addSubview:imgV];
    }
    
    [_containerView setNeedsDisplay];
    [self addGestures];
}

-(void)addImageView:(UIImage *)img{
    [_allImages addObject:img];

    UIImageView *_imageView     =   [UIImageView new];
    _imageView.image            =   img;
    _imageView.contentMode      =   UIViewContentModeScaleAspectFit;
    _imageView.tag              =   9999;
    _imageView.alpha            =   kOverlayAlpha;
    _imageView.layer.borderColor    =   [UIColor blueColor].CGColor;
    _imageView.layer.borderWidth    =   2.0;
    selectedIndex               =   _allImages.count - 1;
    [_containerView addSubview:_imageView];
    [self resetImageViewFrame:_imageView];
    [_allImageViews addObject:_imageView];
    
    _imageView.userInteractionEnabled   =   true;
    [_tableView reloadData];
    [self addGestures];
    
    UITapGestureRecognizer *tapGesture  =   [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGetsure:)];
    tapGesture.numberOfTapsRequired     =   1;
    [_imageView addGestureRecognizer:tapGesture];
    
    [self updateView];
}

-(void)updateView{
    _containerView.blendMode    = [self getBlendModeForImage];
    
    [_containerView setNeedsDisplay];
}

-(void)addGestures{
    
    [pinch removeTarget:self action:@selector(pinchHandlerView:)];
    [panGesture removeTarget:self action:@selector(panHandlerView:)];

    UIImageView *imgV   =   [_allImageViews objectAtIndex:selectedIndex];

    pinch               =   [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchHandlerView:)];
    pinch.delegate      =   self;
    [imgV addGestureRecognizer:pinch];
    
    panGesture          =   [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panHandlerView:)];
    
    [imgV addGestureRecognizer:panGesture];
}

-(void)tapGetsure:(UITapGestureRecognizer *)sender{
    UIImageView *sourceView     =   (UIImageView *)[sender view];
    
    selectedIndex               =   [_allImageViews indexOfObject:sourceView];
    [self reArrangeAllImages];
}

- (void)panHandlerView:(UIPanGestureRecognizer*)sender
{
    UIImageView *sourceView =   (UIImageView *)[sender view];

    CGPoint point           =   [sender locationInView:_containerView];
    sourceView.center       =   point;
    NSLog(@"%@",NSStringFromCGRect(sourceView.frame));
    
    [self updateView];

}

- (void)pinchHandlerView:(UIPinchGestureRecognizer*)sender
{
    UIImageView *sourceView =   (UIImageView *)[sender view];
    static CGRect initialFrame;
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        initialFrame                =  sourceView.frame;
    }
    
    CGFloat scale                   =   sender.scale;
    CGRect rect;
    rect.size.width                 =   initialFrame.size.width*scale;
    rect.size.height                =   initialFrame.size.height*scale;
    rect.origin.x                   =   initialFrame.origin.x + (initialFrame.size.width-rect.size.width)/2;
    rect.origin.y                   =   initialFrame.origin.y + (initialFrame.size.height-rect.size.height)/2;
    
    if (rect.size.width < 100 || rect.size.height < 100){
        return;
    }
    sourceView.frame                =   rect;
    sourceView.layer.borderColor    =   [UIColor yellowColor].CGColor;
    sourceView.layer.borderWidth    =   2;
    
    [self updateView];

}

- (void)resetImageViewFrame:(UIImageView *)imgView;
{
    CGSize size = (imgView.image) ? imgView.image.size : imgView.frame.size;
    if(size.width>0 && size.height>0){
        CGFloat ratio = MIN(_containerView.frame.size.width / size.width, _containerView.frame.size.height / size.height);
        CGFloat W = ratio * size.width * _containerScrollView.zoomScale;
        CGFloat H = ratio * size.height * _containerScrollView.zoomScale;
        
        imgView.frame = CGRectMake(MAX(0, (_containerView.width-W)/2), MAX(0, (_containerView.height-H)/2), W, H);
        imgView.layer.borderWidth   =   2;
        imgView.layer.borderColor   =   [UIColor yellowColor].CGColor;
    }
}

- (void)initMenuScrollView
{
    if(self.menuScrollView==nil){
        UIScrollView *menuScroll                    =   [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.editor.view.width, kMenuBarHeight)];
        menuScroll.top                              =   self.editor.view.height - menuScroll.height;
        menuScroll.autoresizingMask                 =   UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        menuScroll.showsHorizontalScrollIndicator   =   NO;
        menuScroll.showsVerticalScrollIndicator     =   NO;
        
        [self.editor.view addSubview:menuScroll];
        self.menuScrollView                         =   menuScroll;
    }
    self.menuScrollView.backgroundColor             =   [UIColor whiteColor];
}

- (void)setMenu
{
    CGFloat W = 70;
    CGFloat H = self.menuScrollView.height;
    CGFloat x = 0;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        W   =   100;
    }
    
    NSArray *_menu = @[
                       @{@"title":@"Normal", @"icon":[UIImage imageNamed:@"adjust"]},
                       @{@"title":@"Multiply", @"icon":[UIImage imageNamed:@"adjust"]},
                       @{@"title":@"Screen", @"icon":[UIImage imageNamed:@"adjust"]},
                       @{@"title":@"Overlay", @"icon":[UIImage imageNamed:@"adjust"]},
                       @{@"title":@"Darken", @"icon":[UIImage imageNamed:@"adjust"]},
                       @{@"title":@"Lighten", @"icon":[UIImage imageNamed:@"adjust"]},
                       @{@"title":@"Darken", @"icon":[UIImage imageNamed:@"adjust"]},
                       @{@"title":@"Color Dodge", @"icon":[UIImage imageNamed:@"adjust"]},
                       @{@"title":@"Color Burn", @"icon":[UIImage imageNamed:@"adjust"]},
                       @{@"title":@"Soft Light", @"icon":[UIImage imageNamed:@"adjust"]},
                       @{@"title":@"Hard Light", @"icon":[UIImage imageNamed:@"adjust"]},
                       @{@"title":@"Difference", @"icon":[UIImage imageNamed:@"adjust"]},
                       @{@"title":@"Exclusion", @"icon":[UIImage imageNamed:@"adjust"]},
                       @{@"title":@"Hue", @"icon":[UIImage imageNamed:@"adjust"]},
                       @{@"title":@"Saturation", @"icon":[UIImage imageNamed:@"adjust"]},
                       @{@"title":@"Color", @"icon":[UIImage imageNamed:@"adjust"]},
                       @{@"title":@"Luminosity", @"icon":[UIImage imageNamed:@"adjust"]},
                       ];
    
    NSInteger tag = 0;
    for(NSDictionary *obj in _menu){
        ToolBarItem *view = [CLImageEditorTheme menuItemWithFrame:CGRectMake(x, 0, W, H) target:self action:@selector(tappedMenu:) toolInfo:nil isIcon:true];
        view.tag = tag++;
        view.iconView.image     = obj[@"icon"];
        view.titleLabel.text    = obj[@"title"];
        
        [self.menuScrollView addSubview:view];
        x += W;
    }
    self.menuScrollView.contentSize = CGSizeMake(MAX(x, self.menuScrollView.frame.size.width+1), 0);
}

- (void)tappedMenu:(UITapGestureRecognizer*)sender
{
    sender.view.alpha = 0.2;
    [UIView animateWithDuration:kCLImageToolAnimationDuration
                     animations:^{
                         sender.view.alpha = 1;
                     }
     ];
    
    blendMode = sender.view.tag;

    [UIView animateWithDuration:kCLImageToolAnimationDuration
                     animations:^{
                         
                     }
                     completion:^(BOOL finished) {
                     }
     ];
    
    [self updateView];
}

- (void)cleanup
{
    [self.menuScrollView removeFromSuperview];
    [_containerView removeFromSuperview];

    [_tableView removeFromSuperview];
    [_addBtn removeFromSuperview];
    
    self.editor.imageView.userInteractionEnabled                        =   NO;
    self.editor.scrollView.panGestureRecognizer.minimumNumberOfTouches  =   1;
    
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

-(void)buildThumbnailImage:(void (^)(UIImage *result))completionHandler{
    
    double widthScaleFactor             =   1;
    double heightScaleFactor            =   1;
    
    CGRect rect                         =   CGRectMake(0, 0, self.editor.imageView.frame.size.width/widthScaleFactor,self.editor.imageView.frame.size.height/heightScaleFactor);
    
    UIGraphicsImageRenderer *renderer   =   [[UIGraphicsImageRenderer alloc] initWithSize:rect.size];
    
    UIImage *image                      =   [renderer imageWithActions:^(UIGraphicsImageRendererContext * _Nonnull context) {
        [_originalImage drawInRect:rect blendMode:[self getBlendModeForImage] alpha:1];
        
        for(UIImageView *imgv in _allImageViews){
            
            CGRect expectedFrame        =   CGRectMake(imgv.left/widthScaleFactor, imgv.top/heightScaleFactor, imgv.width / widthScaleFactor, imgv.height / heightScaleFactor);
            
            CGRect visibleRect          =   CGRectMake(expectedFrame.origin.x - rect.origin.x,expectedFrame.origin.y - rect.origin.y, imgv.width / widthScaleFactor,imgv.height / heightScaleFactor);
            
            [imgv.image drawInRect:visibleRect blendMode:[self getBlendModeForImage] alpha:imgv.alpha];
        }
    }];
    
    completionHandler(image);
}

-(void)buildImage:(void (^)(UIImage *result))completionHandler{
    double widthScaleFactor             =   self.editor.imageView.frame.size.width/_originalImage.size.width;
    double heightScaleFactor            =   self.editor.imageView.frame.size.height/_originalImage.size.height;
    
    CGRect rect                         =   CGRectMake(0, 0, self.editor.imageView.frame.size.width/widthScaleFactor,self.editor.imageView.frame.size.height/heightScaleFactor);
    
    UIGraphicsImageRendererFormat *format   =   [[UIGraphicsImageRendererFormat alloc]init];
    format.scale                        =   _originalImage.scale;
   
    UIGraphicsImageRenderer *renderer   =   [[UIGraphicsImageRenderer alloc] initWithSize:rect.size format:format];
    
    UIImage *image                      =   [renderer imageWithActions:^(UIGraphicsImageRendererContext * _Nonnull context) {
        [_originalImage drawInRect:rect blendMode:[self getBlendModeForImage] alpha:1];

        for(UIImageView *imgv in _allImageViews){
            
            CGRect expectedFrame        =   CGRectMake(imgv.left/widthScaleFactor, imgv.top/heightScaleFactor, imgv.width / widthScaleFactor, imgv.height / heightScaleFactor);
            
            CGRect visibleRect          =   CGRectMake(expectedFrame.origin.x - rect.origin.x,expectedFrame.origin.y -  rect.origin.y, imgv.width / widthScaleFactor,imgv.height / heightScaleFactor);
            
            [imgv.image drawInRect:visibleRect blendMode:[self getBlendModeForImage] alpha:1.0];
        }
    }];
    
    completionHandler(image);
}

-(CGBlendMode)getBlendModeForImage{
    switch (blendMode) {
        case 0:
            return kCGBlendModeNormal;
            break;
        case 1:
            return kCGBlendModeMultiply;
            break;
        case 2:
            return kCGBlendModeScreen;
            break;
        case 3:
            return kCGBlendModeOverlay;
            break;
        case 4:
            return kCGBlendModeDarken;
            break;
        case 5:
            return kCGBlendModeLighten;
            break;
        case 6:
            return kCGBlendModeColorDodge;
            break;
        case 7:
            return kCGBlendModeColorBurn;
            break;
        case 8:
            return kCGBlendModeSoftLight;
            break;
        case 9:
            return kCGBlendModeHardLight;
            break;
        case 10:
            return kCGBlendModeDifference;
            break;
        case 11:
            return kCGBlendModeExclusion;
            break;
        case 12:
            return kCGBlendModeHue;
            break;
        case 13:
            return kCGBlendModeSaturation;
            break;
        case 14:
            return kCGBlendModeColor;
            break;
        case 15:
            return kCGBlendModeColor;
            break;
        default:
            return kCGBlendModeLuminosity;

            break;
    }
}

//-(void)buildImage1:(void (^)(UIImage *result))completionHandler{
//    
//    UIImageView *leadingImgV    =   [_allImageViews firstObject];
//    UIImageView *topImgV        =   [_allImageViews firstObject];
//    UIImageView *trailingImgV   =   [_allImageViews firstObject];
//    UIImageView *bottomImgV     =   [_allImageViews firstObject];
//    
//    for(UIImageView *imgv in _allImageViews){
//        if(imgv.left < leadingImgV.left){
//            leadingImgV = imgv;
//        }
//    }
//    
//    for(UIImageView *imgv in _allImageViews){
//        if(imgv.top < topImgV.top){
//            topImgV = imgv;
//        }
//    }
//    
//    for(UIImageView *imgv in _allImageViews){
//        if(imgv.right > trailingImgV.right){
//            trailingImgV = imgv;
//        }
//    }
//    
//    for(UIImageView *imgv in _allImageViews){
//        if(imgv.bottom > bottomImgV.bottom){
//            bottomImgV = imgv;
//        }
//    }
//    
//    double widthScaleFactor             =   trailingImgV.frame.size.width/trailingImgV.image.size.width;
//    double heightScaleFactor            =   bottomImgV.frame.size.height/bottomImgV.image.size.height;
//    
//    CGRect rect                         =   CGRectMake((leadingImgV.left/widthScaleFactor), (topImgV.top/heightScaleFactor), (trailingImgV.right/widthScaleFactor) - (leadingImgV.left/widthScaleFactor)  , (bottomImgV.bottom/heightScaleFactor) - (topImgV.top/heightScaleFactor));
//    
//    UIGraphicsImageRenderer *renderer   =   [[UIGraphicsImageRenderer alloc] initWithSize:rect.size];
//    
//    UIImage *image                      =   [renderer imageWithActions:^(UIGraphicsImageRendererContext * _Nonnull context) {
//        
//        for(UIImageView *imgv in _allImageViews){
//            
//            CGRect expectedFrame        =   CGRectMake(imgv.left/widthScaleFactor, imgv.top/heightScaleFactor, imgv.width / widthScaleFactor, imgv.height / heightScaleFactor);
//            
//            CGRect visibleRect          =   CGRectMake(expectedFrame.origin.x - rect.origin.x,expectedFrame.origin.y - rect.origin.y, imgv.width / widthScaleFactor,imgv.height / heightScaleFactor);
//            
//            [imgv.image drawInRect:visibleRect blendMode:[self getBlendModeForImage] alpha:imgv.alpha];
//        }
//    }];
//    
//    completionHandler(image);
//}

@end
