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
    }
    while again

    return customers
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

    repeat {
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
            bankAccounts.savingsAcc = savAcc

        case 3:
            // open fixed deposit account
            let fdAcc = createFdAcc()
            bankAccounts.fixedDepositAcc = fdAcc

        default:
            // wrong choice
            print("Sorry, incorrect input.")
        }

        print("Would you like to add more bank account? y/n")
    }
    while readLine()! == "y"

    return bankAccounts
}

func customerLogin() -> CustomerDetails? {
    var customer: CustomerDetails?
    var again = false
    repeat {
        customer = tryLogin()
        if let cust = customer {
            print("Welcome \(cust.name)")
            again = false
        }
        else {
            print("Incorrect name or password. Would you like to try again? y/n")
            again = readLine()! == "y"
        }
    }
    while again

    return customer
}

func tryLogin() -> CustomerDetails? {
    print("Enter your name:")
    let name = readLine()!
    print("Enter your password:")
    let pass = readLine()!

    if let custs = customers?.customers {
        for cust in custs {
            if cust.name.lowercased() == name.lowercased(), cust.password.lowercased() == pass.lowercased() {
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
        if let fd = cust!.customers.last!.accounts!.fixedDepositAcc {
            if Int(fd.accountNo)! > lastAccNo {
                lastAccNo = Int(fd.accountNo)!
            }
        }
        else if let sal = cust!.customers.last!.accounts!.salaryAcc {
            if Int(sal.accountNo)! > lastAccNo {
                lastAccNo = Int(sal.accountNo)!
            }
        }
        else if let sav = cust!.customers.last!.accounts!.savingsAcc {
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
    }
    while rep

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

// functions regarding transactions

func showTransactionsMenu() {
    
}

func displayBalance(accs: Accounts?) {
    if let accounts = accs {
        if let salAcc = accounts.salaryAcc {
            print("Balance in salary account is: \(String(format: "%.2f", salAcc.accountBalance))")
        }
        
        if let savAcc = accounts.savingsAcc {
            print("Balance in savings account is: \(String(format: "%.2f", savAcc.accountBalance))")
        }
        
        if let fdAcc = accounts.fixedDepositAcc {
            print("Balance in Fixed Deposit account is: \(String(format: "%.2f", fdAcc.accountBalance))")
        }
        
    }
}

func depositMoney(accs: Accounts?, money: Double) {
    if let accounts = accs {
        
        var salAcc: SalaryAccount?
        var savAcc: SavingsAccount?
        var fdAcc: FixedDepositAccount?
        
        var str = "In which account would you like to deposit?\n"
        if let _salAcc = accounts.salaryAcc {
            str += "1 - Salary Account\n"
            salAcc = _salAcc
        }
        
        if let _savAcc = accounts.savingsAcc {
            str += "2 - Savings Account\n"
            savAcc = _savAcc
        }
        
        if let _fdAcc = accounts.fixedDepositAcc {
            str += "3 - Fixed Deposit Account\n"
            fdAcc = _fdAcc
        }
        
        str += "press 0 to go back to previous menu"
        
        var userChoice = -1
        repeat {
            
            print(str)
            userChoice = Int(readLine()!)!
            
            switch userChoice {
                case 0: // go back to previous menu
                    print("")
                    
                case 1: // salary account
                    let newBal = salAcc?.addBalance(amountToAdd: money)
                    print("new balance in salary account is: \(String(describing: newBal))")
                    
                case 2: // savings account
                    let newBal = savAcc?.addBalance(amountToAdd: money)
                    print("new balance in savings account is: \(String(describing: newBal))")
                    
                case 3: // FD account
                    let newBal = fdAcc?.addBalance(amountToAdd: money)
                    print("new balance in Fixed Deposit account is: \(String(describing: newBal))")
                    
                default:
                    print("Invalid input. please try again")
                    userChoice = -1
            }
            
        } while(userChoice == -1)
        
    }
}

