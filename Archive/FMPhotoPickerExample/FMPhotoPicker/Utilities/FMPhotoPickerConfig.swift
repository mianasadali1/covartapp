//
//  FMPhotoPickerOptions.swift
//  FMPhotoPicker
//
//  Created by c-nguyen on 2018/02/09.
//  Copyright © 2018 Tribal Media House. All rights reserved.
//

import Foundation
import Photos

public enum FMSelectMode {
    case multiple
    case single
}

public enum FMMediaType {
    case image
    case video
    case unsupported
    
    public func value() -> Int {
        switch self {
        case .image:
            return PHAssetMediaType.image.rawValue
        case .video:
            return PHAssetMediaType.video.rawValue
        case .unsupported:
            return PHAssetMediaType.unknown.rawValue
        }
    }
    
    init(withPHAssetMediaType type: PHAssetMediaType) {
        switch type {
        case .image:
            self = .image
        case .video:
            self = .video
        default:
            self = .unsupported
        }
    }
}

public struct FMPhotoPickerConfig {
    public var mediaTypes: [FMMediaType] = [.image]
    public var selectMode: FMSelectMode = .multiple
    public var maxImage: Int = 10
    public var maxVideo: Int = 10
    public var availableFilters: [FMFilterable] = kDefaultAvailableFilters
    public var availableCrops: [FMCroppable] = kDefaultAvailableCrops
    public var alertController: FMAlertable = FMAlert()
    
    public var forceCropEnabled = false
    public var eclipsePreviewEnabled = false
    
    public var titleFontSize: CGFloat = 17
    
    public var strings: [String: String] = [
        "picker_button_cancel":                     "Cancel",
        "picker_button_select_done":                "Done",
        "picker_warning_over_image_select_format":  "You can select maximum %d images",
        "picker_warning_over_video_select_format":  "You can select maximum %d videos",
        
        "present_title_photo_created_date_format":  "yyyy/M/d",
        "present_button_back":                      "Back",
        "present_button_edit_image":                "Edit",
        
        "editor_button_cancel":                     "Cancel",
        "editor_button_done":                       "Done",
        "editor_menu_filter":                       "Filter",
        "editor_menu_crop":                         "Crop",
        "editor_menu_crop_button_reset":            "Reset",
        "editor_menu_crop_button_rotate":           "Rotate",
        
        "editor_crop_ratio3x2":                     "3:2",
        "editor_crop_ratio4x3":                     "4:3",
        "editor_crop_ratio5x3":                     "5:3",
        "editor_crop_ratio5x4":                     "5:4",
        "editor_crop_ratio6x4":                     "6:4",
        "editor_crop_ratio16x9":                    "16:9",
        "editor_crop_ratio9x16":                    "9:16",
        "editor_crop_ratio4x6":                     "4:6",
        "editor_crop_ratio4x5":                     "4:5",
        "editor_crop_ratio3x5":                     "3:5",
        "editor_crop_ratio3x4":                     "3:4",
        "editor_crop_ratio2x3":                     "2:3",
        "editor_crop_FBCover":                      "Facebook Cover",
        "editor_crop_FBProfileImage":               "Facebook Profile Image",
        "editor_crop_FBEventImage":                 "Facebook Post",
        "editor_crop_LinkedInBg":               "LinkedIn Background",
        "editor_crop_LinkedInProfileImage":               "LinkedIn Profile Image",
        "editor_crop_YouTubeCover":               "YouTube Cover",
        "editor_crop_YouTubeProfile":               "YouTube Profile Image",
        "editor_crop_InstagramProfile":               "Instagram Profile Image",
        "editor_crop_InstagramPost":               "Instagram Post",
        "editor_crop_InstagramStory":               "Instagram Story",
        "editor_crop_TwitterBG":               "Twitter Background",
        "editor_crop_TwitterPost":               "Twitter Post",
        "editor_crop_TumblerPost":               "Tumbler Post",
        "editor_crop_iPhoneWallpaper":               "iPhone Wallpaper",
        "editor_crop_iPadWallpaper":               "iPad Wallpaper",
        
        "editor_crop_ratioCustom":                  "Custom",
        "editor_crop_ratioOrigin":                  "Origin",
        "editor_crop_ratioSquare":                  "Square",
        
        ]
    
    public init() {
        
    }
}

