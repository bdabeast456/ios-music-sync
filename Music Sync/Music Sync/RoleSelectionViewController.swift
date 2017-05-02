//
//  RoleSelectionViewController.swift
//  Music Sync
//
//  Created by Brandon Pearl on 4/20/17.
//  Copyright © 2017 Brandon Pearl. All rights reserved.
//

import UIKit

class RoleSelectionViewController: ViewControllerBase {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let bText = (sender! as! UIButton).titleLabel!.text!;
        let dest = segue.destination as! NameSelectionViewController;
        dest.roleChosen = bText;
    }
}
