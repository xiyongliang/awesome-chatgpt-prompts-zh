//
//  ProfileView.swift
//  个人资料视图
//
//  Created with Claude Code
//

import SwiftUI
import Charts

struct ProfileView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // 用户信息卡片
                    userInfoCard

                    // 统计概览
                    statisticsOverview

                    // 冥想历史图表
                    meditationChart

                    // 成就徽章
                    achievementsBadges

                    // 设置选项
                    settingsOptions
                }
                .padding()
            }
            .navigationTitle("我的")
        }
    }

    // MARK: - User Info Card
    private var userInfoCard: some View {
        VStack(spacing: 16) {
            // 头像
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [.purple, .blue],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 100, height: 100)

                Text("禅")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(.white)
            }

            VStack(spacing: 4) {
                Text("冥想者")
                    .font(.title2)
                    .fontWeight(.bold)

                Text("开始冥想之旅 30 天")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            // 会员状态
            HStack {
                Image(systemName: "crown.fill")
                    .foregroundColor(.yellow)
                Text("高级会员")
                    .fontWeight(.semibold)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 8)
            .background(Color.yellow.opacity(0.2))
            .cornerRadius(20)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }

    // MARK: - Statistics Overview
    private var statisticsOverview: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("统计概览")
                .font(.headline)

            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 16) {
                StatCard(
                    icon: "flame.fill",
                    title: "连续天数",
                    value: "\(appState.currentStreak)",
                    unit: "天",
                    color: .orange
                )

                StatCard(
                    icon: "clock.fill",
                    title: "总时长",
                    value: "\(appState.totalMeditationMinutes)",
                    unit: "分钟",
                    color: .blue
                )

                StatCard(
                    icon: "checkmark.circle.fill",
                    title: "完成课程",
                    value: "\(appState.meditationHistory.count)",
                    unit: "次",
                    color: .green
                )

                StatCard(
                    icon: "star.fill",
                    title: "本周冥想",
                    value: "\(getWeeklyCount())",
                    unit: "次",
                    color: .purple
                )
            }
        }
    }

    // MARK: - Meditation Chart
    private var meditationChart: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("本周活动")
                .font(.headline)

            // 简单的柱状图
            HStack(alignment: .bottom, spacing: 12) {
                ForEach(getWeeklyData(), id: \.day) { data in
                    VStack(spacing: 8) {
                        // 柱状条
                        RoundedRectangle(cornerRadius: 4)
                            .fill(data.minutes > 0 ? Color.purple : Color.gray.opacity(0.3))
                            .frame(width: 35, height: max(CGFloat(data.minutes) * 2, 20))

                        // 星期
                        Text(data.day)
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 150)
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        }
    }

    // MARK: - Achievements Badges
    private var achievementsBadges: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("成就徽章")
                .font(.headline)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    AchievementBadge(
                        icon: "flame.fill",
                        title: "7天连续",
                        color: .orange,
                        isUnlocked: appState.currentStreak >= 7
                    )

                    AchievementBadge(
                        icon: "star.fill",
                        title: "初学者",
                        color: .yellow,
                        isUnlocked: appState.meditationHistory.count >= 5
                    )

                    AchievementBadge(
                        icon: "moon.stars.fill",
                        title: "夜猫子",
                        color: .indigo,
                        isUnlocked: false
                    )

                    AchievementBadge(
                        icon: "sunrise.fill",
                        title: "早起鸟",
                        color: .orange,
                        isUnlocked: false
                    )

                    AchievementBadge(
                        icon: "heart.fill",
                        title: "坚持者",
                        color: .pink,
                        isUnlocked: appState.currentStreak >= 30
                    )
                }
            }
        }
    }

    // MARK: - Settings Options
    private var settingsOptions: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("设置")
                .font(.headline)

            VStack(spacing: 0) {
                SettingsRow(icon: "bell.fill", title: "提醒设置", color: .orange)
                Divider().padding(.leading, 50)

                SettingsRow(icon: "moon.fill", title: "夜间模式", color: .indigo)
                Divider().padding(.leading, 50)

                SettingsRow(icon: "music.note", title: "音频设置", color: .pink)
                Divider().padding(.leading, 50)

                SettingsRow(icon: "person.fill", title: "账户管理", color: .blue)
                Divider().padding(.leading, 50)

                SettingsRow(icon: "questionmark.circle.fill", title: "帮助与反馈", color: .green)
            }
            .background(Color(.systemBackground))
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        }
    }

    // MARK: - Helper Methods
    private func getWeeklyCount() -> Int {
        let calendar = Calendar.current
        let weekAgo = calendar.date(byAdding: .day, value: -7, to: Date())!
        return appState.meditationHistory.filter { $0.date >= weekAgo }.count
    }

    private func getWeeklyData() -> [WeeklyData] {
        let calendar = Calendar.current
        let weekdays = ["日", "一", "二", "三", "四", "五", "六"]
        var data: [WeeklyData] = []

        for i in 0..<7 {
            let date = calendar.date(byAdding: .day, value: -6 + i, to: Date())!
            let weekday = calendar.component(.weekday, from: date) - 1
            let dayName = weekdays[weekday]

            let dayStart = calendar.startOfDay(for: date)
            let dayEnd = calendar.date(byAdding: .day, value: 1, to: dayStart)!

            let minutes = appState.meditationHistory
                .filter { $0.date >= dayStart && $0.date < dayEnd }
                .reduce(0) { $0 + $1.duration }

            data.append(WeeklyData(day: dayName, minutes: minutes))
        }

        return data
    }
}

// MARK: - Weekly Data Model
struct WeeklyData {
    let day: String
    let minutes: Int
}

// MARK: - Stat Card
struct StatCard: View {
    let icon: String
    let title: String
    let value: String
    let unit: String
    let color: Color

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)

            VStack(spacing: 2) {
                Text(value)
                    .font(.system(size: 28, weight: .bold))

                Text(unit)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

// MARK: - Achievement Badge
struct AchievementBadge: View {
    let icon: String
    let title: String
    let color: Color
    let isUnlocked: Bool

    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(isUnlocked ? color.opacity(0.2) : Color.gray.opacity(0.2))
                    .frame(width: 70, height: 70)

                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(isUnlocked ? color : .gray)
            }

            Text(title)
                .font(.caption)
                .foregroundColor(isUnlocked ? .primary : .secondary)
                .multilineTextAlignment(.center)
        }
        .frame(width: 90)
        .opacity(isUnlocked ? 1.0 : 0.5)
    }
}

// MARK: - Settings Row
struct SettingsRow: View {
    let icon: String
    let title: String
    let color: Color

    var body: some View {
        Button(action: {}) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .foregroundColor(color)
                    .frame(width: 24)

                Text(title)
                    .foregroundColor(.primary)

                Spacer()

                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary)
                    .font(.caption)
            }
            .padding()
        }
    }
}

#Preview {
    ProfileView()
        .environmentObject(AppState())
}
