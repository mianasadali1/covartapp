//
//  GridLayout.swift
//  PetMessageApp
//
//  Created by James Rochabrun on 12/12/16.
//  Copyright © 2016 James Rochabrun. All rights reserved.
//

import UIKit

class GridLayout: UICollectionViewFlowLayout {
    
    let innerSpace: CGFloat = 1.0
    let numberOfCellsOnRow: CGFloat = 4

    
    override init() {
        super.init()
        self.minimumLineSpacing = innerSpace
        self.minimumInteritemSpacing = innerSpace
        self.scrollDirection = .vertical
    }
    
    required init?(coder aDecoder: NSCoder) {
        //fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
    }
    
    func itemWidth() -> CGFloat {
        return (collectionView!.frame.size.width/self.numberOfCellsOnRow)-self.innerSpace
    }
    
    override var itemSize: CGSize {
        set {
            self.itemSize = CGSize(width:itemWidth(), height:itemWidth())
        }
        get {
            return CGSize(width:itemWidth(),height:itemWidth())
        }
    }
    
 
}
