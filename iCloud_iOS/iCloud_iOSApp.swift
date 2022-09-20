//
//  iCloud_iOSApp.swift
//  iCloud_iOS
//
//  Created by Алим Куприянов on 15.09.2022.
//

import UIKit
import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions
                   launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
      
    FirebaseApp.configure()
    return true
  }
}

@main
struct iCloud_iOSApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var user = User()
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                MainView(viewModel: MainViewModel(user: user))
            }
        }
    }
}

