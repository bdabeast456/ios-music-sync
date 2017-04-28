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
    override func viewDidLoad() {
        super.viewDidLoad()
        if let clipText = UIPasteboard.general.string {
            urlLabel.text = clipText
        }

        self.pasteButton.titleLabel?.adjustsFontSizeToFitWidth = true;
        self.pasteButton.titleLabel?.minimumScaleFactor = 0.25;
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didPasteFromClipboard(_ sender: UIButton) {
        if let clipText = UIPasteboard.general.string {
            urlLabel.text = clipText
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let dest = segue.destination as? ConfigureViewController {
            if let urlText = urlLabel.text {
                dest.videoURL = urlText
            }
        }
    }

}
