//
//  ChiTietCuocHenVCell.swift
//  TeamCaring
//
//  Created by Phan Quoc Thanh on 12/26/17.
//  Copyright © 2017 PqThanh. All rights reserved.
//

import UIKit

class ChiTietCuocHenVCell: UITableViewCell {

    @IBOutlet weak var imgAvata: UIImageView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var wImgAvata: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imgAvata.layer.cornerRadius = 15
        imgAvata.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
