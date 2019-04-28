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
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("View did appear")
        updateLineChartData()
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
        var expenseTot = 0.0
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
        for expsData in GlobalData.expenses {
            if(expsData.dateCreated.monthAsString() == "Jan") {
                expenseTot += expsData.expenseAmount
                jan = expenseTot
            }
            if(expsData.dateCreated.monthAsString() == "Feb") {
                expenseTot += expsData.expenseAmount
                feb = expenseTot
            }
            if(expsData.dateCreated.monthAsString() == "Mar") {
                expenseTot += expsData.expenseAmount
                mar = expenseTot
            }
            if(expsData.dateCreated.monthAsString() == "Apr") {
                expenseTot += expsData.expenseAmount
                apr = expenseTot
            }
            if(expsData.dateCreated.monthAsString() == "May") {
                expenseTot += expsData.expenseAmount
                may = expenseTot
            }
            if(expsData.dateCreated.monthAsString() == "Jun") {
                expenseTot += expsData.expenseAmount
                june = expenseTot
            }
            if(expsData.dateCreated.monthAsString() == "Jul") {
                expenseTot += expsData.expenseAmount
                july = expenseTot
            }
            if(expsData.dateCreated.monthAsString() == "Aug") {
                expenseTot += expsData.expenseAmount
                aug = expenseTot
            }
            if(expsData.dateCreated.monthAsString() == "Sep") {
                expenseTot += expsData.expenseAmount
                sept = expenseTot
            }
            if(expsData.dateCreated.monthAsString() == "Oct") {
                expenseTot += expsData.expenseAmount
                oct = expenseTot
            }
            if(expsData.dateCreated.monthAsString() == "Nov") {
                expenseTot += expsData.expenseAmount
                nov = expenseTot
            }
            if(expsData.dateCreated.monthAsString() == "Dec") {
                expenseTot += expsData.expenseAmount
                dec = expenseTot
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
        let lineChartDataSet = LineChartDataSet(entries: dataEntries, label: "Expenses Per Month")
        let lineChartData = LineChartData(dataSet: lineChartDataSet)
        lineChartDataSet.colors = ChartColorTemplates.joyful()
        lineChartDataSet.colors = [NSUIColor.magenta]
        lineChartView.data = lineChartData
        // set axis labels to be visible
        lineChartView.xAxis.granularity = 1
        lineChartView.xAxis.granularityEnabled = true
        lineChartView.xAxis.labelCount = months.count;
        lineChartView.animate(xAxisDuration: 1.0, yAxisDuration: 1.0, easingOption: .easeInBounce)
    }
}

