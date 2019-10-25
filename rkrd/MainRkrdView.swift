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

    var valuesArray: [String] = ["0"]
    
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
    
    @IBOutlet weak var twoAverageValue: UILabel!
    
    @IBOutlet weak var twoBestValue: UILabel!
    
    @IBOutlet weak var oneAverageValue: UILabel!
    
    @IBOutlet weak var oneBestValue: UILabel!
    
    @IBAction func addRkrdOne(_ sender: Any) {
        addRkrd(oneRkrdText.text!)
    }
    
    @IBAction func addRkrdTwo(_ sender: Any) {
        addRkrd(twoRkrdText.text!)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! OneRkrdView
        if(segue.identifier == "oneSegue") {
            destination.rkrdName = oneRkrdText.text
            destination.localValuesArray = oneValuesArray
        }
        if(segue.identifier == "twoSegue") {
            destination.rkrdName = twoRkrdText.text
            destination.localValuesArray = twoValuesArray
        }
    }

    @IBAction func accountSegue(_ sender: Any) {
        performSegue(withIdentifier: "accountSegue", sender: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func addRkrd(_ rkrd: String = "") {
        rkrdText.text = rkrd
        
        self.view.viewWithTag(1)?.isHidden = false;
        self.view.sendSubviewToBack(self.view.viewWithTag(2)!)
        self.view.bringSubviewToFront(self.view.viewWithTag(1)!)
    }
    
    @IBAction func addRkrdNew(_ sender: Any) {
        addRkrd()
    }
    @IBAction func done_adding(_ sender: Any) {
        self.view.viewWithTag(1)?.isHidden = true;
        rkrdsArray.append(rkrdText!.text!)
        if let text = valueText.text {
            if Double(text) != nil {
            valuesArray.append(valueText!.text ?? "no value added")
            }
        }
        print(valuesArray)

        
        if(rkrdsArray[rkrdsArray.count-1] == oneRkrdText.text || self.view.viewWithTag(2)!.isHidden) {
            self.view.bringSubviewToFront(self.view.viewWithTag(2)!)
            self.view.viewWithTag(2)!.isHidden = false;

            if(valueText.text != "") {
                if(Double(valuesArray[valuesArray.count-1]) != nil) {
                    oneValuesArray.append(valuesArray[valuesArray.count-1])
                }
            }

            oneRkrdText.text = rkrdsArray[rkrdsArray.count-1]
            oneValueText.text = oneValuesArray[oneValuesArray.count-1]
            
            oneAverageValue.text = String(calcAverage(oneValuesArray))
            oneBestValue.text = String(calcHighest(oneValuesArray))
        }
        else if(rkrdsArray[rkrdsArray.count-1] == twoRkrdText.text || self.view.viewWithTag(3)!.isHidden) {
            self.view.bringSubviewToFront(self.view.viewWithTag(3)!)
            self.view.viewWithTag(3)!.isHidden = false;

            if(valueText.text != "") {
                if(Double(valuesArray[valuesArray.count-1]) != nil) {
                    twoValuesArray.append(valuesArray[valuesArray.count-1])
                }
            }

            twoRkrdText.text = rkrdsArray[rkrdsArray.count-1]
            twoValueText.text = twoValuesArray[twoValuesArray.count-1]
            
            twoAverageValue.text = String(calcAverage(twoValuesArray))
            twoBestValue.text = String(calcHighest(twoValuesArray))
        }
        
        rkrdText.text!.removeAll()
        valueText.text!.removeAll()
        self.view.endEditing(true)
    }
    
    func calcAverage(_ valueArray: [String]) -> Double {
        var sum: Double = 0
        var average: Double
        
        for n in valueArray {
            sum += Double(n)!
        }

        average = sum/Double((valueArray.count))
        return average
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
    
    func application(_ application: UIApplication,
                shouldSaveApplicationState coder: NSCoder) -> Bool {
       // Save the current app version to the archive.
       coder.encode(1.0, forKey: "rkrdVersion")
            
       // Always save state information.
       return true
    }
}

