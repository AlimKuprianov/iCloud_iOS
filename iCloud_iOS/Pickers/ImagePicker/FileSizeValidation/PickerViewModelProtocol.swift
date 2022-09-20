//
//  PickerViewModelProtocol.swift
//  iCloud_iOS
//
//  Created by Алим Куприянов on 20.09.2022.
//

import Foundation

protocol PickerViewModelProtocol {
    
    func validateFileSize(_ url: URL) -> Bool
    func validateFileExtension(_ url: URL) -> Bool
}

extension PickerViewModelProtocol {
    
    func validateFileSize(_ url: URL) -> Bool {
        let limit = 20 * 1024 * 1024
        let isValidate = url.fileSize >= limit ? false : true
        return isValidate
    }
    
    func validateFileExtension(_ url: URL) -> Bool {
        return url.pathExtension == "txt" ? false : true
    }
}
