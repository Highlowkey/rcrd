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
    
    //TODO: massively clean up this variable list and add comments
    
    var rkrdsArray: [String] = []
    
    var isOneRkrd: Bool = false
    
    var isTwoRkrd: Bool = false
    
    var oneRkrd: Rkrd = Rkrd.init("", [])
    
    var twoRkrd: Rkrd = Rkrd.init("", [])
    
    var rkrds: [Rkrd] = []
    
    var deleted: Bool = false

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
            destination.rkrdName = oneRkrd.rkrdName
            destination.localValuesArray = oneRkrd.rkrdValuesArray
            destination.numRkrd = 1
        }
        if(segue.identifier == "twoSegue") {
            destination.rkrdName = twoRkrd.rkrdName
            destination.localValuesArray = twoRkrd.rkrdValuesArray
            destination.numRkrd = 2
        }
    }

    @IBAction func accountSegue(_ sender: Any) {
        performSegue(withIdentifier: "accountSegue", sender: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if let savedRkrds = loadRkrds() {
            rkrds += savedRkrds
            if let savedOneRkrd: Rkrd = rkrds[0] {
                oneRkrd.rkrdName = savedOneRkrd.rkrdName
                oneRkrd.rkrdValuesArray = savedOneRkrd.rkrdValuesArray
            }
            if let savedTwoRkrd: Rkrd = rkrds[1] {
                twoRkrd.rkrdName = savedTwoRkrd.rkrdName
                twoRkrd.rkrdValuesArray = savedTwoRkrd.rkrdValuesArray
            }
            if(self.view.accessibilityIdentifier == "mainView") {
                doReloadView()
            }
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
                    oneRkrd.rkrdName = rkrdsArray[rkrdsArray.count-1]
                    if let text = valueText.text {
                        if Double(text) != nil {
                            oneRkrd.rkrdValuesArray.append(valueText!.text ?? "N/A")
                        }
                    }
                    oneRkrdText.text = oneRkrd.rkrdName
                    rkrds.append(oneRkrd)
                    self.view.viewWithTag(2)!.isHidden = false
                }
                else if(self.view.viewWithTag(3)!.isHidden) {
                    twoRkrd.rkrdName = rkrdsArray[rkrdsArray.count-1]
                    if let text = valueText.text {
                        if Double(text) != nil {
                            twoRkrd.rkrdValuesArray.append(valueText!.text ?? "N/A")
                        }
                    }
                    rkrds.append(twoRkrd)
                    twoRkrdText.text = twoRkrd.rkrdName
                    self.view.viewWithTag(3)!.isHidden = false
                }
            }
            if(!isNew) {
                if(rkrdText.text! == oneRkrd.rkrdName) {
                    if let text = valueText.text {
                        if Double(text) != nil {
                            oneRkrd.rkrdValuesArray.append(valueText!.text ?? "N/A")
                        }
                    }
                }
                if(rkrdText.text! == twoRkrd.rkrdName) {
                    if let text = valueText.text {
                        if Double(text) != nil {
                            twoRkrd.rkrdValuesArray.append(valueText!.text ?? "N/A")
                        }
                    }
                }
            }

            if (oneRkrd.rkrdValuesArray.count > 0) {
                oneValueText.text = String(oneRkrd.rkrdValuesArray[oneRkrd.rkrdValuesArray.count-1])
                oneAverageValue.text = String(calcAverage(oneRkrd.rkrdValuesArray))
                oneBestValue.text = String(calcHighest(oneRkrd.rkrdValuesArray))
            }
                
            if (twoRkrd.rkrdValuesArray.count > 0) {
                twoValueText.text = String(twoRkrd.rkrdValuesArray[twoRkrd.rkrdValuesArray.count-1])
                twoAverageValue.text = String(calcAverage(twoRkrd.rkrdValuesArray))
                twoBestValue.text = String(calcHighest(twoRkrd.rkrdValuesArray))
            }
            
            rkrdText.text!.removeAll()
            valueText.text!.removeAll()
            self.view.endEditing(true)
            rkrds = [oneRkrd, twoRkrd]
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
    
    func doReloadView() {
        oneRkrd = rkrds[0]
        twoRkrd = rkrds[1]
        if (oneRkrd.rkrdValuesArray.count > 0) {
            oneRkrdText.text = oneRkrd.rkrdName
            oneValueText.text = String(oneRkrd.rkrdValuesArray[oneRkrd.rkrdValuesArray.count-1])
            oneAverageValue.text = String(calcAverage(oneRkrd.rkrdValuesArray))
            oneBestValue.text = String(calcHighest(oneRkrd.rkrdValuesArray))
            self.view.viewWithTag(2)!.isHidden = false
        }
        else {
            self.view.viewWithTag(2)!.isHidden = true
        }
            
        if (twoRkrd.rkrdValuesArray.count > 0) {
            twoRkrdText.text = twoRkrd.rkrdName
            twoValueText.text = String(twoRkrd.rkrdValuesArray[twoRkrd.rkrdValuesArray.count-1])
            twoAverageValue.text = String(calcAverage(twoRkrd.rkrdValuesArray))
            twoBestValue.text = String(calcHighest(twoRkrd.rkrdValuesArray))
            self.view.viewWithTag(3)!.isHidden = false
        }
        else {
            self.view.viewWithTag(3)!.isHidden = true
        }
        
    }
    
    
}
