//
//  HostTableViewCell.swift
//  Music Sync
//
//  Created by Brandon Pearl on 4/29/17.
//  Copyright © 2017 Brandon Pearl. All rights reserved.
//

import UIKit
import MultipeerConnectivity;

class HostTableViewCell: UITableViewCell {
    @IBOutlet weak var guestName: UILabel!
    
    var peer: MCPeerID?;
    var connected: Bool?;

    func assign (_ peer: MCPeerID, _ connected: Bool) {
        self.peer = peer; self.connected = connected;
        guestName.text = peer.displayName;
        if connected {
            backgroundColor = UIColor.green;
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
