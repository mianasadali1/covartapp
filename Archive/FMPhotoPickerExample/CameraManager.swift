//
//  CameraManager.swift
//  FMPhotoPickerExample
//
//  Created by Kanwar on 9/15/18.
//  Copyright © 2018 Tribal Media House. All rights reserved.
//

import UIKit
public typealias CameraManagerCompletion = (UIImage?) -> Void

class CameraManager: NSObject,FMImageEditorViewControllerDelegate {
    var viewContainer : UIViewController? = nil
    
    @objc public func openCameraFrom(view: UIViewController,  completion: @escaping CameraManagerCompletion) {
        viewContainer = view
        var _: Bool = true
        let croppingEnabled: Bool = false
        let allowResizing: Bool = true
        let allowMoving: Bool = false
        let minimumSize: CGSize = CGSize(width: 60, height: 60)
        
        let croppingParameters = CroppingParameters(isEnabled: croppingEnabled, allowResizing: allowResizing, allowMoving: allowMoving, minimumSize: minimumSize)
        
        let cameraViewController = CameraViewController(croppingParameters: croppingParameters, allowsLibraryAccess: true) { [weak self] image, asset in
            //let img = UIImage.init(named: "4fef4rft4.jpg")
            completion(image)
        }
        cameraViewController.modalPresentationStyle = .fullScreen
        viewContainer?.present(cameraViewController, animated: true, completion: nil)
    }
    
    
    func config() -> FMPhotoPickerConfig {
        let selectMode: FMSelectMode = .single
        
        var mediaTypes = [FMMediaType]()
        mediaTypes.append(.image)
        mediaTypes.append(.video)
        
        var config = FMPhotoPickerConfig()
        
        config.selectMode = selectMode
        config.mediaTypes = mediaTypes
        //        config.maxImage = self.maxImage
        //        config.maxVideo = self.maxVideo
        //        config.forceCropEnabled = forceCropEnabled.isOn
        //        config.eclipsePreviewEnabled = eclipsePreviewEnabled.isOn
        
        // in force crop mode, only the first crop option is available
        config.availableCrops = [
            FMCrop.ratioOrigin,
            FMCrop.ratioSquare,
            FMCrop.ratioCustom,
            FMCrop.ratio3x2,
            FMCrop.ratio4x3,
            FMCrop.ratio5x3,
            FMCrop.ratio5x4,
            FMCrop.ratio6x4,
            FMCrop.ratio16x9,
            FMCrop.ratio9x16,
            FMCrop.ratio4x6,
            FMCrop.ratio4x5,
            FMCrop.ratio3x5,
            FMCrop.ratio3x4,
            FMCrop.ratio2x3,
            FMCrop.FBCover,
            FMCrop.FBProfileImage,
            FMCrop.FBEventImage,
            FMCrop.LinkedInBg,
            FMCrop.LinkedInProfileImage,
            FMCrop.YouTubeCover,
            FMCrop.YouTubeProfile,
            FMCrop.InstagramProfile,
            FMCrop.InstagramPost,
            FMCrop.InstagramStory,
            FMCrop.TwitterBG,
            FMCrop.TwitterPost,
            FMCrop.TumblerPost,
            FMCrop.iPhoneWallpaper,
            FMCrop.iPadWallpaper,
        ]
        
        // all available filters will be used
        config.availableFilters = []
        
        return config
    }
    
    
    @objc public func imageEditor(view: UIViewController,  image: UIImage) {
        viewContainer = view
        let vc = FMImageEditorViewController(config: self.config(), sourceImage: image)
        vc.delegate = self
        viewContainer?.present(vc, animated: true, completion: nil)
    }
    
    public func fmImageEditorViewController(_ editor: FMImageEditorViewController, didFinishEdittingPhotoWith photo: UIImage) {
        editor.dismiss(animated: true, completion: nil)
        
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ViewController") as? ViewController
        vc?.originalImage = photo
        vc?.modalPresentationStyle = .fullScreen

        viewContainer?.present(vc!, animated: true, completion: nil)
    }
}
