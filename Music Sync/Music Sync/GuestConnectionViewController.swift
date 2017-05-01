//
//  GuestConnectionViewController.swift
//  Music Sync
//
//  Created by Brandon Pearl on 4/20/17.
//  Copyright © 2017 Brandon Pearl. All rights reserved.
//

import UIKit

class GuestConnectionViewController: ViewControllerBase, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var availableHostTable: UITableView!
    var guestName:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        availableHostTable.delegate = self
        availableHostTable.dataSource = self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection: Int) -> Int {
        //return model.getNumberOfHosts()
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //model.sendInvite(indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellToReturn: GuestTableViewCell = availableHostTable.dequeueReusableCell(withIdentifier: "GuestCellID", for: indexPath) as! GuestTableViewCell
        //cellToReturn.model = model!
        //cellToReturn.guestName.text = model.getGuestName(indexPath.row)
        return cellToReturn
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
