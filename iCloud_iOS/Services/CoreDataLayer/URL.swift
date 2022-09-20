//
//  URL.swift
//  iCloud_iOS
//
//  Created by Алим Куприянов on 19.09.2022.
//

import Foundation

extension URL {
    var itemAttributes: [FileAttributeKey: Any]? {
        do {
            return try FileManager.default.attributesOfItem(atPath: path)
        } catch let error as NSError {
            print("FileAttribute error: \(error)")
        }
        return nil
    }
    
    var fileSize: UInt64 {
        return itemAttributes?[.size] as? UInt64 ?? UInt64(0)
    }
}
