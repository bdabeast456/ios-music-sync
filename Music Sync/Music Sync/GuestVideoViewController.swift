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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        youtubeWindow.delegate = self

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
    
    func stopVideoNow() {
        youtubeWindow.stopVideo()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func scheduleVideoAt(_ timeToStart: Date) {
        NSLog("\n\nSchedule Video Called:\n");
        NSLog("\n\nSENT: \(TimeString.FORMATTER.string(from:timeToStart))\nNOW:  \(TimeString.FORMATTER.string(from:(NSDate() as Date)))\n\n");
        //let timeToStart2 = TimeString.FORMATTER.date(from: "2017:05:02:17:04:30:00000000")!;
        let when = DispatchTime.now() + timeToStart.timeIntervalSinceNow;
        DispatchQueue.main.asyncAfter(deadline: when, execute: {
            NSLog("\n\nStarting YouTube Video\n\n");
            self.playVideoNow()
        })
    }
    
    func playVideoNow() {
        NSLog("\n\nPlay Video Called\n\n");
        youtubeWindow.playVideo()
    }

}
