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
    
    var youtubeURL:String!
    var videoTimer:Timer!
    var model: Guest?;
    
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
        videoTimer = Timer(fireAt: timeToStart, interval: 0, target: self, selector: #selector(playVideoNow), userInfo: nil, repeats: false)
        RunLoop.main.add(videoTimer!, forMode: RunLoopMode.commonModes)
    }
    
    func playVideoNow() {
        youtubeWindow.playVideo()
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
