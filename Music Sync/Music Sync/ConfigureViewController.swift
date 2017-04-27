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
        let configs = ["playsinline": 1]//,
                       //"controls": 0]
        youtubeWindow.load(withPlayerParams: configs)

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //youtubeWindow.loadVideo(byURL: "https://www.youtube.com/watch?v=Sv3fxl6clfo", startSeconds: 0, suggestedQuality: .default)
        youtubeWindow.cueVideo(byId: "Sv3fxl6clfo", startSeconds: 0, suggestedQuality: .default)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func playAndSendConfigs(_ sender: UIButton) {
        youtubeWindow.playVideo()
    }

    @IBAction func stopHostAndGuests(_ sender: UIButton) {
        youtubeWindow.stopVideo()
    }
}
