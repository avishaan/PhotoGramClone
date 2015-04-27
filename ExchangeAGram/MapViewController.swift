//
//  MapViewController.swift
//  ExchangeAGram
//
//  Created by Brown Magic on 4/27/15.
//  Copyright (c) 2015 codeHatcher. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
  
  @IBOutlet weak var mapView: MKMapView!
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    let location = CLLocationCoordinate2D(latitude: 48.868639224587, longitude: 2.37119161036255)
    // determine how much map to show
    let span = MKCoordinateSpanMake(0.05, 0.05)
    // region to show
    let region = MKCoordinateRegionMake(location, span)
    mapView.setRegion(region, animated: true)
    
    let annotation = MKPointAnnotation()
    annotation.setCoordinate(location)
    annotation.title = "Canal Saint-Martin"
    annotation.subtitle = "Paris"
    
    // put annotation on map
    mapView.addAnnotation(annotation)
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
}
