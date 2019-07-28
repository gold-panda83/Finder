//
//  InboxCell.swift
//  Jalebi
//
//  Created by Rao Mudassar on 10/6/18.
//  Copyright © 2018 Rao Mudassar. All rights reserved.
//

import UIKit

class InboxCell: UITableViewCell {
    
    
    @IBOutlet weak var inbox_img: UIImageView!
    
    @IBOutlet weak var inbox_name: UILabel!
    
    @IBOutlet weak var inbox_msg: UILabel!
    @IBOutlet weak var inbox_dot: UIImageView!
    
    
    @IBOutlet weak var inbox_time: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
