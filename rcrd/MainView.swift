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
    
    var numRcrds : Int = 2
    
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
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: NSNotification.Name(rawValue: "refresh"), object: nil)
        if let savedRcrds = loadRcrds() {
            yourRcrds.rcrds.removeAll()
            yourRcrds.rcrds += savedRcrds
            if yourRcrds.rcrds.count > 0 {
                if let savedOneRcrd: Rcrd = yourRcrds.rcrds[0] {
                    yourRcrds.rcrds[0].rcrdName = savedOneRcrd.rcrdName
                    yourRcrds.rcrds[0].rcrdValuesArray = savedOneRcrd.rcrdValuesArray
                }
                if yourRcrds.rcrds.count > 1 {
                    if let savedTwoRcrd: Rcrd = yourRcrds.rcrds[1] {
                        yourRcrds.rcrds[1].rcrdName = savedTwoRcrd.rcrdName
                        yourRcrds.rcrds[1].rcrdValuesArray = savedTwoRcrd.rcrdValuesArray
                    }
                }
            }
            doReloadView()
        }
    }
    
    @objc func refresh(notification: NSNotification) {
        print("Refreshing...")
        doReloadView()
        saveRcrds()
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
            var index: Int = 0
            for n in yourRcrds.rcrds {
                if (n.rcrdName == rcrdText!.text) {
                    isNew = false
                    index = yourRcrds.rcrds.firstIndex(of: n)!
                }
            }
            inputArray.append(rcrdText!.text!)
        
            if(isNew) {
                yourRcrds.rcrds.append(Rcrd(inputArray[inputArray.count-1],[]))
                index = yourRcrds.rcrds.count-1
                if let text = valueText.text {
                    if Double(text) != nil {
                        yourRcrds.rcrds[index].rcrdValuesArray.append(valueText!.text!)
                    }
                }
            }
            if(!isNew) {
                if let text = valueText.text {
                    if Double(text) != nil {
                        yourRcrds.rcrds[index].rcrdValuesArray.append(valueText!.text!)
                    }
                }
            }
            rcrdText.text!.removeAll()
            valueText.text!.removeAll()
            self.view.endEditing(true)
            saveRcrds()
            doReloadView()
        }
    }
    
    //rcrdView segue management
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "oneSegue") {
            let destination = segue.destination as! RcrdView
            destination.numDisplayed = 1
            destination.rcrdDisplayed = yourRcrds.findRcrd(oneRcrdText.text!)
        }
        if(segue.identifier == "twoSegue") {
            let destination = segue.destination as! RcrdView
            destination.numDisplayed = 2
            destination.rcrdDisplayed = yourRcrds.findRcrd(twoRcrdText.text!)
        }
    }
    
    @IBAction func unwindAfterDelete(segue:UIStoryboardSegue) {
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
        self.view.viewWithTag(2)!.isHidden = true
        self.view.viewWithTag(3)!.isHidden = true
        oneValueText.text = ""
        oneAverageValue.text = ""
        oneBestValue.text = ""
        twoValueText.text = ""
        twoAverageValue.text = ""
        twoBestValue.text = ""
        var firstFilled: Bool = false
        for n in yourRcrds.rcrds {
            if(!firstFilled) {
                if (n.rcrdName != "" && n.isFollowing == true) {
                    oneRcrdText.text = n.rcrdName
                    if (n.rcrdValuesArray.count > 0) {
                        oneValueText.text = String(n.rcrdValuesArray[n.rcrdValuesArray.count-1])
                        oneAverageValue.text = String(yourRcrds.calcAverageHelper(n.rcrdValuesArray))
                        oneBestValue.text = String(yourRcrds.calcHighestHelper(n.rcrdValuesArray))
                    }
                    firstFilled = true
                    self.view.viewWithTag(2)!.isHidden = false
                }
            }
            else {
                if (n.rcrdName != "" && n.isFollowing == true) {
                    twoRcrdText.text = n.rcrdName
                    if (n.rcrdValuesArray.count > 0) {
                        twoValueText.text = String(n.rcrdValuesArray[n.rcrdValuesArray.count-1])
                        twoAverageValue.text = String(yourRcrds.calcAverageHelper(n.rcrdValuesArray))
                        twoBestValue.text = String(yourRcrds.calcHighestHelper(n.rcrdValuesArray))
                    }
                    self.view.viewWithTag(3)!.isHidden = false
                }
            }
        }
    }
    
    
}
