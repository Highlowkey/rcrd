//
//  RcrdList.swift
//  rcrd
//
//  Created by Patrick McElroy on 11/4/19.
//  Copyright © 2019 Patrick McElroy. All rights reserved.
//

import UIKit
import Charts
import Foundation
import os.log

class RcrdList: UITableViewController {
    
    var allRcrds: [Rcrd] = []

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allRcrds.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> RcrdCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "rcrdCell", for: indexPath) as! RcrdCell
        if (allRcrds[indexPath.item].rcrdName != "" && allRcrds[indexPath.item].rcrdValuesArray.count > 0) {
            cell.rcrd = allRcrds[indexPath.item]
            cell.loadView()
        }
        return cell
    }
    
    func calcHighest(_ valueArray: [String]) -> Double {
        var highestValue: Double = Double(valueArray[0])!
        for n in valueArray {
            if(Double(n)! > highestValue) {
                highestValue = Double(n)!
            }
        }
        return highestValue
    }

}
