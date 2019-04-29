//
//  NewExpenseViewController.swift
//  SaveSmart
//
//  Created by Brian Li on 4/13/19.
//  Copyright © 2019 Brian Li. All rights reserved.
//

import UIKit

class BudgetSelectionViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // MARK: Instance vars
    
    var selectedBudgetIdx: Int = 0
    var selectedBudget: Budget {
        return GlobalData.budgets[selectedBudgetIdx]
    }
    
    // MARK: Outlets
    @IBOutlet weak var budgetPickerView: UIPickerView!
    
    
    @IBAction func onCancelPress(_ sender: Any) {
        dismiss(animated: true , completion: nil)
    }
    @IBAction func onSavePress(_ sender: Any) {
        performSegue(withIdentifier: "unwindToBarChart", sender: self)
    }
    
    // MARK: UIViewController Methods
    
    override func viewDidLoad() {
        self.budgetPickerView.delegate = self
        self.budgetPickerView.dataSource = self
        self.budgetPickerView.selectRow(selectedBudgetIdx, inComponent: 0, animated: false)
    }
    
    // MARK: UIPickerView methods
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return GlobalData.budgets.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow: Int, forComponent: Int) -> String? {
        return GlobalData.budgets[titleForRow].budgetName
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedBudgetIdx = row
    }
}
