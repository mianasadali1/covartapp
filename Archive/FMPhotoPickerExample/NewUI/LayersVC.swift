//
//  LayersVC.swift
//  FMPhotoPickerExample
//
//  Created by Apple on 12/09/21.
//  Copyright © 2021 Tribal Media House. All rights reserved.
//

import UIKit

class LayerCell: UITableViewCell {
    
    //MARK: - Outlets
    @IBOutlet weak var btnSelectDelete: UIButton!
    @IBOutlet weak var viewLayer: UIView!
    @IBOutlet weak var imgLayer: UIImageView!
    @IBOutlet weak var btnCheckbox: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var btnDeleteWidthConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.selectionStyle = .none
        viewLayer.layer.cornerRadius = 5.0
        viewLayer.layer.borderWidth = 2.0
        viewLayer.layer.borderColor = #colorLiteral(red: 0.8980392157, green: 0.4901960784, blue: 0, alpha: 1)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}

class LayersVC: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var tblLayer: UITableView!
    
    //MARK: - Variables
    var arrLayers = [String]()
    var selectedDeleteIndex: Int = -1
    @objc var originalImage: UIImage!
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        arrLayers = ["WaterMarkSample", "ExplicitContent"]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.addLeftButtonWithImage(self, action: #selector(actionButtonBack(_:)), buttonImage: #imageLiteral(resourceName: "icBack"))
        
        self.navigationItem.title = "Layers"
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
    }
    
    //MARK: - Button Action Methods
    @objc func actionButtonBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func actionButtonCheckmark(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    @objc func actionButtonDeleteSelect(_ sender: UIButton) {
        if selectedDeleteIndex == sender.tag {
            selectedDeleteIndex = -1
        } else {
            selectedDeleteIndex = sender.tag
        }
        
        tblLayer.reloadData()
    }
    
    @objc func actionButtonDelete(_ sender: UIButton) {
        arrLayers.remove(at: sender.tag)
        selectedDeleteIndex = -1
        tblLayer.reloadData()
    }
}

extension LayersVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? arrLayers.count : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LayerCell") as! LayerCell
            if selectedDeleteIndex == indexPath.row {
                cell.btnDelete.isHidden = false
                cell.btnDeleteWidthConstraint.constant = 80.0
            } else {
                cell.btnDelete.isHidden = true
                cell.btnDeleteWidthConstraint.constant = 37.0
            }
            cell.imgLayer.image = UIImage(named: arrLayers[indexPath.row])
            cell.btnDelete.tag = indexPath.row
            cell.btnCheckbox.tag = indexPath.row
            cell.btnSelectDelete.tag = indexPath.row
            
            cell.btnCheckbox.addTarget(self, action: #selector(actionButtonCheckmark(_:)), for: .touchUpInside)
            cell.btnSelectDelete.addTarget(self, action: #selector(actionButtonDeleteSelect(_:)), for: .touchUpInside)
            cell.btnDelete.addTarget(self, action: #selector(actionButtonDelete(_:)), for: .touchUpInside)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LayerCell") as! LayerCell
            cell.imgLayer.image = originalImage
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
}
