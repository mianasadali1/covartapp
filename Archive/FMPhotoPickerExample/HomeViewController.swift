//
//  ViewController.swift
//  FMPhotoPickerExample
//
//  Created by c-nguyen on 2018/01/25.
//  Copyright © 2018 Tribal Media House. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, FMImageEditorViewControllerDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let imagePicker = UIImagePickerController()
    
    func fmImageEditorViewController(_ editor: FMImageEditorViewController, didFinishEdittingPhotoWith photo: UIImage) {
        self.navigationController?.popViewController(animated: true)
        
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ViewController") as? ViewController
        vc?.originalImage = photo
        vc?.modalPresentationStyle = .fullScreen

        self.present(vc!, animated: true, completion: nil)
    }
    
    @IBOutlet weak var selectMode: UISegmentedControl!
    @IBOutlet weak var allowImage: UISwitch!
    @IBOutlet weak var allowVideo: UISwitch!
    @IBOutlet weak var maxImageLB: UILabel!
    @IBOutlet weak var maxVideoLB: UILabel!
    @IBOutlet weak var previewImageView: UIImageView!
    @IBOutlet weak var forceCropEnabled: UISwitch!
    @IBOutlet weak var eclipsePreviewEnabled: UISwitch!
    
    private var maxImage: Int = 5
    private var maxVideo: Int = 5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self

    
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
//            let vc = FMImageEditorViewController(config: config(), sourceImage: pickedImage)
//            vc.delegate = self
//            
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
//        
//        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func openGallery(_ sender: Any) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func openCamera(_ sender: Any) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .camera
        
        present(imagePicker, animated: true, completion: nil)
    }
    
}

