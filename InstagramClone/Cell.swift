//
//  Cell.swift
//  InstagramClone
//
//  Created by Christopher Alan on 12/29/14.
//  Copyright (c) 2014 CA Studios. All rights reserved.
//

import UIKit

class Cell: UITableViewCell {
    
    @IBOutlet var postedImage: UIImageView!
    @IBOutlet var title: UILabel!
    @IBOutlet var username: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
