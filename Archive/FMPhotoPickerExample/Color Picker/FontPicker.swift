//
//  MaterialColorPicker.swift
//  MaterialColorPicker
//
//  Created by George Kye on 2016-06-09.
//  Copyright © 2016 George Kye. All rights reserved.
//

import Foundation
import UIKit

private class FontPickerCell: UICollectionViewCell{
    
    func setup(){
        //self.layer.cornerRadius = 0
    }
    
    //MARK: - Lifecycle
    
    init() {
        super.init(frame: CGRect.zero)
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


@objc public protocol FontPickerDataSource {
    /**
     Set colors for MaterialColorPicker (optional. Default colors will be used if nil)
     - returns: should return an array of `UIColor`
     */
    func fonts()->[NSString]
}


@objc public protocol FontPickerDelegate{
    /**
     Return selected index and color for index
     - parameter index: index of selected item
     - parameter color: background color of selected item
     */
    func didSelectFontAtIndex(_ fontPickerView: FontPicker, index: Int, font: NSString)
    
    /**
     Return a size for the current cell (overrides default size)
     - parameter MaterialColorPickerView: current MaterialColorPicker instantse
     - parameter index:                   index of cell
     - returns: CGSize
     */
    @objc optional func sizeForCellAtIndex(_ fontPickerView: FontPicker, index: Int)->CGSize
}

open class FontPicker: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    fileprivate var selectedIndex: IndexPath?
    lazy var fonts: [NSString] = {
        let fonts = FontsList.allFonts()
        return fonts
    }()
    
    open var dataSource: FontPickerDataSource?{
        didSet{
            if let font = dataSource?.fonts(){
                self.fonts = font
            }
        }
    }
    
    @objc dynamic open var delegate: FontPickerDelegate?
    
    /// Shuffles colors within ColorPicker
//    open var shuffleColors: Bool = false{
//        didSet{
//            if shuffleColors{ fonts.shuffle() }
//        }
//    }
    
    /// Color for border of selected cell
    @objc dynamic open var selectionColor: UIColor = UIColor.black
    
    /// Border width for selected Cell
    @objc dynamic open var selectedBorderWidth: CGFloat = 2
    
    /// Set spacing between cells
    @objc dynamic open var cellSpacing: CGFloat = 2
    
    //Setup collectionview and flow layout
    lazy var collectionView: UICollectionView = {
        let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: 3*self.bounds.height, height: self.bounds.height)
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 1
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: self.frame, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(FontPickerCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.backgroundColor = UIColor.clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        initialize()
        addContrains(self, subView: collectionView)
    }
    
    fileprivate func initialize() {
        collectionView.removeFromSuperview()
        self.addSubview(self.collectionView)
    }
    
    //Select index programtically
    open func selectCellAtIndex(_ index: Int){
        let indexPath = IndexPath(row: index, section: 0)
        selectedIndex = indexPath
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
        
        self.delegate?.didSelectFontAtIndex(self, index: (self.selectedIndex! as NSIndexPath).item, font: fonts[index])
    }
    
    //MARK: CollectionView DataSouce
    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fonts.count
    }
    
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        func getRandomColor() -> UIColor {
            //Generate between 0 to 1
            let red:CGFloat = CGFloat(drand48())
            let green:CGFloat = CGFloat(drand48())
            let blue:CGFloat = CGFloat(drand48())
            
            return UIColor(red:red, green: green, blue: blue, alpha: 1.0)
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! FontPickerCell
        cell.layer.masksToBounds = true
        cell.clipsToBounds = true
        
        for v in cell.contentView.subviews{
            v.removeFromSuperview()
        }
        
        let lblNew = UILabel()
        lblNew.frame        =   CGRect(x: 0, y: 0, width: cell.frame.size.width, height: cell.frame.size.height)
        lblNew.backgroundColor = UIColor.clear
        lblNew.text         =   "Font " + String(describing: indexPath.row)
        
        lblNew.font         =   UIFont(name: fonts[(indexPath as NSIndexPath).item] as String, size: 14)
        lblNew.textColor    =   .white
        lblNew.translatesAutoresizingMaskIntoConstraints = false
        cell.contentView.addSubview(lblNew)
        
        cell.backgroundColor = UIColor.clear
        if indexPath == selectedIndex {
            //cell.backgroundColor    = UIColor.lightText
        }else{
            cell.layer.borderWidth = 0
            cell.layer.borderColor = UIColor.clear.cgColor
        }
        
//        cell.contentView.addRightBorder(.lightGray, width: 1)
//        cell.contentView.addBottomBorder(.lightGray, width: 1)
//        cell.contentView.addTopBorder(.lightGray, width: 1)

        return cell
    }
    
    //MARK: CollectionView delegate
    
    open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath
        self.delegate?.didSelectFontAtIndex(self, index: (self.selectedIndex! as NSIndexPath).item, font: fonts[indexPath.item])
        collectionView.reloadData()
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let size = delegate?.sizeForCellAtIndex?(self, index: (indexPath as NSIndexPath).row){
            return size
        }
        
        return CGSize(width: 2.5*self.bounds.height, height: self.bounds.height - 1)
    }
    
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return cellSpacing
    }
    
    fileprivate func addContrains(_ superView: UIView, subView: UIView){
        subView.translatesAutoresizingMaskIntoConstraints = false
        let views = ["myView" : subView]
        superView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[myView]|", options:[] , metrics: nil, views: views))
        superView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[myView]|", options:[] , metrics: nil, views: views))
    }
}

