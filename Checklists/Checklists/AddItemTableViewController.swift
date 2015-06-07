//
//  AddItemTableViewController.swift
//  Checklists
//
//  Created by rushyourmind on 15/5/17.
//  Copyright (c) 2015年 rym. All rights reserved.
//

import UIKit

protocol AddItemViewControllerDelegate :class{
    func addItemViewControllerDidCancel(controller: AddItemTableViewController)
    func addItemViewController(controller: AddItemTableViewController, didFinishAddingItem item: ChecklistItem)
    
    //for edit
    func addItemViewController(controller: AddItemTableViewController, didFinisheEditignItem item: ChecklistItem)
}
class AddItemTableViewController: UITableViewController , UITextFieldDelegate{
    
    weak var delegate: AddItemViewControllerDelegate?
    @IBAction func cancel(){
        delegate?.addItemViewControllerDidCancel(self)
        //dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var shouldRemaindSwitch: UISwitch!
    @IBOutlet weak var dueDateLabel: UILabel!
    
    var dueDate = NSDate()
    
    var datePickerVisible = false
    
    var itemToEdit: ChecklistItem?
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 44
        
        if let item = itemToEdit {
            title = "Edit Item"
            textField.text = item.text
            doneBarButton.enabled = true
            shouldRemaindSwitch.on = item.shouldRemaind
            dueDate = item.dueDate
        }
        updateDueDateLabel()
    }
    
    func updateDueDateLabel(){
        //convert from date to str
        let formatter = NSDateFormatter()
        formatter.dateStyle = .MediumStyle
        formatter.timeStyle = .ShortStyle
        dueDateLabel.text = formatter.stringFromDate(dueDate)
    }
    
    @IBAction func done(){
        if let item = itemToEdit {
            
            item.text = textField.text
            item.shouldRemaind = shouldRemaindSwitch.on
            item.dueDate = dueDate
            item.scheduleNotification()
            delegate?.addItemViewController(self, didFinisheEditignItem :item)
        } else {
            
            let item = ChecklistItem()
            item.text = textField.text
            item.checked = false
            item.shouldRemaind = shouldRemaindSwitch.on
            item.dueDate = dueDate
            item.scheduleNotification()
            delegate?.addItemViewController(self, didFinishAddingItem: item)
        }
        //println("Contents of the text field \(textField.text)")
        //dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBOutlet weak var doneBarButton: UIBarButtonItem!

    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let oldText :NSString = textField.text
        let newText :NSString = oldText.stringByReplacingCharactersInRange(range, withString: string)
        
        doneBarButton.enabled = (newText.length>0)
        return true
        
    }
    
    
    override func tableView(tableView: UITableView, var indentationLevelForRowAtIndexPath indexPath: NSIndexPath) -> Int {
        if indexPath.section == 1 && indexPath.row == 2 {
            indexPath = NSIndexPath(forRow: 0, inSection: indexPath.section)
        }
        return super.tableView(tableView, indentationLevelForRowAtIndexPath: indexPath)
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        textField.resignFirstResponder()
        
        if indexPath.section == 1 && indexPath.row == 1 {
            if !datePickerVisible {
                showDatePicker()
            } else {
                hideDatePicker()
            }
        }
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        if indexPath.section == 1 && indexPath.row == 1 {
            return indexPath
        } else {
            return nil
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 1 && indexPath.row == 2 {
            return 217
        } else {
            return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 && datePickerVisible {
            return 3
        } else {
            return super.tableView(tableView, numberOfRowsInSection: section)
        }
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 1 && indexPath.row == 2{
            var cell: UITableViewCell! = tableView.dequeueReusableCellWithIdentifier("DatePickerCell") as? UITableViewCell
            if cell == nil{
                cell = UITableViewCell(style: .Default, reuseIdentifier: "DatePickerCell")
                cell.selectionStyle = .None
                
                
                let datePicker = UIDatePicker(frame: CGRect(x:0,y:0,width:320,height:216))
                
                datePicker.tag = 100
                
                cell.contentView.addSubview(datePicker)
                
                datePicker.addTarget(self, action: "dateChanged:", forControlEvents: .ValueChanged)
                
            }
            return cell
        }else {
            return super.tableView(tableView, cellForRowAtIndexPath: indexPath)
        }
    }
    
    
    
    func showDatePicker(){
        datePickerVisible = true
        
        let indexPathDatePicker = NSIndexPath(forRow: 2, inSection: 1)
        
        tableView.insertRowsAtIndexPaths([indexPathDatePicker], withRowAnimation: .Fade)
        
    }
    
    func hideDatePicker() {
        if datePickerVisible {
            datePickerVisible = false
            
            let indexPathDateRow = NSIndexPath(forRow: 1, inSection: 1)
            let indexPathDatePicker = NSIndexPath(forRow: 2, inSection: 1)
            
            if let cell = tableView.cellForRowAtIndexPath(indexPathDateRow) {
                cell.detailTextLabel!.textColor = UIColor(white: 0, alpha: 0.5)
            }
            
            tableView.beginUpdates()
            tableView.reloadRowsAtIndexPaths([indexPathDateRow], withRowAnimation: .None)
            tableView.deleteRowsAtIndexPaths([indexPathDatePicker], withRowAnimation: .Fade)
            tableView.endUpdates()
        }
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        hideDatePicker()
    }
    
    func dateChanged(datePicker: UIDatePicker) {
        dueDate = datePicker.date
        updateDueDateLabel()
    }
    
    @IBAction func shouldRemindToggled(switchCOntrol: UISwitch){
        textField.resignFirstResponder()
        if (switchCOntrol.on){
            let notificationSettings = UIUserNotificationSettings(forTypes: .Alert | .Sound, categories: nil)
            UIApplication.sharedApplication().registerUserNotificationSettings(notificationSettings)
        }
    }
}
