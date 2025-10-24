//
//  HomeView.swift
//  首页视图
//
//  Created with Claude Code
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var appState: AppState
    @State private var greeting = "你好"
    private let dataService = DataService.shared

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // 问候语和统计
                    headerSection

                    // 每日推荐
                    dailyRecommendationSection

                    // 精选课程
                    featuredCoursesSection

                    // 按分类浏览
                    categoriesSection
                }
                .padding()
            }
            .background(
                LinearGradient(
                    colors: [Color.purple.opacity(0.1), Color.blue.opacity(0.1)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
            )
            .navigationTitle("冥想")
        }
        .onAppear {
            updateGreeting()
        }
    }

    // MARK: - Header Section
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(greeting)
                .font(.system(size: 32, weight: .bold))

            HStack(spacing: 16) {
                StatBadge(
                    icon: "flame.fill",
                    value: "\(appState.currentStreak)",
                    label: "天连续",
                    color: .orange
                )

                StatBadge(
                    icon: "clock.fill",
                    value: "\(appState.totalMeditationMinutes)",
                    label: "分钟",
                    color: .blue
                )
            }
        }
    }

    // MARK: - Daily Recommendation
    private var dailyRecommendationSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("今日推荐")
                .font(.headline)

            if let course = dataService.getFeaturedCourses().first {
                NavigationLink(destination: CourseDetailView(course: course)) {
                    DailyRecommendationCard(course: course)
                }
            }
        }
    }

    // MARK: - Featured Courses
    private var featuredCoursesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("精选课程")
                .font(.headline)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(dataService.getFeaturedCourses()) { course in
                        NavigationLink(destination: CourseDetailView(course: course)) {
                            CourseCard(course: course)
                        }
                    }
                }
            }
        }
    }

    // MARK: - Categories Section
    private var categoriesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("浏览分类")
                .font(.headline)

            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 16) {
                ForEach(MeditationCategory.allCases) { category in
                    NavigationLink(destination: CategoryCoursesView(category: category)) {
                        CategoryCard(category: category)
                    }
                }
            }
        }
    }

    // MARK: - Helper Methods
    private func updateGreeting() {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 0..<6:
            greeting = "夜深了"
        case 6..<12:
            greeting = "早安"
        case 12..<18:
            greeting = "午安"
        default:
            greeting = "晚安"
        }
    }
}

// MARK: - Stat Badge
struct StatBadge: View {
    let icon: String
    let value: String
    let label: String
    let color: Color

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .foregroundColor(color)
                .font(.title3)

            VStack(alignment: .leading, spacing: 2) {
                Text(value)
                    .font(.system(size: 18, weight: .bold))
                Text(label)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

// MARK: - Daily Recommendation Card
struct DailyRecommendationCard: View {
    let course: MeditationCourse

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            // 背景渐变
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    LinearGradient(
                        colors: [course.category.color, course.category.color.opacity(0.7)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(height: 200)

            // 内容
            VStack(alignment: .leading, spacing: 8) {
                Image(systemName: course.category.icon)
                    .font(.system(size: 32))
                    .foregroundColor(.white)

                Text(course.title)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)

                Text(course.subtitle)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.9))

                HStack {
                    Label("\(course.duration) 分钟", systemImage: "clock")
                    Spacer()
                    if course.isPremium {
                        Label("高级", systemImage: "crown.fill")
                    }
                }
                .font(.caption)
                .foregroundColor(.white.opacity(0.9))
            }
            .padding(20)
        }
    }
}

// MARK: - Course Card
struct CourseCard: View {
    let course: MeditationCourse

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // 课程图片/图标
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(course.category.color.opacity(0.3))
                    .frame(width: 160, height: 120)

                Image(systemName: course.category.icon)
                    .font(.system(size: 40))
                    .foregroundColor(course.category.color)
            }

            // 课程信息
            VStack(alignment: .leading, spacing: 4) {
                Text(course.title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                    .lineLimit(1)

                Text("\(course.duration) 分钟")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .frame(width: 160)
    }
}

// MARK: - Category Card
struct CategoryCard: View {
    let category: MeditationCategory

    var body: some View {
        VStack(spacing: 12) {
            // 图标
            ZStack {
                Circle()
                    .fill(category.color.opacity(0.2))
                    .frame(width: 60, height: 60)

                Image(systemName: category.icon)
                    .font(.system(size: 28))
                    .foregroundColor(category.color)
            }

            // 标题和描述
            VStack(spacing: 4) {
                Text(category.rawValue)
                    .font(.headline)
                    .foregroundColor(.primary)

                Text(category.description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

#Preview {
    HomeView()
        .environmentObject(AppState())
}
