//
//  GalleryService.swift
//  iCloud_iOS
//
//  Created by Алим Куприянов on 19.09.2022.
//

import Photos

final class GalleryService {
    
    static func imagePickerRequest(completion access: @escaping (Bool) -> Void) {
        
        let accessStatus = PHPhotoLibrary.authorizationStatus()
        switch accessStatus {
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({ status in
                if status == .authorized {
                    access(true)
                    return
                }
            })
        case .restricted, .denied:
            access(false)
        case .authorized:
            access(true)
        default:
            access(false)
        }
    }
}
