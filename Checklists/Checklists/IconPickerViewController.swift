//
//  IconPickerViewController.swift
//  Checklists
//
//  Created by rushyourmind on 15/6/4.
//  Copyright (c) 2015年 rym. All rights reserved.
//

import UIKit

protocol IconPickerViewControllerDelegate: class {
    func iconPicker(picker: IconPickerViewController, didPickIcon iconName: String)
}
class IconPickerViewController: UITableViewController {
    let icons =  [
    "No Icon",
    "Appointments",
    "Birthdays",
    "Chores",
    "Drinks",
    "Folder",
    "Groceries",
    "Inbox",
    "Photos",
    "Trips"]
    weak var delegate: IconPickerViewControllerDelegate?
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let delegate = delegate {
            let iconName = icons[indexPath.row]
            delegate.iconPicker(self, didPickIcon: iconName)
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return icons.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("IconCell") as! UITableViewCell
        
        let iconName = icons[indexPath.row]
        cell.textLabel!.text = iconName
        cell.imageView!.image = UIImage(named: iconName)
        
        return cell
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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

}
