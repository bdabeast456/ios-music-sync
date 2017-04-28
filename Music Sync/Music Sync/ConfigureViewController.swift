//
//  ConfigureViewController.swift
//  Music Sync
//
//  Created by Brandon Pearl on 4/20/17.
//  Copyright © 2017 Brandon Pearl. All rights reserved.
//

import UIKit
import youtube_ios_player_helper

class ConfigureViewController: ViewControllerBase {
    @IBOutlet weak var youtubeWindow: YTPlayerView!
    @IBOutlet weak var globalDelay: UISlider!
    @IBOutlet weak var guestConfigTable: UITableView!
    
    var videoURL:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        youtubeWindow.load(withVideoId: "Sv3fxl6clfo", playerVars: youtubeConfigs)
        //youtubeWindow.playVideo()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func playAndSendConfigs(_ sender: UIButton) {
        youtubeWindow.playVideo()
        //youtubeWindow.playVideo()
    }

    @IBAction func stopHostAndGuests(_ sender: UIButton) {
        youtubeWindow.stopVideo()
    }
}
