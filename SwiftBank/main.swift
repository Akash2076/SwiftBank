//
//  main.swift
//  SwiftBank
//
//  Created by Keval on 2/25/21.
//

import Foundation

// object to store all customer details including their bank accounts
var customers: Customers?
// object to store currently logged in customer
var loggedInCustomer: CustomerDetails?

// getting the saved data if exist
var savedData = getSavedData()

// check if the program is executing for first time
// if so, register at least 1 customer before showing them main menu
if savedData.isFirstTime {
    print("\nWelcome to Swift Bank. Please register yourself to get started")
    
    // register multiple users and save them in variable users
    let users = registerMultipleUsers()
    
    // create the object of Customers which holds all data of our program
    customers = Customers(custs: users)
    var jsonStr = ""
    
    // if customers obj is not nil, get the JSONstring for that object
    if let data = customers {
        jsonStr = getJsonString(of: data)
    }
    
    // save Json string into file
    saveJsonFile(of: jsonStr)
}
else {
    // if we already have a saved data from previous execution of program
    // in that case, store that data into our customers obj from savedData variable
    customers = savedData.cust
}


// When the user reaches here, it means we have a saved json file with all data
// and we have not nil 'customers' object

// Show main menu
print("\nWelcome to Swift Bank. What would you like to do today?")

// loop if user enters invalid action digit
var userChoice = -1
repeat {
    print("1 - Register new user\n2 - Login existing user\n0 - Exit\nTo perform transactions, you need to login")
    userChoice = Int(readLine()!)!
    
    // switch to check user input action
    switch userChoice {
        case 0: // exit - print thank you message and exit
            print("Thank you for using Swift Bank. See you next time! Bye..")
            
        case 1: // register users
            let users = registerMultipleUsers()
            
            // loop in all registered users to add them in our global 'customers' object
            for user in users {
                customers?.customers.append(user)
            }
            
            // if customers obj is not null, get the json string
            var jsonStr = ""
            if let data = customers {
                jsonStr = getJsonString(of: data)
            }

            // save json to file
            saveJsonFile(of: jsonStr)
            
            // reset user choice to show main menu again
            userChoice = -1
            
        case 2: // Login
            loggedInCustomer = customerLogin()
            
            // if user logged in successfully
            // then show them the Transaction menu
            if let _ = loggedInCustomer {
                showAndPerformTransactions()
            }
            
            // reset user choice to redirect to main menu
            userChoice = -1
            
        case 9: // Testing - printing all data in Json String
            showJson()
            userChoice = -1
            
        default: // invalid action digit
            print("Please enter valid choice.")
            userChoice = -1
    }
    
} while(userChoice == -1)   // check userChoice condition

