//
//  DocumentPickerViewModel.swift
//  iCloud_iOS
//
//  Created by Алим Куприянов on 20.09.2022.
//

import Foundation
import UniformTypeIdentifiers

final class DocumentPickerViewModel: ObservableObject,
                                     PickerViewModelProtocol {
    
    let types: [UTType] = [
        UTType.png,
        UTType.message,
        UTType.aiff,
        UTType.aliasFile,
        UTType.appleArchive,
        UTType.archive,
        UTType.audio,
        UTType.item,
        UTType.jpeg,
        UTType.pdf,
        UTType.gif,
        UTType.mp3,
        UTType.movie,
        UTType.archive,
        UTType.xml
    ]
}
