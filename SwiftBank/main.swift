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
    
    // show main menu
    print("\nWelcome to Swift Bank. What would you like to do today?")
    
    var userChoice = -1
    repeat {
        print("1 - Register new user\n2 - Login existing user\n0 - Exit\nTo perform transactions, you need to login")
        userChoice = Int(readLine()!)!
        
        switch userChoice {
            case 0:
                print("Thank you for using Swift Bank. See you next time! Bye..")
                
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
                userChoice = -1
                
            case 2:
                loggedInCustomer = customerLogin()
                if let _ = loggedInCustomer {
                    showAndPerformTransactions()
                    userChoice = -1
                }
                
            default:
                print("Please enter valid choice.")
                userChoice = -1
        }
        
    } while(userChoice == -1)
    
}

// When the user reaches here, it means we have a logged in customer
// Show the transactions menu
// showTransactionsMenu()



