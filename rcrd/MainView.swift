//
//  MainView.swift
//  rcrd
//
//  Created by user on 6/18/19.
//  Copyright © 2019 user. All rights reserved.
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
    
    var user: String = UIDevice.current.identifierForVendor!.uuidString
    
    var addingNew: Bool = false
    
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
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: NSNotification.Name(rawValue: "refresh"), object: nil)
        yourRcrds.rcrds.removeAll()
        self.view.viewWithTag(2)!.alpha = 0
        self.view.viewWithTag(3)!.alpha = 0
        ref.child(user).child("name").observeSingleEvent(of: .value, with: {(snapshot) in
            if(snapshot.exists()) {
                yourRcrds.accountName = snapshot.value as! String
            }
        })
        ref.child(user).child("rcrds").observeSingleEvent(of: .value, with: {(snapshot) in
            for rcrd in snapshot.children.allObjects as! [DataSnapshot] {
                let rcrdName = rcrd.key
                let rcrdType = rcrd.childSnapshot(forPath: "type").value as! String
                let isFollowing = rcrd.childSnapshot(forPath: "following").value as! Bool
                var rcrdValuesArray: [String] = []
                if (rcrd.childSnapshot(forPath: "values").childrenCount > 0) {
                    for value in rcrd.childSnapshot(forPath: "values").children.allObjects as! [DataSnapshot] {
                        rcrdValuesArray.append(value.value as! String)
                        }
                }
                yourRcrds.rcrds.append(Rcrd(rcrdName, rcrdValuesArray, isFollowing, rcrdType))
                self.doReloadView()
            }
        })
    }
    
    @objc func refresh(notification: NSNotification) {
        print("Refreshing...")
        doReloadView()
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
    
    //updating your rcrds after adding
    
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
            updateFirebase()
            doReloadView()
        }
    }
    
    //update firebase
    
    func updateFirebase() {
        for n in yourRcrds.rcrds {
            ref.child(user).child("rcrds").child(n.rcrdName).child("type").setValue(n.rcrdType)
            ref.child(user).child("rcrds").child(n.rcrdName).child("following").setValue(n.isFollowing)
            ref.child(user).child("rcrds").child(n.rcrdName).child("values").removeValue()
            for a in n.rcrdValuesArray {
                ref.child(user).child("rcrds").child(n.rcrdName).child("values").childByAutoId().setValue(a)
            }
        }
    }
    
    //rcrdView segue management
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "oneSegue") {
            let destination = segue.destination as! RcrdView
            destination.numDisplayed = 1
            destination.rcrdDisplayed = yourRcrds.findRcrd(name: oneRcrdText.text!)
        }
        if(segue.identifier == "twoSegue") {
            let destination = segue.destination as! RcrdView
            destination.numDisplayed = 2
            destination.rcrdDisplayed = yourRcrds.findRcrd(name: twoRcrdText.text!)
        }
        if(segue.identifier == "listSegue") {
            let destination = segue.destination as! RcrdList
            destination.rcrdArray = yourRcrds.rcrds
        }
    }
    
    @IBAction func unwindAfterDelete(segue:UIStoryboardSegue) {
        doReloadView()
    }
    
    //accountView segue management
    
    @IBAction func accountSegue(_ sender: Any) {
        performSegue(withIdentifier: "accountSegue", sender: self)
    }
    
    @IBAction func listSegue(_ sender: Any) {
        performSegue(withIdentifier: "listSegue", sender: self)
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
                UIView.animate(withDuration: 1, animations: {
                    self.view.viewWithTag(2)!.alpha = 1
                }, completion:  nil)
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
                self.view.viewWithTag(3)!.isHidden = false
                UIView.animate(withDuration: 1, animations: {
                    self.view.viewWithTag(3)!.alpha = 1
                }, completion:  nil)
                }
        }
    }
    
}
