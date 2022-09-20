//
//  HomeView.swift
//  iCloud_iOS
//
//  Created by Алим Куприянов on 16.09.2022.
//

import SwiftUI

struct MainView: View {
    @StateObject var viewModel: MainViewModel
    var body: some View {
        Group {
                if viewModel.user.token != nil {
                    
                    ContentView(viewModel: ContentViewModel(user: viewModel.user,
                                                            parentFolder: viewModel.rootFolder))
                    
                } else {
                    RegistrationView(authViewModel: RegistrationViewModel(user: viewModel.user))
                }
        }
        .onAppear {
            viewModel.fetchUser()
        }
    }
}
