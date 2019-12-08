//
//  global.swift
//  rcrd
//
//  Created by Patrick McElroy on 11/14/19.
//  Copyright © 2019 Patrick McElroy. All rights reserved.
//

import Foundation
import Firebase

class rcrdInformation {
    
    var accountName: String
    var rcrds: [Rcrd] = []
    init(nameIn: String) {
        rcrds = []
        accountName = nameIn
    }
    
    func findRcrd(name: String) -> Rcrd{
        for n in yourRcrds.rcrds {
            if (n.rcrdName == name) {
                return n
            }
        }
        return Rcrd("", [])
    }
    
    func calcAverage(_ rcrd: Rcrd) -> Double {
        return calcAverageHelper(rcrd.rcrdValuesArray)
    }
    
    func calcHighest(_ rcrd: Rcrd) -> Double {
        return calcHighestHelper(rcrd.rcrdValuesArray)
    }
    
    func calcTotal(_ rcrd: Rcrd) -> Double {
        return calcTotalHelper(rcrd.rcrdValuesArray)
    }
    
    func calcTotalHelper(_ valueArray: [String]) -> Double {
        var sum: Double = 0
        
        for n in valueArray {
            sum += Double(n)!
        }
        
        return sum
    }
    
    func calcAverageHelper(_ valueArray: [String]) -> Double {
        var sum: Double = 0
        var average: Double
        
        for n in valueArray {
            sum += Double(n)!
        }

        average = sum/Double((valueArray.count))
        return round(average*1000)/1000
    }
    
    func calcHighestHelper(_ valueArray: [String]) -> Double {
        var highestValue: Double = Double(valueArray[0])!
        for n in valueArray {
            if(Double(n)! > highestValue) {
                highestValue = Double(n)!
            }
        }
        return highestValue
    }
}
var yourRcrds = rcrdInformation(nameIn: "Your Name")
var otherRcrds = rcrdInformation(nameIn: "Other Name")

