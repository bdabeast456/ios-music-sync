//
//  ViewControllerBase.swift
//  Music Sync
//
//  Created by Brandon Pearl on 4/20/17.
//  Copyright © 2017 Brandon Pearl. All rights reserved.
//

import UIKit
import CoreBluetooth

class ViewControllerBase: ViewControllerUIBase {
    
    var bluetoothManager: CBPeripheralManager!

    override func viewDidLoad() {
        super.viewDidLoad()

        let button:UIBarButtonItem = UIBarButtonItem(title: "To Role Selection", style: .plain, target: self, action: #selector(abort))
        self.navigationItem.leftBarButtonItem = button
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func noteError (_ message: String) -> Void {
        NSLog(message);
    }
    func abort () -> Void {
        navigationController!.popToRootViewController(animated: true);
    }
    func throwError (_ message: String) -> Void {
        noteError(message);
        abort();
    }

}
