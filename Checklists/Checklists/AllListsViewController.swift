//
//  AllListsViewController.swift
//  Checklists
//
//  Created by rushyourmind on 15/5/23.
//  Copyright (c) 2015年 rym. All rights reserved.
//

import UIKit

class AllListsViewController: UITableViewController , ListDetailViewControllerDelegate{

    var lists :[Checklist]
    required init!(coder aDecoder: NSCoder!) {
        lists = [Checklist]()
        
        super.init(coder: aDecoder)
        
        println("\(documentDirectory())")
        loadChecklists()
        /*
        var list = Checklist(name: "Birthday")
        lists.append(list)
        
        list = Checklist(name:  "Groceries")
        lists.append(list)
        
        list = Checklist(name:  "Cool Apps")
        lists.append(list)
        
        list = Checklist(name:  "To Do")
        lists.append(list)
        
        for list in lists{
            let item = ChecklistItem()
            item.text = "Item for \(list.name)"
            list.items.append(item)
        }
*/
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source


    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return lists.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell! = tableView.dequeueReusableCellWithIdentifier("Cell") as? UITableViewCell

        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: "Cell")
        }
        let checklist = lists[indexPath.row]
        cell.textLabel!.text = checklist.name
        cell.accessoryType = .DetailDisclosureButton
        // Configure the cell...

        return cell
    }
    

    //这里的sender传 的checklist不会直接到达controller，而是传导了下面prepareForSegue方法中的sender
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let checklist = lists[indexPath.row]
        performSegueWithIdentifier("ShowChecklist", sender: checklist)
    }
    
    //这个函数发生在ChecklistViewController的viewDidLoad函数之前
    //整个发生的顺序是：   
    //1. 调用preformSegue...
    //2. 在storyboard中查找这个segue
    //3. 找到这个viewcontroller，创建这个controller
    //4. 调用controller的 init
    //5. 这里的prepareForSegue
    //6. controller 的viewDidLoad函数
    //所以controller中的Checklist要定义为Checlist!,因为初始化的时候可以允许它为空
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowChecklist"{
            let controller = segue.destinationViewController as! ChecklistViewController
            //这里设置controller中 的 checklist
            controller.checklist = sender as! Checklist
        } else if segue.identifier == "AddChecklist" {
           let navigationController = segue.destinationViewController as! UINavigationController
            var controller  = navigationController.topViewController as! ListDetailViewController
            controller.delegate = self
            controller.checklistToEdit = nil
        }
    }
    
    
    func listDetailViewControllerDidCancel(controller: ListDetailViewController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func listDetailViewController(controller: ListDetailViewController, didFinishEditingChecklist checklist: Checklist) {
        if let index = find(lists, checklist){
            let indexPath = NSIndexPath(forRow: index, inSection: 0)
            if let cell = tableView.cellForRowAtIndexPath(indexPath){
                cell.textLabel!.text = checklist.name
            }
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func listDetailViewController(controller: ListDetailViewController, didFinishAddingChecklist checklist: Checklist) {
        let newRowIndex = lists.count
        lists.append(checklist)
        
        let indexPath = NSIndexPath(forRow: newRowIndex, inSection: 0)
        let indexPaths = [indexPath]
        tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
       
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        lists.removeAtIndex(indexPath.row)
        let indexPaths = [indexPath]
        tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
        
    }
    
    //修改
    override func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        let navigationController = storyboard!.instantiateViewControllerWithIdentifier("ListNavigationController") as! UINavigationController
        let controller = navigationController.topViewController as! ListDetailViewController
        controller.delegate = self
        let checklist = lists[indexPath.row]
        controller.checklistToEdit = checklist
        presentViewController(navigationController, animated:true,completion: nil)
        
    }
    
    func documentDirectory() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as! [String]
        return paths[0]
    }
    
    func dataFilePath() -> String{
        return documentDirectory().stringByAppendingPathComponent("Checklists.plist")
    }
    
    func saveChecklists() {
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWithMutableData: data)
        archiver.encodeObject(lists, forKey: "Checklists")
        archiver.finishEncoding()
        data.writeToFile(dataFilePath(), atomically: true)
    }
    
    
    func loadChecklists(){
        let path = dataFilePath()
        if NSFileManager.defaultManager().fileExistsAtPath(path){
            if let data = NSData(contentsOfFile: path){
                
                let unarchiver = NSKeyedUnarchiver(forReadingWithData: data)
                lists = unarchiver.decodeObjectForKey("Checklists") as! [Checklist]
                unarchiver.finishDecoding()
        
            }
        }
    }
    

}
