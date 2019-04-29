//
//  PieChartViewController.swift
//  SaveSmart
//
//  Created by Arbaz Ahmed on 4/17/19.
//  Copyright © 2019 Brian Li. All rights reserved.
//

import UIKit
import Charts

class PieChartViewController: UIViewController {

    @IBOutlet weak var pieChartView: PieChartView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    var numEntries = [PieChartDataEntry]()
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updatePieChartData()
    }
    
    func updatePieChartData() {
        var budgetTot = 0.0
        var expenseTot = 0.0
        
        // get total budget
        for budgData in GlobalData.budgets {
            budgetTot += budgData.budgetTotal
        }
        
        // get total expense
        for expsData in GlobalData.expenses {
            expenseTot += expsData.expenseAmount
        }
        
        let budgetEntry = PieChartDataEntry(value: budgetTot)
        let remainderEntry = PieChartDataEntry(value: max(budgetTot - expenseTot, 0))
        budgetEntry.label = "Expenses"
        remainderEntry.label = "Remaining Budget"
        numEntries = [budgetEntry, remainderEntry]
        
        let pieChartDataSet = PieChartDataSet(entries: numEntries, label: "")
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        pieChartDataSet.colors = ChartColorTemplates.joyful()
        pieChartView.data = pieChartData
        pieChartView.chartDescription?.text = "Total Budget vs. Total Expense"
        pieChartView.animate(xAxisDuration: 1.0, yAxisDuration: 1.0, easingOption: .easeInElastic)
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
