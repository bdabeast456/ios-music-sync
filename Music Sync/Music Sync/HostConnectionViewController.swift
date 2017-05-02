//
//  HostConnectionViewController.swift
//  Music Sync
//
//  Created by Brandon Pearl on 4/20/17.
//  Copyright © 2017 Brandon Pearl. All rights reserved.
//

import UIKit

class HostConnectionViewController: ViewControllerBase, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var availableGuestTable: UITableView!
    var model: Host?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        availableGuestTable.delegate = self
        availableGuestTable.dataSource = self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection: Int) -> Int {
        //return model.getNumberOfGuests()
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //model.sendInvite(indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellToReturn: HostTableViewCell = availableGuestTable.dequeueReusableCell(withIdentifier: "HostCellID", for: indexPath) as! HostTableViewCell
        //cellToReturn.model = model!
        //cellToReturn.guestName.text = model.getGuestName(indexPath.row)
        return cellToReturn
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        (segue.destination as! ClipboardViewController).model = model;
        model!.baseVC = segue.destination as! ClipboardViewController;
    }

}
