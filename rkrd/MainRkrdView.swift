//
//  ViewController.swift
//  rkrd
//
//  Created by Patrick McElroy on 6/18/19.
//  Copyright © 2019 Patrick McElroy. All rights reserved.
//

import UIKit
import Charts
import Foundation
import os.log

class MainRkrdView: UIViewController {
    
    var rkrdsArray: [String] = []
    
    var rkrds: [Rkrd] = []
    
    //addRkrdView outlets
    @IBOutlet weak var rkrdText: UITextField!
    @IBOutlet weak var valueText: UITextField!
    
    //oneView outlets
    @IBOutlet weak var oneRkrdText: UILabel!
    @IBOutlet weak var oneValueText: UILabel!
    @IBOutlet weak var oneAverageValue: UILabel!
    @IBOutlet weak var oneBestValue: UILabel!

    //twoView outlets
    @IBOutlet weak var twoRkrdText: UILabel!
    @IBOutlet weak var twoValueText: UILabel!
    @IBOutlet weak var twoAverageValue: UILabel!
    @IBOutlet weak var twoBestValue: UILabel!
    
    //view loading
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let savedRkrds = loadRkrds() {
            rkrds += savedRkrds
            if let savedOneRkrd: Rkrd = rkrds[0] {
                rkrds[0].rkrdName = savedOneRkrd.rkrdName
                rkrds[0].rkrdValuesArray = savedOneRkrd.rkrdValuesArray
            }
            if let savedTwoRkrd: Rkrd = rkrds[1] {
                rkrds[1].rkrdName = savedTwoRkrd.rkrdName
                rkrds[1].rkrdValuesArray = savedTwoRkrd.rkrdValuesArray
            }
            if(self.view.accessibilityIdentifier == "mainView") {
                doReloadView()
            }
        }
    }
    
    //prompting rkrd adding
    
    @IBAction func addRkrdNew(_ sender: Any) {
        addRkrd()
    }
    
    @IBAction func addRkrdOne(_ sender: Any) {
        addRkrd(oneRkrdText.text!)
    }
    
    @IBAction func addRkrdTwo(_ sender: Any) {
        addRkrd(twoRkrdText.text!)
    }
    
    func addRkrd(_ rkrd: String = "") {
        rkrdText.text = rkrd
        
        self.view.viewWithTag(1)?.isHidden = false;
        self.view.sendSubviewToBack(self.view.viewWithTag(2)!)
        self.view.bringSubviewToFront(self.view.viewWithTag(1)!)
        
    }
    
    //updating rkrds after adding
    
    @IBAction func done_adding(_ sender: Any) {
        doReloadView()
        self.view.viewWithTag(1)?.isHidden = true
        if(rkrdText!.text != "") {
            var isNew: Bool = true
            for n in rkrds {
                if (n.rkrdName == rkrdText!.text) {
                    isNew = false
                }
            }
            rkrdsArray.append(rkrdText!.text!)
        
            if(isNew) {
                if(self.view.viewWithTag(2)!.isHidden) {
                    rkrds[0].rkrdName = rkrdsArray[rkrdsArray.count-1]
                    if let text = valueText.text {
                        if Double(text) != nil {
                            rkrds[0].rkrdValuesArray.append(valueText!.text!)
                        }
                        rkrds[0].rkrdValuesArray.append("0")
                    }
                    oneRkrdText.text = rkrds[0].rkrdName
                    self.view.viewWithTag(2)!.isHidden = false
                }
                else if(self.view.viewWithTag(3)!.isHidden) {
                    rkrds[1].rkrdName = rkrdsArray[rkrdsArray.count-1]
                    if let text = valueText.text {
                        if Double(text) != nil {
                            rkrds[1].rkrdValuesArray.append(valueText!.text!)
                        }
                    }
                    twoRkrdText.text = rkrds[1].rkrdName
                    rkrds[1].rkrdValuesArray.append("0")
                    self.view.viewWithTag(3)!.isHidden = false
                }
            }
            if(!isNew) {
                if(rkrdText.text! == rkrds[0].rkrdName) {
                    if let text = valueText.text {
                        if Double(text) != nil {
                            rkrds[0].rkrdValuesArray.append(valueText!.text ?? "N/A")
                        }
                    }
                }
                if(rkrdText.text! == rkrds[1].rkrdName) {
                    if let text = valueText.text {
                        if Double(text) != nil {
                            rkrds[1].rkrdValuesArray.append(valueText!.text ?? "N/A")
                        }
                    }
                }
            }

            if (rkrds[0].rkrdValuesArray.count > 0) {
                oneValueText.text = String(rkrds[0].rkrdValuesArray[rkrds[0].rkrdValuesArray.count-1])
                oneAverageValue.text = String(calcAverage(rkrds[0].rkrdValuesArray))
                oneBestValue.text = String(calcHighest(rkrds[0].rkrdValuesArray))
            }
                
            if (rkrds[1].rkrdValuesArray.count > 0) {
                twoValueText.text = String(rkrds[1].rkrdValuesArray[rkrds[1].rkrdValuesArray.count-1])
                twoAverageValue.text = String(calcAverage(rkrds[1].rkrdValuesArray))
                twoBestValue.text = String(calcHighest(rkrds[1].rkrdValuesArray))
            }
            
            rkrdText.text!.removeAll()
            valueText.text!.removeAll()
            self.view.endEditing(true)
            saveRkrds()
        }
    }
    
    func calcAverage(_ valueArray: [String]) -> Double {
        var sum: Double = 0
        var average: Double
        
        for n in valueArray {
            sum += Double(n)!
        }

        average = sum/Double((valueArray.count))
        return round(average*1000)/1000
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
    
    //rkrdView segue management
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! OneRkrdView
        if(segue.identifier == "oneSegue") {
            destination.rkrdName = rkrds[0].rkrdName
            destination.localValuesArray = rkrds[0].rkrdValuesArray
            destination.numRkrd = 1
        }
        if(segue.identifier == "twoSegue") {
            destination.rkrdName = rkrds[1].rkrdName
            destination.localValuesArray = rkrds[1].rkrdValuesArray
            destination.numRkrd = 2
        }
    }
    
    @IBAction func unwindAfterDelete(segue:UIStoryboardSegue) {
        if(segue.identifier == "1") {
            rkrds[0] = Rkrd("", [])
        }
        if(segue.identifier == "2") {
            rkrds[1] = Rkrd("", [])
        }
        saveRkrds()
        doReloadView()
    }
    
    //accountView segue management
    
    @IBAction func accountSegue(_ sender: Any) {
        performSegue(withIdentifier: "accountSegue", sender: self)
    }

    //user rkrd saving and loading
    
    func application(_ application: UIApplication,
                shouldSaveApplicationState coder: NSCoder) -> Bool {
       // Save the current app version to the archive.
       coder.encode(1.0, forKey: "rkrdVersion")
            
       // Always save state information.
       return true
    }
    
    private func saveRkrds() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(rkrds, toFile: Rkrd.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Rkrds successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save rkrds...", log: OSLog.default, type: .error)
        }
    }
    
    private func loadRkrds() -> [Rkrd]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Rkrd.ArchiveURL.path) as? [Rkrd]
    }

    //view reloading after delete or re-launch
    
    func doReloadView() {
        if (rkrds[0].rkrdValuesArray.count > 0) {
            oneRkrdText.text = rkrds[0].rkrdName
            oneValueText.text = String(rkrds[0].rkrdValuesArray[rkrds[0].rkrdValuesArray.count-1])
            oneAverageValue.text = String(calcAverage(rkrds[0].rkrdValuesArray))
            oneBestValue.text = String(calcHighest(rkrds[0].rkrdValuesArray))
            self.view.viewWithTag(2)!.isHidden = false
        }
        else {
            self.view.viewWithTag(2)!.isHidden = true
        }
            
        if (rkrds[1].rkrdValuesArray.count > 0) {
            twoRkrdText.text = rkrds[1].rkrdName
            twoValueText.text = String(rkrds[1].rkrdValuesArray[rkrds[1].rkrdValuesArray.count-1])
            twoAverageValue.text = String(calcAverage(rkrds[1].rkrdValuesArray))
            twoBestValue.text = String(calcHighest(rkrds[1].rkrdValuesArray))
            self.view.viewWithTag(3)!.isHidden = false
        }
        else {
            self.view.viewWithTag(3)!.isHidden = true
        }
        
    }
    
    
}
