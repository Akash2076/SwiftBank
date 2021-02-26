//
//  FileUtils.swift
//  SwiftBank
//
//  Created by Keval on 2/26/21.
//

import Foundation

let bankDirectoryName = "SwiftBank"
let bankFileName = "BankData.json"

extension URL {
    static func getOrCreateFolder(folderName: String) -> URL? {
        let fileManager = FileManager.default
        // Get document directory for device, this should succeed
        if let documentDirectory = fileManager.urls(for: .documentDirectory,
                                                    in: .userDomainMask).first
        {
            // Construct a URL with desired folder name
            let folderURL = documentDirectory.appendingPathComponent(folderName)
            // If folder URL does not exist, create it
            if !fileManager.fileExists(atPath: folderURL.path) {
                do {
                    // Attempt to create folder
                    try fileManager.createDirectory(atPath: folderURL.path,
                                                    withIntermediateDirectories: true,
                                                    attributes: nil)
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

// this will be called at initialization of the program
func getSavedData() -> (cust: Customer?, isFirstTime: Bool) {
    if let customer = readJsonFile() {
        return (customer, false)
    }

    return (nil, true)
}

// converting object to string
func getJsonString(of obj: Customer) -> String {
    do {
        let jsonEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = [.prettyPrinted]
        let jsonData = try jsonEncoder.encode(obj)
        if let json = String(data: jsonData, encoding: String.Encoding.utf8) {
            print(json)
            return json
        }
    } catch {}
    return ""
}

func saveJsonFile(of jsonString: String) {
    if let path = URL.getOrCreateFolder(folderName: bankDirectoryName) {
        let filePath = path.appendingPathComponent(bankFileName)
        print("saving data at: \(filePath)")

        do {
            try jsonString.write(to: filePath, atomically: true, encoding: .utf8)
        } catch {
            print("error writing json")
        }
    }
}

func readJsonFile() -> Customer? {
    if let path = URL.getOrCreateFolder(folderName: bankDirectoryName) {
        let filePath = path.appendingPathComponent(bankFileName)
        let data = NSData(contentsOf: filePath)

        do {
            // converting data to object(i.e Product in our case)
            if let payload = data as Data? {
                cust = try JSONDecoder().decode(Customer.self, from: payload)
                return cust
            }
        } catch {
            print("error reading json")
        }
    }

    return nil
}
