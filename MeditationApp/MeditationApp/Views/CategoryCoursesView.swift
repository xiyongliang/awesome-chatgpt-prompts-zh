//
//  CategoryCoursesView.swift
//  分类课程视图
//
//  Created with Claude Code
//

import SwiftUI

struct CategoryCoursesView: View {
    let category: MeditationCategory
    private let dataService = DataService.shared

    var courses: [MeditationCourse] {
        dataService.getCourses(for: category)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // 分类描述
                categoryHeader

                // 课程列表
                LazyVStack(spacing: 16) {
                    ForEach(courses) { course in
                        NavigationLink(destination: CourseDetailView(course: course)) {
                            CourseListItem(course: course)
                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle(category.rawValue)
        .navigationBarTitleDisplayMode(.large)
    }

    // MARK: - Category Header
    private var categoryHeader: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: category.icon)
                    .font(.system(size: 40))
                    .foregroundColor(category.color)

                Spacer()
            }

            Text(category.description)
                .font(.body)
                .foregroundColor(.secondary)

            Text("\(courses.count) 个课程")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(category.color.opacity(0.1))
        .cornerRadius(16)
    }
}

#Preview {
    NavigationView {
        CategoryCoursesView(category: .relaxation)
    }
}
