//
//  LineChartViewController.swift
//  SaveSmart
//
//  Created by Arbaz Ahmed on 4/17/19.
//  Copyright © 2019 Brian Li. All rights reserved.
//

import UIKit
import Charts

class LineChartViewController: UIViewController {

    @IBOutlet weak var lineChartView: LineChartView!
    
    var selectedBudget = GlobalData.budgets[0]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateLineChartData()
        lineChartView.rightAxis.enabled = false
    }
    
    
     var lineChartEntry = [ChartDataEntry]()

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    var months = ["Jan", "Feb", "Mar","Apr","May","June","July","Aug","Sept","Oct","Nov","Dec"]
    
    func updateLineChartData() {
        // entries for array
        var jan = 0.0
        var feb = 0.0
        var mar = 0.0
        var apr = 0.0
        var may = 0.0
        var june = 0.0
        var july = 0.0
        var aug = 0.0
        var sept = 0.0
        var oct = 0.0
        var nov = 0.0
        var dec = 0.0
        var dataEntries: [ChartDataEntry] = []
        // get monthly total expense
        print(selectedBudget.budgetName)
        for expsData in GlobalData.expenses {
        if(expsData.belongingBudget?.budgetName == selectedBudget.budgetName) {
            if(expsData.dateCreated.monthAsString() == "Jan" &&
                expsData.dateCreated.years(from: Date()) == 0) {
                jan = expsData.expenseAmount
            }
            if(expsData.dateCreated.monthAsString() == "Feb" &&
                expsData.dateCreated.years(from: Date()) == 0) {
                feb = expsData.expenseAmount
            }
            if(expsData.dateCreated.monthAsString() == "Mar" &&
                expsData.dateCreated.years(from: Date()) == 0) {
                mar = expsData.expenseAmount
            }
            if(expsData.dateCreated.monthAsString() == "Apr" &&
                expsData.dateCreated.years(from: Date()) == 0) {
                apr = expsData.expenseAmount
            }
            if(expsData.dateCreated.monthAsString() == "May" &&
                expsData.dateCreated.years(from: Date()) == 0) {
                may = expsData.expenseAmount
            }
            if(expsData.dateCreated.monthAsString() == "Jun" &&
                expsData.dateCreated.years(from: Date()) == 0) {
                june = expsData.expenseAmount
            }
            if(expsData.dateCreated.monthAsString() == "Jul" &&
                expsData.dateCreated.years(from: Date()) == 0) {
                july = expsData.expenseAmount
            }
            if(expsData.dateCreated.monthAsString() == "Aug" &&
                expsData.dateCreated.years(from: Date()) == 0) {
                aug = expsData.expenseAmount
            }
            if(expsData.dateCreated.monthAsString() == "Sep" &&
                expsData.dateCreated.years(from: Date()) == 0) {
                sept = expsData.expenseAmount
            }
            if(expsData.dateCreated.monthAsString() == "Oct" &&
                expsData.dateCreated.years(from: Date()) == 0) {
                oct = expsData.expenseAmount
            }
            if(expsData.dateCreated.monthAsString() == "Nov" &&
                expsData.dateCreated.years(from: Date()) == 0) {
                nov = expsData.expenseAmount
            }
            if(expsData.dateCreated.monthAsString() == "Dec" &&
                expsData.dateCreated.years(from: Date()) == 0) {
                dec = expsData.expenseAmount
            }
            }
        }
        
        // add expenses per month to array
        var expenseValues = [jan,feb,mar,apr,may,june,july,aug,sept,oct,nov,dec]
        
        // add the values to the chart
        for i in 0..<months.count{
            let dataEntry = ChartDataEntry(x: Double(i), y: expenseValues[i])
            dataEntries.append(dataEntry)
        }
        // add x-axis label for months
        lineChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: months)
        lineChartView.xAxis.granularity = 1
        let lineChartDataSet = LineChartDataSet(entries: dataEntries, label: "\(selectedBudget.budgetName) budget")
        let lineChartData = LineChartData(dataSet: lineChartDataSet)
        lineChartDataSet.colors = ChartColorTemplates.joyful()
        lineChartDataSet.colors = [NSUIColor.magenta]
        lineChartView.data = lineChartData
        // set axis labels to be visible
        lineChartView.fitScreen()
        lineChartView.xAxis.granularity = 1
        lineChartView.xAxis.granularityEnabled = true
        lineChartView.xAxis.labelCount = months.count;
        DispatchQueue.main.async(execute: {() -> Void in
            self.lineChartView.animate(xAxisDuration: 1.75, yAxisDuration: 1.75, easingOption: .easeInOutBack)
        })
    }
    
    
    @IBAction func unwindToLineChart(segue:UIStoryboardSegue) {
        if segue.source is LineChartSelectionViewController{
            let vc = segue.source as! LineChartSelectionViewController
            selectedBudget = vc.selectedBudget
            updateLineChartData()
        }
    }
}

