//
//  MainTabView.swift
//  Paper-Stock
//
//  Created by Szymon on 15/08/2026.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            NavigationStack {
                WhoAmIView()
            }
            .tabItem { Label("Home", systemImage: "house") }

            NavigationStack {
//                SearchView()
            }
            .tabItem { Label("Search", systemImage: "magnifyingglass") }

            NavigationStack {
                WhoAmIView()
            }
            .tabItem { Label("Profil", systemImage: "person") }
        }
    }
}

#Preview {
    MainTabView()
}
