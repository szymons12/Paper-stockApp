//
//  Paper_StockApp.swift
//  Paper-Stock
//
//  Created by Szymon on 29/07/2026.
//

import SwiftUI

@main
struct Paper_StockApp: App {
    @StateObject private var loginViewModel = LoginViewModel()
    var body: some Scene {
         WindowGroup {
             if loginViewModel.isAuthenticated {
//                CandlesView(symbol: "TSLA")
                 Top10View()
                     .environmentObject(loginViewModel)
             }
             
             else {
                 LoginView()
                     .environmentObject(loginViewModel)
             }
         }
     }
    
 }
