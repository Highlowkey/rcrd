//
//  ViewController.swift
//  rkrd
//
//  Created by Patrick McElroy on 6/18/19.
//  Copyright © 2019 Patrick McElroy. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    
    var rkrdsArray: [String] = []
    
    var valuesArray: [String] = []
    
    var oneValuesArray: [String] = []
    
    var twoValuesArray: [String] = []
    
    @IBOutlet weak var oneRkrdText: UILabel!
    
    @IBOutlet weak var oneValueText: UILabel!
    
    @IBOutlet weak var rkrdText: UITextField!
    
    @IBOutlet weak var oneView: RkrdView!
    
    @IBOutlet weak var valueText: UITextField!
    
    @IBOutlet weak var twoRkrdText: UILabel!
    
    @IBOutlet weak var twoValueText: UILabel!
    
    @IBOutlet weak var averageValue: UILabel!
    
    @IBAction func twoSegue(_ sender: Any) {
        performSegue(withIdentifier: "twoSegue", sender: self)
    }
    
    @IBAction func accountSegue(_ sender: Any) {
        performSegue(withIdentifier: "accountSegue", sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        print(rkrdsArray)
        print(valuesArray)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func add_rkrd(_ sender: Any) {
        
        print("Hello")
        self.view.viewWithTag(1)?.isHidden = false;
        self.view.sendSubviewToBack(self.view.viewWithTag(2)!)
        self.view.bringSubviewToFront(self.view.viewWithTag(1)!)
    }
    
    @IBAction func done_adding(_ sender: Any) {
        self.view.viewWithTag(1)?.isHidden = true;
        rkrdsArray.append(rkrdText!.text!)
        valuesArray.append(valueText!.text ?? "no value added")
        print(rkrdsArray)
        rkrdText.text!.removeAll()
        valueText.text!.removeAll()
        
        if(self.view.viewWithTag(2)!.isHidden) {
            self.view.bringSubviewToFront(self.view.viewWithTag(2)!)
            self.view.viewWithTag(2)!.isHidden = false;
            oneValuesArray.append(valuesArray[valuesArray.count-1])
            oneRkrdText.text = rkrdsArray[rkrdsArray.count-1]
            oneValueText.text = oneValuesArray[oneValuesArray.count-1]
            var sum: Double = 0
            var average: Double
            for n in oneValuesArray {
                sum += Double(n)!
            }
            average = sum/Double((oneValuesArray.count))
            averageValue.text = String(average)
        }
        else if(self.view.viewWithTag(3)!.isHidden) {
            self.view.bringSubviewToFront(self.view.viewWithTag(3)!)
            self.view.viewWithTag(3)!.isHidden = false;
            twoValuesArray.append(valuesArray[valuesArray.count-1])
            twoRkrdText.text = rkrdsArray[rkrdsArray.count-1]
            twoValueText.text = twoValuesArray[oneValuesArray.count-1]
        }
        self.view.endEditing(true)
        
        
    }
}

