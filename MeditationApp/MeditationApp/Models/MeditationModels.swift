//
//  MeditationModels.swift
//  数据模型定义
//
//  Created with Claude Code
//

import Foundation
import SwiftUI

// MARK: - User Model
struct User: Codable, Identifiable {
    let id: UUID
    var name: String
    var email: String
    var membershipLevel: MembershipLevel
    var joinDate: Date

    enum MembershipLevel: String, Codable {
        case free = "免费版"
        case premium = "高级会员"
        case lifetime = "终身会员"
    }
}

// MARK: - Meditation Category
enum MeditationCategory: String, CaseIterable, Identifiable {
    case relaxation = "放松解压"
    case sleep = "改善睡眠"
    case focus = "提升专注"
    case anxiety = "缓解焦虑"
    case mindfulness = "正念冥想"
    case breathing = "呼吸练习"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .relaxation: return "sun.max.fill"
        case .sleep: return "moon.stars.fill"
        case .focus: return "brain.head.profile"
        case .anxiety: return "heart.fill"
        case .mindfulness: return "leaf.fill"
        case .breathing: return "wind"
        }
    }

    var color: Color {
        switch self {
        case .relaxation: return .orange
        case .sleep: return .indigo
        case .focus: return .blue
        case .anxiety: return .pink
        case .mindfulness: return .green
        case .breathing: return .cyan
        }
    }

    var description: String {
        switch self {
        case .relaxation: return "释放压力，放松身心"
        case .sleep: return "帮助你快速入睡，提高睡眠质量"
        case .focus: return "提升注意力，保持专注状态"
        case .anxiety: return "平复情绪，缓解焦虑感"
        case .mindfulness: return "活在当下，觉察身心"
        case .breathing: return "调整呼吸，平静心灵"
        }
    }
}

// MARK: - Meditation Course
struct MeditationCourse: Identifiable, Codable, Hashable {
    let id: UUID
    var title: String
    var subtitle: String
    var description: String
    var category: MeditationCategory
    var duration: Int // 分钟
    var instructor: String
    var audioFileName: String?
    var imageFileName: String
    var isPremium: Bool
    var difficulty: Difficulty
    var tags: [String]

    enum Difficulty: String, Codable {
        case beginner = "初级"
        case intermediate = "中级"
        case advanced = "高级"
    }

    init(id: UUID = UUID(),
         title: String,
         subtitle: String,
         description: String,
         category: MeditationCategory,
         duration: Int,
         instructor: String,
         audioFileName: String? = nil,
         imageFileName: String = "default_meditation",
         isPremium: Bool = false,
         difficulty: Difficulty = .beginner,
         tags: [String] = []) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.description = description
        self.category = category
        self.duration = duration
        self.instructor = instructor
        self.audioFileName = audioFileName
        self.imageFileName = imageFileName
        self.isPremium = isPremium
        self.difficulty = difficulty
        self.tags = tags
    }

    // 为了支持 Codable
    enum CodingKeys: String, CodingKey {
        case id, title, subtitle, description, category, duration
        case instructor, audioFileName, imageFileName, isPremium, difficulty, tags
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        subtitle = try container.decode(String.self, forKey: .subtitle)
        description = try container.decode(String.self, forKey: .description)

        // 处理 category 的解码
        let categoryString = try container.decode(String.self, forKey: .category)
        category = MeditationCategory(rawValue: categoryString) ?? .mindfulness

        duration = try container.decode(Int.self, forKey: .duration)
        instructor = try container.decode(String.self, forKey: .instructor)
        audioFileName = try container.decodeIfPresent(String.self, forKey: .audioFileName)
        imageFileName = try container.decode(String.self, forKey: .imageFileName)
        isPremium = try container.decode(Bool.self, forKey: .isPremium)
        difficulty = try container.decode(Difficulty.self, forKey: .difficulty)
        tags = try container.decode([String].self, forKey: .tags)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(subtitle, forKey: .subtitle)
        try container.encode(description, forKey: .description)
        try container.encode(category.rawValue, forKey: .category)
        try container.encode(duration, forKey: .duration)
        try container.encode(instructor, forKey: .instructor)
        try container.encode(audioFileName, forKey: .audioFileName)
        try container.encode(imageFileName, forKey: .imageFileName)
        try container.encode(isPremium, forKey: .isPremium)
        try container.encode(difficulty, forKey: .difficulty)
        try container.encode(tags, forKey: .tags)
    }
}

// MARK: - Meditation Session
struct MeditationSession: Identifiable, Codable {
    let id: UUID
    let courseId: UUID?
    let date: Date
    let duration: Int // 实际冥想时长（分钟）
    let completed: Bool

    init(id: UUID = UUID(), courseId: UUID? = nil, date: Date = Date(), duration: Int, completed: Bool = true) {
        self.id = id
        self.courseId = courseId
        self.date = date
        self.duration = duration
        self.completed = completed
    }
}

// MARK: - Timer Preset
struct TimerPreset: Identifiable {
    let id: UUID = UUID()
    let duration: Int // 秒
    let title: String

    static let presets = [
        TimerPreset(duration: 300, title: "5 分钟"),
        TimerPreset(duration: 600, title: "10 分钟"),
        TimerPreset(duration: 900, title: "15 分钟"),
        TimerPreset(duration: 1200, title: "20 分钟"),
        TimerPreset(duration: 1800, title: "30 分钟")
    ]
}
