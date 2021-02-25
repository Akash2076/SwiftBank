//
//  main.swift
//  SwiftBank
//
//  Created by Keval on 2/25/21.
//

import Foundation


extension URL {
    static func createFolder(folderName: String) -> URL? {
        let fileManager = FileManager.default
        // Get document directory for device, this should succeed
        if let documentDirectory = fileManager.urls(for: .documentDirectory,
                                                    in: .userDomainMask).first {
            // Construct a URL with desired folder name
            let folderURL = documentDirectory.appendingPathComponent(folderName)
            // If folder URL does not exist, create it
            if !fileManager.fileExists(atPath: folderURL.path) {
                do {
                    // Attempt to create folder
                    try fileManager.createDirectory(atPath: folderURL.path,
                                                    withIntermediateDirectories: true,
                                                    attributes: nil)
                    // try fileManager.createFile(atPath: folderURL.path, contents: nil)
                } catch {
                    // Creation failed. Print error & return nil
                    print(error.localizedDescription)
                    return nil
                }
            }
            // Folder either exists, or was created. Return URL
            return folderURL
        }
        // Will only be called if document directory not found
        return nil
    }
}

// converting object to string
func getJsonString(of obj: Customer) -> String{
    do{
        let jsonEncoder = JSONEncoder()
        let jsonData = try jsonEncoder.encode(obj)
        if let json = String(data: jsonData, encoding: String.Encoding.utf8){
            print(json)
            return json
        }
    }catch{ }
    return ""
}

func saveJsonFile(of data: String) {
    if let documentDirectory = FileManager.default.urls(for: .documentDirectory,
                                                        in: .userDomainMask).first
    {
        let pathWithFilename = documentDirectory.appendingPathComponent("myJsonString.json")
        print(pathWithFilename) // this is thet path where our file will be stored
        do {
            try data.write(to: pathWithFilename, atomically: true, encoding: .utf8)
        } catch {
            // Handle error
        }
    }
}

func read() -> Customer? {
    if let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
        let url = documentDirectory.appendingPathComponent("BankData.json")
        let data = NSData(contentsOf: url)
        
        do {
            // converting data to object(i.e Product in our case)
            if let payload = data as Data? {
                let product = try JSONDecoder().decode(Customer.self, from: payload)
                return product
            }
        } catch {}
    }
    return nil
}



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
    
    cust.accounts = bankAcc
    let jsonStr = getJsonString(of: cust)
    do {
        try jsonStr.write(to: filePath, atomically: true, encoding: .utf8)
    } catch {
        print("error")
    }
    
}



