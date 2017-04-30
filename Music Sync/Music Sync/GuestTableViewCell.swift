//
//  GuestTableViewCell.swift
//  Music Sync
//
//  Created by Brandon Pearl on 4/29/17.
//  Copyright © 2017 Brandon Pearl. All rights reserved.
//

import UIKit

class GuestTableViewCell: UITableViewCell {
    @IBOutlet weak var hostName: UILabel!
    
    //var model:Model!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
