//
//  HostConnectionViewController.swift
//  Music Sync
//
//  Created by Brandon Pearl on 4/20/17.
//  Copyright © 2017 Brandon Pearl. All rights reserved.
//

import UIKit;
import MultipeerConnectivity;

class HostConnectionViewController: ViewControllerBase, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var availableGuestTable: UITableView!
    var model: Host?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        availableGuestTable.delegate = self
        availableGuestTable.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //Get number of rows in the table.
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection: Int) -> Int {
        return model!.discoveredGuests.count;
    }
    
    //Return the UITableViewCell at the given indexPath.
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentPeer: MCPeerID = model!.discoveredGuests[indexPath.row];
        let connected: Bool = model!.finalGuests.contains(currentPeer);
        let cellToReturn: HostTableViewCell = availableGuestTable.dequeueReusableCell(withIdentifier: "HostCellID", for: indexPath) as! HostTableViewCell;
        cellToReturn.assign(currentPeer, connected);
        return cellToReturn
    }
    
    //Invites the peer represented by the
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let called: HostTableViewCell = tableView.cellForRow(at: indexPath) as! HostTableViewCell;
        if (!called.connected!) {
            model!.sendInvitations(toGuests: [called.peer!]);
        }
    }

    //Called by model when guests are found / lost.
    func tableUpdated () -> Void {
        availableGuestTable.reloadData();
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        (segue.destination as! ClipboardViewController).model = model;
        model!.endDiscovery();
        model!.getTimeDelays();
        model!.baseVC = segue.destination as! ClipboardViewController;
    }

}
