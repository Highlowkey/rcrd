//
//  AccountView.swift
//  rcrd
//
//  Created by Patrick McElroy on 10/16/19.
//  Copyright © 2019 Patrick McElroy. All rights reserved.
//

import UIKit
import Firebase


class AccountView: UIViewController {
    
    var ref: DatabaseReference!
    var otherUser: String!
    
    @IBOutlet weak var accountName: UITextField!
    @IBOutlet weak var otherAccountName: UITextField!
    @IBOutlet weak var editAccount: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        accountName.text = yourRcrds.accountName
        ref = Database.database().reference()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func updateAccount(_ sender: Any) {
        if(accountName.isUserInteractionEnabled) {
            accountName.resignFirstResponder()
            accountName.isUserInteractionEnabled = false
            ref.child(accountName.text ?? "testing").setValue(UIDevice.current.identifierForVendor?.uuidString)
            editAccount.setTitle("edit", for: .normal)
            yourRcrds.accountName = accountName.text!
        }
        else {
            self.accountName.isUserInteractionEnabled = true
            accountName.becomeFirstResponder()
            editAccount.setTitle("done", for: .normal)
        }
    }
    
    @IBAction func showAccount(_ sender: Any) {
        otherRcrds.rcrds.removeAll()
        ref.observeSingleEvent(of: .value, with: {(snapshot) in
            self.otherUser = snapshot.childSnapshot(forPath: self.otherAccountName.text!).value as? String
            for rcrd in snapshot.childSnapshot(forPath: self.otherUser).childSnapshot(forPath: "rcrds").children.allObjects as! [DataSnapshot] {
                let rcrdName = rcrd.key
                let rcrdType = rcrd.childSnapshot(forPath: "type").value as! String
                let isFollowing = rcrd.childSnapshot(forPath: "following").value as! Bool
                var rcrdValuesArray: [String] = []
                if (rcrd.childSnapshot(forPath: "values").childrenCount > 0) {
                    for value in rcrd.childSnapshot(forPath: "values").children.allObjects as! [DataSnapshot] {
                        rcrdValuesArray.append(value.value as! String)
                        }
                }
                otherRcrds.rcrds.append(Rcrd(rcrdName, rcrdValuesArray, isFollowing, rcrdType))
            }
            self.performSegue(withIdentifier: "otherListSegue", sender: self)
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "otherListSegue") {
            let destination = segue.destination as! RcrdList
            destination.rcrdArray = otherRcrds.rcrds
        }
    }
}
