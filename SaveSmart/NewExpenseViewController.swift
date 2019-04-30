//
//  NewExpenseViewController.swift
//  SaveSmart
//
//  Created by Brian Li on 4/13/19.
//  Copyright © 2019 Brian Li. All rights reserved.
//

import UIKit
import RealmSwift

class NewExpenseViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // MARK: Instance vars
    var originalExpense: Expense? = nil
    var merchantName: String = ""
    var expenseAmt: String = ""
    var belongingBudgetIdx: Int = 0
    var belongingBudget: Budget {
        return GlobalData.budgets[belongingBudgetIdx]
    }
    var newExpense: Expense {
        let resExpense = Expense()
        resExpense.merchantName = merchantName
        resExpense.expenseAmount = Double(expenseAmt)!
        resExpense.belongingBudget = belongingBudget
        return resExpense
    }
    
    // MARK: Outlets
    @IBOutlet weak var merchantNameTF: UITextField!
    @IBOutlet weak var expenseAmtTF: UITextField!
    @IBOutlet weak var budgetPickerView: UIPickerView!
    
    // MARK: Actions
    @IBAction func onMerchantNameEdit(_ sender: Any) {
        merchantName = merchantNameTF.text ?? ""
    }
    @IBAction func onExpenseAmtEdit(_ sender: Any) {
        expenseAmt = expenseAmtTF.text ?? ""
    }
    @IBAction func onCancelPress(_ sender: Any) {
        dismiss(animated: true , completion: nil)
    }
    @IBAction func onSavePress(_ sender: Any) {
        if expenseAmt.doubleValue == nil {
            showNaNAlert()
        } else {
            performSegue(withIdentifier: "unwindToExpenseListFromNewExpense", sender: self)
        }
    }
    
    // MARK: UIViewController Methods
    
    override func viewDidLoad() {
        self.budgetPickerView.delegate = self
        self.budgetPickerView.dataSource = self
        merchantNameTF.text = merchantName
        expenseAmtTF.text = expenseAmt
        self.budgetPickerView.selectRow(belongingBudgetIdx, inComponent: 0, animated: false)
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
        belongingBudgetIdx = row
    }
    
    // MARK: Methods
    func showNaNAlert() {
        displayErrorAlert(errorMessage: "Budget Amount Not a Number")
    }
    
    func displayErrorAlert(errorMessage: String) {
        let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style{
            case .default:
                print("default")
            case .cancel:
                print("cancel")
            case .destructive:
                print("destructive")
            }}))
        self.present(alert, animated: true, completion: nil)
    }
}
