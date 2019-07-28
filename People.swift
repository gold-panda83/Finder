//
//  People.swift
//  Finder
//
//  Created by Rao Mudassar on 11/12/18.
//  Copyright © 2018 Rao Mudassar. All rights reserved.
//

import UIKit

class People: NSObject {
    
    var fb_id:String! = ""
    var first_name:String! = ""
    var last_name:String! = ""
    var birthday:String! = ""
    var gender:String! = ""
    var image1:String! = ""
    var about_me:String! = ""
    var distance:String! = ""
    var image2:String! = ""
    var image3:String! = ""
    var image4:String! = ""
    var image5:String! = ""
    var image6:String! = ""

   
    init(fb_id: String!, first_name: String!,last_name:String!,birthday:String!,gender:String!,image1:String!,about_me:String!,distance:String!,image2:String!,image3:String!,image4:String!,image5:String!,image6:String!) {
        
        self.fb_id = fb_id
        self.first_name = first_name
        self.last_name = last_name
        self.birthday = birthday
        self.gender = gender
        self.image1 = image1
        self.about_me = about_me
        self.distance = distance
        self.image2 = image2
        self.image3 = image3
        self.image4 = image4
        self.image5 = image5
        self.image6 = image6
    
    }

}
