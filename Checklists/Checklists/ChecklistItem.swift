//
//  ChecklistItem.swift
//  Checklists
//
//  Created by rushyourmind on 15/5/16.
//  Copyright (c) 2015年 rym. All rights reserved.
//

import Foundation

class ChecklistItem: NSObject, NSCoding{
    var text = ""
    var checked = false
    func encodeWithCoder(_ encoder: NSCoder){
        encoder.encodeObject(text, forKey:"Text")
        encoder.encodeBool(checked, forKey: "Checked")
    }
    required init(coder aDecoder:NSCoder){
        super.init()
        text = aDecoder.decodeObjectForKey("Text") as! String
        checked = aDecoder.decodeBoolForKey("Checked")
    }
    

    override init(){
        super.init()
    }
    
}