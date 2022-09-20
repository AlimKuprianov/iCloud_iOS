//
//  DocumentPicker.swift
//  iCloud_iOS
//
//  Created by Алим Куприянов on 20.09.2022.
//

import SwiftUI

struct DocumentPicker: UIViewControllerRepresentable {
    
    @ObservedObject var viewModel: DocumentPickerViewModel
    @Binding var documentURL: URL?
    @Binding var alertMessage: String
    @Binding var showAlert: Bool
    @Environment(\.presentationMode) private var presentationMode
    
    func makeCoordinator() -> Coordinator {
        return DocumentPicker.Coordinator(documentPicker: self)
    }
    
    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: viewModel.types)
        picker.allowsMultipleSelection = false
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}
    
    final class Coordinator: NSObject, UIDocumentPickerDelegate {
        let picker: DocumentPicker
        init(documentPicker: DocumentPicker) {
            self.picker = documentPicker
        }
        
        func documentPicker(_ controller: UIDocumentPickerViewController,
                            didPickDocumentsAt urls: [URL]) {
            
            guard let url = urls.first,
                  url.startAccessingSecurityScopedResource() else {
                      return
                  }
            defer { url.stopAccessingSecurityScopedResource() }
            do {
                let data = try Data(contentsOf: url)
                print(data)
            } catch {
                print(error.localizedDescription)
            }
            
            guard picker.viewModel.validateFileSize(url) else {
                picker.alertMessage = "Файл больше 20МБ!"
                picker.showAlert = true
                return
            }
            guard picker.viewModel.validateFileExtension(url) else {
                picker.alertMessage = "Неподдерживаемый формат файла"
                picker.showAlert = true
                return
            }
            picker.documentURL = url
            picker.presentationMode.wrappedValue.dismiss()
        }
        func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
            picker.presentationMode.wrappedValue.dismiss()
        }
    }
}
