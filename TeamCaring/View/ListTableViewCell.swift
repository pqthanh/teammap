//
//  ListTableViewCell.swift
//  TeamCaring
//
//  Created by Phan Quoc Thanh on 11/30/17.
//  Copyright © 2017 PqThanh. All rights reserved.
//

import UIKit

class ListTableViewCell: UITableViewCell {

    @IBOutlet weak var imgAvata: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var level: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imgAvata.layer.cornerRadius = 20
        imgAvata.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
