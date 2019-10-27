//
//  OneRkrdView.swift
//  rkrd
//
//  Created by Patrick McElroy on 10/21/19.
//  Copyright © 2019 Patrick McElroy. All rights reserved.
//

import Foundation
import UIKit
import Charts


class OneRkrdView: MainRkrdView {
    
    @IBOutlet weak var progressChart: LineChartView!
    
    var numRkrd: Int = 0
    
    var rkrdName: String?
    
    var localValuesArray: [String] = []
    
    
    @IBOutlet weak var oneRkrdViewText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        oneRkrdViewText.text = rkrdName
        setChartValues(localValuesArray.count)
        // Do any additional setup after loading the view.
    }
    
    func setChartValues(_ count : Int = 20) {
        let values = (0..<count).map { (i) -> ChartDataEntry in
            let val = Double(localValuesArray[i])!
            return ChartDataEntry(x: Double(i), y: val)
        }
        
        let set1 = LineChartDataSet(values: values, label: rkrdName)
        let data = LineChartData(dataSet: set1)
        
        set1.colors = [NSUIColor.black]
        set1.circleColors = [NSUIColor.black]
        set1.circleRadius = 5
        data.setValueTextColor(UIColor.clear)
        
        
        self.progressChart.data = data
    }
    
    @IBAction func deleteRkrd(_ sender: Any) {
        dismiss(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! MainRkrdView
        destination.view.viewWithTag(numRkrd + 2)?.isHidden = true
        destination.rkrds[numRkrd] = Rkrd("", [])
    }
    
}
