//
//  ContentView.swift
//  主视图 - 底部导航
//
//  Created with Claude Code
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Label("首页", systemImage: "house.fill")
                }
                .tag(0)

            ExploreView()
                .tabItem {
                    Label("探索", systemImage: "sparkles")
                }
                .tag(1)

            TimerView()
                .tabItem {
                    Label("计时器", systemImage: "timer")
                }
                .tag(2)

            ProfileView()
                .tabItem {
                    Label("我的", systemImage: "person.fill")
                }
                .tag(3)
        }
        .accentColor(.purple)
    }
}

#Preview {
    ContentView()
        .environmentObject(AppState())
}
