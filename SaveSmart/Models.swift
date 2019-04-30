//
//  BudgetModel.swift
//  SaveSmart
//
//  Created by Brian Li on 4/13/19.
//  Copyright © 2019 Brian Li. All rights reserved.
//

import Foundation
import RealmSwift
import Charts

class CustomColors {
    static let red = ChartColorTemplates.joyful()[0]
    static let green = NSUIColor(red: 102/255.0, green: 187/255.0, blue: 106/255.0, alpha: 1.0)
}

class GlobalData {
    static var uncategorizedBudget: Budget? {
        return cachedBudgets.first
    }
    static var cachedBudgets: [Budget] = []
    static var cachedExpenses: [Expense] = []
    static var budgetCacheInvalidated = true
    static var expenseCacheInvalidated = true
    static var budgets: [Budget] {
        if budgetCacheInvalidated {
            let realm = try! Realm()
            cachedBudgets = realm.objects(Budget.self).filter {(_) -> Bool in return true}
            budgetCacheInvalidated = false
        }
        return cachedBudgets
    }
    static var expenses: [Expense] {
        if expenseCacheInvalidated {
            let realm = try! Realm()
            cachedExpenses = realm.objects(Expense.self).filter {(_) -> Bool in return true}
            expenseCacheInvalidated = false
        }
        return cachedExpenses
    }
    static let sorts: [(String, (Expense, Expense) -> Bool)] = [("Price (Low to High)", {(expense1, expense2) -> Bool in expense1.expenseAmount < expense2.expenseAmount}), ("Price (High to Low)", {(expense1, expense2) -> Bool in expense1.expenseAmount > expense2.expenseAmount}), ("Date (Newest First)", {(expense1, expense2) -> Bool in expense1.dateCreated > expense2.dateCreated}), ("Date (Oldest First)", {(expense1, expense2) -> Bool in expense1.dateCreated < expense2.dateCreated})]
    static let allBudgetsName = "All"
}

class Budget: Object {
    @objc dynamic var budgetName: String = "Uncategorized";
    @objc dynamic var budgetTotal: Double = 0.0;
    @objc dynamic let dateCreated = Date()
    var expenseTotal: Double {
        return GlobalData.expenses
            .filter({(expense: Expense) -> Bool in
                return expense.belongingBudget?.budgetName == self.budgetName && dateCreated.monthAsString() == Date().monthAsString() &&
                dateCreated.years(from: Date()) == Date().years(from: Date())
            })
            .reduce(0, {(res: Double, expense: Expense) -> Double in
                return res + expense.expenseAmount})
    }
    var formattedBudgetTotal: String {
        return formatCurrency(value: budgetTotal)
    }
    var formattedExpenseTotal: String {
        return formatCurrency(value: expenseTotal)
    }
}

class Expense: Object {
    @objc dynamic var merchantName: String = ""
    @objc dynamic var expenseAmount: Double = 0.0
    @objc dynamic var belongingBudget: Budget? = GlobalData.uncategorizedBudget
    @objc dynamic var dateCreated = Date()
    
    var formattedExpenseAmount: String {
        return "-\(formatCurrency(value: expenseAmount))"
    }
}

func formatCurrency(value: Double) -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    return "\(formatter.string(for: value) ?? "00.00")"
}

extension String {
    struct NumFormatter {
        static let instance = NumberFormatter()
    }
    
    var doubleValue: Double? {
        return NumFormatter.instance.number(from: self)?.doubleValue
    }
    
    var integerValue: Int? {
        return NumFormatter.instance.number(from: self)?.intValue
    }
}

extension Realm {
    
    func addUncategorizedBudget() {
        try! write {
            add(create(Budget.self))
            GlobalData.budgetCacheInvalidated = true
        }
    }
    
    func add(budget: Budget) {
        try! write {
            create(Budget.self, value: [budget.budgetName, budget.budgetTotal])
            GlobalData.budgetCacheInvalidated = true
        }
    }
    
    func add(expense: Expense) {
        try! write {
            create(Expense.self, value: [expense.merchantName, expense.expenseAmount, expense.belongingBudget!, expense.dateCreated])
            GlobalData.expenseCacheInvalidated = true
        }
    }
    
    func delete(budget: Budget) {
        try! write {
            for expenseToUpdate in objects(Expense.self).filter({(expense: Expense) -> Bool in return expense.belongingBudget?.budgetName == budget.budgetName}) {
                expenseToUpdate.belongingBudget = GlobalData.uncategorizedBudget
            }
            delete(budget)
            GlobalData.budgetCacheInvalidated = true
            GlobalData.expenseCacheInvalidated = true
        }
    }
    
    func delete(expense: Expense) {
        try! write {
            delete(expense)
            GlobalData.expenseCacheInvalidated = true
        }
    }
    
    func update(originalBudget: Budget, newBudget: Budget) {
        try! write {
            originalBudget.budgetName = newBudget.budgetName
            originalBudget.budgetTotal = newBudget.budgetTotal
            GlobalData.budgetCacheInvalidated = true
        }
    }
    
    func update(originalExpense: Expense, newExpense: Expense) {
        try! write {
            originalExpense.merchantName = newExpense.merchantName
            originalExpense.expenseAmount = newExpense.expenseAmount
            originalExpense.belongingBudget = newExpense.belongingBudget
            GlobalData.expenseCacheInvalidated = true
        }
    }
}

// Taken from: https://stackoverflow.com/questions/27182023/getting-the-difference-between-two-nsdates-in-months-days-hours-minutes-seconds
extension Date {
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0
    }
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    /// Returns the a custom time interval description from another date
    func offset(from date: Date) -> String {
        if years(from: date)   > 0 { return "\(years(from: date))y"   }
        if months(from: date)  > 0 { return "\(months(from: date))M"  }
        if weeks(from: date)   > 0 { return "\(weeks(from: date))w"   }
        if days(from: date)    > 0 { return "\(days(from: date))d"    }
        if hours(from: date)   > 0 { return "\(hours(from: date))h"   }
        if minutes(from: date) > 0 { return "\(minutes(from: date))m" }
        if seconds(from: date) > 0 { return "\(seconds(from: date))s" }
        return ""
    }
    
    func monthAsString() -> String {
        let df = DateFormatter()
        df.setLocalizedDateFormatFromTemplate("MMM")
        return df.string(from: self)
    }
    
}
