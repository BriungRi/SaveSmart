//
//  SecondViewController.swift
//  SaveSmart
//
//  Created by Brian Li on 4/13/19.
//  Copyright © 2019 Brian Li. All rights reserved.
//

import UIKit
import Charts

class SecondViewController: UIViewController {

    @IBOutlet weak var pieChartView: PieChartView!
    
    @IBOutlet weak var lineChartView: LineChartView!
    
    
    var expenseEntry = PieChartDataEntry(value: 0)
    var budgetEntry = PieChartDataEntry(value: 0)

    
    var numEntries = [PieChartDataEntry]()
    var lineChartEntry = [ChartDataEntry]()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    
        print("View did appear")
        updatePieChartData()
        updateLineChartData()
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
        pieChartView.chartDescription?.text = "Total Budget vs. Total Expense"
        budgetEntry.label = "Budget"
        expenseEntry.label = "Expense"
        
        budgetEntry = PieChartDataEntry(value: budgetTot)
        expenseEntry = PieChartDataEntry(value: expenseTot)
        numEntries = [budgetEntry, expenseEntry]
        let pieChartDataSet = PieChartDataSet(entries: numEntries, label: nil)
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        
        pieChartDataSet.colors = [NSUIColor.green, NSUIColor.red]
        pieChartView.data = pieChartData
    }

    func updateLineChartData() {
        var expenses = 0.0
        var i = 0.0
        for expense in GlobalData.expenses {
            expenses = expense.expenseAmount
            let value = ChartDataEntry(x: i, y: expenses)
            lineChartEntry.append(value)
            i += 1
        }
        let line1 = LineChartDataSet(entries: lineChartEntry, label: "Expenses")
        line1.colors = [NSUIColor.red]
        let data = LineChartData()
        
        data.addDataSet(line1)
        lineChartView.data = data
        lineChartView.chartDescription?.text = "Expenses Over Time"
    }

}

