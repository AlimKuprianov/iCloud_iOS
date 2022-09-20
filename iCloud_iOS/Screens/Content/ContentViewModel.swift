//
//  ViewModel.swift
//  iCloud_iOS
//
//  Created by Алим Куприянов on 19.09.2022.
//

import Combine
import FirebaseAuth


final class ContentViewModel: ObservableObject {
    
    @Published var segmentedIndex: Int = UserDefaults.standard.integer(forKey: UserDefaultKeys.segmentedIndex) {
        didSet {
            getAllFiles()
        }
    }
    @Published var filterType: Filter = .none
    @Published var showImagePicker = false
    @Published var showDocumentPicker = false
    
    @Published var isNeedAlert = false
    @Published var alertMessage = ""
    @Published var parentFolder: FileModel?
    @Published var items: [FileModel] = []
    
    @Published var newFileURL: URL?
    
    @Published var isNeedEditAlert = false
    @Published var itemName: String = ""
    
    @Published var user: User
    private var cancellableSet: Set<AnyCancellable> = []
        
    public var isAllowAddFolder: Bool {
        let isLimit = parentFolder?.depthLevel == 0 ? true : false
        return isLimit
    }
    
    public var folderName: String {
        parentFolder?.fileName ?? "Папка"
    }
    
    public func getAllFiles() {
        
        guard let id = user.userID,
        let depthLevel = parentFolder?.depthLevel,
        let parentID = parentFolder?.id else {
            return
        }
        if depthLevel == 0 {
            parentFolder = CoreDataService.shared.fetchRootFolder(withOwnerID: id)?.converted()
        } else {
            parentFolder = CoreDataService.shared.fetchContentItemsFrom(withOwnerID: id,
                                                                        depthLevel: depthLevel,
                                                                        id: parentID)
        }
        guard let contentItems = parentFolder?.fileModels else { return }
        switch filterType {
        case .folders:
            parentFolder?.fileModels = contentItems.filter({ $0.fileType == .folder })
        case .none:
            break
        case .files:
            parentFolder?.fileModels = contentItems.filter({ $0.fileType == .file })
        }
    }
    
    public func addFolder() {
        
        guard let parentFolder = parentFolder,
              let userID = user.userID,
              let entity = CoreDataService.shared.fetchRootFolder(withOwnerID: userID),
              let itemsData = entity.contentItems,
              var entityItems = try? JSONDecoder().decode([FileModel]?.self, from: itemsData) else {
                  return
              }
        let folder = FileModel(fileType: .folder,
                              depthLevel: parentFolder.depthLevel + 1,
                              id: UUID(),
                              ownerID: user.userID,
                              url: nil,
                              fileName: "Новая папка",
                              parentId: parentFolder.parentId)
        
        entityItems.insert(folder, at: 0)
        entity.contentItems = try? JSONEncoder().encode(entityItems)
        CoreDataService.shared.save()
        getAllFiles()
    }
    
    public func openImagePicker() {
        
        getAllFiles()
        GalleryService.imagePickerRequest { reqResult in
            DispatchQueue.main.async {
                guard reqResult == true else {
                    self.alertMessage = "Проблемы с доступом в Фотогалерею"
                    self.isNeedAlert.toggle()
                    return
                }
                self.showImagePicker.toggle()
            }
        }
    }
    
    func openDocumentPicker() {
        
        getAllFiles()
        showDocumentPicker.toggle()
    }
    
    public func logOut() {
        
        let auth = Auth.auth()
        try? auth.signOut()
        user.token = nil
        user.userID = nil
    }
    
    private func addFile() {
        
        guard let url = newFileURL,
        let parentFolder = parentFolder,
        let userID = user.userID,
        var contentItems = parentFolder.fileModels else { return }
        let fileName = url.lastPathComponent
        let file = FileModel(fileType: .file,
                            depthLevel: parentFolder.depthLevel,
                            id: UUID(),
                            ownerID: userID,
                            url: newFileURL,
                            fileName: fileName,
                            parentId: parentFolder.id)
        contentItems.insert(file, at: 0)
        CoreDataService.shared.saveNewFile(file,
                                           ownerID: userID)
        newFileURL = nil
        getAllFiles()
        
    }
        
    init(user: User,
         parentFolder: FileModel?) {
        
        self.user = user
        self.parentFolder = parentFolder
        if let parentFolder = parentFolder,
           let items = parentFolder.fileModels {
            self.items = items
        }
        $segmentedIndex
            .receive(on: RunLoop.main)
            .sink(receiveValue: { UserDefaults.standard.set($0, forKey: UserDefaultKeys.segmentedIndex) })
            .store(in: &cancellableSet)
        $newFileURL
            .receive(on: RunLoop.main)
            .sink(receiveValue: { _ in self.addFile() })
            .store(in: &cancellableSet)
        $filterType
            .receive(on: RunLoop.main)
            .sink { _ in self.getAllFiles() }
            .store(in: &cancellableSet)
    }
}
