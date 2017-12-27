//
//  CuocHenTableViewCell.swift
//  TeamCaring
//
//  Created by fwThanh on 12/27/17.
//  Copyright © 2017 PqThanh. All rights reserved.
//

import UIKit

class CuocHenTableViewCell: UITableViewCell {

    @IBOutlet weak var imgAvata: UIImageView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbDetail: UILabel!
    @IBOutlet weak var lbStatus: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        lbStatus.layer.cornerRadius = 15
        lbStatus.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
