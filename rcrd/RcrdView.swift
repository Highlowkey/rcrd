//
//  RcrdView.swift
//  rcrd
//
//  Created by Patrick McElroy on 10/21/19.
//  Copyright © 2019 Patrick McElroy. All rights reserved.
//

import Foundation
import UIKit
import Charts


class RcrdView: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var progressChart: LineChartView!
    
    var numDisplayed: Int = 0
    
    var rcrdDisplayed: Rcrd = Rcrd("", [])
    
    var index: Int = 0

    @IBOutlet weak var oneRcrdViewText: UILabel!
    
    @IBOutlet weak var typePicker: UIPickerView!
    
    var types: [String] = ["total", "best", "average", "goal"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for n in yourRcrds.rcrds {
            if(n.rcrdName == rcrdDisplayed.rcrdName) {
                index = yourRcrds.rcrds.firstIndex(of: n)!
            }
        }
        rcrdDisplayed = yourRcrds.rcrds[index]
        oneRcrdViewText.text = rcrdDisplayed.rcrdName
        setChartValues(rcrdDisplayed.rcrdValuesArray.count)
        typePicker.delegate = self
        typePicker.dataSource = self
        self.typePicker.selectRow(types.firstIndex(of: rcrdDisplayed.rcrdType)!, inComponent: 0, animated: true)
        // Do any additional setup after loading the view.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return types.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        yourRcrds.rcrds[index].rcrdType = types[pickerView.selectedRow(inComponent: 0)]
        return types[row]
    }
    
    func setChartValues(_ count : Int = 20) {
        let values = (0..<count).map { (i) -> ChartDataEntry in
            let val = Double(rcrdDisplayed.rcrdValuesArray[i])!
            return ChartDataEntry(x: Double(i), y: val)
        }
        
        let set1 = LineChartDataSet(values: values, label: rcrdDisplayed.rcrdName)
        let data = LineChartData(dataSet: set1)
        
        set1.colors = [NSUIColor.black]
        set1.circleColors = [NSUIColor.black]
        set1.circleRadius = 5
        data.setValueTextColor(UIColor.clear)
        
        
        self.progressChart.data = data
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
    
    @IBAction func deleteSegue(_ sender: Any) {
        yourRcrds.rcrds.remove(at: index)
        let identifier: String = String(numDisplayed)
        performSegue(withIdentifier: identifier, sender: self)
    }
    
}
