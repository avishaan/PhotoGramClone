//
//  FeedItem.swift
//  ExchangeAGram
//
//  Created by Brown Magic on 4/27/15.
//  Copyright (c) 2015 codeHatcher. All rights reserved.
//

import Foundation
import CoreData
@objc (FeedItem)

class FeedItem: NSManagedObject {

    @NSManaged var caption: String
    @NSManaged var image: NSData
    @NSManaged var thumbnail: NSData
    @NSManaged var latitude: NSNumber
    @NSManaged var longitude: NSNumber

}
