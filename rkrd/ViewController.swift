//
//  ViewController.swift
//  rkrd
//
//  Created by Patrick McElroy on 6/18/19.
//  Copyright © 2019 Patrick McElroy. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    
    @IBOutlet weak var rkrdText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func add_rkrd(_ sender: Any) {
        print("Hello");
        self.view.viewWithTag(1)?.isHidden = false;
    }
    
    @IBAction func done_adding(_ sender: Any) {
        self.view.viewWithTag(1)?.isHidden = true;
        print(rkrdText.text ?? "N/A")
    }
}

