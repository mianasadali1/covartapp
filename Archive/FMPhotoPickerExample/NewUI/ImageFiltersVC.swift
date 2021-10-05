//
//  ImageFiltersVC.swift
//  FMPhotoPickerExample
//
//  Created by Apple on 09/09/21.
//  Copyright © 2021 Tribal Media House. All rights reserved.
//

import UIKit

let AppDel = UIApplication.shared.delegate as! AppDelegate

@objc public protocol FilteredImage: class {
    func filteredImageGetBack(photo: UIImage)
}

class ImageFiltersVC: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var imgSelected: UIImageView!
    @IBOutlet weak var colOptions: UICollectionView!
    @IBOutlet weak var colFilters: UICollectionView!
    @IBOutlet weak var viewSlider: UIView!
    @IBOutlet weak var filterSlider: UISlider!
    @IBOutlet weak var viewAdjust: UIView!
    @IBOutlet weak var colAdjust: UICollectionView!
    @IBOutlet weak var adjustSlider: UISlider!
    @objc weak var delegate: FilteredImage?
    
    //MARK: - Variables
    let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
    var actionCompletionBlock: ((_ image: UIImage) -> ())?
    
    @objc var originalImage: UIImage!
    var tempFilteredImage: UIImage!
    var smallImage: UIImage!
    var selectedOption: Int = 0
    var selectedAdjustment: Int = 0
    internal var filterIndex = 0
    internal let context = CIContext(options: nil)
  
    var arrOptions: [[String : Any]] = [["icon": "icFilter", "iconSel": "icFilterSel", "title": "Filters"], ["icon": "icEffect", "iconSel": "icEffectSel", "title": "Adjust"]]

//    var arrOptions: [[String : Any]] = [["icon": "icFilter", "iconSel": "icFilterSel", "title": "Filters"], ["icon": "icOverlay", "iconSel": "icOverlaySel", "title": "Overlay"], ["icon": "icEffect", "iconSel": "icEffectSel", "title": "Adjust"]]
    
    internal let filterNameList = [
        "No Filter",
        "CIPhotoEffectChrome",
        "CIPhotoEffectFade",
        "CIPhotoEffectInstant",
        "CIPhotoEffectMono",
        "CIPhotoEffectNoir",
        "CIPhotoEffectProcess",
        "CIPhotoEffectTonal",
        "CIPhotoEffectTransfer",
        "CILinearToSRGBToneCurve",
        "CISRGBToneCurveToLinear",
        "CIColorInvert",
        "CIColorMonochrome",
        "CIColorPosterize",
        "CIFalseColor",
        "CIMaximumComponent",
        "CIMinimumComponent",
        "CISepiaTone"
    ]
    
    internal let filterDisplayNameList = [
        "Normal",
        "Chrome",
        "Fade",
        "Instant",
        "Mono",
        "Noir",
        "Process",
        "Tonal",
        "Transfer",
        "Tone",
        "Linear",
        "Invert",
        "Monochrome",
        "Posterize",
        "False Color",
        "Comp 1",
        "Comp 2",
        "Sepia"
    ]
    
    internal var editList: [[String : Any]] = [
                                            ["name": "Brightness", "icon": "icBrightness", "filter": "CIColorControls", "keyName": kCIInputBrightnessKey, "minValue": -0.4, "maxValue": 0.4, "currentValue": 0.0, "slider": true],
                                            ["name": "Contrast", "icon": "icContrast", "filter": "CIColorControls", "keyName": kCIInputContrastKey, "minValue": 1.0, "maxValue": 4.0, "currentValue": 1.0, "slider": true],
                                            ["name": "Saturation", "icon": "icSaturation", "filter": "CIColorControls", "keyName": kCIInputSaturationKey, "minValue": 0.0, "maxValue": 2.0, "currentValue": 1.0, "slider": true],
                                            ["name": "Sharpen", "icon": "icSharpen", "filter": "CISharpenLuminance", "keyName": kCIInputSharpnessKey, "minValue": -1.0, "maxValue": 1.0, "currentValue": 0, "slider": true],
                                            ["name": "Warmth", "icon": "icWarmth", "filter": "CITemperatureAndTint", "keyName": "inputNeutral", "minValue": -1.0, "maxValue": 1.0, "currentValue": 0, "slider": true],
                                            ["name": "Highlights", "icon": "icHighlight", "filter": "CIHighlightShadowAdjust", "keyName": "inputHighlightAmount", "minValue": 0.0, "maxValue": 2.0, "currentValue": 1.0, "slider": true],
                                            ["name": "Shadows", "icon": "icShadow", "filter": "CIHighlightShadowAdjust", "keyName": "inputShadowAmount", "minValue": -1.0, "maxValue": 1.0, "currentValue": 0.0, "slider": true],
                                            ["name": "Vignette", "icon": "icVignette", "filter": "CIVignette", "keyName": "", "minValue": 0.0, "maxValue": 4.0, "currentValue": 0.0, "slider": true]]
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.isTranslucent = true
//        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
//        self.navigationItem.addLeftButtonWithImage(self, action: #selector(actionButtonCancel(_:)), buttonImage: #imageLiteral(resourceName: "icCancel"))
        
        let space1 = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        space1.width = 60
        let btnCancel = UIBarButtonItem(image: #imageLiteral(resourceName: "icCancel"), style: .plain, target: self, action: #selector(actionButtonCancel(_:)))
//        let btnUndo = UIBarButtonItem(image: #imageLiteral(resourceName: "icUndo"), style: .plain, target: self, action: #selector(actionButtonUndo(_:)))
        self.navigationItem.addMutipleItemsToLeft(items: [btnCancel, space1])
        
        let space2 = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        space2.width = 60
//        let btnLayers = UIBarButtonItem(image: #imageLiteral(resourceName: "icLayers"), style: .plain, target: self, action: #selector(actionButtonLayers(_:)))
        let btnConfirm = UIBarButtonItem(image: #imageLiteral(resourceName: "icConfirm"), style: .plain, target: self, action: #selector(actionButtonConfirm(_:)))
        self.navigationItem.addMutipleItemsToRight(items: [btnConfirm, space2])
        
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
//        self.navigationController?.navigationBar.shadowImage = UIImage()
//        self.navigationController?.navigationBar.layoutIfNeeded()

        colOptions.register(UINib(nibName: "FilterCollectionCell", bundle: nil), forCellWithReuseIdentifier: "FilterCollectionCell")
        colFilters.register(UINib(nibName: "ImageFilterColCell", bundle: nil), forCellWithReuseIdentifier: "ImageFilterColCell")
        colAdjust.register(UINib(nibName: "AdjustColCell", bundle: nil), forCellWithReuseIdentifier: "AdjustColCell")
        
        imgSelected.image = originalImage
        tempFilteredImage = originalImage
        smallImage = resizeImage(image: originalImage)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.navigationController?.setNavigationBarHidden(false, animated: true)
//        self.navigationController?.navigationBar.isHidden = false
//        self.navigationController?.navigationBar.isTranslucent = true
//        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
//        self.navigationItem.addLeftButtonWithImage(self, action: #selector(actionButtonCancel(_:)), buttonImage: #imageLiteral(resourceName: "icCancel"))
//
//        let space1 = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
//        space1.width = 60
//        let btnCancel = UIBarButtonItem(image: #imageLiteral(resourceName: "icCancel"), style: .plain, target: self, action: #selector(actionButtonCancel(_:)))
////        let btnUndo = UIBarButtonItem(image: #imageLiteral(resourceName: "icUndo"), style: .plain, target: self, action: #selector(actionButtonUndo(_:)))
//        self.navigationItem.addMutipleItemsToLeft(items: [btnCancel, space1])
//
//        let space2 = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
//        space2.width = 60
////        let btnLayers = UIBarButtonItem(image: #imageLiteral(resourceName: "icLayers"), style: .plain, target: self, action: #selector(actionButtonLayers(_:)))
//        let btnConfirm = UIBarButtonItem(image: #imageLiteral(resourceName: "icConfirm"), style: .plain, target: self, action: #selector(actionButtonConfirm(_:)))
//        self.navigationItem.addMutipleItemsToRight(items: [btnConfirm, space2])
//
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
//        self.navigationController?.navigationBar.shadowImage = UIImage()
//        self.navigationController?.navigationBar.layoutIfNeeded()
    }
    
    //MARK: - Helper Methods
    func applyFilter() {
        var filterName = ""
        if selectedOption == 0 {
            filterName = filterNameList[filterIndex]
            let filteredImage = createFilteredImage(filterName: filterName, image: originalImage)
            tempFilteredImage = filteredImage
            imgSelected.image = filteredImage
        } else if selectedOption == 1 {
            filterName = (editList[selectedAdjustment])["filter"] as? String ?? ""
            if filterName == "Adjust" {
//                imgSelected.image = self.imgSelected.image?.imageRotatedByDegrees(degrees: CGFloat(filterSlider.value))
            } else {
                let filteredImage = createEdittedImage(filterName: filterName, image: tempFilteredImage)
                imgSelected.image = filteredImage
            }
        } else {
            filterName = (editList[selectedAdjustment])["filter"] as? String ?? ""
            if filterName == "Adjust" {
//                imgSelected.image = self.imgSelected.image?.imageRotatedByDegrees(degrees: CGFloat(filterSlider.value))
            } else {
                let filteredImage = createEdittedImage(filterName: filterName, image: tempFilteredImage)
                imgSelected.image = filteredImage
            }
        }
    }
    
    func createFilteredImage(filterName: String, image: UIImage) -> UIImage {
        //DispatchQueue.global(qos: .userInitiated).async {
            let sourceImage = CIImage(image: image)
            let filter = CIFilter(name: filterName)
            filter?.setDefaults()
            filter?.setValue(sourceImage, forKey: kCIInputImageKey)
            let outputCGImage = context.createCGImage((filter?.outputImage!)!, from: (filter?.outputImage!.extent)!)
            let filteredImage = UIImage(cgImage: outputCGImage!, scale: image.scale, orientation: image.imageOrientation)
            
            //DispatchQueue.main.async {
                return filteredImage
            //}
        //}
    }
    
    func createEdittedImage(filterName: String, image: UIImage) -> UIImage {
        let editName = (editList[selectedAdjustment])["name"] as? String ?? ""
        let sourceImage = CIImage(image: image)
        let filter = CIFilter(name: filterName)
        filter?.setValue(sourceImage, forKey: kCIInputImageKey)
        
        if editName == "Warmth" {
            let warmX = (adjustSlider.value * 2000) + 6500
            filter?.setValue(CIVector(x: CGFloat(warmX), y: 0), forKey: "inputNeutral")
            filter?.setValue(CIVector(x: 6500, y: 0), forKey: "inputTargetNeutral")
        } else if editName == "Vignette" {
            filter?.setValue(adjustSlider.value * 2, forKey: "inputIntensity")
            filter?.setValue(adjustSlider.value * 30, forKey: "inputRadius")
        } else {
            filter?.setValue(NSNumber(value: adjustSlider.value), forKey: (editList[selectedAdjustment])["keyName"] as? String ?? "")
        }
        
        let outputCGImage = context.createCGImage((filter?.outputImage!)!, from: (filter?.outputImage!.extent)!)
        let filteredImage = UIImage(cgImage: outputCGImage!, scale: image.scale, orientation: image.imageOrientation)
        return filteredImage
    }
    
    func resizeImage(image: UIImage) -> UIImage {
        let ratio: CGFloat = 0.3
        let resizedSize = CGSize(width: Int(image.size.width * ratio), height: Int(image.size.height * ratio))
        UIGraphicsBeginImageContext(resizedSize)
        image.draw(in: CGRect(x: 0, y: 0, width: resizedSize.width, height: resizedSize.height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage!
    }
    
    //MARK: - Button Action Methods
    @objc func actionButtonCancel(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func actionButtonUndo(_ sender: UIButton) {
        
    }
    
    @objc func actionButtonLayers(_ sender: UIButton) {
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "LayersVC") as! LayersVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
//    var actionCompletionBlock: ((_ image: UIImage) -> ())?
    @objc public func yourFunction(handler: (_ image: UIImage) -> ()) {
        handler(imgSelected.image ?? originalImage)
    }

    @objc func actionButtonConfirm(_ sender: UIButton) {
//        if actionCompletionBlock != nil {
//            actionCompletionBlock!(imgSelected.image!)
            if let image = imgSelected.image {
                self.delegate?.filteredImageGetBack(photo: image)
            }
//        }
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionSliderValueChanged(_ sender: UISlider) {
        applyFilter()
    }
    
    @IBAction func actionButtonCancelSlider(_ sender: UIButton) {
        colOptions.isHidden = false
        viewSlider.isHidden = true
    }
    
    @IBAction func actionButtonConfirmSlider(_ sender: UIButton) {
        
    }
}

extension ImageFiltersVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == colOptions {
            return arrOptions.count
        } else if collectionView == colFilters {
            return filterNameList.count
        } else {
            return editList.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == colOptions {
            return CGSize(width: collectionView.frame.size.width/2, height: collectionView.frame.size.height)
        } else if collectionView == colFilters {
            return CGSize(width: collectionView.frame.size.height, height: collectionView.frame.size.height)
        } else {
            return CGSize(width: collectionView.frame.size.width/4.3, height: collectionView.frame.size.height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == colOptions {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterCollectionCell", for: indexPath) as! FilterCollectionCell
            if indexPath.item == selectedOption {
                cell.imgIcon.image = UIImage(named: (arrOptions[indexPath.item])["iconSel"] as? String ?? "")
                cell.lblTitle.textColor = #colorLiteral(red: 0.8980392157, green: 0.4901960784, blue: 0, alpha: 1)
            } else {
                cell.imgIcon.image = UIImage(named: (arrOptions[indexPath.item])["icon"] as? String ?? "")
                cell.lblTitle.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            }
            
            cell.lblTitle.text = (arrOptions[indexPath.item])["title"] as? String
            return cell
        } else if collectionView == colFilters {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageFilterColCell", for: indexPath) as! ImageFilterColCell
            
            switch selectedOption {
            case 0:
                var filteredImage = smallImage
                if indexPath.item != 0 {
                    filteredImage = createFilteredImage(filterName: filterNameList[indexPath.item], image: smallImage!)
                }
                cell.imgFilter.image = filteredImage
                break
            case 1:
                cell.imgFilter.image = #imageLiteral(resourceName: "Hue")
                break
            default:
                break
            }
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AdjustColCell", for: indexPath) as! AdjustColCell
            cell.lblTitle.text = (editList[indexPath.item])["name"] as? String ?? ""
            if indexPath.item == selectedAdjustment {
                cell.lblTitle.textColor = #colorLiteral(red: 0.8980392157, green: 0.4901960784, blue: 0, alpha: 1)
            } else {
                cell.lblTitle.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == colOptions {
            selectedOption = indexPath.item
            if selectedOption == 1 { //2
                viewAdjust.isHidden = false
                adjustSlider.minimumValue = Float((editList[selectedAdjustment])["minValue"] as? Double ?? 0)
                adjustSlider.maximumValue = Float((editList[selectedAdjustment])["maxValue"] as? Double ?? 0)
                adjustSlider.value = Float((editList[selectedAdjustment])["currentValue"] as? Double ?? 0)
            } else {
                viewAdjust.isHidden = true
            }
        } else if collectionView == colFilters {
            switch selectedOption {
            case 0:
                filterIndex = indexPath.item
                if filterIndex != 0 {
                    applyFilter()
                } else {
                    imgSelected.image = originalImage
                }
                break
            case 1:
                selectedAdjustment = indexPath.item
                adjustSlider.minimumValue = Float((editList[selectedAdjustment])["minValue"] as? Double ?? 0)
                adjustSlider.maximumValue = Float((editList[selectedAdjustment])["maxValue"] as? Double ?? 0)
                adjustSlider.value = Float((editList[selectedAdjustment])["currentValue"] as? Double ?? 0)
//                colOptions.isHidden = true
//                viewSlider.isHidden = false
                break
            default:
                break
            }
        } else {
            selectedAdjustment = indexPath.item
            adjustSlider.minimumValue = Float((editList[selectedAdjustment])["minValue"] as? Double ?? 0)
            adjustSlider.maximumValue = Float((editList[selectedAdjustment])["maxValue"] as? Double ?? 0)
            adjustSlider.value = Float((editList[selectedAdjustment])["currentValue"] as? Double ?? 0)
        }
        
        colFilters.reloadData()
        colOptions.reloadData()
        colAdjust.reloadData()
    }
}
