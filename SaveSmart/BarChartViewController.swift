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

    var selectedBudget = GlobalData.budgets[0]
    
    @IBOutlet weak var barChartView: BarChartView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var pickerView: UIPickerView!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateBarChartData()
        barChartView.rightAxis.enabled = false
    }
    
    
    func updateBarChartData() {
        let dataEntries = [BarChartDataEntry(x: 0, y: selectedBudget.expenseTotal)]
        
        barChartView.leftAxis.removeAllLimitLines()
        barChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: [selectedBudget.budgetName])
        let chartDataSet = BarChartDataSet(dataEntries)
        let chartData = BarChartData(dataSet: chartDataSet)
        chartDataSet.colors = ChartColorTemplates.joyful()
        chartDataSet.label? = "\(selectedBudget.budgetName) Budget"
        barChartView.data = chartData
        let ll = ChartLimitLine(limit: selectedBudget.budgetTotal, label: "Limit: $\(selectedBudget.budgetTotal)")
        ll.lineColor = NSUIColor.red
        barChartView.leftAxis.addLimitLine(ll)
        barChartView.xAxis.granularity = 1
        barChartView.xAxis.granularityEnabled = true
        barChartView.xAxis.labelCount = GlobalData.budgets.count;
        barChartView.leftAxis.axisMinimum = 0
        barChartView.leftAxis.axisMaximum = max(selectedBudget.budgetTotal, selectedBudget.expenseTotal) * 1.1
    }
    
    @IBAction func unwindToBarChart(segue:UIStoryboardSegue) {
        if segue.source is BudgetSelectionViewController{
            let vc = segue.source as! BudgetSelectionViewController
            selectedBudget = vc.selectedBudget
            updateBarChartData()
        }
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
