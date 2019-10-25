//
//  ViewController.swift
//  rkrd
//
//  Created by Patrick McElroy on 6/18/19.
//  Copyright © 2019 Patrick McElroy. All rights reserved.
//

import UIKit
import Charts

class MainRkrdView: UIViewController {
    
    var rkrdsArray: [String] = []

    var valuesArray: [String] = []
    
    var oneValuesArray: [String] = []

    var twoValuesArray: [String] = []
    
    var oneRkrd: Bool = false
    
    var twoRkrd: Bool = false

    @IBOutlet weak var oneRkrdText: UILabel!

    @IBOutlet weak var oneValueText: UILabel!

    @IBOutlet weak var rkrdText: UITextField!

    @IBOutlet weak var oneView: UIView!

    @IBOutlet weak var valueText: UITextField!

    @IBOutlet weak var twoRkrdText: UILabel!

    @IBOutlet weak var twoValueText: UILabel!

    @IBOutlet weak var oneAverageValue: UILabel!
    
    @IBOutlet weak var oneBestValue: UILabel!
    
    @IBAction func add_rkrd_one(_ sender: Any) {
        rkrdText.text = oneRkrdText.text

        self.view.viewWithTag(1)?.isHidden = false;
        self.view.sendSubviewToBack(self.view.viewWithTag(2)!)
        self.view.bringSubviewToFront(self.view.viewWithTag(1)!)
    }

    @IBAction func oneSegue(_ sender: Any) {
        performSegue(withIdentifier: "oneSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "oneSegue") {
            let destination = segue.destination as! OneRkrdView
            destination.rkrdName = rkrdsArray[0]
            destination.localValuesArray = valuesArray
        }
    }

    @IBAction func twoSegue(_ sender: Any) {
        performSegue(withIdentifier: "twoSegue", sender: self)
    }

    @IBAction func accountSegue(_ sender: Any) {
        performSegue(withIdentifier: "accountSegue", sender: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
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
        if(valueText.text != "") {
            valuesArray.append(valueText!.text ?? "no value added")
        }
        print(valuesArray)

        
        if(rkrdsArray[rkrdsArray.count-1] == oneRkrdText.text || self.view.viewWithTag(2)!.isHidden) {
            self.view.bringSubviewToFront(self.view.viewWithTag(2)!)
            self.view.viewWithTag(2)!.isHidden = false;

            if(valueText.text != "") {
                oneValuesArray.append(valuesArray[valuesArray.count-1])
            }

            oneRkrdText.text = rkrdsArray[rkrdsArray.count-1]
            oneValueText.text = oneValuesArray[oneValuesArray.count-1]
            var sum: Double = 0
            var average: Double
            for n in oneValuesArray {
                sum += Double(n)!
            }

            average = sum/Double((oneValuesArray.count))
            oneAverageValue.text = String(average)
            
            var highestValue: Double = -1
            for n in oneValuesArray {
                if(Double(n)! > highestValue) {
                    highestValue = Double(n)!
                }
            }
            oneBestValue.text = String(highestValue)
        }
        else if(rkrdsArray[rkrdsArray.count-1] == twoRkrdText.text || self.view.viewWithTag(3)!.isHidden) {
            self.view.bringSubviewToFront(self.view.viewWithTag(3)!)
            self.view.viewWithTag(3)!.isHidden = false;
            twoValuesArray.append(valuesArray[valuesArray.count-1])
            twoRkrdText.text = rkrdsArray[rkrdsArray.count-1]
            twoValueText.text = twoValuesArray[twoValuesArray.count-1]
        }
        
        rkrdText.text!.removeAll()
        valueText.text!.removeAll()
        self.view.endEditing(true)
        
        
    }
}

