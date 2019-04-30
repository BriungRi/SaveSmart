//
//  NewExpenseViewController.swift
//  SaveSmart
//
//  Created by Brian Li on 4/13/19.
//  Copyright © 2019 Brian Li. All rights reserved.
//

import UIKit
import RealmSwift

class FilterExpenseViewController: UIViewController  {
    
    // MARK: Instance vars
    var sortFunctionIdx = 0
    var filterBudgetName: String = GlobalData.allBudgetsName
    let sortByPickerDelegate = SortByPickerDelegate()
    let filterByPickerDelegate = BudgetFilterPickerDelegate()
    
    // MARK: Outlets
    @IBOutlet weak var sortByPickerView: UIPickerView!
    @IBOutlet weak var budgetPickerView: UIPickerView!
    
    @IBAction func onCancelPress(_ sender: Any) {
        dismiss(animated: true , completion: nil)
    }
    @IBAction func onSavePress(_ sender: Any) {
        sortFunctionIdx = sortByPickerDelegate.selectedSortIdx
        filterBudgetName = filterByPickerDelegate.selectedFilterName
        performSegue(withIdentifier: "unwindToExpenseListFromFilter", sender: self)
    }
    
    // MARK: UIViewController Methods
    
    override func viewDidLoad() {
        sortByPickerDelegate.selectedSortIdx = sortFunctionIdx
        self.sortByPickerView.delegate = sortByPickerDelegate
        self.sortByPickerView.dataSource = sortByPickerDelegate
        self.sortByPickerView.selectRow(sortFunctionIdx, inComponent: 0, animated: false)
        
        let filterOptionIdx = filterByPickerDelegate.getRowBy(optionName: filterBudgetName)
        filterByPickerDelegate.selectedOptionIdx = filterOptionIdx
        self.budgetPickerView.delegate = filterByPickerDelegate
        self.budgetPickerView.dataSource = filterByPickerDelegate
        self.budgetPickerView.selectRow(filterOptionIdx, inComponent: 0, animated: false)
    }
}

class SortByPickerDelegate: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    // MARK: UIPickerView methods
    var selectedSortIdx = 0
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return GlobalData.sorts.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow: Int, forComponent: Int) -> String? {
        return GlobalData.sorts[titleForRow].0
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedSortIdx = row
    }
}

class BudgetFilterPickerDelegate: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    var options = [GlobalData.allBudgetsName] + GlobalData.budgets.map({$0.budgetName})
    var selectedFilterName: String {
        return options[selectedOptionIdx]
    }
    var selectedOptionIdx = 0
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return options.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow: Int, forComponent: Int) -> String? {
        return options[titleForRow]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedOptionIdx = row
    }
    
    func getRowBy(optionName: String) -> Int {
        for i in 0..<options.count {
            if options[i] == optionName {
                return i
            }
        }
        return -1
    }
}
