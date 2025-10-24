# 快速开始指南

## 5 分钟上手冥想应用

### 步骤 1：打开项目

```bash
# 进入项目目录
cd MeditationApp

# 使用 Xcode 打开项目
open MeditationApp.xcodeproj
```

### 步骤 2：运行应用

1. 在 Xcode 中选择模拟器（推荐 iPhone 14 Pro）
2. 点击运行按钮（或按 Cmd + R）
3. 等待编译完成

### 步骤 3：体验核心功能

#### 首页浏览
- 查看个人统计（连续天数、总时长）
- 浏览今日推荐课程
- 探索六大冥想分类

#### 课程体验
1. 点击任意课程卡片
2. 查看课程详情
3. 点击"开始冥想"按钮
4. 体验播放器界面

#### 冥想计时器
1. 切换到"计时器"标签
2. 选择冥想时长（建议从 5 分钟开始）
3. 点击"开始冥想"
4. 体验自由冥想模式

#### 个人统计
1. 切换到"我的"标签
2. 查看统计概览
3. 浏览本周活动图表
4. 查看成就徽章

## 项目文件说明

### 必读文档
- **README.md** - 项目介绍（5 分钟阅读）
- **USER_GUIDE.md** - 用户指南（15 分钟阅读）
- **PROJECT_SUMMARY.md** - 项目总结（10 分钟阅读）

### 进阶文档
- **DEVELOPMENT.md** - 开发文档（技术细节）
- **FEATURES.md** - 功能规划（未来路线图）

## 核心代码位置

### 想看数据模型？
```
MeditationApp/Models/MeditationModels.swift
```

### 想看主界面？
```
MeditationApp/Views/HomeView.swift
MeditationApp/Views/ContentView.swift
```

### 想看播放器？
```
MeditationApp/Views/PlayerView.swift
MeditationApp/Services/AudioPlayerService.swift
```

### 想看计时器？
```
MeditationApp/Views/TimerView.swift
```

## 快速定制

### 修改主题色
编辑 `Assets.xcassets/AccentColor.colorset/Contents.json`

### 添加新课程
编辑 `Services/DataService.swift` 的 `getSampleCourses()` 方法

### 修改分类
编辑 `Models/MeditationModels.swift` 的 `MeditationCategory` 枚举

## 常见问题

### Q: 为什么没有声音？
A: 这是演示版本，音频文件需要单独添加到项目中。

### Q: 如何添加真实音频？
A:
1. 将 MP3 文件添加到项目
2. 在课程数据中设置 `audioFileName`
3. AudioPlayerService 会自动加载

### Q: 能在真机上运行吗？
A: 可以！但需要：
1. 有效的 Apple Developer 账号
2. 配置代码签名
3. 选择真机设备运行

### Q: 数据会保存吗？
A: 当前版本数据在内存中，重启应用会重置。下一步需要添加 CoreData 实现持久化。

## 下一步

### 学习建议
1. 先通读 USER_GUIDE.md 了解功能
2. 再看 DEVELOPMENT.md 理解架构
3. 最后看 FEATURES.md 了解规划

### 开发建议
1. 首先添加数据持久化（CoreData）
2. 然后集成真实音频文件
3. 接着实现用户系统
4. 最后添加高级功能

### 扩展方向
- 添加更多课程和分类
- 实现社交分享功能
- 集成 Apple Watch
- 添加小组件支持

## 资源链接

### Apple 官方文档
- [SwiftUI Tutorials](https://developer.apple.com/tutorials/swiftui)
- [AVFoundation Guide](https://developer.apple.com/av-foundation/)
- [Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/)

### 推荐学习
- SwiftUI by Example
- Hacking with Swift
- Stanford CS193p

## 技术支持

遇到问题？
1. 查看项目文档
2. 检查 Xcode 控制台错误
3. 搜索相关问题
4. 提交 GitHub Issue

---

**准备好了吗？现在就打开 Xcode 开始你的冥想应用之旅！**

✨ Happy Coding! ✨
