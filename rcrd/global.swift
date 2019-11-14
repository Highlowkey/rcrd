//
//  global.swift
//  rcrd
//
//  Created by Patrick McElroy on 11/14/19.
//  Copyright © 2019 Patrick McElroy. All rights reserved.
//

import Foundation

class rcrdInformation {
    var name: String
    var rcrds: [Rcrd] = []
    init(nameIn: String) {
        rcrds = [Rcrd("", []), Rcrd("", [])]
        name = nameIn
    }
}
var yourRcrds = rcrdInformation(nameIn: "rcrds")
