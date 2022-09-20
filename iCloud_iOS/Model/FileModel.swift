//
//  FileModel.swift
//  iCloud_iOS
//
//  Created by Алим Куприянов on 19.09.2022.
//

import Foundation

enum ItemType: Codable {
    case file
    case folder
}

struct FileModel: Identifiable, Codable {
    let id: UUID
    let fileType: ItemType
    let ownerID: String?
    let depthLevel: Int
    let url: URL?
    var fileName: String
    var fileModels: [FileModel]?
    var parentId: UUID?
    
    init(fileType: ItemType,
         depthLevel: Int,
         id: UUID,
         ownerID: String?,
         url: URL?,
         fileName: String,
         parentId: UUID?) {
        self.id = id
        self.depthLevel = depthLevel
        self.fileType = fileType
        self.ownerID = ownerID
        self.url = url
        self.fileName = fileName
        self.parentId = parentId
        switch fileType {
        case .folder:
            fileModels = []
        case .file:
            fileModels = nil
        }
    }
}
