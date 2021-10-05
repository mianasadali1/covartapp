//
//  SelectAudioVC.swift
//  FMPhotoPickerExample
//
//  Created by Apple on 11/09/21.
//  Copyright © 2021 Tribal Media House. All rights reserved.
//

import UIKit

class AudioCell: UITableViewCell {

    //MARK: - Outlets
    @IBOutlet weak var lblSound: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}

class SelectAudioVC: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tblSound: UITableView!
    
    //MARK: - Variables
    var arrSound = [[String : Any]]()
    var selectedSound: Int = -1
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.addLeftButtonWithImage(self, action: #selector(actionButtonBack(_:)), buttonImage: #imageLiteral(resourceName: "icBack"))
        
        self.navigationItem.title = "Select Sound"
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
    }
    
    //MARK: - Button Action Methods
    @objc func actionButtonBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension SelectAudioVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrSound.count + 4
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AudioCell") as! AudioCell
        if selectedSound == indexPath.row {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        cell.lblSound.text = String(format: "Sound %d", indexPath.row + 1)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedSound = indexPath.row
        tableView.reloadData()
    }
}
