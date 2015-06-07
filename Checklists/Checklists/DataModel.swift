//
//  DataModel.swift
//  Checklists
//
//  Created by rushyourmind on 15/5/28.
//  Copyright (c) 2015年 rym. All rights reserved.
//

import UIKit

class DataModel {
    var lists = [Checklist]()
    
    init(){
        println("\(documentDirectory())")
        loadChecklists()
        resgisterDefaults()
        handleFirstTime()
    }
   
    func sortChecklists(){
        lists.sort({c1, c2 in return c1.name.localizedStandardCompare(c2.name) == NSComparisonResult.OrderedAscending})
    }
    
    //computed property
    var indexOfSelectedChecklist: Int{
        get{
            return NSUserDefaults.standardUserDefaults().integerForKey("ChecklistIndex")
        }
        set{
            NSUserDefaults.standardUserDefaults().setInteger(newValue, forKey: "ChecklistIndex")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
    func resgisterDefaults(){
        //这里的中括号也可以用来初始化dictionary
        let dictionary = ["ChecklistIndex": -1, "FirstTime": true, "ChecklistItemID": 0]
        NSUserDefaults.standardUserDefaults().registerDefaults(dictionary)
    }
    
    func handleFirstTime(){
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let firstTime = userDefaults.boolForKey("FirstTime")
        if firstTime {
            let checklist = Checklist(name: "List")
            lists.append(checklist)
            indexOfSelectedChecklist = 0
            userDefaults.setBool(false, forKey: "FirstTime")
        }
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
    
    
    class func nextChecklistItemID() -> Int{
        let userDefaluts = NSUserDefaults.standardUserDefaults()
        let itemID = userDefaluts.integerForKey("ChecklistItemID")
        userDefaluts.setInteger(itemID + 1, forKey: "ChecklistItemID")
        userDefaluts.synchronize()
        return itemID
    }
   
}
