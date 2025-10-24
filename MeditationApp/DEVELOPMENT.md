# 开发文档

## 项目架构

### MVVM 架构
本项目采用 MVVM (Model-View-ViewModel) 架构模式：

- **Models**: 数据模型和业务逻辑
  - `MeditationModels.swift` - 核心数据模型

- **Views**: SwiftUI 视图组件
  - `ContentView.swift` - 主导航容器
  - `HomeView.swift` - 首页
  - `ExploreView.swift` - 探索页面
  - `TimerView.swift` - 冥想计时器
  - `ProfileView.swift` - 个人资料
  - `CourseDetailView.swift` - 课程详情
  - `PlayerView.swift` - 音频播放器

- **Services**: 业务服务层
  - `DataService.swift` - 数据管理服务
  - `AudioPlayerService.swift` - 音频播放服务

- **AppState**: 全局应用状态管理

## 核心功能实现

### 1. 冥想课程系统

**数据模型**
```swift
struct MeditationCourse {
    let id: UUID
    var title: String
    var category: MeditationCategory
    var duration: Int
    // ... 其他属性
}
```

**分类系统**
- 放松解压 (Relaxation)
- 改善睡眠 (Sleep)
- 提升专注 (Focus)
- 缓解焦虑 (Anxiety Relief)
- 正念冥想 (Mindfulness)
- 呼吸练习 (Breathing)

### 2. 音频播放器

使用 AVFoundation 框架实现音频播放：
- 播放/暂停控制
- 进度跟踪
- 前进/后退 15 秒
- 音量控制
- 播放完成回调

### 3. 冥想计时器

自定义计时器功能：
- 预设时长选择 (5/10/15/20/30 分钟)
- 圆形进度指示器
- 暂停/继续功能
- 完成统计

### 4. 用户进度追踪

**统计数据**
- 连续冥想天数
- 总冥想时长
- 完成课程数量
- 每周活动图表

**数据持久化**
- 使用 AppState 管理全局状态
- 可扩展为 CoreData 或 SwiftData

### 5. UI/UX 设计

**设计原则**
- 简洁平静的界面
- 柔和的配色方案
- 流畅的动画过渡
- 直观的导航结构

**主题色**
- 紫色 (主色调)
- 渐变背景
- 分类专属颜色

## 技术栈

### 核心框架
- **SwiftUI**: 声明式 UI 框架
- **Combine**: 响应式编程
- **AVFoundation**: 音频处理

### 最低要求
- iOS 16.0+
- Xcode 14.0+
- Swift 5.7+

## 代码规范

### 命名规范
- 类型使用大驼峰 (PascalCase)
- 变量和函数使用小驼峰 (camelCase)
- 常量使用大写下划线 (SCREAMING_SNAKE_CASE)

### 文件组织
```
MeditationApp/
├── MeditationApp.swift     # App 入口
├── Models/                 # 数据模型
├── Views/                  # 视图组件
├── Services/               # 业务服务
└── Assets.xcassets/        # 资源文件
```

### 注释规范
- 每个文件顶部包含文件说明
- 复杂逻辑添加注释
- 使用 MARK 分隔代码段

## 扩展功能建议

### 短期优化
1. 添加真实音频文件
2. 实现数据持久化 (CoreData/SwiftData)
3. 添加推送通知提醒
4. 支持深色模式切换
5. 添加音效和背景音乐

### 长期规划
1. 社区功能 (分享、评论)
2. 付费订阅系统
3. 离线下载课程
4. Apple Watch 配套应用
5. HealthKit 集成
6. 多语言支持
7. 自定义冥想计划
8. AI 个性化推荐

## 测试

### 单元测试
- 数据模型测试
- 业务逻辑测试
- 服务层测试

### UI 测试
- 导航流程测试
- 交互功能测试
- 界面渲染测试

## 性能优化

### 图片优化
- 使用 SF Symbols 代替位图
- 图片资源压缩
- 懒加载策略

### 内存管理
- 避免强引用循环
- 及时释放音频资源
- 优化列表渲染

## 部署

### App Store 发布检查清单
- [ ] 完善应用图标
- [ ] 准备截图和预览视频
- [ ] 编写应用描述
- [ ] 设置应用分类和关键词
- [ ] 配置 App 内购买 (如需要)
- [ ] 隐私政策和服务条款
- [ ] TestFlight 测试
- [ ] 提交审核

## 许可证

本项目使用 MIT 许可证

## 贡献指南

欢迎提交 Issue 和 Pull Request

## 联系方式

如有问题，请通过 GitHub Issues 联系
