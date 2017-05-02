//
//  ConfigTableViewCell.swift
//  Music Sync
//
//  Created by Brandon Pearl on 4/29/17.
//  Copyright © 2017 Brandon Pearl. All rights reserved.
//

import UIKit;
import MultipeerConnectivity;

class ConfigTableViewCell: UITableViewCell {
    
    @IBOutlet weak var guestName: UILabel!
    @IBOutlet weak var guestSlider: UISlider!
    var model: Host?
    var peer: MCPeerID?;
    var cDelay: TimeInterval?;

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func assign(_ model: Host, _ peer: MCPeerID, _ cDelay: TimeInterval) {
        self.model = model; self.peer = peer; self.cDelay = cDelay;
        guestName.text = peer.displayName;
        guestSlider.value = Float(cDelay);
    }

    @IBAction func setGuestDelay(_ sender: UISlider) {
        model!.setCDelay(peer!, Double(sender.value));
    }
}
