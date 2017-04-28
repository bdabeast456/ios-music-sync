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

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let dest = segue.destination as? GuestVideoViewController {
            //dest.youtubeURL = youtubeURL!
        }
    }
}
