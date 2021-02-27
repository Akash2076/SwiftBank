//
//  Functions.swift
//  SwiftBank
//
//  Created by Keval on 2/26/21.
//

import Foundation

// Constants
let savingMinBal = Double(100)
let savingIntRate = Double(6)
let fdIntRate = Double(9)


func registerMultipleUsers() -> [CustomerDetails] {
    var customers = [CustomerDetails]()
    var again = false
    repeat {
        customers.append(registerUser())
        print("Would you like to register more user? y/n")
        again = readLine()! == "y"
    } while(again)
}

func registerUser() -> CustomerDetails {
    print("Enter your name: ")
    let name = readLine()!
    print("Set your password: ")
    let pass = readLine()!
    print("Enter your contact no: ")
    let contactNo = readLine()!
    print("Enter your address/city: ")
    let address = readLine()!
    
    let customer = CustomerDetails(name: name, contactNo: contactNo, address: address, password: pass)
    customer.addBankAccounts(accs: letAddBankAccounts())
    
    print("Registration successful.")
    
    return customer
}

func letAddBankAccounts() -> Accounts {
    
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
    
    return bankAccounts
    
}

func customerLogin() -> CustomerDetails? {
    var customer: CustomerDetails?
    var again = false
    repeat{
        customer = tryLogin()
        if let cust = customer {
            print("Welcome \(cust.name)")
            again = false
        }
        else {
            print("Incorrect name or password. Would you like to try again? y/n")
            again = readLine()! == "y"
        }
        
    } while(again)
    
    return customer
}

func tryLogin() -> CustomerDetails? {
    print("Enter your name:")
    let name = readLine()!
    print("Enter your password:")
    let pass = readLine()!
    
    if let custs = customers?.customers {
        for cust in custs {
            if cust.name == name && cust.password == pass {
                // code to login
                return cust
            }
        }
    }
    return nil
}


// creating bank account related functions
func generateNextAccountNumber() -> String {
    var accNo = 0
    var lastAccNo = 0
    let savedData = getSavedData()
    if savedData.isFirstTime {
        accNo = Int(String(format: "%02d", 1))!
    }
    else {
        let cust = savedData.cust
        if let fd = cust!.customers.last!.accounts!.FixedDepositAcc {
            if Int(fd.accountNo)! > lastAccNo {
                lastAccNo = Int(fd.accountNo)!
            }
        }
        else if let sal = cust!.customers.last!.accounts!.salaryAcc {
            if Int(sal.accountNo)! > lastAccNo {
                lastAccNo = Int(sal.accountNo)!
            }
        }
        else if let sav = cust!.customers.last!.accounts!.SavingsAcc {
            if Int(sav.accountNo)! > lastAccNo {
                lastAccNo = Int(sav.accountNo)!
            }
        }
    }
    accNo = lastAccNo + 1
    return String(format: "%02d", accNo)
}

func createSalaryAcc() -> SalaryAccount {
    let accNo = generateNextAccountNumber()
    print("Enter the account balance you'd like to add:")
    let accBal = Double(readLine()!)!
    print("Enter the name of your employer: ")
    let employer = readLine()!
    print("Enter your monthly salary: ")
    let monthlySal = Double(readLine()!)!
    
    return SalaryAccount(accNo: accNo, accBalance: accBal, employer: employer, monthlySalary: monthlySal)
}

func createSavingAcc() -> SavingsAccount {
    let accNo = generateNextAccountNumber()
    print("Minimum balance you need to maintain is: \(savingMinBal)\nAnd interest rate is: \(savingIntRate)%")
    
    var accBal = Double(0)
    var rep = false
    repeat {
        print("Enter the account balance you'd like to add:")
        accBal = Double(readLine()!)!
        if accBal > savingMinBal {
            rep = false
        }
        else {
            print("Please enter amount more than \(savingMinBal)")
            rep = true
        }
    } while(rep)
    
    
    return SavingsAccount(accNo: accNo, accBalance: accBal, minBal: savingMinBal, intRate: savingIntRate)
}

func createFdAcc() -> FixedDepositAccount {
    let accNo = generateNextAccountNumber()
    print("Enter the account balance you'd like to add:")
    let accBal = Double(readLine()!)!
    print("Enter the number of months as term duration for FD: ")
    let termDur = Int(readLine()!)!
    
    print("Interest rate for Fixed Deposit is \(fdIntRate)%")
    
    return FixedDepositAccount(accNo: accNo, accBalance: accBal, termDur: termDur, intRate: fdIntRate)
}
