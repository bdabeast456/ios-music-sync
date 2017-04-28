//
//  GuestVideoViewController.swift
//  Music Sync
//
//  Created by Brandon Pearl on 4/20/17.
//  Copyright © 2017 Brandon Pearl. All rights reserved.
//

import UIKit
import youtube_ios_player_helper

class GuestVideoViewController: ViewControllerBase {
    var youtubeURL:String!
    @IBOutlet weak var youtubeView: YTPlayerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.navigationItem.leftBarButtonItem?.target = "goBackTwoControllers"
        
        let button:UIBarButtonItem = UIBarButtonItem(title: "To Host Selection", style: .plain, target: self, action: #selector(goBackTwoControllers))
        self.navigationItem.leftBarButtonItem = button

        // Do any additional setup after loading the view.
    }

    func goBackTwoControllers() {
        let viewControllerList:[UIViewController] = (self.navigationController?.viewControllers)!
        self.navigationController?.popToViewController(viewControllerList[viewControllerList.count - 3], animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func quitToRoleSelection(_ sender: UIButton) {
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
