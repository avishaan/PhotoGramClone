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
  
  let kIntensity = 0.7
  
  var context:CIContext = CIContext(options: nil)
  
  var filters:[CIFilter] = []
  
  let placeHolderImage = UIImage(named: "Placeholder")
  
  let tmp = NSTemporaryDirectory()
  
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
    
    filters = photoFilters()
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // UICollectionViewDataSource
  
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return filters.count
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    
    let cell:FilterCell = collectionView.dequeueReusableCellWithReuseIdentifier("MyCell", forIndexPath: indexPath) as FilterCell
      // cell imageView doesn't have an image then go ahead and render. this prevents re-render during scrolling
    cell.imageView.image = placeHolderImage
    
    // create a processing queue
    let filterQueue:dispatch_queue_t = dispatch_queue_create("filter queue", nil)
    dispatch_async(filterQueue, { () -> Void in
      // will eval following when processor has space
      // get the image from cache
      let filterImage = self.getCachedImage(indexPath.row)
      // get back to the main thread
      dispatch_async(dispatch_get_main_queue(), { () -> Void in
        cell.imageView.image = filterImage
      })
    })
    
    return cell
  }
  
  // UI CollectionViewDelegate
  
  func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    createUIAlertController(indexPath)
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
    
    let colorControls = CIFilter(name: "CIColorControls")
    colorControls.setValue(0.5, forKey: kCIInputSaturationKey)
    
    let sepia = CIFilter(name: "CISepiaTone")
    sepia.setValue(kIntensity, forKey: kCIInputIntensityKey)
    
    let colorClamp = CIFilter(name: "CIColorClamp")
    colorClamp.setValue(CIVector(x: 0.9, y: 0.9, z: 0.9, w: 0.9), forKey: "inputMaxComponents")
    colorClamp.setValue(CIVector(x: 0.2, y: 0.2, z: 0.2, w: 0.2), forKey: "inputMinComponents")
    
    let composite = CIFilter(name: "CIHardLightBlendMode")
    // take image from the sepia conversion
    composite.setValue(sepia.outputImage, forKey: kCIInputImageKey)
    
    let vignette = CIFilter(name: "CIVignette")
    vignette.setValue(composite.outputImage, forKey: kCIInputImageKey)
    vignette.setValue(kIntensity*2, forKey: kCIInputIntensityKey)
    vignette.setValue(kIntensity*30, forKey: kCIInputRadiusKey)
    
    return [blur, instant, noir, transfer, unsharpen, monochrome, colorControls, sepia, colorClamp, composite, vignette]
  }
  
  // take image data and filter instance and get back UIImage
  func filteredImageFromImage(imageData: NSData, filter: CIFilter) -> UIImage {
    
    let unfilteredImage = CIImage(data: imageData)
    filter.setValue(unfilteredImage, forKey: kCIInputImageKey)
    let filteredImage:CIImage = filter.outputImage
    
    // determine the rect of the image
    let extent = filteredImage.extent()
    // bitmap image using our filtered image and the extent, makes it optimized
    let cgImage:CGImageRef = context.createCGImage(filteredImage, fromRect: extent)
    
    let finalImage = UIImage(CGImage: cgImage)
    return finalImage!;
  }
  
  // UIAlertController Helper Function
  
  func createUIAlertController(indexPath:NSIndexPath) {
    // create instance
    let alert = UIAlertController(title: "Photo Options", message: "Please choose an option", preferredStyle: UIAlertControllerStyle.Alert)
    // add a text field to this
    alert.addTextFieldWithConfigurationHandler { (textField) -> Void in
      textField.placeholder = "Add Caption!"
      textField.secureTextEntry = false
    }
    
    var text:String
    // grab first text field from the controller
    let textField = alert.textFields![0] as UITextField
    
    // make sure text was actually entered in before proceeding
    if textField.text != nil {
      text = textField.text
    }
    
    let photoAction = UIAlertAction(title: "Post Photo to Facebook with Caption", style: UIAlertActionStyle.Destructive) { (UIAlertAction) -> Void in
      
      var text = textField.text
      
      self.shareToFacebook(indexPath)
      self.saveFilterToCoreData(indexPath, caption: text)
    }
    
    alert.addAction(photoAction)
    
    let saveFilterAction = UIAlertAction(title: "Save Filter without Posting to Facebook", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
      
      var text = textField.text
      
      self.saveFilterToCoreData(indexPath, caption: text)
    }
    
    // add action to the alert
    alert.addAction(saveFilterAction)
    
    let cancelAction = UIAlertAction(title: "Select Another Filter", style: UIAlertActionStyle.Cancel) { (UIAlertAction) -> Void in
      
    }
    
    alert.addAction(cancelAction)
    // present the alert controller
    self.presentViewController(alert, animated: true, completion: nil)
  }
  
  func saveFilterToCoreData (indexPath:NSIndexPath, caption:String) {
    let filterImage = self.filteredImageFromImage(self.thisFeedItem.image, filter: self.filters[indexPath.row])
    
    // create some image data
    let imageData = UIImageJPEGRepresentation(filterImage, 1.0)
    self.thisFeedItem.image = imageData
    // update thumbnail
    let thumbnailData = UIImageJPEGRepresentation(filterImage, 0.1)
    self.thisFeedItem.thumbnail = thumbnailData
    // save caption
    self.thisFeedItem.caption = caption
    
    // save/persist to the file system
    (UIApplication.sharedApplication().delegate as AppDelegate).saveContext()
    self.navigationController?.popViewControllerAnimated(true)

  }
  
  func shareToFacebook (indexPath:NSIndexPath) {
    // get back the filtered image
    let filterImage = self.filteredImageFromImage(self.thisFeedItem.image, filter: self.filters[indexPath.row])
    // don't worry about why this is an NSArray vs Array, NSArray is Obj-c and facebook wants this
    let photos:NSArray = [filterImage]
    var params = FBPhotoParams()
    params.photos = photos
    
    FBDialogs.presentShareDialogWithPhotoParams(params, clientState: nil) { (call, result, error) -> Void in
      // code here runs after call to FBhandler finishes
      if (result? != nil) {
        println(result)
      } else {
        println(error)
      }
    }
  }
  
  // caching functions
  
  func cacheImage(imageNumber:Int) {
    let filename = "\(imageNumber)"
    // give us a unqiue path based on imageNumber (ideally a UID in the future)
    let uniquePath = tmp.stringByAppendingPathComponent(filename)
    
    // make sure file exists at our file path, if not generate a filter
    if !NSFileManager.defaultManager().fileExistsAtPath(filename) {
      let data = self.thisFeedItem.thumbnail
      let filter = self.filters[imageNumber]
      let image = filteredImageFromImage(data, filter: filter)
      UIImageJPEGRepresentation(image, 1.0).writeToFile(uniquePath, atomically: true)
    }
  }
  func getCachedImage (imageNumber:Int) -> UIImage {
    let fileName = "\(imageNumber)"
    let uniquePath = tmp.stringByAppendingPathComponent(fileName)
    var image:UIImage
    
    // make sure file exists before trying to get it
    if NSFileManager.defaultManager().fileExistsAtPath(uniquePath) {
      image = UIImage(contentsOfFile: uniquePath)!
    } else {
      // cache doesn't exist, go ahead and cache it
      self.cacheImage(imageNumber)
      image = UIImage(contentsOfFile: uniquePath)!
    }
    
    return image
  }
}
