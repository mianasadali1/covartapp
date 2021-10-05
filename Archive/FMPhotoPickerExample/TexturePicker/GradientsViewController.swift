//
//  ViewController.swift
//  CollectionViewTutorial
//
//  Created by James Rochabrun on 12/13/16.
//  Copyright © 2016 James Rochabrun. All rights reserved.
//

import UIKit

class GradientsViewController: UIViewController,FMImageEditorViewControllerDelegate {
    
    var gridCollectionView: UICollectionView!
    var gridLayout: GridLayout!
    var fullImageView: UIImageView!
    var gradients = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        gridLayout = GridLayout()
        gridCollectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: gridLayout)
        gridCollectionView.backgroundColor = UIColor(white: 0, alpha: 0.8)
        gridCollectionView.showsVerticalScrollIndicator = false
        gridCollectionView.showsHorizontalScrollIndicator = false
        gridCollectionView.dataSource = self
        gridCollectionView.delegate = self
        gridCollectionView!.register(ImageCellHome.self, forCellWithReuseIdentifier: "cell")
        self.view.addSubview(gridCollectionView)
        
        fullImageView = UIImageView()
        fullImageView.contentMode = .scaleAspectFit
        //fullImageView.backgroundColor = UIColor.lightGray
        fullImageView.isUserInteractionEnabled = true
        fullImageView.alpha = 0
        self.view.addSubview(fullImageView)
        
        let dismissWihtTap = UITapGestureRecognizer(target: self, action: #selector(hideFullImage))
        fullImageView.addGestureRecognizer(dismissWihtTap)
        
        
        _ = Bundle.main.resourcePath
        let subdir = Bundle.main.resourceURL!.appendingPathComponent("Gradients").path

        let fm = FileManager.default
        let path = subdir
        
        do {
            let items = try fm.contentsOfDirectory(atPath: path)
            
            for item in items {
                gradients.append(path + "/" + item)
                
                print("Found \(item)")
            }
        } catch {
            // failed to read directory – bad permissions, perhaps?
        }
        
        gridCollectionView.reloadData()

    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        var frame = gridCollectionView.frame
        frame.size.height = self.view.frame.size.height
        frame.size.width = self.view.frame.size.width
        frame.origin.x = 0
        frame.origin.y = 0
        gridCollectionView.frame = frame
        fullImageView.frame = gridCollectionView.frame
    }
    
    func showFullImage(of image:UIImage) {
        
        fullImageView.transform = CGAffineTransform(scaleX: 0, y: 0)
        fullImageView.contentMode = .scaleAspectFit

        UIView.animate(withDuration: 0.5, delay: 0, options: [], animations:{[unowned self] in
            
            self.fullImageView.image = image
            self.fullImageView.alpha = 1
            self.fullImageView.transform = CGAffineTransform(scaleX: 1, y: 1)

        }, completion: nil)
    }
    
    @objc func hideFullImage() {

        UIView.animate(withDuration: 0.5, delay: 0, options: [], animations:{[unowned self] in
            self.fullImageView.alpha = 0
        }, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension GradientsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gradients.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ImageCellHome
        cell.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        let imagePath = gradients[indexPath.item]
        
        cell.imageView.image = UIImage.init(contentsOfFile: imagePath)?.square()
        cell.imageView.contentMode = UIViewContentMode.scaleAspectFit
        return cell
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! ImageCellHome
        
        if let image = cell.imageView.image {
            let vc = FMImageEditorViewController(config: config(), sourceImage: image)
            vc.delegate = self
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
            
        } else {
            print("no photo")
        }
    }
    
    func fmImageEditorViewController(_ editor: FMImageEditorViewController, didFinishEdittingPhotoWith photo: UIImage) {
        editor.dismiss(animated: true, completion: nil)
        
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ViewController") as? ViewController
        vc?.originalImage = photo
        vc?.modalPresentationStyle = .fullScreen

        self.navigationController?.pushViewController(vc!, animated: true)
    }
}










