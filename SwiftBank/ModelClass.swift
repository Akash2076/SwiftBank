//
//  ModelClass.swift
//  SwiftBank
//
//  Created by Keval on 2/25/21.
//

import Foundation

class Customer: Codable {
    var name: String
    var contactNo: String
    var address: String
    var password: String
    
    var accounts: [BankAccount]
    
    
    init(name: String, contactNo: String, address: String, password: String) {
        self.name = name
        self.contactNo = contactNo
        self.address = address
        self.password = password
        
        self.accounts = []
    }
    
    func addBankAccounts(accs: [BankAccount]) {
        self.accounts = accs
    }
    
}

class BankAccount: Codable {
    var accountNo: Int
    var accountBalance: Double
    
    init(accNo: Int, accBalance: Double) {
        self.accountNo = accNo
        self.accountBalance = accBalance
    }
    
    func addBalance(amountToAdd: Double) -> Double{
        return accountBalance + amountToAdd
    }
    
    func deductBalance(amountToDeduct: Double) -> Double {
        return accountBalance - amountToDeduct
    }
}

class SalaryAccount: BankAccount {
    var employer: String
    var monthlySalary: Double
    
    init(accNo: Int, accBalance: Double, employer: String, monthlySalary: Double) {
        self.employer = employer
        self.monthlySalary = monthlySalary
        
        super.init(accNo: accNo, accBalance: accBalance)
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    
}
