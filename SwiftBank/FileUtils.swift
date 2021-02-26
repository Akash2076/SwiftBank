//
//  FileUtils.swift
//  SwiftBank
//
//  Created by Keval on 2/26/21.
//

import Foundation

extension URL {
    static func createFolder(folderName: String) -> URL? {
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
