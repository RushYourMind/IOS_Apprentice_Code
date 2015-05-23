//
//  AllListsViewController.swift
//  Checklists
//
//  Created by rushyourmind on 15/5/23.
//  Copyright (c) 2015年 rym. All rights reserved.
//

import UIKit

class AllListsViewController: UITableViewController {

    var lists :[Checklist]
    required init!(coder aDecoder: NSCoder!) {
        lists = [Checklist]()
        
        super.init(coder: aDecoder)
        
        var list = Checklist(name: "Birthday")
        lists.append(list)
        
        list = Checklist(name:  "Groceries")
        lists.append(list)
        
        list = Checklist(name:  "Cool Apps")
        lists.append(list)
        
        list = Checklist(name:  "To Do")
        lists.append(list)
        
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
    }
    }

}
