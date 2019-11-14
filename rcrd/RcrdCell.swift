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
import os.log

class RcrdCell: UITableViewCell {
    
    var rcrd: Rcrd = Rcrd("", [])
    var numRcrd = 0
    
    @IBOutlet weak var following: UISwitch!
    
    @IBAction func follwingChange(_ sender: Any) {
        rcrd.isFollowing = !rcrd.isFollowing
        yourRcrds.rcrds[numRcrd].isFollowing = rcrd.isFollowing
    }
    
    func loadView() {
        self.textLabel!.text = rcrd.rcrdName
        self.following.isOn = rcrd.isFollowing
    }
}
