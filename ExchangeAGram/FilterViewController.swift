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
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10)
    layout.itemSize = CGSize(width: 150.0, height: 150.0)
    collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
    
    // set delegate datasource, normally we drag in storyboard
    collectionView.dataSource = self
    collectionView.delegate = self
    
    collectionView.backgroundColor = UIColor.whiteColor()
    self.view.addSubview(collectionView)
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 0
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    return UICollectionViewCell()
  }
  
}
