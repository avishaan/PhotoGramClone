//
//  FilterCell.swift
//  ExchangeAGram
//
//  Created by Brown Magic on 4/15/15.
//  Copyright (c) 2015 codeHatcher. All rights reserved.
//

import UIKit

class FilterCell: UICollectionViewCell {
  
  var imageView:UIImageView!
  
  // custom initializer so we can have the cell immediately setup the image view when it is created
  override init(frame: CGRect) {
    // we want the UICollectionViewCell to do it's own init, after we add our own custom functionality
    super.init(frame: frame)
    
    imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
    contentView.addSubview(imageView)
  }
  
  // make this class NSCoding compliant
  required init(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
}
