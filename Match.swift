//
//  Match.swift
//  Finder
//
//  Created by Rao Mudassar on 11/13/18.
//  Copyright © 2018 Rao Mudassar. All rights reserved.
//

import UIKit

class Match: NSObject {
    
    var match_id:String! = ""
    var user_name:String! = ""
     var user_image:String! = ""
 
   
    
    
    init(match_id: String!, user_name: String!, user_image: String!) {
        
        self.match_id = match_id
        self.user_name = user_name
        self.user_image = user_image
    
      
        
    }

}
