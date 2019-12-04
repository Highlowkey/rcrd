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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func updateAccount(_ sender: Any) {
        ref.child(accountName.text ?? "testing").setValue(UIDevice.current.identifierForVendor?.uuidString)
    }
    
    @IBAction func showAccount(_ sender: Any) {
        ref.observeSingleEvent(of: .value, with: {(snapshot) in
            self.otherUser = snapshot.childSnapshot(forPath: "Patrick McElroy").value as? String
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
                self.performSegue(withIdentifier: "otherListSegue", sender: self)
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "otherListSegue") {
            let destination = segue.destination as! RcrdList
            destination.rcrdArray = otherRcrds.rcrds
        }
    }
}
