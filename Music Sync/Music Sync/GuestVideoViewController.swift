//
//  GuestVideoViewController.swift
//  Music Sync
//
//  Created by Brandon Pearl on 4/20/17.
//  Copyright © 2017 Brandon Pearl. All rights reserved.
//

import UIKit
import youtube_ios_player_helper
import Foundation

class GuestVideoViewController: ViewControllerBase, YTPlayerViewDelegate {
    
    @IBOutlet weak var youtubeWindow: YTPlayerView!
    
    var model: Guest?;
    var youtubeURL:String?
    var videoTimer:Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        youtubeWindow.delegate = self
        //self.navigationItem.leftBarButtonItem?.target = "goBackTwoControllers"
        
        let button:UIBarButtonItem = UIBarButtonItem(title: "To Host Selection", style: .plain, target: self, action: #selector(goBackTwoControllers))
        self.navigationItem.leftBarButtonItem = button

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let urlString = youtubeURL {
            let urlSplit = urlString.components(separatedBy: "=")
            let videoID = urlSplit[urlSplit.count - 1]
            if youtubeWindow.load(withVideoId: videoID, playerVars: youtubeConfigs) {
                youtubeWindow.setPlaybackQuality(.small)
            }
        }
    }
    
    func playerView(_ playerView: YTPlayerView, didChangeTo state: YTPlayerState) {
        switch(state) {
        case YTPlayerState.queued:
            //message model that we're ready
            break
        default:
            break
        }
    }
    
    func goBackTwoControllers() {
        let viewControllerList:[UIViewController] = (self.navigationController?.viewControllers)!
        self.navigationController?.popToViewController(viewControllerList[viewControllerList.count - 3], animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func scheduleVideoAt(_ timeToStart: Date) {
        NSLog("\n\nSchedule Video Called:\n");
        NSLog("\n\nSENT: \(TimeString.FORMATTER.string(from:timeToStart))\nNOW:  \(TimeString.FORMATTER.string(from:(NSDate() as Date)))\n\n");
        //let timeToStart2 = TimeString.FORMATTER.date(from: "2017:05:02:17:04:30:00000000")!;
        videoTimer = Timer(fireAt: timeToStart, interval: 0, target: self, selector: #selector(playVideoNow), userInfo: nil, repeats: false)
        //RunLoop.main.add(videoTimer!, forMode: RunLoopMode.commonModes)
    }
    
    func playVideoNow() {
        NSLog("\n\nPlay Video Called\n\n");
        youtubeWindow.playVideo()
    }

}
