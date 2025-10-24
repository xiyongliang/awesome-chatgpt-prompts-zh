//
//  CourseDetailView.swift
//  课程详情视图
//
//  Created with Claude Code
//

import SwiftUI

struct CourseDetailView: View {
    let course: MeditationCourse
    @Environment(\.dismiss) var dismiss
    @State private var showPlayer = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // 课程头图
                courseHeader

                // 课程信息
                courseInfo

                // 课程描述
                courseDescription

                // 课程标签
                courseTags

                // 开始按钮
                startButton
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showPlayer) {
            PlayerView(course: course)
        }
    }

    // MARK: - Course Header
    private var courseHeader: some View {
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
                .frame(height: 250)

            // 图标
            VStack(alignment: .leading, spacing: 12) {
                Image(systemName: course.category.icon)
                    .font(.system(size: 60))
                    .foregroundColor(.white)

                if course.isPremium {
                    HStack {
                        Image(systemName: "crown.fill")
                        Text("高级会员专享")
                    }
                    .font(.caption)
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.black.opacity(0.3))
                    .cornerRadius(20)
                }
            }
            .padding(20)
        }
    }

    // MARK: - Course Info
    private var courseInfo: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(course.title)
                .font(.system(size: 28, weight: .bold))

            Text(course.subtitle)
                .font(.title3)
                .foregroundColor(.secondary)

            HStack(spacing: 20) {
                InfoLabel(icon: "clock", text: "\(course.duration) 分钟")
                InfoLabel(icon: "chart.bar", text: course.difficulty.rawValue)
                InfoLabel(icon: "person", text: course.instructor)
            }
            .font(.subheadline)
        }
    }

    // MARK: - Course Description
    private var courseDescription: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("课程介绍")
                .font(.headline)

            Text(course.description)
                .font(.body)
                .foregroundColor(.secondary)
                .lineSpacing(4)
        }
    }

    // MARK: - Course Tags
    private var courseTags: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("特点")
                .font(.headline)

            FlowLayout(spacing: 8) {
                ForEach(course.tags, id: \.self) { tag in
                    Text(tag)
                        .font(.caption)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(course.category.color.opacity(0.2))
                        .foregroundColor(course.category.color)
                        .cornerRadius(20)
                }
            }
        }
    }

    // MARK: - Start Button
    private var startButton: some View {
        Button(action: {
            showPlayer = true
        }) {
            HStack {
                Image(systemName: "play.fill")
                Text("开始冥想")
                    .fontWeight(.semibold)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(course.category.color)
            .foregroundColor(.white)
            .cornerRadius(16)
        }
        .padding(.top)
    }
}

// MARK: - Info Label
struct InfoLabel: View {
    let icon: String
    let text: String

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
            Text(text)
        }
        .foregroundColor(.secondary)
    }
}

// MARK: - Flow Layout
struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = FlowResult(
            in: proposal.replacingUnspecifiedDimensions().width,
            subviews: subviews,
            spacing: spacing
        )
        return result.size
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = FlowResult(
            in: bounds.width,
            subviews: subviews,
            spacing: spacing
        )
        for (index, subview) in subviews.enumerated() {
            subview.place(at: CGPoint(x: bounds.minX + result.positions[index].x,
                                     y: bounds.minY + result.positions[index].y),
                         proposal: .unspecified)
        }
    }

    struct FlowResult {
        var size: CGSize = .zero
        var positions: [CGPoint] = []

        init(in maxWidth: CGFloat, subviews: Subviews, spacing: CGFloat) {
            var currentX: CGFloat = 0
            var currentY: CGFloat = 0
            var lineHeight: CGFloat = 0

            for subview in subviews {
                let subviewSize = subview.sizeThatFits(.unspecified)

                if currentX + subviewSize.width > maxWidth && currentX > 0 {
                    currentX = 0
                    currentY += lineHeight + spacing
                    lineHeight = 0
                }

                positions.append(CGPoint(x: currentX, y: currentY))
                currentX += subviewSize.width + spacing
                lineHeight = max(lineHeight, subviewSize.height)
            }

            size = CGSize(width: maxWidth, height: currentY + lineHeight)
        }
    }
}

#Preview {
    NavigationView {
        CourseDetailView(course: DataService.shared.getSampleCourses()[0])
    }
}
