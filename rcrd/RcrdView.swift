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


class RcrdView: UIViewController {
    
    @IBOutlet weak var progressChart: LineChartView!
    
    var numRcrd: Int = 0
    
    var rcrdDisplayed: Rcrd = Rcrd("", [])

    @IBOutlet weak var oneRcrdViewText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rcrdDisplayed = yourRcrds.rcrds[numRcrd]
        oneRcrdViewText.text = rcrdDisplayed.rcrdName
        setChartValues(rcrdDisplayed.rcrdValuesArray.count)
        // Do any additional setup after loading the view.
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
        yourRcrds.rcrds[numRcrd].rcrdName = ""
        yourRcrds.rcrds[numRcrd].rcrdValuesArray = []
        let identifier: String = String(numRcrd)
        performSegue(withIdentifier: identifier, sender: self)
    }
    
}
