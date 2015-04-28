//
//  FeedViewController.swift
//  ExchangeAGram
//
//  Created by Brown Magic on 4/6/15.
//  Copyright (c) 2015 codeHatcher. All rights reserved.
//

import UIKit
import MobileCoreServices
import CoreData
import MapKit

class FeedViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate {
  
  @IBOutlet weak var collectionView: UICollectionView!
  
  var feedArray:[AnyObject] = []
  
  var locationManager: CLLocationManager!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    
    // setup location related items
    locationManager = CLLocationManager()
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
    // request permissions
    locationManager.requestAlwaysAuthorization()
    locationManager.distanceFilter = 100.0
    locationManager.startUpdatingLocation()
    
    
    // get back all the feed item instances
    let request = NSFetchRequest(entityName: "FeedItem")
    // get access app delegate instance
    let appDelegate:AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
    let context:NSManagedObjectContext = appDelegate.managedObjectContext!
    feedArray = context.executeFetchRequest(request, error: nil)!
    
  }
  
  override func viewDidAppear(animated: Bool) {
    // get back all the feed item instances
    let request = NSFetchRequest(entityName: "FeedItem")
    // get access app delegate instance
    let appDelegate:AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
    let context:NSManagedObjectContext = appDelegate.managedObjectContext!
    feedArray = context.executeFetchRequest(request, error: nil)!
    
    collectionView.reloadData()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  /*
  // MARK: - Navigation
  
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
  // Get the new view controller using segue.destinationViewController.
  // Pass the selected object to the new view controller.
  }
  */
  @IBAction func profileTapped(sender: UIBarButtonItem) {
    // we want to segue to the profile
    self.performSegueWithIdentifier("profileSegue", sender: nil)
  }
  @IBAction func snapBarButtonItemTapped(sender: UIBarButtonItem) {
    // check to see if the camera is available, not avail in the simulator
    if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
      var cameraController = UIImagePickerController()
      // set delegate to self so fnc we implement inside will be called by this protocol
      cameraController.delegate = self
      // after checking camera is avail set the camera as the sourcetype
      cameraController.sourceType = UIImagePickerControllerSourceType.Camera
      
      // specify the media types for the camera controller, this is abstract type
      let mediaTypes:[AnyObject] = [kUTTypeImage]
      cameraController.mediaTypes = mediaTypes
      // dont let use edit photos in the application
      cameraController.allowsEditing = false
      
      //present image on the screen with animation
      self.presentViewController(cameraController, animated: true, completion: nil)
      
    } else if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
      var photoLibraryController = UIImagePickerController()
      photoLibraryController.delegate = self
      photoLibraryController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
      
      // pick the media types
      let mediaTypes:[AnyObject] = [kUTTypeImage]
      photoLibraryController.mediaTypes = mediaTypes
      // don't let any editing, could set to true to play with editing
      photoLibraryController.allowsEditing = false
      
      // present and dont need anything to show when it's done (nil)
      self.presentViewController(photoLibraryController, animated: true, completion: nil)
    } else {
      // what if neither of these are available (seems unlikely)
      var alertView = UIAlertController(title: "Alert", message: "Your device doesn't suppor the photo library", preferredStyle: UIAlertControllerStyle.Alert)
      alertView.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
      // show the alert
      self.presentViewController(alertView, animated: true, completion: nil)
    }
  }
  
  // UIImagePickerControllerDelegate
  func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
    // we don't know the type coming back so we need to tell it is a UIImage
    let image = info[UIImagePickerControllerOriginalImage] as UIImage
    
    // convert to jpg and return NSData instance
    let imageData = UIImageJPEGRepresentation(image, 1.0)
    let thumbnailData = UIImageJPEGRepresentation(image, 0.1)
    
    // create the feeditem
    // get from appDelete
    let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
    // create entity from coredata?
    let entityDescription = NSEntityDescription.entityForName("FeedItem", inManagedObjectContext: managedObjectContext!)
    let feedItem = FeedItem(entity: entityDescription!, insertIntoManagedObjectContext: managedObjectContext!)
    
    // setup feeditem and save it
    feedItem.image = imageData
    feedItem.caption = "Test Caption"
    feedItem.thumbnail = thumbnailData
    feedItem.latitude = locationManager.location.coordinate.latitude
    feedItem.longitude = locationManager.location.coordinate.longitude
    
    // create unique ident for item
    let UUID = NSUUID().UUIDString
    feedItem.uniqueID = UUID

    // save feedItem
    (UIApplication.sharedApplication().delegate as AppDelegate).saveContext()
    
    // add item to the feedArray
    feedArray.append(feedItem)
    // dismiss image view controller so we can see feedview controller again
    self.dismissViewControllerAnimated(true, completion: nil)
    // reload the collection view itself
    self.collectionView.reloadData()
  }
  
  // UICollectionViewDataSource
  
  func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return feedArray.count
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    
    var cell:FeedCell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as FeedCell
    
    // originally the feedarray is anyObject, we know it is FeedItem
    let thisItem = feedArray[indexPath.row] as FeedItem
    
    cell.imageView.image = UIImage(data: thisItem.image)
    cell.captionLabel.text = thisItem.caption
    
    return cell
  }
  
  // UICollectionViewDelegate
  
  func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    let thisItem = feedArray[indexPath.row] as FeedItem
    var filterVC = FilterViewController()
    filterVC.thisFeedItem = thisItem
    
    // present on the screen, we are inside UINavication controller stack
    self.navigationController?.pushViewController(filterVC, animated: false)
  }
  
  // CLLocationManagerDelegate
  func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
   println("locations = \(locations)")
    
  }
  
}
