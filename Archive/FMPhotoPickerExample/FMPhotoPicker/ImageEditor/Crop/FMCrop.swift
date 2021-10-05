//
//  FMCrop.swift
//  FMPhotoPicker
//
//  Created by c-nguyen on 2018/03/09.
//  Copyright © 2018 Tribal Media House. All rights reserved.
//

import UIKit

public struct FMCropRatio {
    let width: CGFloat
    let height: CGFloat
    
    public init(width: CGFloat, height: CGFloat) {
        self.width = width
        self.height = height
    }
}

public enum FMCrop: FMCroppable {
    case ratioOrigin
    case ratioSquare
    case ratioCustom
    case ratio3x2
    case ratio4x3
    case ratio5x3
    case ratio5x4
    case ratio6x4
    case ratio16x9
    case ratio9x16
    case ratio4x6
    case ratio4x5
    case ratio3x5
    case ratio3x4
    case ratio2x3
    case FBCover
    case FBProfileImage
    case FBEventImage
    case LinkedInBg
    case LinkedInProfileImage
    case YouTubeCover
    case YouTubeProfile
    case InstagramProfile
    case InstagramPost
    case InstagramStory
    case TwitterBG
    case TwitterPost
    case TumblerPost
    case iPhoneWallpaper
    case iPadWallpaper
    
    public func ratio() -> FMCropRatio? {
        switch self {
        case .ratio4x3:
            return FMCropRatio(width: 4, height: 3)
        case .ratio16x9:
            return FMCropRatio(width: 16, height: 9)
        case .ratioSquare:
            return FMCropRatio(width: 1, height: 1)
            
        case .ratioOrigin:
            return nil
        case .ratioCustom:
            return nil
        case .ratio3x2:
            return FMCropRatio(width: 3, height: 2)
        case .ratio5x3:
            return FMCropRatio(width: 5, height: 3)
        case .ratio5x4:
            return FMCropRatio(width: 5, height: 4)
        case .ratio6x4:
            return FMCropRatio(width: 6, height: 4)
        case .ratio9x16:
            return FMCropRatio(width: 9, height: 16)
        case .ratio4x6:
            return FMCropRatio(width: 4, height: 6)
        case .ratio4x5:
            return FMCropRatio(width: 4, height: 5)
        case .ratio3x5:
            return FMCropRatio(width: 3, height: 5)
        case .ratio3x4:
            return FMCropRatio(width: 3, height: 4)
        case .ratio2x3:
            return FMCropRatio(width: 2, height: 3)
        case .FBCover:
            return FMCropRatio(width: 82, height: 31)
        case .FBProfileImage:
            return FMCropRatio(width: 1, height: 1)
        case .FBEventImage:
            return FMCropRatio(width: 16, height: 9)
        case .LinkedInBg:
            return FMCropRatio(width: 4, height: 1)
        case .LinkedInProfileImage:
            return FMCropRatio(width: 1, height: 1)
        case .YouTubeCover:
            return FMCropRatio(width: 16, height: 9)
        case .YouTubeProfile:
            return FMCropRatio(width: 1, height: 1)
        case .InstagramProfile:
            return FMCropRatio(width: 1, height: 1)
        case .InstagramPost:
            return FMCropRatio(width: 1, height: 1)
        case .InstagramStory:
            return FMCropRatio(width: 9, height: 16)
        case .TwitterBG:
            return FMCropRatio(width: 3, height: 1)
        case .TwitterPost:
            return FMCropRatio(width: 2, height: 1)
        case .TumblerPost:
            return FMCropRatio(width: 2, height: 3)
        case .iPhoneWallpaper:
            return FMCropRatio(width: 40, height: 71)
        case .iPadWallpaper:
            return FMCropRatio(width: 3, height: 4)
        }
    }
    
    public func name(strings: [String: String]) -> String? {
        switch self {
        case .ratio4x3: return strings["editor_crop_ratio4x3"]
        case .ratio16x9: return strings["editor_crop_ratio16x9"]
        case .ratioCustom: return strings["editor_crop_ratioCustom"]
        case .ratioOrigin: return strings["editor_crop_ratioOrigin"]
        case .ratioSquare: return strings["editor_crop_ratioSquare"]
        case .ratio3x2:
            return strings["editor_crop_ratio3x2"]
        case .ratio5x3:
            return strings["editor_crop_ratio5x3"]
        case .ratio5x4:
            return strings["editor_crop_ratio5x4"]
        case .ratio6x4:
            return strings["editor_crop_ratio6x4"]
        case .ratio9x16:
            return strings["editor_crop_ratio9x16"]
        case .ratio4x6:
            return strings["editor_crop_ratio4x6"]
        case .ratio4x5:
            return strings["editor_crop_ratio4x5"]
        case .ratio3x5:
            return strings["editor_crop_ratio3x5"]
        case .ratio3x4:
            return strings["editor_crop_ratio3x4"]
        case .ratio2x3:
            return strings["editor_crop_ratio2x3"]
        case .FBCover:
            return strings["editor_crop_FBCover"]
        case .FBProfileImage:
            return strings["editor_crop_FBProfileImage"]
        case .FBEventImage:
            return strings["editor_crop_FBEventImage"]
        case .LinkedInBg:
            return strings["editor_crop_LinkedInBg"]
        case .LinkedInProfileImage:
            return strings["editor_crop_LinkedInProfileImage"]
        case .YouTubeCover:
            return strings["editor_crop_YouTubeCover"]
        case .YouTubeProfile:
            return strings["editor_crop_YouTubeProfile"]
        case .InstagramProfile:
            return strings["editor_crop_InstagramProfile"]
        case .InstagramPost:
            return strings["editor_crop_InstagramPost"]
        case .InstagramStory:
            return strings["editor_crop_InstagramStory"]
        case .TwitterBG:
            return strings["editor_crop_TwitterBG"]
        case .TwitterPost:
            return strings["editor_crop_TwitterPost"]
        case .TumblerPost:
            return strings["editor_crop_TumblerPost"]
        case .iPhoneWallpaper:
            return strings["editor_crop_iPhoneWallpaper"]
        case .iPadWallpaper:
            return strings["editor_crop_iPadWallpaper"]
            
        }
    }
    
    public func icon() -> UIImage {
        var icon: UIImage?
        switch self {
        case .ratio4x3:
            icon = UIImage(named: "icon_crop_4x3", in: Bundle(for: FMPhotoPickerViewController.self), compatibleWith: nil)
        case .ratio16x9:
            icon = UIImage(named: "icon_crop_16x9", in: Bundle(for: FMPhotoPickerViewController.self), compatibleWith: nil)
        case .ratioCustom:
            icon = UIImage(named: "icon_crop_custom", in: Bundle(for: FMPhotoPickerViewController.self), compatibleWith: nil)
        case .ratioOrigin:
            icon = UIImage(named: "icon_crop_origin_ratio", in: Bundle(for: FMPhotoPickerViewController.self), compatibleWith: nil)
        case .ratioSquare:
            icon = UIImage(named: "icon_crop_square", in: Bundle(for: FMPhotoPickerViewController.self), compatibleWith: nil)
        case .ratio3x2:
            icon = UIImage(named: "icon_crop_3x2", in: Bundle(for: FMPhotoPickerViewController.self), compatibleWith: nil)
        case .ratio5x3:
            icon = UIImage(named: "icon_crop_5x3", in: Bundle(for: FMPhotoPickerViewController.self), compatibleWith: nil)
        case .ratio5x4:
            icon = UIImage(named: "icon_crop_5x4", in: Bundle(for: FMPhotoPickerViewController.self), compatibleWith: nil)
        case .ratio6x4:
            icon = UIImage(named: "icon_crop_6x4", in: Bundle(for: FMPhotoPickerViewController.self), compatibleWith: nil)
        case .ratio9x16:
            icon = UIImage(named: "icon_crop_9x16", in: Bundle(for: FMPhotoPickerViewController.self), compatibleWith: nil)
        case .ratio4x6:
            icon = UIImage(named: "icon_crop_4x6", in: Bundle(for: FMPhotoPickerViewController.self), compatibleWith: nil)
        case .ratio4x5:
            icon = UIImage(named: "icon_crop_4x5", in: Bundle(for: FMPhotoPickerViewController.self), compatibleWith: nil)
        case .ratio3x5:
            icon = UIImage(named: "icon_crop_3x5", in: Bundle(for: FMPhotoPickerViewController.self), compatibleWith: nil)
        case .ratio3x4:
            icon = UIImage(named: "icon_crop_3x4", in: Bundle(for: FMPhotoPickerViewController.self), compatibleWith: nil)
        case .ratio2x3:
            icon = UIImage(named: "icon_crop_2x3", in: Bundle(for: FMPhotoPickerViewController.self), compatibleWith: nil)
        case .FBCover:
            icon = UIImage(named: "facebook", in: Bundle(for: FMPhotoPickerViewController.self), compatibleWith: nil)
        case .FBProfileImage:
            icon = UIImage(named: "facebook", in: Bundle(for: FMPhotoPickerViewController.self), compatibleWith: nil)
        case .FBEventImage:
            icon = UIImage(named: "facebook", in: Bundle(for: FMPhotoPickerViewController.self), compatibleWith: nil)
        case .LinkedInBg:
            icon = UIImage(named: "linkedin", in: Bundle(for: FMPhotoPickerViewController.self), compatibleWith: nil)
        case .LinkedInProfileImage:
            icon = UIImage(named: "linkedin", in: Bundle(for: FMPhotoPickerViewController.self), compatibleWith: nil)
        case .YouTubeCover:
            icon = UIImage(named: "youtube", in: Bundle(for: FMPhotoPickerViewController.self), compatibleWith: nil)
        case .YouTubeProfile:
            icon = UIImage(named: "youtube", in: Bundle(for: FMPhotoPickerViewController.self), compatibleWith: nil)
        case .InstagramProfile:
            icon = UIImage(named: "instagram", in: Bundle(for: FMPhotoPickerViewController.self), compatibleWith: nil)
        case .InstagramPost:
            icon = UIImage(named: "instagram", in: Bundle(for: FMPhotoPickerViewController.self), compatibleWith: nil)
        case .InstagramStory:
            icon = UIImage(named: "instagram", in: Bundle(for: FMPhotoPickerViewController.self), compatibleWith: nil)
        case .TwitterBG:
            icon = UIImage(named: "twitter", in: Bundle(for: FMPhotoPickerViewController.self), compatibleWith: nil)
        case .TwitterPost:
            icon = UIImage(named: "twitter", in: Bundle(for: FMPhotoPickerViewController.self), compatibleWith: nil)
        case .TumblerPost:
            icon = UIImage(named: "tumbler", in: Bundle(for: FMPhotoPickerViewController.self), compatibleWith: nil)
        case .iPhoneWallpaper:
            icon = UIImage(named: "iphone", in: Bundle(for: FMPhotoPickerViewController.self), compatibleWith: nil)
        case .iPadWallpaper:
            icon = UIImage(named: "ipad", in: Bundle(for: FMPhotoPickerViewController.self), compatibleWith: nil)
        }
        if icon != nil {
            return icon!
        }
        return UIImage()
    }
    
    public func identifier() -> String {
        switch self {
        case .ratio4x3: return "ratio4x3"
        case .ratio16x9: return "ratio16x9"
        case .ratioCustom: return "ratioCustom"
        case .ratioOrigin: return "ratioOrigin"
        case .ratioSquare: return "ratioSquare"
        case .ratio3x2:
            return "ratio3x2"
        case .ratio5x3:
            return "ratio5x3"
        case .ratio5x4:
            return "ratio5x4"
        case .ratio6x4:
            return "ratio6x4"
        case .ratio9x16:
            return "ratio9x16"
        case .ratio4x6:
            return "ratio4x6"
        case .ratio4x5:
            return "ratio4x5"
        case .ratio3x5:
            return "ratio3x5"
        case .ratio3x4:
            return "ratio3x4"
        case .ratio2x3:
            return "ratio2x3"
        case .FBCover:
            return "FBCover"
        case .FBProfileImage:
            return "FBProfileImage"
        case .FBEventImage:
            return "FBEventImage"
        case .LinkedInBg:
            return "LinkedInBg"
        case .LinkedInProfileImage:
            return "LinkedInProfileImage"
        case .YouTubeCover:
            return "YouTubeCover"
        case .YouTubeProfile:
            return "YouTubeProfile"
        case .InstagramProfile:
            return "InstagramProfile"
        case .InstagramPost:
            return "InstagramPost"
        case .InstagramStory:
            return "InstagramStory"
        case .TwitterBG:
            return "TwitterBG"
        case .TwitterPost:
            return "TwitterPost"
        case .TumblerPost:
            return "TumblerPost"
        case .iPhoneWallpaper:
            return "iPhoneWallpaper"
        case .iPadWallpaper:
            return "iPadWallpaper"
        }
    }
}

