//
//  MeditationApp.swift
//  冥想课程应用
//
//  Created with Claude Code
//

import SwiftUI

@main
struct MeditationApp: App {
    @StateObject private var appState = AppState()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
        }
    }
}

// MARK: - App State
class AppState: ObservableObject {
    @Published var currentUser: User?
    @Published var meditationHistory: [MeditationSession] = []
    @Published var totalMeditationMinutes: Int = 0
    @Published var currentStreak: Int = 0

    init() {
        loadUserData()
    }

    func loadUserData() {
        // 从本地存储加载用户数据
        // 这里可以使用 UserDefaults 或 CoreData
    }

    func saveMeditationSession(_ session: MeditationSession) {
        meditationHistory.append(session)
        totalMeditationMinutes += session.duration
        updateStreak()
    }

    private func updateStreak() {
        // 计算连续冥想天数
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())

        var streak = 0
        var currentDate = today

        for session in meditationHistory.reversed() {
            let sessionDate = calendar.startOfDay(for: session.date)
            if sessionDate == currentDate {
                streak += 1
                currentDate = calendar.date(byAdding: .day, value: -1, to: currentDate)!
            } else if sessionDate < currentDate {
                break
            }
        }

        currentStreak = streak
    }
}
