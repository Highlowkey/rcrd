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
    
    var inputArray: [String] = []
    
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
    
    var oneRcrd: Int = 0
    var twoRcrd: Int = 1
    
    //view loading
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let savedRcrds = loadRcrds() {
            yourRcrds.rcrds.removeAll()
            yourRcrds.rcrds += savedRcrds
            if let savedOneRcrd: Rcrd = yourRcrds.rcrds[0] {
                yourRcrds.rcrds[0].rcrdName = savedOneRcrd.rcrdName
                yourRcrds.rcrds[0].rcrdValuesArray = savedOneRcrd.rcrdValuesArray
            }
            if let savedTwoRcrd: Rcrd = yourRcrds.rcrds[1] {
                yourRcrds.rcrds[1].rcrdName = savedTwoRcrd.rcrdName
                yourRcrds.rcrds[1].rcrdValuesArray = savedTwoRcrd.rcrdValuesArray
            }
            if(self.restorationIdentifier == "MainView") {
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
    
    //updating yourRcrds.rcrds after adding
    
    @IBAction func done_adding(_ sender: Any) {
        self.view.viewWithTag(1)?.isHidden = true
        if(rcrdText!.text != "") {
            var isNew: Bool = true
            for n in yourRcrds.rcrds {
                if (n.rcrdName == rcrdText!.text) {
                    isNew = false
                }
            }
            inputArray.append(rcrdText!.text!)
        
            if(isNew) {
                if(self.view.viewWithTag(2)!.isHidden) {
                    yourRcrds.rcrds[0].rcrdName = inputArray[inputArray.count-1]
                    if let text = valueText.text {
                        if Double(text) != nil {
                            yourRcrds.rcrds[0].rcrdValuesArray.append(valueText!.text!)
                        }
                    }
                    oneRcrdText.text = yourRcrds.rcrds[0].rcrdName
                    self.view.viewWithTag(2)!.isHidden = false
                }
                else if(self.view.viewWithTag(3)!.isHidden) {
                    yourRcrds.rcrds[1].rcrdName = inputArray[inputArray.count-1]
                    if let text = valueText.text {
                        if Double(text) != nil {
                            yourRcrds.rcrds[1].rcrdValuesArray.append(valueText!.text!)
                        }
                    }
                    twoRcrdText.text = yourRcrds.rcrds[1].rcrdName
                    self.view.viewWithTag(3)!.isHidden = false
                }
            }
            if(!isNew) {
                if(rcrdText.text! == yourRcrds.rcrds[0].rcrdName) {
                    if let text = valueText.text {
                        if Double(text) != nil {
                            yourRcrds.rcrds[0].rcrdValuesArray.append(valueText!.text!)
                        }
                    }
                }
                if(rcrdText.text! == yourRcrds.rcrds[1].rcrdName) {
                    if let text = valueText.text {
                        if Double(text) != nil {
                            yourRcrds.rcrds[1].rcrdValuesArray.append(valueText!.text!)
                        }
                    }
                }
            }

            if (yourRcrds.rcrds[0].rcrdValuesArray.count > 0) {
                oneValueText.text = String(yourRcrds.rcrds[0].rcrdValuesArray[yourRcrds.rcrds[0].rcrdValuesArray.count-1])
                oneAverageValue.text = String(calcAverage(yourRcrds.rcrds[0].rcrdValuesArray))
                oneBestValue.text = String(calcHighest(yourRcrds.rcrds[0].rcrdValuesArray))
            }
            else {
                oneValueText.text = ""
                oneAverageValue.text = ""
                oneBestValue.text = ""
            }
                
            if (yourRcrds.rcrds[1].rcrdValuesArray.count > 0) {
                twoValueText.text = String(yourRcrds.rcrds[1].rcrdValuesArray[yourRcrds.rcrds[1].rcrdValuesArray.count-1])
                twoAverageValue.text = String(calcAverage(yourRcrds.rcrds[1].rcrdValuesArray))
                twoBestValue.text = String(calcHighest(yourRcrds.rcrds[1].rcrdValuesArray))
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
        if(segue.identifier == "oneSegue") {
            let destination = segue.destination as! RcrdView
//            destination.rcrdName = yourRcrds.rcrds[0].rcrdName
//            destination.localValuesArray = yourRcrds.rcrds[0].rcrdValuesArray
            destination.numRcrd = oneRcrd
        }
        if(segue.identifier == "twoSegue") {
            let destination = segue.destination as! RcrdView
//            destination.rcrdName = yourRcrds.rcrds[1].rcrdName
//            destination.localValuesArray = yourRcrds.rcrds[1].rcrdValuesArray
            destination.numRcrd = twoRcrd
        }
//        if(segue.identifier == "listSegue") {
//            let destination = segue.destination as! RcrdList
//        }
    }
    
    @IBAction func unwindAfterDelete(segue:UIStoryboardSegue) {
//        if(segue.identifier == "1") {
//            yourRcrds.rcrds[0] = Rcrd("", [])
////            oneValueText.text = ""
////            oneAverageValue.text = ""
////            oneBestValue.text = ""
//        }
//        if(segue.identifier == "2") {
//            yourRcrds.rcrds[1] = Rcrd("", [])
////            twoValueText.text = ""
////            twoAverageValue.text = ""
////            twoBestValue.text = ""
//        }
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
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(yourRcrds.rcrds, toFile: Rcrd.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Rcrds successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save yourRcrds.rcrds...", log: OSLog.default, type: .error)
        }
    }
    
    private func loadRcrds() -> [Rcrd]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Rcrd.ArchiveURL.path) as? [Rcrd]
    }

    //view reloading after delete or re-launch
    
    func doReloadView() {
//        if (yourRcrds.rcrds[0].rcrdName != "") {
//            oneRcrdText.text = yourRcrds.rcrds[0].rcrdName
//            if (yourRcrds.rcrds[0].rcrdValuesArray.count > 0) {
//                oneValueText.text = String(yourRcrds.rcrds[0].rcrdValuesArray[yourRcrds.rcrds[0].rcrdValuesArray.count-1])
//                oneAverageValue.text = String(calcAverage(yourRcrds.rcrds[0].rcrdValuesArray))
//                oneBestValue.text = String(calcHighest(yourRcrds.rcrds[0].rcrdValuesArray))
//            }
//            self.view.viewWithTag(2)!.isHidden = false
//        }
//        else {
//            self.view.viewWithTag(2)!.isHidden = true
//        }
//
//        if (yourRcrds.rcrds[1].rcrdName != "") {
//            twoRcrdText.text = yourRcrds.rcrds[1].rcrdName
//            if (yourRcrds.rcrds[1].rcrdValuesArray.count > 0) {
//                twoValueText.text = String(yourRcrds.rcrds[1].rcrdValuesArray[yourRcrds.rcrds[1].rcrdValuesArray.count-1])
//                twoAverageValue.text = String(calcAverage(yourRcrds.rcrds[1].rcrdValuesArray))
//                twoBestValue.text = String(calcHighest(yourRcrds.rcrds[1].rcrdValuesArray))
//            }
//            self.view.viewWithTag(3)!.isHidden = false
//        }
//        else {
//            self.view.viewWithTag(3)!.isHidden = true
//        }
        
        self.view.viewWithTag(2)!.isHidden = true
        self.view.viewWithTag(3)!.isHidden = true
        var firstFilled: Bool = false
        for n in yourRcrds.rcrds {
            if(!firstFilled) {
                if (n.rcrdName != "" && n.isFollowing == true) {
                    oneRcrdText.text = n.rcrdName
                    if (n.rcrdValuesArray.count > 0) {
                        oneValueText.text = String(n.rcrdValuesArray[n.rcrdValuesArray.count-1])
                        oneAverageValue.text = String(calcAverage(n.rcrdValuesArray))
                        oneBestValue.text = String(calcHighest(n.rcrdValuesArray))
                    }
                    firstFilled = true
                    oneRcrd = yourRcrds.rcrds.firstIndex(of: n)!
                    self.view.viewWithTag(2)!.isHidden = false
                }
            }
            else {
                if (n.rcrdName != "" && n.isFollowing == true) {
                    twoRcrdText.text = n.rcrdName
                    if (n.rcrdValuesArray.count > 0) {
                        oneValueText.text = String(n.rcrdValuesArray[n.rcrdValuesArray.count-1])
                        oneAverageValue.text = String(calcAverage(n.rcrdValuesArray))
                        oneBestValue.text = String(calcHighest(n.rcrdValuesArray))
                    }
                    twoRcrd = yourRcrds.rcrds.firstIndex(of: n)!
                    self.view.viewWithTag(3)!.isHidden = false
                }
            }
        }
    }
    
    
}
