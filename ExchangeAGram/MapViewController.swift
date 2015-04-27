//
//  MapViewController.swift
//  ExchangeAGram
//
//  Created by Brown Magic on 4/27/15.
//  Copyright (c) 2015 codeHatcher. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class MapViewController: UIViewController {
  
  @IBOutlet weak var mapView: MKMapView!
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
    // Do any additional setup after loading the view.
    // query for the feeditems
    let request = NSFetchRequest(entityName: "FeedItem")
    
    //acces app delegate
    let appDelegate:AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
    //get context
    let context = appDelegate.managedObjectContext!
    var error:NSError?
    let itemArray = context.executeFetchRequest(request, error: &error)
    println(error)
    
    if (itemArray!.count > 0) {
      for item in itemArray! {
        // generate coordinate from the itemArray
        let location = CLLocationCoordinate2DMake(Double(item.latitude), Double(item.longitude))
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegionMake(location, span)
        // should refactor so it doesn't only focus on last pin added
        mapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.setCoordinate(location)
        annotation.title = item.caption
        
        mapView.addAnnotation(annotation)
      }
    }
    
//    let location = CLLocationCoordinate2D(latitude: 48.868639224587, longitude: 2.37119161036255)
//    // determine how much map to show
//    let span = MKCoordinateSpanMake(0.05, 0.05)
//    // region to show
//    let region = MKCoordinateRegionMake(location, span)
//    mapView.setRegion(region, animated: true)
//    
//    let annotation = MKPointAnnotation()
//    annotation.setCoordinate(location)
//    annotation.title = "Canal Saint-Martin"
//    annotation.subtitle = "Paris"
//    
//    // put annotation on map
//    mapView.addAnnotation(annotation)
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
}
