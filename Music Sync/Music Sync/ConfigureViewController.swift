//
//  ConfigureViewController.swift
//  Music Sync
//
//  Created by Brandon Pearl on 4/20/17.
//  Copyright © 2017 Brandon Pearl. All rights reserved.
//

import UIKit
import youtube_ios_player_helper
import Foundation

class ConfigureViewController: ViewControllerBase, YTPlayerViewDelegate, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var youtubeWindow: YTPlayerView!
    @IBOutlet weak var globalDelay: UISlider!
    @IBOutlet weak var guestConfigTable: UITableView!
    @IBOutlet weak var configTable: UITableView!
    
    //var model:Model!
    //var videoTimer:Timer!
    var isPlaying = false
    var videoURL:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        youtubeWindow.delegate = self
        configTable.delegate = self
        configTable.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configTable.reloadData()
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
            isPlaying = true
            break
        default:
            break
        }
    }
    
    func abortDueToHostError() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection: Int) -> Int {
        //return model.getNumberOfGuests()
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellToReturn: ConfigTableViewCell = guestConfigTable.dequeueReusableCell(withIdentifier: "ConfigGuestID", for: indexPath) as! ConfigTableViewCell
        //cellToReturn.model = model
        //cellToReturn.guestName.text = model.getNameForIndex(indexPath.row)
        return cellToReturn
    }
    
    @IBAction func playAndSendConfigs(_ sender: UIButton) {
        if !isPlaying {
            /*
            videoTimer = Timer(fireAt: model.activate(), interval: 0, target: self, selector: #selector(playVideoNow), userInfo: nil, repeats: false)
            RunLoop.main.add(videoTimer!, forMode: RunLoopMode.commonModes)
            */
            youtubeWindow.playVideo()
        }
    }

    @IBAction func stopHostAndGuests(_ sender: UIButton) {
        if isPlaying {
            isPlaying = false
            youtubeWindow.stopVideo()
        }
    }
    
    func playVideoNow() {
        youtubeWindow.playVideo()
    }
}
