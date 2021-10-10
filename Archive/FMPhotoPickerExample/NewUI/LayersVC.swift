//
//  LayersVC.swift
//  FMPhotoPickerExample
//
//  Created by Apple on 12/09/21.
//  Copyright © 2021 Tribal Media House. All rights reserved.
//

import UIKit

@objc public protocol LayersUpdatedScrollView: class {
    func scrollViewLayersUpdates(scrollView: UIScrollView)
}

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
    @objc weak var delegate: LayersUpdatedScrollView?
    
    //MARK: - Variables
    var arrLayers = [String]()
    var selectedDeleteIndex: Int = -1
    @objc var originalImage: UIImage!
    @objc var scrollView: UIScrollView!
    private var imageLayers: [UIImageView] = [UIImageView]()
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tblLayer.setEditing(true, animated: true)
        imageFiltrationInScrollviewSubviews()
        // Do any additional setup after loading the view.
        arrLayers = ["WaterMarkSample", "ExplicitContent"]
    }
    
    private func imageFiltrationInScrollviewSubviews() {
        for counter in 0..<scrollView.subviews.count {
            let subContentView = scrollView.subviews[counter]
            if subContentView.isKind(of: UIImageView.self) {
                if let imageView = subContentView as? UIImageView {
                    self.imageLayers.append(imageView)
                }
            }
        }
        self.tblLayer.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
//        self.navigationController?.navigationBar.backgroundColor = #colorLiteral(red: 0.09019608051, green: 0, blue: 0.3019607961, alpha: 1)
        self.view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        let textAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes

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
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imageLayers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LayerCell") as! LayerCell
        let imageview = imageLayers[indexPath.row]
        cell.imgLayer.image = imageview.image
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let itemToMove = imageLayers[sourceIndexPath.row]
        imageLayers.remove(at: sourceIndexPath.row)
        imageLayers.insert(itemToMove, at: destinationIndexPath.row)
        self.updatesInScrollviewSubviews()
    }
    
    private func updatesInScrollviewSubviews() {
        var tempScrollView: UIScrollView = self.scrollView
        
        for counter in 0..<scrollView.subviews.count {
            let subContentView = scrollView.subviews[counter]
            if let imageView = subContentView as? UIImageView {
                tempScrollView.insertSubview(imageView, at: counter)
            } else {
                tempScrollView.insertSubview(subContentView, at: counter)
            }
        }

            
//        for subview in scrollView.subviews {
//            subview.removeFromSuperview()
//        }
        for counter in 0..<tempScrollView.subviews.count {
            let subContentView = scrollView.subviews[counter]
            self.scrollView.addSubview(subContentView)
        }
//        self.scrollView = tempScrollView
        self.delegate?.scrollViewLayersUpdates(scrollView: self.scrollView)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            imageLayers.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
}
