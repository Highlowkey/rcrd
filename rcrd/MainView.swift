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
import Firebase

class MainView: UIViewController {
    
    var inputArray: [String] = []
    
    var numRcrds: Int = 2
    
    var ref: DatabaseReference!
    
    var user: String = "Patrick McElroy"
    
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
        ref = Database.database().reference()
        doReloadView()
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: NSNotification.Name(rawValue: "refresh"), object: nil)

    }
    
    @objc func refresh(notification: NSNotification) {
        print("Refreshing...")
        doReloadView()
        //saveRcrds()
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
            if let text = valueText.text {
                if Double(text) != nil {
                    ref.child("Patrick McElroy").child("rcrds").child(rcrdText.text!).child("values").childByAutoId().setValue(valueText.text!)
                }
            }
            ref.child("Patrick McElroy").child("rcrds").child(rcrdText.text!).child("type").setValue("best")
            ref.child("Patrick McElroy").child("rcrds").child(rcrdText.text!).child("following").setValue(true)
            
            rcrdText.text!.removeAll()
            valueText.text!.removeAll()
            self.view.endEditing(true)
            doReloadView()
        }
    }
    
    //rcrdView segue management
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "oneSegue") {
            let destination = segue.destination as! RcrdView
            destination.numDisplayed = 1
//            destination.rcrdDisplayed = yourRcrds.findRcrd(oneRcrdText.text!, user, ref)
        }
        if(segue.identifier == "twoSegue") {
            let destination = segue.destination as! RcrdView
            destination.numDisplayed = 2
            destination.rcrdName = twoRcrdText.text!
        }
    }
    
    @IBAction func unwindAfterDelete(segue:UIStoryboardSegue) {
        //saveRcrds()
        doReloadView()
    }
    
    //accountView segue management
    
    @IBAction func accountSegue(_ sender: Any) {
        performSegue(withIdentifier: "accountSegue", sender: self)
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
        ref.child("Patrick McElroy").child("rcrds").observeSingleEvent(of: .value, with: {(snapshot) in
            for rcrd in snapshot.children.allObjects as! [DataSnapshot] {
                let rcrdName = rcrd.key
                let rcrdType = rcrd.childSnapshot(forPath: "type").value
                let isFollowing = rcrd.childSnapshot(forPath: "following").value
                var rcrdValuesArray: [String] = []
                if (rcrd.childSnapshot(forPath: "values").childrenCount > 0) {
                    for value in rcrd.childSnapshot(forPath: "values").children.allObjects as! [DataSnapshot] {
                        rcrdValuesArray.append(value.value as! String)
                    }
                }
                if(!firstFilled) {
                    if (rcrdName != "" && isFollowing as! Bool == true) {
                        self.oneRcrdText.text = rcrdName
                        if (rcrdValuesArray.count > 0) {
                            self.oneValueText.text = String(rcrdValuesArray[rcrdValuesArray.count-1])
                            self.oneAverageValue.text = String(yourRcrds.calcAverageHelper(rcrdValuesArray))
                            self.oneBestValue.text = String(yourRcrds.calcHighestHelper(rcrdValuesArray))
                        }
                        firstFilled = true
                        self.view.viewWithTag(2)!.isHidden = false
                    }
                }
                else {
                    if (rcrdName != "" && isFollowing as! Bool == true) {
                        self.twoRcrdText.text = rcrdName
                        if (rcrdValuesArray.count > 0) {
                            self.twoValueText.text = String(rcrdValuesArray[rcrdValuesArray.count-1])
                            self.twoAverageValue.text = String(yourRcrds.calcAverageHelper(rcrdValuesArray))
                            self.twoBestValue.text = String(yourRcrds.calcHighestHelper(rcrdValuesArray))
                        }
                        self.view.viewWithTag(3)!.isHidden = false
                    }
                }
            }
        })
    }
    
    
}
