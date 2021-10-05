//
//  ProjectVC.swift
//  FMPhotoPickerExample
//
//  Created by Apple on 09/09/21.
//  Copyright © 2021 Tribal Media House. All rights reserved.
//

import UIKit

class ProjectVC: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var colProjects: UICollectionView!
    
    //MARK: - Variables
    var arrProjects = [UIImage]()
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        colProjects.register(UINib(nibName: "ImageFilterColCell", bundle: nil), forCellWithReuseIdentifier: "ImageFilterColCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationItem.title = "Projects"
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.addLeftButtonWithImage(self, action: #selector(actionButtonBack(_:)), buttonImage: #imageLiteral(resourceName: "icBack"))
        
        //let btnNext = UIBarButtonItem(image: #imageLiteral(resourceName: "icNext"), style: .plain, target: self, action: #selector(actionButtonNext(_:)))
        //self.navigationItem.addMutipleItemsToRight(items: [btnNext])
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
    }
    
    //MARK: - Button Action Methods
    @objc func actionButtonBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func actionButtonNext(_ sender: UIButton) {
        
    }
}

extension ProjectVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrProjects.count + 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (collectionView.frame.size.width / 2) - 20
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageFilterColCell", for: indexPath) as! ImageFilterColCell
        cell.layer.borderWidth = 1.0
        cell.layer.borderColor = #colorLiteral(red: 0.8980392157, green: 0.4901960784, blue: 0, alpha: 1)
        
        if indexPath.item == 0 {
            cell.imgFilter.image = #imageLiteral(resourceName: "icAddOrange")
        } else {
            cell.imgFilter.image = #imageLiteral(resourceName: "Luminosity")
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 0 {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "StartPageViewController") as! StartPageViewController
            vc.isSelectingImage = false
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let vc = storyboard.instantiateViewController(withIdentifier: "FirstVC") as! FirstVC
//            vc.selectedImage = #imageLiteral(resourceName: "Luminosity")
//            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
