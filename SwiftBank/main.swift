//
//  main.swift
//  SwiftBank
//
//  Created by Keval on 2/25/21.
//

import Foundation

var customers: Customers?

var savedData = getSavedData()
if savedData.isFirstTime {
    // ask user to enter new customer
    var custDetail = registerUser()
    
    print("Thanks for registering.")
    
    let bankAccounts = Accounts()
    repeat{
        
        print("Which account would you like to open?\n1 - Salary account\n2 - Saving account\n3 - Fixed Deposit account")
        let choice = Int(readLine()!)!
        
        switch choice {
            case 1:
                // open salary account
                let salAcc = createSalaryAcc()
                bankAccounts.salaryAcc = salAcc
                
            case 2:
                // open saving account
                let savAcc = createSavingAcc()
                bankAccounts.SavingsAcc = savAcc
        
            case 3:
                // open fixed deposit account
                let fdAcc = createFdAcc()
                bankAccounts.FixedDepositAcc = fdAcc
        
            default:
                // wrong choice
                print("Sorry, incorrect input.")
        }
        
        print("Would you like to add more bank account? y/n")
        
    } while(readLine()! == "y")
    
    custDetail.accounts = bankAccounts
    savedData.cust = Customers(custs: [custDetail])
    var jsonStr = ""
    if let data = savedData.cust {
        jsonStr = getJsonString(of: data)
    }
    
    saveJsonFile(of: jsonStr)
    
    
}




