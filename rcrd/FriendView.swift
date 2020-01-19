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
    @IBOutlet weak var otherAccountName: UITextField!
    var friends: [String] = []
    @IBOutlet weak var friend: UIButton!
    @IBOutlet weak var friendName: UILabel!
    @IBOutlet weak var friendDescript: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        ref.observeSingleEvent(of: .value, with: {(snapshot) in
            for friend in snapshot.childSnapshot(forPath: UIDevice.current.identifierForVendor!.uuidString).childSnapshot(forPath: "friends").children.allObjects as! [DataSnapshot] {
                self.friends.append(friend.key)
            }
            if(self.friends.count > 0) {
                self.friendName.text! = String(self.friends[0].prefix(1).uppercased())
                self.friendDescript.text! = self.friends[0]
                self.friendName.isHidden = false
                self.friendDescript.isHidden = false
                self.friend.isHidden = false
            }
        })
        // Do any additional setup after loading the view.
    }
    
    @IBAction func showFriend(_ sender: Any) {
        otherRcrds.rcrds.removeAll()
        ref.observeSingleEvent(of: .value, with: {(snapshot) in
            if(snapshot.childSnapshot(forPath: self.friends[0]).exists()) {
                self.otherUser = snapshot.childSnapshot(forPath: self.friends[0]).value as? String
                if(snapshot.childSnapshot(forPath: self.otherUser).childSnapshot(forPath: "rcrds").exists()) {
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
                }
                self.friendName.text! = String(self.friends[0].prefix(1).uppercased())
                self.friendDescript.text! = self.friends[0]
                self.friendName.isHidden = false
                self.friendDescript.isHidden = false
                self.friend.isHidden = false
                self.performSegue(withIdentifier: "otherListSegue", sender: self)
            }
        })
    }
    
    @IBAction func addFriend(_ sender: Any) {
        self.view.viewWithTag(1)?.isHidden = false
    }

    @IBAction func showAccount(_ sender: Any) {
        otherRcrds.rcrds.removeAll()
        ref.child(UIDevice.current.identifierForVendor!.uuidString).child("friends").child(otherAccountName.text!).setValue(1)
        friends.append(otherAccountName.text!)
        self.friendName.text! = String(self.friends[0].prefix(1).uppercased())
        self.friendDescript.text! = self.friends[0]
        self.friendName.isHidden = false
        self.friendDescript.isHidden = false
        self.friend.isHidden = false
        self.view.viewWithTag(1)?.isHidden = true
    }
    
    @IBAction func resetFriends(_ sender: Any) {
        self.friendDescript.text! = ""
        self.friendName.isHidden = true
        self.friendDescript.isHidden = true
        friends.removeAll()
        self.friend.isHidden = true
        ref.child(UIDevice.current.identifierForVendor!.uuidString).child("friends").removeValue()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "otherListSegue") {
            let destination = segue.destination as! RcrdList
            destination.rcrdArray = otherRcrds.rcrds
            destination.isYours = false
        }
    }
}
