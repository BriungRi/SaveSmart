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
    
    var selectedBudget = GlobalData.budgets[0]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updatePieChartData()
    }
    
    func updatePieChartData() {
        let expensesEntry = PieChartDataEntry(value: (selectedBudget.expenseTotal / selectedBudget.budgetTotal) * 100)
        let remainderEntry = PieChartDataEntry(value: (max(selectedBudget.budgetTotal - selectedBudget.expenseTotal, 0) / selectedBudget.budgetTotal) * 100)
        
        let entries = [expensesEntry, remainderEntry]
        expensesEntry.label = "Expenses %"
        remainderEntry.label = "Remainder %"
        
        let pieChartDataSet = PieChartDataSet(entries: entries, label: "")
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        pieChartDataSet.colors = [CustomColors.red, CustomColors.green]
        pieChartView.data = pieChartData
        pieChartView.centerText = "\(selectedBudget.budgetName) budget"
        DispatchQueue.main.async(execute: {() -> Void in
            self.pieChartView.animate(xAxisDuration: 1.75, yAxisDuration: 1.75, easingOption: .easeInBack)
        })
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func unwindToPieChart(segue:UIStoryboardSegue) {
        if segue.source is PieChartSelectionViewController{
            let vc = segue.source as! PieChartSelectionViewController
            selectedBudget = vc.selectedBudget
            print(selectedBudget.budgetName)
            updatePieChartData()
        }
    }

}
