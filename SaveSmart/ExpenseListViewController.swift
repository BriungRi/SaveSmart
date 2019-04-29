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
//        addDemoData()
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
    
    func addDemoData() {
        let secondsInMonth = 2628000
        let expense1 = Expense()
        expense1.merchantName = "Skechers"
        expense1.expenseAmount = 10.99
        expense1.belongingBudget = GlobalData.budgets[0]
        expense1.dateCreated.addTimeInterval(TimeInterval(secondsInMonth))
        
        let expense2 = Expense()
        expense2.merchantName = "Canada Goose"
        expense2.expenseAmount = 1000.88
        expense2.belongingBudget = GlobalData.budgets[0]
        expense2.dateCreated.addTimeInterval(TimeInterval(secondsInMonth * 3))
        
        let expense3 = Expense()
        expense3.merchantName = "Patagonia"
        expense3.expenseAmount = 80
        expense3.belongingBudget = GlobalData.budgets[0]
        expense3.dateCreated.addTimeInterval(TimeInterval(secondsInMonth * 4))
        
        let expense4 = Expense()
        expense4.merchantName = "Cake"
        expense4.expenseAmount = 2.50
        expense4.belongingBudget = GlobalData.budgets[0]
        expense4.dateCreated.addTimeInterval(TimeInterval(secondsInMonth * 2))
        
        let expense5 = Expense()
        expense5.merchantName = "Lunas"
        expense5.expenseAmount = 8.88
        expense5.belongingBudget = GlobalData.budgets[0]
        expense5.dateCreated.addTimeInterval(TimeInterval(secondsInMonth * 3))
        
        let expense6 = Expense()
        expense6.merchantName = "Paris Baguette"
        expense6.expenseAmount = 15.72
        expense6.belongingBudget = GlobalData.budgets[0]
        expense6.dateCreated.addTimeInterval(TimeInterval(secondsInMonth * 5))
        
        let expense7 = Expense()
        expense7.merchantName = "McDonalds"
        expense7.expenseAmount = 4.96
        expense7.belongingBudget = GlobalData.budgets[0]
        
        let expense8 = Expense()
        expense8.merchantName = "Brooks"
        expense8.expenseAmount = 96.00
        expense8.belongingBudget = GlobalData.budgets[0]
        
        let expenses = [expense1, expense2, expense3, expense4, expense5, expense6, expense7, expense8]
        for expense in expenses {
            addExpense(expense: expense)
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

