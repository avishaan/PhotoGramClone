//
//  FilterViewController.swift
//  ExchangeAGram
//
//  Created by Brown Magic on 4/15/15.
//  Copyright (c) 2015 codeHatcher. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
  
  var thisFeedItem:FeedItem!
  
  var collectionView:UICollectionView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    
    // view instance to organize items UIFlowCollectionViewLayout
    
    let layout = UICollectionViewFlowLayout()
    // add some insets
    layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    layout.itemSize = CGSize(width: 150.0, height: 150.0)
    collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
    
    // set delegate datasource, normally we drag in storyboard
    collectionView.dataSource = self
    collectionView.delegate = self
    collectionView.backgroundColor = UIColor.whiteColor()
    // register cell with the class
    collectionView.registerClass(FilterCell.self, forCellWithReuseIdentifier: "MyCell")
    
    self.view.addSubview(collectionView)
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // UICollectionViewDataSource
  
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 2
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    
    let cell:FilterCell = collectionView.dequeueReusableCellWithReuseIdentifier("MyCell", forIndexPath: indexPath) as FilterCell
    cell.imageView.image = UIImage(named: "Placeholder")
    
    return cell
  }
  
  // Helper Function
  
  // return array of Image View filter instances
  func photoFilters() -> [CIFilter] {
    // filter instances
    let blur = CIFilter(name: "CIGaussianBlur")
    let instant = CIFilter(name: "CIPhotoEffectInstant")
    let noir = CIFilter(name: "CIPhotoEffectNoir")
    let transfer = CIFilter(name: "CIPhotoEffectTransfer")
    let unsharpen = CIFilter(name: "CIUnsharpMask")
    let monochrome = CIFilter(name: "CIColorMonochrome")
    
    return []
  }
  
}
