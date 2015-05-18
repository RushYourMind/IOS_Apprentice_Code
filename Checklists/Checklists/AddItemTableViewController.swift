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
}
class AddItemTableViewController: UITableViewController , UITextFieldDelegate{
    
    weak var delegate: AddItemViewControllerDelegate?
    @IBAction func cancel(){
        delegate?.addItemViewControllerDidCancel(self)
        //dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBOutlet weak var textField: UITextField!
    @IBAction func done(){
        let item = ChecklistItem()
        item.text = textField.text
        item.checked = false
        delegate?.addItemViewController(self, didFinishAddingItem: item)
        //println("Contents of the text field \(textField.text)")
        //dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        return nil
    }
    
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
}
