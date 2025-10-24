//
//  DataService.swift
//  数据服务层 - 提供示例课程数据
//
//  Created with Claude Code
//

import Foundation

class DataService {
    static let shared = DataService()

    private init() {}

    // MARK: - Sample Meditation Courses
    func getSampleCourses() -> [MeditationCourse] {
        return [
            // 放松解压课程
            MeditationCourse(
                title: "晨间觉醒",
                subtitle: "开启充满活力的一天",
                description: "通过温和的引导冥想，帮助你在清晨唤醒身心，以积极平和的心态开始新的一天。",
                category: .relaxation,
                duration: 10,
                instructor: "李静",
                audioFileName: "morning_awakening",
                imageFileName: "morning_meditation",
                isPremium: false,
                difficulty: .beginner,
                tags: ["早晨", "活力", "新手友好"]
            ),
            MeditationCourse(
                title: "深度放松",
                subtitle: "释放一天的压力与紧张",
                description: "通过渐进式肌肉放松和深呼吸，帮助你彻底放松身心，释放累积的压力。",
                category: .relaxation,
                duration: 20,
                instructor: "王明",
                audioFileName: "deep_relaxation",
                imageFileName: "relaxation",
                isPremium: true,
                difficulty: .intermediate,
                tags: ["放松", "减压", "晚间"]
            ),

            // 改善睡眠课程
            MeditationCourse(
                title: "安然入睡",
                subtitle: "让你的大脑准备好休息",
                description: "通过舒缓的声音和渐进式放松技巧，帮助你平静思绪，快速进入深度睡眠。",
                category: .sleep,
                duration: 15,
                instructor: "张悦",
                audioFileName: "sleep_meditation",
                imageFileName: "sleep",
                isPremium: false,
                difficulty: .beginner,
                tags: ["睡眠", "失眠", "放松"]
            ),
            MeditationCourse(
                title: "深度睡眠引导",
                subtitle: "高质量睡眠的秘密",
                description: "结合身体扫描和睡眠故事，引导你进入深层次的恢复性睡眠状态。",
                category: .sleep,
                duration: 30,
                instructor: "陈曦",
                audioFileName: "deep_sleep",
                imageFileName: "night_sky",
                isPremium: true,
                difficulty: .intermediate,
                tags: ["深度睡眠", "恢复", "故事"]
            ),

            // 提升专注课程
            MeditationCourse(
                title: "专注力训练",
                subtitle: "提高工作和学习效率",
                description: "通过正念呼吸和注意力锚定技巧，训练你的大脑保持长时间专注。",
                category: .focus,
                duration: 12,
                instructor: "刘伟",
                audioFileName: "focus_training",
                imageFileName: "focus",
                isPremium: false,
                difficulty: .beginner,
                tags: ["专注", "效率", "工作"]
            ),
            MeditationCourse(
                title: "心流状态",
                subtitle: "进入高效工作模式",
                description: "引导你进入心流状态，在专注中找到工作的乐趣和高效率。",
                category: .focus,
                duration: 25,
                instructor: "赵娟",
                audioFileName: "flow_state",
                imageFileName: "concentration",
                isPremium: true,
                difficulty: .advanced,
                tags: ["心流", "高效", "创造力"]
            ),

            // 缓解焦虑课程
            MeditationCourse(
                title: "平静内心",
                subtitle: "应对日常焦虑",
                description: "学习如何在焦虑来临时，通过呼吸和觉察来平复情绪，重获内心平静。",
                category: .anxiety,
                duration: 10,
                instructor: "孙丽",
                audioFileName: "calm_mind",
                imageFileName: "peaceful",
                isPremium: false,
                difficulty: .beginner,
                tags: ["焦虑", "平静", "应急"]
            ),
            MeditationCourse(
                title: "情绪疗愈",
                subtitle: "深度处理焦虑情绪",
                description: "通过深入的冥想练习，帮助你识别、接纳并释放焦虑情绪。",
                category: .anxiety,
                duration: 20,
                instructor: "周敏",
                audioFileName: "emotional_healing",
                imageFileName: "healing",
                isPremium: true,
                difficulty: .intermediate,
                tags: ["疗愈", "情绪", "深度"]
            ),

            // 正念冥想课程
            MeditationCourse(
                title: "正念入门",
                subtitle: "开始你的正念之旅",
                description: "学习正念冥想的基本技巧，培养对当下时刻的觉察能力。",
                category: .mindfulness,
                duration: 15,
                instructor: "李静",
                audioFileName: "mindfulness_intro",
                imageFileName: "mindfulness",
                isPremium: false,
                difficulty: .beginner,
                tags: ["正念", "入门", "基础"]
            ),
            MeditationCourse(
                title: "正念生活",
                subtitle: "将正念融入日常",
                description: "学习如何在日常生活的每一个时刻保持正念，活在当下。",
                category: .mindfulness,
                duration: 18,
                instructor: "王明",
                audioFileName: "mindful_living",
                imageFileName: "mindful_life",
                isPremium: true,
                difficulty: .intermediate,
                tags: ["正念", "生活", "日常"]
            ),

            // 呼吸练习课程
            MeditationCourse(
                title: "基础呼吸法",
                subtitle: "学习正确的冥想呼吸",
                description: "掌握腹式呼吸、方形呼吸等基础呼吸技巧，为冥想打下坚实基础。",
                category: .breathing,
                duration: 8,
                instructor: "张悦",
                audioFileName: "basic_breathing",
                imageFileName: "breathing",
                isPremium: false,
                difficulty: .beginner,
                tags: ["呼吸", "基础", "技巧"]
            ),
            MeditationCourse(
                title: "4-7-8 呼吸法",
                subtitle: "快速平静神经系统",
                description: "学习经典的4-7-8呼吸法，这是一种能快速让身心平静的强大技巧。",
                category: .breathing,
                duration: 10,
                instructor: "陈曦",
                audioFileName: "478_breathing",
                imageFileName: "breath_control",
                isPremium: false,
                difficulty: .beginner,
                tags: ["呼吸法", "快速", "平静"]
            )
        ]
    }

    // MARK: - Get Courses by Category
    func getCourses(for category: MeditationCategory) -> [MeditationCourse] {
        return getSampleCourses().filter { $0.category == category }
    }

    // MARK: - Get Course by ID
    func getCourse(by id: UUID) -> MeditationCourse? {
        return getSampleCourses().first { $0.id == id }
    }

    // MARK: - Get Featured Courses
    func getFeaturedCourses() -> [MeditationCourse] {
        let allCourses = getSampleCourses()
        // 返回每个分类的第一个课程作为精选
        var featured: [MeditationCourse] = []
        for category in MeditationCategory.allCases {
            if let course = allCourses.first(where: { $0.category == category }) {
                featured.append(course)
            }
        }
        return featured
    }
}
