//
//  FriendView.swift
//  rcrd
//
//  Created by Patrick McElroy on 12/13/19.
//  Copyright © 2019 Patrick McElroy. All rights reserved.
//

import Foundation
import UIKit
import Firebase


class FriendView: UIViewController {
    
    var ref: DatabaseReference!
    var otherUser: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func addFriend(_ sender: Any) {
        self.view.viewWithTag(1)?.isHidden = false
    }

    @IBAction func showAccount(_ sender: Any) {
//        otherRcrds.rcrds.removeAll()
//        ref.observeSingleEvent(of: .value, with: {(snapshot) in
//            self.otherUser = snapshot.childSnapshot(forPath: self.otherAccountName.text!).value as? String
//            for rcrd in snapshot.childSnapshot(forPath: self.otherUser).childSnapshot(forPath: "rcrds").children.allObjects as! [DataSnapshot] {
//                let rcrdName = rcrd.key
//                let rcrdType = rcrd.childSnapshot(forPath: "type").value as! String
//                let isFollowing = rcrd.childSnapshot(forPath: "following").value as! Bool
//                var rcrdValuesArray: [String] = []
//                if (rcrd.childSnapshot(forPath: "values").childrenCount > 0) {
//                    for value in rcrd.childSnapshot(forPath: "values").children.allObjects as! [DataSnapshot] {
//                        rcrdValuesArray.append(value.value as! String)
//                        }
//                }
//                otherRcrds.rcrds.append(Rcrd(rcrdName, rcrdValuesArray, isFollowing, rcrdType))
//            }
//            self.performSegue(withIdentifier: "otherListSegue", sender: self)
//        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "otherListSegue") {
            let destination = segue.destination as! RcrdList
            destination.rcrdArray = otherRcrds.rcrds
        }
    }
}
