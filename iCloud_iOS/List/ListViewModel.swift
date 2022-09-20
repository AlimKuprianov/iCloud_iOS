//
//  ListViewModel.swift
//  iCloud_iOS
//
//  Created by Алим Куприянов on 19.09.2022.
//

import Foundation

class ListViewViewModel: ObservableObject {
    
    @Published var parentFolder: FileModel?
    @Published var items: [FileModel] = []
    @Published var editableItem: Editable = .none
    @Published var segmentedIndex: Int
    
    public var user: User
    
    func delete(_ item: FileModel) {
        
        guard let ownerID = user.userID else { return }
        parentFolder?.fileModels?.removeAll(where: { $0.id == item.id })
        items.removeAll(where: { $0.id == item.id })
        CoreDataService.shared.delete(item,
                                      ownerID: ownerID)
    }
    
    func rename(_ item: FileModel) {
        
        guard let ownerID = user.userID else { return }
        CoreDataService.shared.renameItem(item,
                                          withOwnerID: ownerID)
    }
    
    init(parentFolder: FileModel?,
         user: User,
         segmentedIndex: Int) {
        
        self.user = user
        self.segmentedIndex = segmentedIndex
        guard let parentFolder = parentFolder,
              let items = parentFolder.fileModels else {
            return
        }
        self.items = items
    }
}
