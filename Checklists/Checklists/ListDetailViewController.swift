//
//  ListDetailViewController.swift
//  Checklists
//
//  Created by rushyourmind on 15/5/23.
//  Copyright (c) 2015年 rym. All rights reserved.
//

import UIKit
protocol ListDetailViewControllerDelegate: class{
    func listDetailViewControllerDidCancel(controller: ListDetailViewController)
    
    func listDetailViewController(controller: ListDetailViewController, didFinishAddingChecklist checklist:Checklist)
    
    func listDetailViewController(controller: ListDetailViewController, didFinishEditingChecklist checklist:Checklist)
}
class ListDetailViewController: UITableViewController ,UITextFieldDelegate, IconPickerViewControllerDelegate{
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    weak var delegate :ListDetailViewControllerDelegate?
    

    
    var checklistToEdit: Checklist?

    //keep track of the selected icon name
    var iconName = "Folder"
    
    func iconPicker(picker: IconPickerViewController, didPickIcon iconName: String) {
        self.iconName = iconName
        iconImageView.image = UIImage(named: iconName)
        navigationController?.popViewControllerAnimated(true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 44
        if let checklist = checklistToEdit{
            title = "Edit Checklist"
            textField.text = checklist.name
            doneBarButton.enabled = true
            iconName = checklist.iconName
        }
        iconImageView.image = UIImage(named: iconName)
        
    }
    
    override func viewWillAppear(animated: Bool) {
            super.viewWillAppear(animated)
            textField.becomeFirstResponder()
    }
    

    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool{
        let oldText: NSString = textField.text
        let newText: NSString = oldText.stringByReplacingCharactersInRange(range, withString: string)
        doneBarButton.enabled = (newText.length>0)
        return true
    }
    
    @IBAction func cancel(){
        delegate?.listDetailViewControllerDidCancel(self)
    }
    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBAction func done(){
        if let checklist = checklistToEdit{
            checklist.name = textField.text
            checklist.iconName = iconName
            delegate?.listDetailViewController(self, didFinishEditingChecklist: checklist)
        } else {
            let checklist = Checklist(name: textField.text, iconName: iconName)
            delegate?.listDetailViewController(self, didFinishAddingChecklist: checklist)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "PickIcon"{
            let controller = segue.destinationViewController as! IconPickerViewController
            controller.delegate = self
        }
    }
    

}
