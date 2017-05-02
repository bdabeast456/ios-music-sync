//
//  NameSelectionViewController.swift
//  Music Sync
//
//  Created by Brandon Pearl on 4/20/17.
//  Copyright © 2017 Brandon Pearl. All rights reserved.
//

import UIKit

class NameSelectionViewController: ViewControllerBase, UITextFieldDelegate {
    
    var roleChosen:String?
    var nameChosen:String?
    @IBOutlet weak var namePrompt: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.delegate = self

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        namePrompt.text = "Please Enter Your \(roleChosen!) Name and Hit Return"
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didEnterName(_ sender: UITextField) {
        if let fieldText = sender.text {
            let trimmedText = fieldText.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            if trimmedText.characters.count > 0 {
                nameChosen = trimmedText
                performSegue(withIdentifier: "Name\(roleChosen!)ToConnectionSegue", sender: self)
            }
        }
    }
    

    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let id = segue.identifier {
            if id == "NameGuestToConnectionSegue" {
                if let dest = segue.destination as? GuestConnectionViewController {
                    dest.model = Guest(displayName: nameChosen!, baseVC: dest);
                    dest.model!.startDiscovery();
                }
            }
            else {
                if let dest = segue.destination as? HostConnectionViewController {
                    dest.model = Host(displayName: nameChosen!, baseVC: dest)
                    dest.model!.startDiscovery();
                }
            }
        }
     }
}
