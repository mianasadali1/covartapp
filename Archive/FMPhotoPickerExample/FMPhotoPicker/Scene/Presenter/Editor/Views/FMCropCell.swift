//
//  FMCropCell.swift
//  FMPhotoPicker
//
//  Created by c-nguyen on 2018/03/09.
//  Copyright © 2018 Tribal Media House. All rights reserved.
//

import UIKit

class FMCropCell: UICollectionViewCell {
    static let reussId = String(describing: self)
    public var imageView: UIImageView
    public var name: UILabel
    
    override init(frame: CGRect) {
        imageView = UIImageView()
        name = UILabel()
        
        super.init(frame: frame)
        
        imageView.frame = CGRect(x: (frame.width - 24) / 2, y: 10, width: 24, height: 24)
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = UIColor.white

        name.frame = CGRect(x: 0, y: 35, width: frame.width, height: 35)
        
        self.addSubview(imageView)
        self.addSubview(name)
        
        name.translatesAutoresizingMaskIntoConstraints = false
        //        name.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        //        name.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4).isActive = true
        
        name.text = "Crop"
        name.textColor = kWhiteColor
        name.textAlignment = .center
        name.font = UIFont.boldSystemFont(ofSize: 10)
        name.numberOfLines = 0
        //name.backgroundColor = UIColor.yellow
    }
    
    override func prepareForReuse() {
        setDeselected()
    }
    
    public func setSelected() {
        let tintedImage = imageView.image?.withRenderingMode(.alwaysTemplate)
        imageView.image = tintedImage
        imageView.tintColor = kRedColor
        
        name.textColor = kRedColor
    }
    
    public func setDeselected() {
        name.textColor = kWhiteColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

