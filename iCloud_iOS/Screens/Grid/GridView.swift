//
//  GridView.swift
//  iCloud_iOS
//
//  Created by Алим Куприянов on 19.09.2022.
//

import SwiftUI

struct GridView: View {
    @ObservedObject var viewModel: ListViewViewModel
    @FocusState var focusedItem: Focusable?

    private let adaptiveColumns = [
        GridItem(.adaptive(minimum: 100))
    ]
    var body: some View {
        ScrollView {
            LazyVGrid(columns: adaptiveColumns, spacing: 20) {
                ForEach($viewModel.items, id: \.id) { $item in
                    Group {
                        if item.fileType == .folder {
                            NavigationLink(destination: ContentView(viewModel: ContentViewModel(user: viewModel.user,
                                                                                                    parentFolder: item))) {
                                VStack {
                                    Spacer(minLength: 30)

                                    Image(systemName: "folder.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(maxWidth: 50, maxHeight: 50)
                                    TextField(item.fileName, text: $item.fileName)
                                        .multilineTextAlignment(.center)
                                        .truncationMode(.middle)
                                        .focused($focusedItem, equals: .item(id: item.id.uuidString))
                                        .disabled(!(viewModel.editableItem == .item(id: item.id.uuidString)))
                                        .submitLabel(.done)
                                        .onSubmit {
                                            viewModel.rename(item)
                                            viewModel.editableItem = .none
                                            focusedItem = Focusable.none
                                        }
                                }
                                
                            }.buttonStyle(PlainButtonStyle())
                        } else {
                            VStack {
                                Spacer(minLength: 30)

                                Image(systemName: "doc.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(maxWidth: 50, maxHeight: 50)
                                TextField(item.fileName, text: $item.fileName)
                                    .multilineTextAlignment(.center)
                                    .truncationMode(.middle)
                                    .focused($focusedItem, equals: .item(id: item.id.uuidString))
                                    .disabled(!(viewModel.editableItem == .item(id: item.id.uuidString)))
                                    .submitLabel(.done)
                                    .onSubmit {
                                        viewModel.rename(item)
                                        viewModel.editableItem = .none
                                        focusedItem = Focusable.none
                                    }
                            }
                        }
                    }
                    .contextMenu {
                        Button {
                            viewModel.editableItem = .item(id: item.id.uuidString)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                self.focusedItem = .item(id: item.id.uuidString)
                            }
                        } label: {
                            Label("Rename", systemImage: "pencil")
                        }
                        Button(role: .destructive) {
                            viewModel.delete(item)
                        } label: {
                            Label("Delete", systemImage: "trash.fill")
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
    }
}
