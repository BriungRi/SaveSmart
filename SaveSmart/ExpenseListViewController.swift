//
//  FirstViewController.swift
//  SaveSmart
//
//  Created by Brian Li on 4/13/19.
//  Copyright © 2019 Brian Li. All rights reserved.
//

import UIKit
import RealmSwift

class ExpenseListViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editExpenseSegue" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let controller = (segue.destination as! UINavigationController).topViewController as! NewExpenseViewController
                let expenseToEdit = GlobalData.expenses[indexPath.row]
                controller.originalExpense = expenseToEdit
                controller.merchantName = expenseToEdit.merchantName
                controller.expenseAmt = "\(expenseToEdit.expenseAmount)"
                controller.belongingBudgetIdx = indexPath.row
            }
        }
    }
    
    // MARK: UITableViewController methods
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GlobalData.expenses.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let expense = GlobalData.expenses[indexPath.row]
        cell.textLabel!.text = "\(expense.formattedExpenseAmount) [\(expense.belongingBudget!.budgetName)]"
        cell.detailTextLabel!.text = "\(expense.merchantName), \(expense.dateCreated.description)"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let expenses = GlobalData.expenses
            let toDelete = expenses[indexPath.row]
            deleteExpense(expense: toDelete)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    @IBAction func unwindToExpenseList(segue:UIStoryboardSegue) {
        if segue.source is NewExpenseViewController{
            let vc = segue.source as! NewExpenseViewController
            let toAdd = vc.newExpense
            if let originalExpense = vc.originalExpense {
                updateExpense(originalExpense: originalExpense, newExpense: toAdd)
            } else {
                addExpense(expense: toAdd)
            }
            tableView.reloadData()
        }
    }
    
    @objc func refresh(sender:AnyObject) {
        tableView.reloadData()
        self.refreshControl?.endRefreshing()
    }

    // MARK: Methods
    func addExpense(expense: Expense) {
        let realm = try! Realm()
        realm.add(expense: expense)
    }
    
    func deleteExpense(expense: Expense) {
        let realm = try! Realm()
        realm.delete(expense: expense)
    }
    
    func updateExpense(originalExpense: Expense, newExpense: Expense) {
        let realm = try! Realm()
        realm.update(originalExpense: originalExpense, newExpense: newExpense)
    }
}

