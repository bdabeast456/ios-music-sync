//
//  ViewControllerBase.swift
//  Music Sync
//
//  Created by Brandon Pearl on 4/20/17.
//  Copyright © 2017 Brandon Pearl. All rights reserved.
//

import UIKit
import CoreBluetooth

class ViewControllerBase: ViewControllerUIBase, CBPeripheralManagerDelegate {
    
    var bluetoothManager: CBPeripheralManager!

    override func viewDidLoad() {
        super.viewDidLoad()

        bluetoothManager = CBPeripheralManager(delegate: self, queue: nil, options: nil)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        switch(peripheral.state) {
        case CBManagerState.poweredOff:
            let alert = UIAlertController(title: "Bluetooth Required",
                                          message: "Please turn on Bluetooth",
                                          preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Dismiss",
                                          style: UIAlertActionStyle.default,
                                          handler: nil))
            self.present(alert, animated: true, completion: nil)
            break
        default:
            break
        }
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
