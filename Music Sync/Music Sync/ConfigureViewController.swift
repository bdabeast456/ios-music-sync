//
//  ConfigureViewController.swift
//  Music Sync
//
//  Created by Brandon Pearl on 4/20/17.
//  Copyright © 2017 Brandon Pearl. All rights reserved.
//

import UIKit;
import youtube_ios_player_helper;
import Foundation;
import MultipeerConnectivity;

class ConfigureViewController: ViewControllerBase, YTPlayerViewDelegate, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var youtubeWindow: YTPlayerView!
    @IBOutlet weak var globalDelay: UISlider!
    @IBOutlet weak var guestConfigTable: UITableView!
    @IBOutlet weak var configTable: UITableView!
    
    
    var isPlaying = false
    var videoURL:String?
    
    var videoTimer:Timer?
    var model: Host?;
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        youtubeWindow.delegate = self
        configTable.delegate = self
        configTable.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configTable.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        NSLog("\n\nviewDidAppear Called\(videoURL==nil)\n\n");
        super.viewDidAppear(animated)
        if let urlString = videoURL {
            NSLog("\n\nEntered Block\n\n");
            let urlSplit = urlString.components(separatedBy: "=")
            let videoID = urlSplit[urlSplit.count - 1]
            NSLog("\n\nAttempting to load YouTube video.");
            if youtubeWindow.load(withVideoId: videoID, playerVars: youtubeConfigs) {
                youtubeWindow.setPlaybackQuality(.small)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
    
    //Gets number of rows in the Table.
    func tableView(_ tableView: UITableView, numberOfRowsInSection: Int) -> Int {
        return model!.finalGuests.count;
    }
    
    //Gets cell at the specific row in the Table.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentPeer: MCPeerID = model!.finalGuests[indexPath.row];
        let customDelay: TimeInterval = model!.cDelays[indexPath.row];
        let cellToReturn: ConfigTableViewCell = guestConfigTable.dequeueReusableCell(withIdentifier: "ConfigGuestID", for: indexPath) as! ConfigTableViewCell;
        cellToReturn.assign(model!, currentPeer, customDelay);
        return cellToReturn;
    }
    
    //Called by model when invited guests drop from the session.
    func dropEvent () -> Void {
        configTable.reloadData();
    }
    
    @IBAction func playAndSendConfigs(_ sender: UIButton) {
        if !isPlaying {
            isPlaying = true;
            NSLog("\n\nSending Play Times to Guests\n\n");
            OperationQueue.main.addOperation {
                self.model!.sendPlayTimes(Double(self.globalDelay.value));
                NSLog("\n\nStarting YouTube Video\n\n");
                self.videoTimer = Timer(fireAt: Date().addingTimeInterval(Double(self.globalDelay.value)), interval: 0, target: self, selector: #selector(self.playVideoNow), userInfo: nil, repeats: false);
            }
            //RunLoop.main.add(videoTimer, forMode: RunLoopMode.commonModes);
        }
    }

    @IBAction func stopHostAndGuests(_ sender: UIButton) {
        if isPlaying {
            isPlaying = false;
            model!.stopGuests();
            youtubeWindow.stopVideo();
        }
    }
    
    func playVideoNow() {
        youtubeWindow.playVideo()
    }
}
