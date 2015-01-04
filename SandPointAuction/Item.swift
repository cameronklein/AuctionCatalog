//
//  Item.swift
//  SandPointAuction
//
//  Created by Cameron Klein on 1/3/15.
//  Copyright (c) 2015 Cameron Klein. All rights reserved.
//

import Foundation
import CoreData

@objc(Item)

class Item: NSManagedObject {

    @NSManaged var timeStamp: NSDate
    @NSManaged var number: NSNumber
    @NSManaged var title: String
    @NSManaged var itemDescription: String
    @NSManaged var favorited: Bool
  

}
