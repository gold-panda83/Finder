//
//  Inbox.swift
//  Jalebi
//
//  Created by Rao Mudassar on 10/6/18.
//  Copyright © 2018 Rao Mudassar. All rights reserved.
//

import UIKit

class Inbox: NSObject {
    
    var timestamp:String! = ""
    var msg:String! = ""
    var rid:String! = ""
    var status:String! = ""
    var picture:String! = ""
    var username:String! = ""
  
 
    init(timestamp: String!, msg: String!,rid:String!,status:String!,picture:String!,username:String!) {
        
        self.timestamp = timestamp
        self.msg = msg
        self.rid = rid
        self.status = status
        self.picture = picture
        self.username = username
     
       
        
        
    }

}
