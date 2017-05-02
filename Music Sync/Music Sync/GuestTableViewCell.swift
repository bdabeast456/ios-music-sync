//
//  GuestTableViewCell.swift
//  Music Sync
//
//  Created by Brandon Pearl on 4/29/17.
//  Copyright © 2017 Brandon Pearl. All rights reserved.
//

import UIKit
import MultipeerConnectivity;

class GuestTableViewCell: UITableViewCell {
    @IBOutlet weak var hostName: UILabel!
    
    var peer: MCPeerID?;
    
    func assign(_ peer: MCPeerID) {
        self.peer = peer;
        hostName.text = peer.displayName;
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
