//
//  FirstViewController.swift
//  SaveSmart
//
//  Created by Brian Li on 4/13/19.
//  Copyright © 2019 Brian Li. All rights reserved.
//

import UIKit
import RealmSwift

class BudgetListViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if GlobalData.budgets.isEmpty {
            let realm = try! Realm()
            realm.addUncategorizedBudget()
        }
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editBudgetSegue" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let controller = (segue.destination as! UINavigationController).topViewController as! NewBudgetViewController
                let budgetToEdit = GlobalData.budgets[indexPath.row]
                controller.originalBudget = budgetToEdit
                controller.budgetName = budgetToEdit.budgetName
                controller.budgetAmt = "\(budgetToEdit.budgetTotal)"
            }
        }
    }
    
    // MARK: UITableViewController methods

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GlobalData.budgets.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let budget = GlobalData.budgets[indexPath.row]
        cell.textLabel!.text = budget.budgetName
        cell.detailTextLabel!.text = "\(budget.formattedExpenseTotal) / \(budget.formattedBudgetTotal)"
        if budget.expenseTotal == budget.budgetTotal {
            cell.backgroundColor = UIColor .yellow
        } else if budget.expenseTotal < budget.budgetTotal {
            cell.backgroundColor = UIColor .green
        } else {
            cell.backgroundColor = UIColor .red
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return indexPath.row > 0
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete && indexPath.row > 0 {
            let budgets = GlobalData.budgets
            let toDelete = budgets[indexPath.row]
            deleteBudget(budget: toDelete)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        tableView.reloadData()
    }
    
    @IBAction func unwindToBudgetList(segue:UIStoryboardSegue) {
        if segue.source is NewBudgetViewController {
            let vc = segue.source as! NewBudgetViewController
            let toAdd = vc.newBudget
            if let originalBudget = vc.originalBudget {
                updateBudget(originalBudget: originalBudget, newBudget: toAdd)
            } else {
                addBudget(budget: toAdd)
            }
            tableView.reloadData()
        }
    }
    
    @objc func refresh(sender:AnyObject) {
        tableView.reloadData()
        self.refreshControl?.endRefreshing()
    }
    
    // MARK: Methods
    
    func addBudget(budget: Budget) {
        let realm = try! Realm()
        realm.add(budget: budget)
    }
    
    func deleteBudget(budget: Budget) {
        let realm = try! Realm()
        realm.delete(budget: budget)
    }
    
    func updateBudget(originalBudget: Budget, newBudget: Budget) {
        let realm = try! Realm()
        realm.update(originalBudget: originalBudget, newBudget: newBudget)
    }
}
