//
//  main.swift
//  SwiftBank
//
//  Created by Keval on 2/25/21.
//

import Foundation

var customers: Customers?
var loggedInCustomer: CustomerDetails?

var savedData = getSavedData()
if savedData.isFirstTime {
    print("\nWelcome to Swift Bank. Please register yourself to get started")
    loggedInCustomer = registerUser()
    print("Welcome \(loggedInCustomer!.name)")

    customers = Customers(custs: [loggedInCustomer!])
    var jsonStr = ""
    if let data = customers {
        jsonStr = getJsonString(of: data)
    }

    saveJsonFile(of: jsonStr)
    
}
else {
    customers = savedData.cust
    
    // todo: show main menu
    print("\nWelcome to Swift Bank. What would you like to do?")
    
    var userChoice = -1
    repeat {
        print("1 - Register new user\n2 - Login existing user\nTo perform transactions, you need to login")
        userChoice = Int(readLine()!)!
        
        switch userChoice {
            case 1:
                let users = registerMultipleUsers()
                for user in users {
                    customers?.customers.append(user)
                }
                
                var jsonStr = ""
                if let data = customers {
                    jsonStr = getJsonString(of: data)
                }

                saveJsonFile(of: jsonStr)
                
            case 2:
                loggedInCustomer = customerLogin()
                
            default:
                print("Please enter valid choice.")
                userChoice = -1
        }
        
        if loggedInCustomer == nil {
            userChoice = -1
        }
        
    } while(userChoice == -1)
    
}

// When the user reaches here, it means we have a logged in customer
// Show the transactions menu
// showTransactionsMenu()

var userChoice = -1
repeat {
    
    print(Constants.transactionMenu)
    userChoice = Int(readLine()!)!
    
    switch userChoice {
        case 1: // Display current balance
            displayBalance(accs: loggedInCustomer!.accounts)
            userChoice = -1     // set -1 to again show the transaction menu

        case 2: // Deposit money
            print("Please add the amount to deposit: ")
            let amount = Double(readLine()!)!
            depositMoney(accs: loggedInCustomer!.accounts, money: amount)
            userChoice = -1

        case 3: // draw money
            print("Please enter the amount to draw: ")
            let amount = Double(readLine()!)!
            drawMoney(accs: loggedInCustomer!.accounts, money: amount)
            userChoice = -1

        case 4: // transfer moeny to other bank accounts
            transferMoney(accs: loggedInCustomer!.accounts)
            userChoice = -1

        case 5: // pay utility bills
            print("")

        case 6: // add new bank account
            print("")

        case 7: // show or change customer details
            print("")

        case 8: // logout (go back to previous menu)
            print("")

        default:
            print("Incorrect input. Please enter valid action number")
            userChoice = -1
    }
    
    print("\n")     // just adding a line break to pretify the command line
} while(userChoice == -1)

