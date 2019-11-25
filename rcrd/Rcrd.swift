//
//  Rkrd.swift
//  rcrd
//
//  Created by Patrick McElroy on 10/25/19.
//  Copyright © 2019 Patrick McElroy. All rights reserved.
//
import Foundation
import os.log

class Rcrd: NSObject, NSCoding {
    
    var rcrdName: String
    var rcrdValuesArray: [String] = []
    var isFollowing: Bool
    var rcrdType: String
    var userID: String
    
    init(_ nameIn: String,_ arrayIn: [String]) {
        rcrdName = nameIn
        rcrdValuesArray = arrayIn
        isFollowing = true
        rcrdType = "best"
        userID = NSFullUserName()
    }
    
    init(_ nameIn: String,_ arrayIn: [String], _ followingIn: Bool) {
        rcrdName = nameIn
        rcrdValuesArray = arrayIn
        isFollowing = followingIn
        rcrdType = "best"
        userID = NSFullUserName()
    }
    
    init(_ nameIn: String,_ arrayIn: [String], _ followingIn: Bool, _ typeIn: String) {
        rcrdName = nameIn
        rcrdValuesArray = arrayIn
        isFollowing = followingIn
        rcrdType = typeIn
        userID = NSFullUserName()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(rcrdName, forKey: "name")
        aCoder.encode(rcrdValuesArray, forKey: "values")
        if(isFollowing) {
            aCoder.encode("1", forKey: "following")
        } else {
            aCoder.encode("0", forKey: "following")
        }
        aCoder.encode(rcrdType, forKey: "type")
    }
    
    required convenience init?(coder: NSCoder) {
        let name = coder.decodeObject(forKey: "name") as! String
        let array = coder.decodeObject(forKey: "values") as! [String]
        var following : Bool = false
        let followingString = coder.decodeObject(forKey: "following") as! String
        if(followingString == "1") {
            following = true
        }
        let type = coder.decodeObject(forKey: "type") as! String
        
        self.init(name, array, following, type)
    }
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("rcrds")
    

}
