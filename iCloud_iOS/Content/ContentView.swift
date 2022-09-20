//
//  ContentView.swift
//  iCloud_iOS
//
//  Created by Алим Куприянов on 15.09.2022.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel: ContentViewModel
    var body: some View {
        
        VStack {
            Spacer()
            
            if viewModel.segmentedIndex == 0 {
                ListView(viewModel: ListViewViewModel(parentFolder: viewModel.parentFolder,
                                                      user: viewModel.user,
                                                      segmentedIndex: viewModel.segmentedIndex))
            } else {
                GridView(viewModel: ListViewViewModel(parentFolder: viewModel.parentFolder,
                                                      user: viewModel.user,
                                                      segmentedIndex: viewModel.segmentedIndex))
            }
        }
        .onAppear(perform: {
            viewModel.getAllFiles()
        })
        .navigationTitle(viewModel.folderName)
        
        .sheet(isPresented: $viewModel.showImagePicker, content: {
            
            GalleryImagePicker(viewModel: GalleryImagePickerViewModel(),
                               imageURL: $viewModel.newFileURL,
                               alertMessage: $viewModel.alertMessage,
                               showAlert: $viewModel.isNeedAlert)
        })
        
        .sheet(isPresented: $viewModel.showDocumentPicker, content: {
            
            DocumentPicker(viewModel: DocumentPickerViewModel(),
                           documentURL: $viewModel.newFileURL,
                           alertMessage: $viewModel.alertMessage,
                           showAlert: $viewModel.isNeedAlert)
        })
        
        .alert(isPresented: $viewModel.isNeedAlert, content: {
            Alert(title: Text(viewModel.alertMessage),
                  dismissButton: .default(Text("OK")))
        })
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack {
                    Text("Действия")
                    Menu {
                        Section {
                            Picker(selection: $viewModel.segmentedIndex, label: Text("Отображать как:")) {
                                Label("Список", systemImage: "list.bullet").tag(0)
                                Label("Сетка", systemImage: "square.grid.2x2").tag(1)
                            }
                        }
                        
                        Section {
                            Picker(selection: $viewModel.filterType, label: Text("Filter")) {
                                Label("Папки", systemImage: "folder.fill").tag(Filter.folders)
                                Label("Ничего", systemImage: "questionmark.folder.fill").tag(Filter.none)
                                Label("Файлы", systemImage: "doc.on.clipboard.fill").tag(Filter.files)
                            }
                        }
                        Section {
                            if viewModel.isAllowAddFolder {
                                Button {
                                    viewModel.addFolder()
                                } label: {
                                    Label("Новая папка", systemImage: "folder.fill.badge.plus")
                                }
                            }
                            Button {
                                viewModel.openImagePicker()
                            } label: {
                                Label("Новое изображение", systemImage: "photo.fill.on.rectangle.fill")
                            }
                            Button {
                                viewModel.openDocumentPicker()
                            } label: {
                                Label("Новый документ", systemImage: "doc.on.doc.fill")
                            }
                        }
                        Section {
                            Button(role: .destructive) {
                                viewModel.logOut()
                            } label: {
                                Text("Выход")
                            }
                        }
                    } label: {
                        viewModel.segmentedIndex == 0 ? Image(systemName: "list.dash") :
                        Image(systemName: "square.grid.2x2")
                    }
                }
            }
        }
    }
}
