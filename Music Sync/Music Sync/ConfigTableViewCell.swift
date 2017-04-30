//
//  ConfigTableViewCell.swift
//  Music Sync
//
//  Created by Brandon Pearl on 4/29/17.
//  Copyright © 2017 Brandon Pearl. All rights reserved.
//

import UIKit

class ConfigTableViewCell: UITableViewCell {
    //var model:Model!
    @IBOutlet weak var guestName: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func setGuestDelay(_ sender: UISlider) {
        let cell = sender.superview as? ConfigTableViewCell
        if let table = cell?.superview as? UITableView {
            let index = table.indexPath(for: cell!)
            //model.setDelayForIndex(index: index, value: sender.value)
        }
    }
}
