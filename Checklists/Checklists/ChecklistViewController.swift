//
//  ViewController.swift
//  Checklists
//
//  Created by rushyourmind on 15/5/16.
//  Copyright (c) 2015年 rym. All rights reserved.
//

import UIKit
//import "ChecklistItem"
class ChecklistViewController: UITableViewController , AddItemViewControllerDelegate{

    //var items: [ChecklistItem]
    var checklist : Checklist!
    required init(coder aDecoder: NSCoder)
    {
        //items = [ChecklistItem]()
        
       
        super.init(coder: aDecoder)
        //loadChecklistItems()
        
        //println("Documents folder is \(documentDirectory())")
//        println("Data file path is \(dataFilePath())")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 44
        title = checklist.name
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checklist.items.count
        
        
    }
    
    func configureTextForCell(cell: UITableViewCell, withChecklistItem item: ChecklistItem){
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = item.text
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ChecklistItem") as! UITableViewCell
        configureTextForCell(cell, withChecklistItem: checklist.items[indexPath.row])
        configureCheckmarkForCell(cell, withChecklistItem: checklist.items[indexPath.row])
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let cell = tableView.cellForRowAtIndexPath(indexPath){
            let item = checklist.items[indexPath.row]
            item.checked = !item.checked
            configureCheckmarkForCell(cell,withChecklistItem: checklist.items[indexPath.row])
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        //saveChecklistItems()
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        checklist.items.removeAtIndex(indexPath.row)
        
        let indexPaths = [indexPath]
        tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
        //saveChecklistItems()
    }
    
    
    func configureCheckmarkForCell(cell : UITableViewCell, withChecklistItem item: ChecklistItem){
        let label = cell.viewWithTag(1001) as! UILabel
        if item.checked {
            label.text = "◊"
        } else{
            label.text = ""
        }
        /*var isChecked = false
        let item = items[indexPath.row]
        if item.checked{
            cell.accessoryType = .Checkmark
        }else{
            cell.accessoryType = .None
        }*/
    }
    //dont need this anymore
   /*
    @IBAction func addItem(){
        let newRowIndex = items.count
        
        let item = ChecklistItem()
        item.text = "I am a new row"
        item.checked = false
        items.append(item)
        let indexPath = NSIndexPath(forRow: newRowIndex, inSection: 0)
        
        let indexPaths = [indexPath]
        tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
    }*/
    
    func addItemViewControllerDidCancel(controller: AddItemTableViewController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func addItemViewController(controller: AddItemTableViewController, didFinishAddingItem item: ChecklistItem) {
        let newRowIndex = checklist.items.count
        checklist.items.append(item)
        let indexPath = NSIndexPath(forRow: newRowIndex, inSection: 0)
        
        let indexPaths = [indexPath]
        tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
        dismissViewControllerAnimated(true, completion: nil)
        //saveChecklistItems()
    }
    func addItemViewController(controller: AddItemTableViewController, didFinisheEditignItem item: ChecklistItem){
        if let index = find(checklist.items, item){
            let indexPath = NSIndexPath(forRow: index, inSection: 0)
            if let cell = tableView.cellForRowAtIndexPath(indexPath){
                configureTextForCell(cell, withChecklistItem: item)
            }
        }
        dismissViewControllerAnimated(true, completion: nil)
        //saveChecklistItems()
    }
    
    //当从ChecklistController跳转到NavigationnControllerde时候，设置好delegate
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        println(segue.identifier)
        if segue.identifier == "AddItem"{
            let navigationController = segue.destinationViewController as! UINavigationController
            let controller = navigationController.topViewController as! AddItemTableViewController
            controller.delegate = self
            
        } else if segue.identifier == "EditItem"{
            let navigationController = segue.destinationViewController as! UINavigationController
            let controller = navigationController.topViewController as! AddItemTableViewController
            controller.delegate = self
            if let indexPath = tableView.indexPathForCell(sender as! UITableViewCell){
               controller.itemToEdit = checklist.items[indexPath.row]
            }
        }
    }
    
//    func documentDirectory() -> String {
//        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as! [String]
//        
//        return paths[0]
//    }
//    
//    
//    func dataFilePath() -> String{
//        return documentDirectory().stringByAppendingPathComponent("Checklists.plist")
//    }
//    
//    func saveChecklistItems(){
//        let data = NSMutableData()
//        let archiver = NSKeyedArchiver(forWritingWithMutableData: data)
//        archiver.encodeObject(items, forKey: "ChecklistItems")
//        archiver.finishEncoding()
//        data.writeToFile(dataFilePath(), atomically: true)
//    }
//    
//    
//    func loadChecklistItems(){
//        let path = dataFilePath()
//        if NSFileManager.defaultManager().fileExistsAtPath(path){
//            if let data = NSData(contentsOfFile: path){
//                let unarchiver = NSKeyedUnarchiver(forReadingWithData: data)
//                items = unarchiver.decodeObjectForKey("ChecklistItems") as! [ChecklistItem]
//                unarchiver.finishDecoding()
//            }
//        }
//    }
}

