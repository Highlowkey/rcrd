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
    
    var name: String
    var rcrds: [Rcrd] = []
    init(nameIn: String) {
        rcrds = []
        name = nameIn
    }
    
    func findRcrd( rcrd: Rcrd, _ name: String, _ user: String, _ ref: DatabaseReference) {
//        let newRef = ref.child(user).child("rcrds").child(name)
//        var rcrdName: String = ""
//        var rcrdType: String = ""
//        var isFollowing: Bool = true
//        var rcrdValuesArray: [String] = []
//        newRef.observeSingleEvent(of: .value, with: {(snapshot) in
//            print("observing")
//            rcrdName = snapshot.key
//            rcrdType = snapshot.childSnapshot(forPath: "type").value as! String
//            isFollowing = snapshot.childSnapshot(forPath: "following").value as! Bool
//            if (snapshot.childSnapshot(forPath: "values").childrenCount > 0) {
//                for value in snapshot.childSnapshot(forPath: "values").children.allObjects as! [DataSnapshot] {
//                    rcrdValuesArray.append(value.value as! String)
//                }
//            }
//            rcrd = Rcrd(rcrdName, rcrdValuesArray, isFollowing, rcrdType)
        })
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
var yourRcrds = rcrdInformation(nameIn: "rcrds")

