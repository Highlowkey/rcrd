//
//  MainView.swift
//  rcrd
//
//  Created by Patrick McElroy on 6/18/19.
//  Copyright © 2019 Patrick McElroy. All rights reserved.
//

import UIKit
import Charts
import Foundation
import os.log

class MainView: UIViewController {
    
    var rcrdsArray: [String] = []
    
    var rcrds: [Rcrd] = [Rcrd("", []), Rcrd("", [])]
    
    //addRcrdView outlets
    @IBOutlet weak var rcrdText: UITextField!
    @IBOutlet weak var valueText: UITextField!
    
    //oneView outlets
    @IBOutlet weak var oneRcrdText: UILabel!
    @IBOutlet weak var oneValueText: UILabel!
    @IBOutlet weak var oneAverageValue: UILabel!
    @IBOutlet weak var oneBestValue: UILabel!

    //twoView outlets
    @IBOutlet weak var twoRcrdText: UILabel!
    @IBOutlet weak var twoValueText: UILabel!
    @IBOutlet weak var twoAverageValue: UILabel!
    @IBOutlet weak var twoBestValue: UILabel!
    
    //view loading
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let savedRcrds = loadRcrds() {
            rcrds += savedRcrds
            if let savedOneRcrd: Rcrd = rcrds[0] {
                rcrds[0].rcrdName = savedOneRcrd.rcrdName
                rcrds[0].rcrdValuesArray = savedOneRcrd.rcrdValuesArray
            }
            if let savedTwoRcrd: Rcrd = rcrds[1] {
                rcrds[1].rcrdName = savedTwoRcrd.rcrdName
                rcrds[1].rcrdValuesArray = savedTwoRcrd.rcrdValuesArray
            }
            if(self.view.accessibilityIdentifier == "mainView") {
                doReloadView()
            }
        }
    }
    
    //prompting rcrd adding
    
    @IBAction func addRcrdNew(_ sender: Any) {
        addRcrd()
    }
    
    @IBAction func addRcrdOne(_ sender: Any) {
        addRcrd(oneRcrdText.text!)
    }
    
    @IBAction func addRcrdTwo(_ sender: Any) {
        addRcrd(twoRcrdText.text!)
    }
    
    func addRcrd(_ rcrd: String = "") {
        rcrdText.text = rcrd
        
        self.view.viewWithTag(1)?.isHidden = false;
        self.view.sendSubviewToBack(self.view.viewWithTag(2)!)
        self.view.bringSubviewToFront(self.view.viewWithTag(1)!)
        
    }
    
    //updating rcrds after adding
    
    @IBAction func done_adding(_ sender: Any) {
        self.view.viewWithTag(1)?.isHidden = true
        if(rcrdText!.text != "") {
            var isNew: Bool = true
            for n in rcrds {
                if (n.rcrdName == rcrdText!.text) {
                    isNew = false
                }
            }
            rcrdsArray.append(rcrdText!.text!)
        
            if(isNew) {
                if(self.view.viewWithTag(2)!.isHidden) {
                    rcrds[0].rcrdName = rcrdsArray[rcrdsArray.count-1]
                    if let text = valueText.text {
                        if Double(text) != nil {
                            rcrds[0].rcrdValuesArray.append(valueText!.text!)
                        }
                    }
                    oneRcrdText.text = rcrds[0].rcrdName
                    self.view.viewWithTag(2)!.isHidden = false
                }
                else if(self.view.viewWithTag(3)!.isHidden) {
                    rcrds[1].rcrdName = rcrdsArray[rcrdsArray.count-1]
                    if let text = valueText.text {
                        if Double(text) != nil {
                            rcrds[1].rcrdValuesArray.append(valueText!.text!)
                        }
                    }
                    twoRcrdText.text = rcrds[1].rcrdName
                    self.view.viewWithTag(3)!.isHidden = false
                }
            }
            if(!isNew) {
                if(rcrdText.text! == rcrds[0].rcrdName) {
                    if let text = valueText.text {
                        if Double(text) != nil {
                            rcrds[0].rcrdValuesArray.append(valueText!.text!)
                        }
                    }
                }
                if(rcrdText.text! == rcrds[1].rcrdName) {
                    if let text = valueText.text {
                        if Double(text) != nil {
                            rcrds[1].rcrdValuesArray.append(valueText!.text!)
                        }
                    }
                }
            }

            if (rcrds[0].rcrdValuesArray.count > 0) {
                oneValueText.text = String(rcrds[0].rcrdValuesArray[rcrds[0].rcrdValuesArray.count-1])
                oneAverageValue.text = String(calcAverage(rcrds[0].rcrdValuesArray))
                oneBestValue.text = String(calcHighest(rcrds[0].rcrdValuesArray))
            }
            else {
                oneValueText.text = ""
                oneAverageValue.text = ""
                oneBestValue.text = ""
            }
                
            if (rcrds[1].rcrdValuesArray.count > 0) {
                twoValueText.text = String(rcrds[1].rcrdValuesArray[rcrds[1].rcrdValuesArray.count-1])
                twoAverageValue.text = String(calcAverage(rcrds[1].rcrdValuesArray))
                twoBestValue.text = String(calcHighest(rcrds[1].rcrdValuesArray))
            }
            else {
                twoValueText.text = ""
                twoAverageValue.text = ""
                twoBestValue.text = ""
            }
            
            rcrdText.text!.removeAll()
            valueText.text!.removeAll()
            self.view.endEditing(true)
            saveRcrds()
            doReloadView()
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
    
    //rcrdView segue management
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! RcrdView
        if(segue.identifier == "oneSegue") {
            destination.rcrdName = rcrds[0].rcrdName
            destination.localValuesArray = rcrds[0].rcrdValuesArray
            destination.numRcrd = 1
        }
        if(segue.identifier == "twoSegue") {
            destination.rcrdName = rcrds[1].rcrdName
            destination.localValuesArray = rcrds[1].rcrdValuesArray
            destination.numRcrd = 2
        }
    }
    
    @IBAction func unwindAfterDelete(segue:UIStoryboardSegue) {
        if(segue.identifier == "1") {
            rcrds[0] = Rcrd("", [])
            oneValueText.text = ""
            oneAverageValue.text = ""
            oneBestValue.text = ""
        }
        if(segue.identifier == "2") {
            rcrds[1] = Rcrd("", [])
            twoValueText.text = ""
            twoAverageValue.text = ""
            twoBestValue.text = ""
        }
        saveRcrds()
        doReloadView()
    }
    
    //accountView segue management
    
    @IBAction func accountSegue(_ sender: Any) {
        performSegue(withIdentifier: "accountSegue", sender: self)
    }

    //user rcrd saving and loading
    
    func application(_ application: UIApplication,
                shouldSaveApplicationState coder: NSCoder) -> Bool {
       // Save the current app version to the archive.
       coder.encode(1.0, forKey: "rcrdVersion")
            
       // Always save state information.
       return true
    }
    
    private func saveRcrds() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(rcrds, toFile: Rcrd.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Rcrds successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save rcrds...", log: OSLog.default, type: .error)
        }
    }
    
    private func loadRcrds() -> [Rcrd]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Rcrd.ArchiveURL.path) as? [Rcrd]
    }

    //view reloading after delete or re-launch
    
    func doReloadView() {
        if (rcrds[0].rcrdName != "") {
            oneRcrdText.text = rcrds[0].rcrdName
            if (rcrds[0].rcrdValuesArray.count > 0) {
                oneValueText.text = String(rcrds[0].rcrdValuesArray[rcrds[0].rcrdValuesArray.count-1])
                oneAverageValue.text = String(calcAverage(rcrds[0].rcrdValuesArray))
                oneBestValue.text = String(calcHighest(rcrds[0].rcrdValuesArray))
            }
            self.view.viewWithTag(2)!.isHidden = false
        }
        else {
            self.view.viewWithTag(2)!.isHidden = true
        }
            
        if (rcrds[1].rcrdName != "") {
            twoRcrdText.text = rcrds[1].rcrdName
            if (rcrds[1].rcrdValuesArray.count > 0) {
                twoValueText.text = String(rcrds[1].rcrdValuesArray[rcrds[1].rcrdValuesArray.count-1])
                twoAverageValue.text = String(calcAverage(rcrds[1].rcrdValuesArray))
                twoBestValue.text = String(calcHighest(rcrds[1].rcrdValuesArray))
            }
            self.view.viewWithTag(3)!.isHidden = false
        }
        else {
            self.view.viewWithTag(3)!.isHidden = true
        }
        
    }
    
    
}
