//
//  Card.swift
//  Example
//
//  Created by HideakiTouhara on 2018/05/17.
//  Copyright © 2018年 HideakiTouhara. All rights reserved.
//

import UIKit
import SDWebImage

class Card: UIView {
    
    @IBOutlet weak var mealImage: UIImageView!
    @IBOutlet weak var mealTitle: UILabel!

    @IBOutlet weak var meal_title: UILabel!
    override init(frame: CGRect){
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    func prepareUI(text: String,text_title: String, img: String) {
        mealTitle.text = text
        mealImage.sd_setImage(with: URL(string:img), placeholderImage: UIImage(named: "Unknown"))
        meal_title.text = text_title
    }
}
