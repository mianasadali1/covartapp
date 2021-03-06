/*
 * ACEDrawingView: https://github.com/acerbetti/ACEDrawingView
 *
 * Copyright (c) 2013 Stefano Acerbetti
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 */

#import <UIKit/UIKit.h>
#import "ACEDrawingToolState.h"
#import "ACEDrawingView.h"

static CGFloat const kDashedBorderWidth     = (2.0f);
static CGFloat const kDashedPhase           = (2.0f);
static CGFloat const kDashedLinesLength[]   = {4.0f, 2.0f};
static size_t const kDashedCount            = (2.0f);



//@class ACEDrawingView;
@class ACEDrawingLabelView;
@class ACEDrawingToolState;

#if __has_feature(objc_arc)
#define ACE_HAS_ARC 1
#define ACE_RETAIN(exp) (exp)
#define ACE_RELEASE(exp)
#define ACE_AUTORELEASE(exp) (exp)
#else
#define ACE_HAS_ARC 0
#define ACE_RETAIN(exp) [(exp) retain]
#define ACE_RELEASE(exp) [(exp) release]
#define ACE_AUTORELEASE(exp) [(exp) autorelease]
#endif


@protocol ACEDrawingTool <NSObject>

@property (nonatomic, strong) UIColor *lineColor;
@property (nonatomic, assign) CGFloat lineAlpha;
@property (nonatomic, assign) ACEDrawingBrushType brushType;

@property (nonatomic, assign) CGFloat lineWidth;

- (void)setInitialPoint:(CGPoint)firstPoint;
- (void)moveFromPoint:(CGPoint)startPoint toPoint:(CGPoint)endPoint;

- (void)draw;

- (ACEDrawingToolState *)captureToolState;

@optional

- (void)applyToolState:(ACEDrawingToolState *)state;

- (id)capturePositionObject;

@end

#pragma mark -

@interface ACEDrawingPenTool : UIBezierPath<ACEDrawingTool> {
    CGMutablePathRef path;
}

- (CGRect)addPathPreviousPreviousPoint:(CGPoint)p2Point withPreviousPoint:(CGPoint)p1Point withCurrentPoint:(CGPoint)cpoint;

@end

#pragma mark -

@interface ACEDrawingEraserTool : ACEDrawingPenTool

@end

#pragma mark -

@interface ACEDrawingLineTool : NSObject<ACEDrawingTool>

@end

#pragma mark -

@interface ACEDrawingDraggableTextTool : NSObject<ACEDrawingTool>

@property (nonatomic, weak) ACEDrawingView *drawingView;
@property (nonatomic, readonly) ACEDrawingLabelView *labelView;

- (void)capturePosition;
- (void)hideHandle;
- (void)undraw;

- (BOOL)canRedo;
- (BOOL)redo;

- (BOOL)canUndo;
- (void)undo;

@end

#pragma mark -

@interface ACEDrawingRectangleTool : NSObject<ACEDrawingTool>

@property (nonatomic, assign) BOOL fill;

@end

#pragma mark -

@interface ACEDrawingEllipseTool : NSObject<ACEDrawingTool>

@property (nonatomic, assign) BOOL fill;

@end

#pragma mark -

@interface ACEDrawingArrowTool : NSObject<ACEDrawingTool>
@end
