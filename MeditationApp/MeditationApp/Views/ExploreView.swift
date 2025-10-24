//
//  ExploreView.swift
//  探索视图 - 浏览所有课程
//
//  Created with Claude Code
//

import SwiftUI

struct ExploreView: View {
    @State private var searchText = ""
    @State private var selectedCategory: MeditationCategory?
    private let dataService = DataService.shared

    var filteredCourses: [MeditationCourse] {
        let courses = dataService.getSampleCourses()

        var filtered = courses
        if let category = selectedCategory {
            filtered = filtered.filter { $0.category == category }
        }

        if !searchText.isEmpty {
            filtered = filtered.filter {
                $0.title.localizedCaseInsensitiveContains(searchText) ||
                $0.subtitle.localizedCaseInsensitiveContains(searchText) ||
                $0.tags.contains { $0.localizedCaseInsensitiveContains(searchText) }
            }
        }

        return filtered
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // 分类过滤器
                    categoryFilter

                    // 课程列表
                    coursesList
                }
                .padding()
            }
            .navigationTitle("探索")
            .searchable(text: $searchText, prompt: "搜索冥想课程")
        }
    }

    // MARK: - Category Filter
    private var categoryFilter: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                // 全部按钮
                FilterChip(
                    title: "全部",
                    isSelected: selectedCategory == nil,
                    color: .purple
                ) {
                    selectedCategory = nil
                }

                // 分类按钮
                ForEach(MeditationCategory.allCases) { category in
                    FilterChip(
                        title: category.rawValue,
                        isSelected: selectedCategory == category,
                        color: category.color
                    ) {
                        selectedCategory = category
                    }
                }
            }
        }
    }

    // MARK: - Courses List
    private var coursesList: some View {
        LazyVStack(spacing: 16) {
            if filteredCourses.isEmpty {
                emptyState
            } else {
                ForEach(filteredCourses) { course in
                    NavigationLink(destination: CourseDetailView(course: course)) {
                        CourseListItem(course: course)
                    }
                }
            }
        }
    }

    // MARK: - Empty State
    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 60))
                .foregroundColor(.secondary)

            Text("未找到相关课程")
                .font(.headline)

            Text("试试其他关键词或分类")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 60)
    }
}

// MARK: - Filter Chip
struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .fontWeight(isSelected ? .semibold : .regular)
                .foregroundColor(isSelected ? .white : color)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    Capsule()
                        .fill(isSelected ? color : color.opacity(0.2))
                )
        }
    }
}

// MARK: - Course List Item
struct CourseListItem: View {
    let course: MeditationCourse

    var body: some View {
        HStack(spacing: 16) {
            // 课程图标
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(course.category.color.opacity(0.3))
                    .frame(width: 80, height: 80)

                Image(systemName: course.category.icon)
                    .font(.system(size: 32))
                    .foregroundColor(course.category.color)
            }

            // 课程信息
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(course.title)
                        .font(.headline)
                        .foregroundColor(.primary)

                    if course.isPremium {
                        Image(systemName: "crown.fill")
                            .font(.caption)
                            .foregroundColor(.yellow)
                    }
                }

                Text(course.subtitle)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)

                HStack(spacing: 12) {
                    Label("\(course.duration) 分钟", systemImage: "clock")
                    Label(course.difficulty.rawValue, systemImage: "chart.bar")
                }
                .font(.caption)
                .foregroundColor(.secondary)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

#Preview {
    ExploreView()
}
