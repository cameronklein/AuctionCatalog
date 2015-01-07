//
//  MasterViewController.swift
//  SandPointAuction
//
//  Created by Cameron Klein on 1/2/15.
//  Copyright (c) 2015 Cameron Klein. All rights reserved.
//

import UIKit
import CoreData

enum Filter : Int {
  case All, Favorites
}

class MasterViewController: UITableViewController, NSFetchedResultsControllerDelegate {

  var detailViewController: DetailViewController? = nil
  var managedObjectContext: NSManagedObjectContext? = nil
  var currentFilter : Filter = .All
  var _favoritesFetchedResultsController: NSFetchedResultsController? = nil

  override func awakeFromNib() {
    super.awakeFromNib()
    if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
        self.clearsSelectionOnViewWillAppear = false
        self.preferredContentSize = CGSize(width: 320.0, height: 600.0)
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    self.tableView.registerNib(UINib(nibName: "AuctionItemCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "Cell")
    
    self.tableView.rowHeight = UITableViewAutomaticDimension
    self.tableView.estimatedRowHeight = 100
    
    let segmentedControlHeader = UISegmentedControl(items: ["All", "Favorites"])
    segmentedControlHeader.addTarget(self, action: "didChangeFilter:", forControlEvents: UIControlEvents.ValueChanged)
    self.tableView.tableHeaderView = segmentedControlHeader

    if let split = self.splitViewController {
      let controllers = split.viewControllers
      self.detailViewController = controllers[controllers.count-1].topViewController as? DetailViewController
    }
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  func insertNewObjects() {
    let context = self.fetchedResultsController.managedObjectContext
    let object1 = NSEntityDescription.insertNewObjectForEntityForName("Item", inManagedObjectContext: context) as Item
    object1.number = 3
    object1.title = "Movie Night @ Sand Point"
    object1.itemDescription = "So much fun! Watch all the movies!"
    
    let object2 = NSEntityDescription.insertNewObjectForEntityForName("Item", inManagedObjectContext: context) as Item
    object2.number = 4
    object2.title = "Pool party!"
    object2.itemDescription = "Splash around and have a great time!"
         
    // Save the context.
    var error: NSError? = nil
    if !context.save(&error) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        //println("Unresolved error \(error), \(error.userInfo)")
        abort()
    }
  }

  // MARK: - Segues

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "showDetail" {
        if let indexPath = self.tableView.indexPathForSelectedRow() {
        let object = self.fetchedResultsController.objectAtIndexPath(indexPath) as NSManagedObject
            let controller = (segue.destinationViewController as UINavigationController).topViewController as DetailViewController
            controller.detailItem = object
            controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
            controller.navigationItem.leftItemsSupplementBackButton = true
        }
    }
  }

  // MARK: - Table View

  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return self.fetchedResultsController.sections?.count ?? 0
  }

  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let sectionInfo = self.fetchedResultsController.sections![section] as NSFetchedResultsSectionInfo
    return sectionInfo.numberOfObjects
  }

  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as AuctionItemCell
    self.configureCell(cell, atIndexPath: indexPath)
    return cell
  }
  
  override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
    configureCell(cell as AuctionItemCell, atIndexPath: indexPath)
  }

  func configureCell(cell: AuctionItemCell, atIndexPath indexPath: NSIndexPath) {
  
    var item = self.fetchedResultsController.objectAtIndexPath(indexPath) as Item
    
    cell.numberLabel.text = item.number.description
    cell.itemTitleLabel.text = item.title
    cell.descriptionLabel.text = item.itemDescription
    
    if item.favorited {
      cell.star.text = "\u{F005}"
      cell.star.textColor = UIColor.yellowColor()
    } else {
      cell.star.text = "\u{F006}"
      cell.star.textColor = UIColor.blackColor()
    }
    
    let tapper = UITapGestureRecognizer()
    tapper.addTarget(self, action: "didTapStar:")
    cell.star.addGestureRecognizer(tapper)
    
  }

  // MARK: - Fetched results controller

  var fetchedResultsController: NSFetchedResultsController {
    
    let fetchRequest = NSFetchRequest()

    let entity = NSEntityDescription.entityForName("Item", inManagedObjectContext: self.managedObjectContext!)
    fetchRequest.entity = entity

    fetchRequest.fetchBatchSize = 100
  
    if currentFilter == .Favorites {
      fetchRequest.predicate = NSPredicate(format: "%K == %@", "favorited", "1")
    }
  
    let sortDescriptor = NSSortDescriptor(key: "number", ascending: true)
    let sortDescriptors = [sortDescriptor]
    
    fetchRequest.sortDescriptors = [sortDescriptor]
  
    let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)
    aFetchedResultsController.delegate = self
      
  	var error: NSError? = nil
  	if !aFetchedResultsController.performFetch(&error) {
  	     // Replace this implementation with code to handle the error appropriately.
  	     // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
           //println("Unresolved error \(error), \(error.userInfo)")
  	     abort()
  	}
      
      return aFetchedResultsController
  }
  
  func controllerWillChangeContent(controller: NSFetchedResultsController) {
      self.tableView.beginUpdates()
  }

  func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
      switch type {
          case .Insert:
              self.tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
          case .Delete:
              self.tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
          default:
              return
      }
  }

  func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
      switch type {
          case .Insert:
              tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
          case .Delete:
              tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
          case .Update:
              self.configureCell(tableView.cellForRowAtIndexPath(indexPath!)! as AuctionItemCell, atIndexPath: indexPath!)
          case .Move:
              tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
              tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
          default:
              return
      }
  }

  func controllerDidChangeContent(controller: NSFetchedResultsController) {
      self.tableView.endUpdates()
  }

  func didTapStar(sender: UITapGestureRecognizer) {
    if let cell = sender.view?.superview?.superview as? AuctionItemCell {
      if let fetchedObjects = self.fetchedResultsController.fetchedObjects{
        if let indexPath = self.tableView.indexPathForCell(cell) {
          if let item = fetchedObjects[indexPath.row] as? Item {
            item.favorited = !item.favorited
            var error: NSError? = nil
            self.managedObjectContext?.save(&error)
            if error != nil {
              println(error)
            }
            if item.favorited {
              cell.star.text = "\u{F005}"
              cell.star.textColor = UIColor.yellowColor()
            } else {
              cell.star.text = "\u{F006}"
              cell.star.textColor = UIColor.blackColor()
              if currentFilter == .Favorites {
                self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Bottom)
              }
            }
          }
        }
      }
    }
    
    
  }
  
  func didChangeFilter(sender: UISegmentedControl) {
    
    switch sender.selectedSegmentIndex {
    case 0:
      currentFilter = .All
      self.tableView.reloadData()
    case 1:
      currentFilter = .Favorites
      self.tableView.reloadData()
    default:
      return ()
    }
  }

}

