//
//  SelectorsList.m
//  UnlimitedEffects
//
//  Created by Kanwarpal Singh on 21/02/16.
//  Copyright © 2016 Kanwarpal Singh. All rights reserved.
//

#import "SelectorsList.h"
#import "MultiLineBasicShapes.h"
#import "MultiLineTextureEfefcts.h"
#import "MultiSquareShapes.h"
#import "SingleLineCludeShapesWithTexture.h"
#import "SingleLineSpikesWithTexture.h"
#import "TextureEffects.h"
#import "SingleLineArcShapeWithTexture.h"
#import "SingleLineShapes.h"
#import "SingleLineArcShapes.h"
#import "SingleLineCloudShapes.h"
#import "SingleLineSpikes.h"
#import "LinesShape.h"
#import "SmiliesShapes.h"
#import "MaskedImages.h"

@implementation SelectorsList

static SelectorsList *sharedInstance = nil;

+ (id)sharedInstance
{
    @synchronized(self) {
        if (sharedInstance == nil) {
            sharedInstance = [SelectorsList new];
        }
    }
    return sharedInstance;
}

-(UIImage *)getImageByApplyingEffectId:(CGSize)imageSize effectId:(NSUInteger)effectId{
    
   // dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *effectImg ;
        
        switch (effectId) {
            case 0:
                effectImg = [SingleLineShapes generateNoShapeImage:imageSize effectId:effectId];
                break;
            case 1:
                effectImg = [LinesShape generateImage:imageSize effectId:effectId];
                break;
            case 2:
                effectImg = [MultiLineBasicShapes generateImage:imageSize effectId:effectId];;
                break;
            case 3:
                effectImg = [MultiLineBasicShapes generateImage:imageSize effectId:effectId];
                break;
            case 4:
                effectImg = [MultiLineBasicShapes generateImage:imageSize effectId:effectId];
                break;
            case 5:
                effectImg = [MultiSquareShapes generateImage:imageSize effectId:effectId];
                break;
            case 6:
                effectImg = [SingleLineShapes generateImageAsWindow:imageSize effectId:effectId];
                break;
            case 7:
                effectImg = [SingleLineShapes generateImageAsWindow:imageSize effectId:effectId];
                break;
            case 8:
                effectImg = [SingleLineShapes generateImageAsWindow:imageSize effectId:effectId];
                break;
            case 9:
                effectImg = [SingleLineShapes generateImageAsWindow:imageSize effectId:effectId];
                break;
            case 10:
                effectImg = [SingleLineShapes generateImageAsWindow:imageSize effectId:effectId];
                break;
            case 11:
                effectImg = [SingleLineShapes generateImageAsWindow:imageSize effectId:effectId];
                break;
            case 12:
                effectImg = [SingleLineShapes generateImageAsWindow:imageSize effectId:effectId];
                break;
            case 13:
                effectImg = [SingleLineCloudShapes generateImage:imageSize effectId:effectId];
                break;
            case 14:
                effectImg = [SingleLineSpikes generateImage:imageSize effectId:effectId];
                break;
            case 15:
                effectImg = [MultiLineBasicShapes generateImage:imageSize effectId:effectId];
                break;
            case 16:
                effectImg = [MultiLineBasicShapes generateImage:imageSize effectId:effectId];
                break;
            case 17:
                effectImg = [MultiLineBasicShapes generateImage:imageSize effectId:effectId];;
                break;
            case 18:
                effectImg = [SingleLineCludeShapesWithTexture generateImage:imageSize effectId:effectId];;
                break;
            case 19:
                effectImg = [SingleLineSpikesWithTexture generateImage:imageSize effectId:effectId];;
                break;
            case 20:
                effectImg = [MultiLineBasicShapes generateImageAsWindow:imageSize effectId:effectId];
                break;
            case 21:
                effectImg = [MultiLineBasicShapes generateImageAsWindow:imageSize effectId:effectId];
                break;
            case 22:
                effectImg = [MultiLineBasicShapes generateImageAsWindow:imageSize effectId:effectId];
                break;
            case 23:
                effectImg = [MultiLineBasicShapes generateImageAsWindow:imageSize effectId:effectId];
                break;
            case 24:
                effectImg = [SingleLineShapes generateImage:imageSize effectId:effectId];
                break;
            case 25:
                effectImg = [SingleLineShapes generateImage:imageSize effectId:effectId];
                break;
            case 26:
                effectImg = [SingleLineShapes generateImage:imageSize effectId:effectId];
                break;
            case 27:
                effectImg = [SingleLineShapes generateImage:imageSize effectId:effectId];
                break;
            case 28:
                effectImg = [SingleLineShapes generateImage:imageSize effectId:effectId];
                break;
            case 29:
                effectImg = [SingleLineShapes generateImage:imageSize effectId:effectId];
                break;
            case 30:
                effectImg = [SingleLineShapes generateImage:imageSize effectId:effectId];
                break;
            case 31:
                effectImg = [SingleLineShapes generateImageAsWindow:imageSize effectId:effectId];
                break;
            case 32:
                effectImg = [SingleLineShapes generateImageAsWindow:imageSize effectId:effectId];
                break;
            case 33:
                effectImg = [SingleLineShapes generateImageAsWindow:imageSize effectId:effectId];
                break;
            case 34:
                effectImg = [SingleLineArcShapes generateImage:imageSize effectId:effectId];
                break;
            case 35:
                effectImg = [SingleLineCloudShapes generateImageAsWindow:imageSize effectId:effectId];
                break;
            case 36:
                effectImg = [SingleLineSpikes generateImageAsWindow:imageSize effectId:effectId];
                break;
            case 37:
                effectImg = [MultiLineBasicShapes generateImageAsWindow:imageSize effectId:effectId];;
                break;
            case 38:
                effectImg = [MultiLineBasicShapes generateImageAsWindow:imageSize effectId:effectId];;
                break;
            case 39:
                effectImg = [MultiLineBasicShapes generateImageAsWindow:imageSize effectId:effectId];;
                break;
            case 40:
                effectImg = [MultiLineTextureEfefcts generateImage:imageSize effectId:effectId];
                break;
            case 41:
                effectImg = [MultiLineTextureEfefcts generateImage:imageSize effectId:effectId];
                break;
            case 42:
                effectImg = [MultiLineTextureEfefcts generateImage:imageSize effectId:effectId];
                break;
            case 43:
                effectImg = [MultiLineTextureEfefcts generateImage:imageSize effectId:effectId];
                break;
            case 44:
                effectImg = [MultiLineTextureEfefcts generateImage:imageSize effectId:effectId];
                break;
            case 45:
                effectImg = [SingleLineCludeShapesWithTexture generateImageAsWindow:imageSize effectId:effectId];;
                break;
            case 46:
                effectImg = [SingleLineSpikesWithTexture generateImageAsWindow:imageSize effectId:effectId];;
                break;
            case 47:
                effectImg = [TextureEffects generateImage:imageSize effectId:effectId];;
                break;
            case 48:
                effectImg = [TextureEffects generateImage:imageSize effectId:effectId];;
                break;
            case 49:
                effectImg = [TextureEffects generateImage:imageSize effectId:effectId];;
                break;
            case 50:
                effectImg = [TextureEffects generateImage:imageSize effectId:effectId];;
                break;
            case 51:
                effectImg = [TextureEffects generateImage:imageSize effectId:effectId];;
                break;
            case 52:
                effectImg = [TextureEffects generateImage:imageSize effectId:effectId];;
                break;
            case 53:
                effectImg = [TextureEffects generateImage:imageSize effectId:effectId];;
                break;
            case 54:
                effectImg = [TextureEffects generateImage:imageSize effectId:effectId];;
                break;
            case 55:
                effectImg = [SingleLineArcShapeWithTexture generateImage:imageSize effectId:effectId];;
                break;
                
            default:
                effectImg = [MaskedImages generateImage:imageSize effectId:effectId];;
                break;
        }
        
        int rndValueForRotatedShape = [NSNumber randomIntInLimit:1 endLimit:10];
      
//        if (rndValueForRotatedShape > 5 && effectId < 17 && effectId > 0) {
//            effectImg = [UIImage rotateImage:effectImg];
//            effectImg = [UIImage addRotatedShapeOnGradientView:effectImg];
//        }
    
    return effectImg;
}

@end
