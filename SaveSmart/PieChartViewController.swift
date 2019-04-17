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
    
    var expenseEntry = PieChartDataEntry(value: 0)
    var budgetEntry = PieChartDataEntry(value: 0)
    
    
    var numEntries = [PieChartDataEntry]()
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("View did appear")
        updatePieChartData()
    }
    
    func updatePieChartData() {
        var budgetTot = 0.0
        var expenseTot = 0.0
        for budgData in GlobalData.budgets {
            budgetTot += budgData.budgetTotal
        }
        
        for expsData in GlobalData.expenses {
            expenseTot += expsData.expenseAmount
        }
        //pieChartView.chartDescription?.text = "Total Budget vs. Total Expense"
        budgetEntry = PieChartDataEntry(value: budgetTot)
        expenseEntry = PieChartDataEntry(value: expenseTot)
        budgetEntry.label = "Budget"
        expenseEntry.label = "Expense"
        numEntries = [budgetEntry, expenseEntry]
        
        let pieChartDataSet = PieChartDataSet(entries: numEntries, label: "")
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        pieChartDataSet.colors = [NSUIColor.blue, NSUIColor.red]
        pieChartView.data = pieChartData
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
