//
//  ViewController.swift
//  FMPhotoPickerExample
//
//  Created by c-nguyen on 2018/01/25.
//  Copyright © 2018 Tribal Media House. All rights reserved.
//

import UIKit

class ColorListController: UIViewController,MaterialColorListDelegate,MaterialColorListDataSource,FMImageEditorViewControllerDelegate {
   
    
    var pickerView: MaterialColorList!

    override func viewDidLoad() {
        super.viewDidLoad()
    
        pickerView = MaterialColorList(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        self.view.addSubview(pickerView)
        pickerView.delegate = self
       // pickerView.shuffleColors = false
        pickerView.selectionColor = UIColor(white: 0, alpha: 0.8)
        pickerView.selectedBorderWidth = 5
        pickerView.cellSpacing = 1

        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        if pickerView != nil{
            var frame = pickerView.frame
            frame.size.height = self.view.frame.size.height
            frame.size.width = self.view.frame.size.width
            frame.origin.x = 0
            frame.origin.y = 0
            pickerView.frame = frame
        }
    }
    
    func colors() -> [UIColor] {
        return GMPalette.allColors()
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
    
    func didSelectColorAtIndex(_ materialColorPickerView: MaterialColorList, index: Int, color: UIColor){
        let image = UIImage.init(from: color, with: CGSize(width: 2000, height: 2000))
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "photoselectedForEditing"), object: image)

        //NotificationCenter.default.post(name: NSNotification.Name(rawValue: "photoselectedForEditing"), object: image)
//        let vc = FMImageEditorViewController(config: config(), sourceImage: image!)
//        vc.delegate = self
       
        
//        self.present(vc, animated: true, completion: nil)
    }
    
    func fmImageEditorViewController(_ editor: FMImageEditorViewController, didFinishEdittingPhotoWith photo: UIImage) {
        editor.dismiss(animated: true, completion: nil)
        
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ViewController") as? ViewController
        vc?.originalImage = photo
        vc?.modalPresentationStyle = .fullScreen
        self.present(vc!, animated: true, completion: nil)
    }
    
    func sizeForCellAtIndex(_ materialColorPickerView: MaterialColorList, index: Int)->CGSize{
        return CGSize(width: (self.view.frame.size.width/4) - 1, height: (self.view.frame.size.width/4) - 1)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

