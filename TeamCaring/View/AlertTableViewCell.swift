//
//  AlertTableViewCell.swift
//  TeamCaring
//
//  Created by Phan Quoc Thanh on 12/15/17.
//  Copyright © 2017 PqThanh. All rights reserved.
//

import UIKit

class AlertTableViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var imgIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
