//
//  GuestConnectionViewController.swift
//  Music Sync
//
//  Created by Brandon Pearl on 4/20/17.
//  Copyright © 2017 Brandon Pearl. All rights reserved.
//

import UIKit;
import MultipeerConnectivity;

class GuestConnectionViewController: ViewControllerBase, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var availableHostTable: UITableView!
    var model: Guest?;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        availableHostTable.delegate = self
        availableHostTable.dataSource = self
        
        let button:UIBarButtonItem = UIBarButtonItem(title: "To Role Selection", style: .plain, target: self, action: #selector(cleanupAndAbort))
        self.navigationItem.leftBarButtonItem = button
    }
    
    func cleanupAndAbort() {
        self.model?.cleanup()
        self.abort()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //Gets number of rows in table.
    func tableView(_ tableView: UITableView, numberOfRowsInSection: Int) -> Int {
        return model!.invitingHosts.count;
    }
    
    //Loads the cell for a particular row in the table.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentPeer: MCPeerID = model!.invitingHosts[indexPath.row];
        let cellToReturn: GuestTableViewCell = availableHostTable.dequeueReusableCell(withIdentifier: "GuestCellID", for: indexPath) as! GuestTableViewCell;
        cellToReturn.assign(currentPeer);
        return cellToReturn;
    }
    
    //Responds to user selecting a row in the table.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let called: GuestTableViewCell = tableView.cellForRow(at: indexPath) as! GuestTableViewCell;
        model!.acceptInvitation(peerID: called.peer!);
        performSegue(withIdentifier: "GuestToWaitingSegue", sender: nil);
    }
    
    //Called by model when host invites are received.
    func tableUpdated () -> Void {
        availableHostTable.reloadData();
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        (segue.destination as! WaitingViewController).model = model;
        model!.endDiscovery();
        model!.baseVC = segue.destination as! WaitingViewController;
    }
    

}
