//
//  OneRkrdView.swift
//  rkrd
//
//  Created by Patrick McElroy on 10/21/19.
//  Copyright © 2019 Patrick McElroy. All rights reserved.
//

import Foundation
import UIKit


class OneRkrdView: MainRkrdView {
    
    var test: String?
    @IBOutlet weak var oneRkrdViewText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        oneRkrdViewText.text = test
        // Do any additional setup after loading the view.
    }
    
    
}
