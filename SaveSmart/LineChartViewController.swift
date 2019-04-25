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
    func updateLineChartData() {
        var expenses = 0.0
        var i = 0.0
        for expense in GlobalData.expenses {
            expenses = expense.expenseAmount
            let value = ChartDataEntry(x: i, y: expenses)
            lineChartEntry.append(value)
            i += 1
        }
        let line1 = LineChartDataSet(entries: lineChartEntry, label: "Expenses over time")
        line1.colors = [NSUIColor.red]
        let data = LineChartData()
        
        data.addDataSet(line1)
        lineChartView.data = data
    }
}
