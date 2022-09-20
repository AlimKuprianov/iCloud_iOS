//
//  HomeViewModel.swift
//  iCloud_iOS
//
//  Created by Алим Куприянов on 19.09.2022.
//

import Foundation
import Combine

class MainViewModel: ObservableObject {
    
    @Published var user: User
    @Published var rootFolder: FileModel?
    @Published var segmentedIndex: Int = UserDefaults.standard.integer(forKey: UserDefaultKeys.segmentedIndex)
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    func fetchUser() {
        user.getToken { error in
            guard error == nil else { return }
            self.getRootFolder()
        }
    }
    
    private func getRootFolder() {
        guard let id = user.userID else { return }
        guard let folder = CoreDataService.shared.fetchRootFolder(withOwnerID: id)?.converted() else {
            rootFolder = createdRootFolder(withOwnerID: id)
            return
        }
        rootFolder = folder
    }
    
    private func createdRootFolder(withOwnerID id: String) -> FileModel {
        let entity = Entity(context: CoreDataService.shared.viewContext)
        let folder = FileModel(fileType: .folder,
                              depthLevel: 0,
                              id: UUID(),
                              ownerID: id,
                              url: nil,
                              fileName: "Документы",
                              parentId: nil)
        entity.type = try? JSONEncoder().encode(folder.fileType)
        entity.depthLevel = Int16(folder.depthLevel)
        entity.id = folder.id
        entity.ownerID = folder.ownerID
        entity.url = folder.url
        entity.fileName = folder.fileName
        entity.contentItems = try? JSONEncoder().encode(folder.fileModels)
        entity.parentId = folder.parentId
        CoreDataService.shared.save()
        return folder
    }

    init(user: User) {
        self.user = user
        self.user.$token
            .receive(on: RunLoop.main)
            .sink(receiveValue: { _ in self.getRootFolder() })
            .store(in: &cancellableSet)
    }
}

