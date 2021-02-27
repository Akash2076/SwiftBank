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
    let custDetail = registerUser()
    
    print("Thanks for registering.")
    
    custDetail.addBankAccounts(accs: letAddBankAccounts())
    
    savedData.cust = Customers(custs: [custDetail])
    var jsonStr = ""
    if let data = savedData.cust {
        jsonStr = getJsonString(of: data)
    }
    
    saveJsonFile(of: jsonStr)
    
}




