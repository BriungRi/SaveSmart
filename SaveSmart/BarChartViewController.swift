//
//  BarChartViewController.swift
//  SaveSmart
//
//  Created by Arbaz Ahmed on 4/28/19.
//  Copyright © 2019 Brian Li. All rights reserved.
//

import UIKit
import Charts

class BarChartViewController: UIViewController {
    

    @IBOutlet weak var barChartView: BarChartView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var pickerView: UIPickerView!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("View did appear")
        updateBarChartData()
    }
    
    
    func updateBarChartData() {
        var budgets = [String]()
        print(budgets)
        var i = 0
        var budgetTot = [Double]()
        for budget in GlobalData.budgets {
            let budgetName = budget.budgetName
            budgets.append(budgetName)
            budgetTot.append(budget.budgetTotal)
            print(budgets)
            print(budgetTot)
            i+=1
        }
        
        
        
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<budgets.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: budgetTot[i])
            dataEntries.append(dataEntry)
        }
        
        barChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: budgets)
        let chartDataSet = BarChartDataSet(dataEntries)
        let chartData = BarChartData(dataSet: chartDataSet)
        chartDataSet.colors = ChartColorTemplates.joyful()
        chartDataSet.label? = "Budget Per Category"
        barChartView.data = chartData
        let ll = ChartLimitLine(limit: 1000, label: "Limit: $1000")
        ll.lineColor = NSUIColor.brown
        barChartView.rightAxis.addLimitLine(ll)
        barChartView.xAxis.granularity = 1
        barChartView.xAxis.granularityEnabled = true
        barChartView.xAxis.labelCount = budgets.count;
        barChartView.animate(xAxisDuration:   1.0, yAxisDuration: 1.0, easingOption: .easeInBounce)
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
