//
//  CoreDataService.swift
//  iCloud_iOS
//
//  Created by Алим Куприянов on 19.09.2022.
//

import Foundation
import CoreData

struct CoreDataService {
    
    static let shared = CoreDataService()
    let persistentContainer: NSPersistentContainer
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    private init() {
        persistentContainer = NSPersistentContainer(name: "AppModel")
        persistentContainer.loadPersistentStores { description, error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func save(completion: @escaping (Error?) -> Void = { _ in }) {
        guard viewContext.hasChanges else { return }
        do {
            try viewContext.save()
            completion(nil)
        } catch {
            completion(error)
        }
    }
    
    func delete(_ item: FileModel,
                ownerID: String) {
        
        guard let rootEntity = fetchRootFolder(withOwnerID: ownerID),
              let entityContentData = rootEntity.contentItems,
              var entityItems = try? JSONDecoder().decode([FileModel]?.self,
                                                          from: entityContentData) else {
                  return
              }
        
        if let index = entityItems.firstIndex(where: { $0.id == item.id }) {
            entityItems.remove(at: index)
            let newItemsData = try? JSONEncoder().encode(entityItems)
            rootEntity.contentItems = newItemsData
            save()
            return
        }
        
        if let index = entityItems.firstIndex(where: { $0.id == item.parentId }),
           let finalIndex = entityItems[index].fileModels?.firstIndex(where: { $0.id == item.id }) {
            
            entityItems[index].fileModels?.remove(at: finalIndex)
            let newItemsData = try? JSONEncoder().encode(entityItems)
            rootEntity.contentItems = newItemsData
            save()
            return
        }
    }
    
    func saveNewFile(_ item: FileModel,
                     ownerID: String) {
        
        guard let rootEntity = fetchRootFolder(withOwnerID: ownerID),
              let entityContentData = rootEntity.contentItems,
              var entityItems = try? JSONDecoder().decode([FileModel]?.self,
                                                          from: entityContentData) else {
                  return
              }
        
        if rootEntity.id == item.parentId {
            entityItems.insert(item, at: 0)
            let newItemsData = try? JSONEncoder().encode(entityItems)
            rootEntity.contentItems = newItemsData
            save()
            return
        }
        
        if let index = entityItems.firstIndex(where: { $0.id == item.parentId }) {
            entityItems[index].fileModels?.insert(item, at: 0)
            let newItemsData = try? JSONEncoder().encode(entityItems)
            rootEntity.contentItems = newItemsData
            save()
            return
        }
    }
    
    func fetchContentItemsFrom(withOwnerID ownerID: String,
                               depthLevel: Int,
                               id: UUID) -> FileModel? {
        
        let rootFolder = fetchRootFolder(withOwnerID: ownerID)?.converted()
        let folder = goInto(array: rootFolder?.fileModels,
                            times: depthLevel)?.first(where: { $0.id == id })
        return folder
    }
    
    private func goInto(array: [FileModel]?,
                        times: Int) -> [FileModel]? {
        
        guard times != 0 else { return nil }
        
        if times == 1 {
            return array
            
        } else {
            
            guard let newArray = array?[0].fileModels else { return array }
            let newTimes = times - 1
            return goInto(array: newArray, times: newTimes)
        }
    }
    
    func renameItem(_ item: FileModel,
                    withOwnerID ownerID: String) {
        
        guard let rootEntity = fetchRootFolder(withOwnerID: ownerID),
              let entityContentData = rootEntity.contentItems,
              var entityItems = try? JSONDecoder().decode([FileModel]?.self,
                                                          from: entityContentData) else {
                  return
              }
        
        if let index = entityItems.firstIndex(where: { $0.id == item.id }) {
            entityItems[index].fileName = item.fileName
            let newItemsData = try? JSONEncoder().encode(entityItems)
            rootEntity.contentItems = newItemsData
            save()
            return
        }
        
        if let index = entityItems.firstIndex(where: { $0.id == item.parentId }),
           let finalIndex = entityItems[index].fileModels?.firstIndex(where: { $0.id == item.id }) {
            entityItems[index].fileModels?[finalIndex].fileName = item.fileName
            let newItemsData = try? JSONEncoder().encode(entityItems)
            rootEntity.contentItems = newItemsData
            save()
            return
        }
    }
    
    func fetchRootFolder(withOwnerID ownerID: String) -> Entity? {
        let request: NSFetchRequest<Entity> = Entity.fetchRequest()
        do {
            let folder = try viewContext.fetch(request).first(where: { $0.ownerID == ownerID })
            return folder
        } catch {
            return nil
        }
    }
    
    func fetchAllFiles(withID id: String) -> [FileModel] {
        let request: NSFetchRequest<Entity> = Entity.fetchRequest()
        do {
            let file = try viewContext.fetch(request).first(where: { $0.ownerID == id })
            guard let contentItems = file?.contentItems,
                  let items = try JSONDecoder().decode([FileModel]?.self, from: contentItems)  else {
                      return []
                  }
            return items
        } catch {
            return []
        }
    }
}
