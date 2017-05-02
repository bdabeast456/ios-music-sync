//
//  WaitingViewController.swift
//  Music Sync
//
//  Created by Brandon Pearl on 4/28/17.
//  Copyright © 2017 Brandon Pearl. All rights reserved.
//

import UIKit

class WaitingViewController: ViewControllerBase {
    
    var youtubeURL:String!
    var model: Guest?;

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tempButton(_ sender: UIButton) {
        performSegue(withIdentifier: "WaitingToGuestVideoSegue", sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        (segue.destination as! GuestVideoViewController).model = model;
    }
}
