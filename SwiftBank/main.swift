//
//  main.swift
//  SwiftBank
//
//  Created by Keval on 2/25/21.
//

import Foundation






var cust = Customer(name: "Keval", contactNo: "7021989791", address: "Bhavnagar", password: "123")
let jsonString = getJsonString(of: cust)

if let path = URL.createFolder(folderName: "SwiftBank") {
    let filePath = path.appendingPathComponent("BankData.json")
    
    do {
        try jsonString.write(to: filePath, atomically: true, encoding: .utf8)
    } catch {
        print("error")
    }

}

var bankAcc: [BankAccount] = [
    SalaryAccount(accNo: 001, accBalance: 125_000, employer: "Google", monthlySalary: 15_000)
]

var accs: Accounts = Accounts(salAcc: SalaryAccount(accNo: 001, accBalance: 125_000, employer: "Google", monthlySalary: 15_000))

// var myCust: Customer
if let path = URL.createFolder(folderName: "SwiftBank") {
    let filePath = path.appendingPathComponent("BankData.json")
    let data = NSData(contentsOf: filePath)
    
    do {
        // converting data to object(i.e Product in our case)
        if let payload = data as Data? {
            cust = try JSONDecoder().decode(Customer.self, from: payload)
            // print(cust.get)
        }
    } catch {}
    
    cust.accounts = accs
    let jsonStr = getJsonString(of: cust)
    do {
        try jsonStr.write(to: filePath, atomically: true, encoding: .utf8)
    } catch {
        print("error")
    }
    
}


