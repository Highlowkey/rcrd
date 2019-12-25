//
//  RcrdCell.swift
//  rcrd
//
//  Created by Patrick McElroy on 11/4/19.
//  Copyright © 2019 Patrick McElroy. All rights reserved.
//

import UIKit
import Charts
import Foundation
import Firebase
import os.log

class RcrdCell: UITableViewCell {
    
    var rcrd: Rcrd = Rcrd("", [])
    var ref: DatabaseReference!
    var numRcrd = 0
    @IBOutlet weak var bestLabel: UILabel!
    @IBOutlet weak var following: UISwitch!
    @IBAction func follwingChange(_ sender: Any) {
        ref = Database.database().reference().child(UIDevice.current.identifierForVendor!.uuidString).child("rcrds").child(rcrd.rcrdName)
        rcrd.isFollowing = !rcrd.isFollowing
        ref.child("following").setValue(rcrd.isFollowing)
        yourRcrds.rcrds[numRcrd].isFollowing = rcrd.isFollowing
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refresh"), object: nil, userInfo: nil)
    }
    
    func loadView() {
        self.textLabel!.text = rcrd.rcrdName
        self.textLabel!.textColor = UIColor.white
        self.textLabel!.font = UIFont.boldSystemFont(ofSize: 17)
        if(rcrd.rcrdValuesArray.count > 0) {
            if(rcrd.rcrdType == "total") {
                self.bestLabel.text = "total: " + String(yourRcrds.calcTotal(rcrd))
            }
            if(rcrd.rcrdType == "best") {
                self.bestLabel.text = "best: " + String(yourRcrds.calcHighest(rcrd))
            }
            if(rcrd.rcrdType == "average") {
                self.bestLabel.text = "average: " + String(yourRcrds.calcAverage(rcrd))
            }
            if(rcrd.rcrdType == "goal") {
                self.bestLabel.text = "goal: " + String(yourRcrds.calcHighest(rcrd))
            }
        }
        self.bestLabel.font = UIFont.systemFont(ofSize: 17)
        self.following.isOn = rcrd.isFollowing
    }
}
