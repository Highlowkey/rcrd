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
    
    @IBAction func follwingChange(_ sender: Any) {
        print("hello")
    }
}
