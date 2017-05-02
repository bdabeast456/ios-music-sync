//
//  ClipboardViewController.swift
//  Music Sync
//
//  Created by Brandon Pearl on 4/20/17.
//  Copyright © 2017 Brandon Pearl. All rights reserved.
//

import UIKit

class ClipboardViewController: ViewControllerBase {
    @IBOutlet weak var urlLabel: UILabel!
    @IBOutlet weak var pasteButton: UIButton!
    
    var model: Host?;
    
    override func viewDidLoad() {
        super.viewDidLoad();
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let clipText = UIPasteboard.general.string {
            urlLabel.text = clipText
        }
        
        self.pasteButton.titleLabel?.adjustsFontSizeToFitWidth = true;
        self.pasteButton.titleLabel?.minimumScaleFactor = 0.25;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning();
    }
    
    @IBAction func didPasteFromClipboard(_ sender: UIButton) {
        if let clipText = UIPasteboard.general.string {
            urlLabel.text = clipText
        }
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        (segue.destination as! ConfigureViewController).model = model;
        (segue.destination as! ConfigureViewController).videoURL = urlLabel.text!;
        model!.baseVC = segue.destination as! ConfigureViewController;
        model!.sendYouTubeAddress(urlLabel.text!);
    }

}
