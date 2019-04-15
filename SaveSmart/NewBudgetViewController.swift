//
//  NewBudgetViewController.swift
//  SaveSmart
//
//  Created by Brian Li on 4/13/19.
//  Copyright © 2019 Brian Li. All rights reserved.
//

import UIKit
import RealmSwift

class NewBudgetViewController: UIViewController {
    
    // MARK: Instance Vars
    var originalBudget: Budget? = nil
    var budgetName: String = ""
    var budgetAmt: String = ""
    var newBudget: Budget {
        let resBudget = Budget()
        resBudget.budgetName = budgetName
        resBudget.budgetTotal = Double(budgetAmt)!
        return resBudget
    }
    
    // MARK: Outlets
    @IBOutlet weak var budgetNameTF: UITextField!
    @IBOutlet weak var budgetAmtTF: UITextField!
    
    // MARK: UIViewController Methods
    override func viewDidLoad() {
        budgetNameTF.text = budgetName
        budgetAmtTF.text = budgetAmt
    }
    
    // MARK: Actions
    @IBAction func onBudgetNameEdit(_ sender: Any) {
        budgetName = budgetNameTF.text ?? ""
    }
    @IBAction func onBudgetAmtEdit(_ sender: Any) {
        budgetAmt = budgetAmtTF.text ?? ""
    }
    @IBAction func onCancelPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func onSavePress(_ sender: Any) {
        if originalBudget == nil &&
            GlobalData.budgets.filter({(budget) -> Bool in budget.budgetName == budgetName}).count > 0 {
            showDuplicateBudgetAlert()
        } else if budgetAmt.doubleValue == nil {
            showNaNAlert()
        } else {
            performSegue(withIdentifier: "unwindToBudgetList", sender: self)
        }
    }
    
    // MARK: Methods
    func showDuplicateBudgetAlert() {
        displayErrorAlert(errorMessage: "Budget Name Already Exists")
    }
    
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
