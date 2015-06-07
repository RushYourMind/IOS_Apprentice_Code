//
//  ChecklistItem.swift
//  Checklists
//
//  Created by rushyourmind on 15/5/16.
//  Copyright (c) 2015年 rym. All rights reserved.
//

import Foundation
import UIKit

class ChecklistItem: NSObject, NSCoding{
    var text = ""
    var checked = false
    var dueDate = NSDate()
    var shouldRemaind = false
    var itemID: Int
    func encodeWithCoder(encoder: NSCoder){
        encoder.encodeObject(text, forKey:"Text")
        encoder.encodeBool(checked, forKey: "Checked")
        encoder.encodeObject(dueDate, forKey: "DueDate")
        encoder.encodeBool(shouldRemaind, forKey: "shouldRemaind")
        encoder.encodeInteger(itemID, forKey: "ItemID")
    }
    required init(coder aDecoder:NSCoder){
        text = aDecoder.decodeObjectForKey("Text") as! String
        checked = aDecoder.decodeBoolForKey("Checked")
        dueDate = aDecoder.decodeObjectForKey("DueDate") as! NSDate
        shouldRemaind = aDecoder.decodeBoolForKey("shouldRemaind")
        itemID = aDecoder.decodeIntegerForKey("ItemID")
        super.init()
    }
    

    override init(){
        itemID = DataModel.nextChecklistItemID()
        super.init()
    }
    
    deinit{
        let existingNotification = notificationForThisItem()
        if let notification = existingNotification {
            UIApplication.sharedApplication().cancelLocalNotification(notification)
        }
    }
    
    func notificationForThisItem() -> UILocalNotification?{
        let allNotifications = UIApplication.sharedApplication().scheduledLocalNotifications as! [UILocalNotification]
        for notification in allNotifications {
            if let number = notification.userInfo?["ItemID"] as? NSNumber{
                if number.integerValue == itemID {
                    return notification
                }
            }
        }
        return nil
    }
    
    func scheduleNotification(){
        let existingNotification = notificationForThisItem()
        if let notification = existingNotification{
            UIApplication.sharedApplication().cancelLocalNotification(notification)
        }
        if shouldRemaind && dueDate.compare(NSDate()) != NSComparisonResult.OrderedAscending {
            let localNotification = UILocalNotification()
            localNotification.fireDate = dueDate
            localNotification.timeZone = NSTimeZone.defaultTimeZone()
            localNotification.alertBody = text
            localNotification.userInfo = ["ItemID": itemID]
            localNotification.soundName = UILocalNotificationDefaultSoundName
            
            UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
            
        }
    }
    
}