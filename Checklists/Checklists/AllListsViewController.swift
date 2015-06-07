//
//  AllListsViewController.swift
//  Checklists
//
//  Created by rushyourmind on 15/5/23.
//  Copyright (c) 2015年 rym. All rights reserved.
//

import UIKit

//ListDetailViewControllerDelegate`是为添加修改数据服务的
//UINavigationControllerDelegate是为响应Navigation stack入栈出栈动作的
class AllListsViewController: UITableViewController , ListDetailViewControllerDelegate, UINavigationControllerDelegate{

    

    //var lists :[Checklist]
        var dataModel: DataModel!
    
    
    
    
    required init!(coder aDecoder: NSCoder!) {
        //dataModel.lists = [Checklist]()
        //lists = [Checklist]()`
        super.init(coder: aDecoder)
        
        //loadChecklists()
        println("\(dataModel?.documentDirectory())")
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
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationController?.delegate = self
        
        //if integerForKey can not find the value for the key you specify, return 0
        //to set the default returen value, code below
        
        let index = dataModel.indexOfSelectedChecklist
        if index >= 0 && index < dataModel.lists.count{
            let checklist = dataModel.lists[index]
            //以前这里
            performSegueWithIdentifier("ShowChecklist", sender: checklist)
            
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool){
        //当 切换回来的时候，清除标志
        // === check whether two variables refer to the same object
        // == checks whether two variables have the same value
        if viewController ===  self{
            dataModel.indexOfSelectedChecklist = -1
        }
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

    func documentsDirectory() -> String{
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as! [String]
        return paths[0]
    }
    func dataFilePath() ->String{
        return documentsDirectory().stringByAppendingString("Checklists.plist")
    }

    /*func saveChecklists(){
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWithMutableData: data)
        archiver.encodeObject(lists, forKey:"Checklists")
        archiver.finishEncoding()
        data.writeToFile(dataFilePath(), atomically: true)
    }
    
    func loadChecklists(){
        let path = dataFilePath()
        if NSFileManager.defaultManager().fileExistsAtPath(path){
            if let data = NSData(contentsOfFile: path){
                let unarchiver = NSKeyedUnarchiver(forReadingWithData: data)
                unarchiver.decodeObjectForKey("Checklists") as! [Checklist]
                unarchiver.finishDecoding()
            }
        }
    }
*/
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return dataModel.lists.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell! = tableView.dequeueReusableCellWithIdentifier("Cell") as? UITableViewCell

        if cell == nil {
            cell = UITableViewCell(style: .Subtitle, reuseIdentifier: "Cell")
        }
        let checklist = dataModel.lists[indexPath.row]
        cell.textLabel!.text = checklist.name
        cell.accessoryType = .DetailDisclosureButton
        cell.imageView!.image = UIImage(named: checklist.iconName)
        // Configure the cell...

        let count = checklist.countUncheckedItems()
        if checklist.items.count == 0{
            cell.detailTextLabel!.text = "(No items)"
        } else if count == 0 {
            cell.detailTextLabel!.text = "All done!"
        } else {
            cell.detailTextLabel!.text = "\(count) Remaining"
        }
        return cell
    }
    

    //这里的sender传 的checklist不会直接到达controller，而是传导了下面prepareForSegue方法中的sender
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        dataModel.indexOfSelectedChecklist = indexPath.row
        let checklist = dataModel.lists[indexPath.row]
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
        /*if let index = find(dataModel.lists, checklist){
            let indexPath = NSIndexPath(forRow: index, inSection: 0)
            if let cell = tableView.cellForRowAtIndexPath(indexPath){
                cell.textLabel!.text = checklist.name
            }
        }*/
        dataModel.sortChecklists()
        tableView.reloadData()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func listDetailViewController(controller: ListDetailViewController, didFinishAddingChecklist checklist: Checklist) {
        /*let newRowIndex = dataModel.lists.count
        dataModel.lists.append(checklist)
        
        let indexPath = NSIndexPath(forRow: newRowIndex, inSection: 0)
        let indexPaths = [indexPath]
        tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
*/
        dataModel.lists.append(checklist)
        dataModel.sortChecklists()
        tableView.reloadData()
       
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        dataModel.lists.removeAtIndex(indexPath.row)
        let indexPaths = [indexPath]
        tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
        
    }
    
    //修改TestItem
    override func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        let navigationController = storyboard!.instantiateViewControllerWithIdentifier("ListNavigationController") as! UINavigationController
        let controller = navigationController.topViewController as! ListDetailViewController
        controller.delegate = self
        let checklist = dataModel.lists[indexPath.row]
        controller.checklistToEdit = checklist
        presentViewController(navigationController, animated:true,completion: nil)
        
    }
    

    

}
