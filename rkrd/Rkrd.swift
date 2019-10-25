//
//  Rkrd.swift
//  rkrd
//
//  Created by Patrick McElroy on 10/25/19.
//  Copyright © 2019 Patrick McElroy. All rights reserved.
//
import Foundation
import os.log

class Rkrd: NSObject, NSCoding {
    
    var rkrdName: String
    var rkrdValuesArray: [String] = []
    
    init(_ nameIn: String,_ arrayIn: [String]) {
        rkrdName = nameIn
        rkrdValuesArray = arrayIn
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(rkrdName, forKey: "name")
        aCoder.encode(rkrdValuesArray, forKey: "values")
    }
    
    required convenience init?(coder: NSCoder) {
        let name = coder.decodeObject(forKey: "name") as! String
        let array = coder.decodeObject(forKey: "values") as! [String]
        
        self.init(name, array)
    }
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("rkrds")
    

}
