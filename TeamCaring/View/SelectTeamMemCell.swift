//
//  SelectTeamMemCell.swift
//  TeamCaring
//
//  Created by Phan Quoc Thanh on 12/5/17.
//  Copyright © 2017 PqThanh. All rights reserved.
//

import UIKit

class SelectTeamMemCell: UITableViewCell {

    @IBOutlet weak var avata: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var select: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        avata.layer.cornerRadius = 20
        avata.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
