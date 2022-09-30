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
                    Text("activities")
                    Menu {
                        Section {
                            Picker(selection: $viewModel.segmentedIndex, label: Text("View as:")) {
                                Label("List", systemImage: "list.bullet").tag(0)
                                Label("Grid", systemImage: "square.grid.2x2").tag(1)
                            }
                        }
                        
                        Section {
                            Picker(selection: $viewModel.filterType, label: Text("Filter")) {
                                Label("Folders", systemImage: "folder.fill").tag(Filter.folders)
                                Label("None", systemImage: "questionmark.folder.fill").tag(Filter.none)
                                Label("Files", systemImage: "doc.on.clipboard.fill").tag(Filter.files)
                            }
                        }
                        Section {
                            if viewModel.isAllowAddFolder {
                                Button {
                                    viewModel.addFolder()
                                } label: {
                                    Label("New Folder", systemImage: "folder.fill.badge.plus")
                                }
                            }
                            Button {
                                viewModel.openImagePicker()
                            } label: {
                                Label("New image", systemImage: "photo.fill.on.rectangle.fill")
                            }
                            Button {
                                viewModel.openDocumentPicker()
                            } label: {
                                Label("New document", systemImage: "doc.on.doc.fill")
                            }
                        }
                        Section {
                            Button(role: .destructive) {
                                viewModel.logOut()
                            } label: {
                                Text("Log out")
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
