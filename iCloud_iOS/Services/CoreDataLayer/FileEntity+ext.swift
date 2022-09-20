//
//  FileEntity+ext.swift
//  iCloud_iOS
//
//  Created by Алим Куприянов on 19.09.2022.
//

import Foundation

extension Entity {
    func converted() -> FileModel? {
        guard let typeData = self.type,
              let type = try? JSONDecoder().decode(ItemType.self, from: typeData),
              let fileID = self.id,
              let fileName = self.fileName else {
                  return nil
              }
        var file = FileModel(fileType: type,
                            depthLevel: Int(self.depthLevel),
                            id: fileID,
                            ownerID: self.ownerID,
                            url: self.url,
                            fileName: fileName,
                            parentId: self.parentId)
        if let data = self.contentItems {
            file.fileModels = try? JSONDecoder().decode([FileModel]?.self, from: data)
        }
        return file
    }
}
