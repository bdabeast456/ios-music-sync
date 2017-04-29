//
//  ConfigureViewController.swift
//  Music Sync
//
//  Created by Brandon Pearl on 4/20/17.
//  Copyright © 2017 Brandon Pearl. All rights reserved.
//

import UIKit
import youtube_ios_player_helper

class ConfigureViewController: ViewControllerBase, YTPlayerViewDelegate {
    @IBOutlet weak var youtubeWindow: YTPlayerView!
    @IBOutlet weak var globalDelay: UISlider!
    @IBOutlet weak var guestConfigTable: UITableView!
    
    var isPlaying = false
    var videoURL:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        youtubeWindow.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let urlString = videoURL {
            let urlSplit = urlString.components(separatedBy: "=")
            let videoID = urlSplit[urlSplit.count - 1]
            if youtubeWindow.load(withVideoId: videoID, playerVars: youtubeConfigs) {
                youtubeWindow.setPlaybackQuality(.small)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func playerView(_ playerView: YTPlayerView, receivedError error: YTPlayerError) {
        let alert = UIAlertController(title: "Unable To Load Video",
                                      message: "Please check video URL and try again.",
                                      preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Back to Video Selection",
                                      style: UIAlertActionStyle.default,
                                      handler: {
                                        action in
                                        self.abortDueToHostError()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func playerView(_ playerView: YTPlayerView, didChangeTo state: YTPlayerState) {
        switch(state) {
        case YTPlayerState.playing:
            print("HOST PLAYING")
            isPlaying = true
            break
        default:
            break
        }
    }
    
    func abortDueToHostError() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func playAndSendConfigs(_ sender: UIButton) {
        youtubeWindow.playVideo()
    }

    @IBAction func stopHostAndGuests(_ sender: UIButton) {
        if isPlaying {
            youtubeWindow.stopVideo()
        }
    }
}
