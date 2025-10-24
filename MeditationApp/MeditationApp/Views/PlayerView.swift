//
//  PlayerView.swift
//  冥想播放器视图
//
//  Created with Claude Code
//

import SwiftUI

struct PlayerView: View {
    let course: MeditationCourse
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var appState: AppState
    @StateObject private var audioPlayer = AudioPlayerService.shared

    @State private var isPlaying = false
    @State private var currentTime: TimeInterval = 0
    @State private var totalTime: TimeInterval = 0
    @State private var showCompletionView = false
    @State private var sessionStartTime = Date()

    var body: some View {
        ZStack {
            // 背景渐变
            LinearGradient(
                colors: [course.category.color.opacity(0.6), course.category.color.opacity(0.3)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 40) {
                // 关闭按钮
                closeButton

                Spacer()

                // 课程信息
                courseInfo

                // 圆形进度指示器
                circularProgress

                // 播放控制
                playbackControls

                Spacer()
            }
            .padding()
        }
        .onAppear {
            setupPlayer()
        }
        .onReceive(audioPlayer.$isPlaying) { playing in
            isPlaying = playing
        }
        .onReceive(audioPlayer.$currentTime) { time in
            currentTime = time
        }
        .onReceive(audioPlayer.$duration) { duration in
            totalTime = duration
        }
        .sheet(isPresented: $showCompletionView) {
            CompletionView(
                course: course,
                duration: Int(currentTime / 60)
            ) {
                dismiss()
            }
        }
    }

    // MARK: - Close Button
    private var closeButton: some View {
        HStack {
            Button(action: {
                audioPlayer.stop()
                dismiss()
            }) {
                Image(systemName: "xmark")
                    .font(.title3)
                    .foregroundColor(.white)
                    .padding(12)
                    .background(Color.white.opacity(0.2))
                    .clipShape(Circle())
            }
            Spacer()
        }
    }

    // MARK: - Course Info
    private var courseInfo: some View {
        VStack(spacing: 12) {
            Image(systemName: course.category.icon)
                .font(.system(size: 50))
                .foregroundColor(.white)

            Text(course.title)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)

            Text(course.instructor)
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.8))
        }
    }

    // MARK: - Circular Progress
    private var circularProgress: some View {
        ZStack {
            // 背景圆
            Circle()
                .stroke(Color.white.opacity(0.3), lineWidth: 8)
                .frame(width: 250, height: 250)

            // 进度圆
            Circle()
                .trim(from: 0, to: audioPlayer.playbackProgress)
                .stroke(Color.white, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                .frame(width: 250, height: 250)
                .rotationEffect(.degrees(-90))
                .animation(.linear(duration: 0.1), value: audioPlayer.playbackProgress)

            // 时间显示
            VStack(spacing: 8) {
                Text(formatTime(currentTime))
                    .font(.system(size: 40, weight: .light, design: .rounded))
                    .foregroundColor(.white)

                Text("/ \(formatTime(totalTime))")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.8))
            }
        }
    }

    // MARK: - Playback Controls
    private var playbackControls: some View {
        HStack(spacing: 40) {
            // 后退 15 秒
            Button(action: {
                let newTime = max(0, currentTime - 15)
                audioPlayer.seek(to: newTime)
            }) {
                Image(systemName: "gobackward.15")
                    .font(.title2)
                    .foregroundColor(.white)
            }

            // 播放/暂停
            Button(action: {
                if isPlaying {
                    audioPlayer.pause()
                } else {
                    audioPlayer.play()
                }
            }) {
                Image(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill")
                    .font(.system(size: 70))
                    .foregroundColor(.white)
            }

            // 前进 15 秒
            Button(action: {
                let newTime = min(totalTime, currentTime + 15)
                audioPlayer.seek(to: newTime)
            }) {
                Image(systemName: "goforward.15")
                    .font(.title2)
                    .foregroundColor(.white)
            }
        }
    }

    // MARK: - Helper Methods
    private func setupPlayer() {
        if let audioFileName = course.audioFileName {
            audioPlayer.loadAudio(fileName: audioFileName)
        }
        sessionStartTime = Date()
    }

    private func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}

// MARK: - Completion View
struct CompletionView: View {
    let course: MeditationCourse
    let duration: Int
    let onDismiss: () -> Void

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            // 完成图标
            ZStack {
                Circle()
                    .fill(course.category.color.opacity(0.2))
                    .frame(width: 120, height: 120)

                Image(systemName: "checkmark")
                    .font(.system(size: 50, weight: .bold))
                    .foregroundColor(course.category.color)
            }

            // 祝贺文字
            VStack(spacing: 12) {
                Text("太棒了!")
                    .font(.system(size: 32, weight: .bold))

                Text("你完成了 \(duration) 分钟的冥想")
                    .font(.title3)
                    .foregroundColor(.secondary)
            }

            // 统计信息
            HStack(spacing: 40) {
                StatItem(
                    icon: "flame.fill",
                    value: "7",
                    label: "天连续",
                    color: .orange
                )

                StatItem(
                    icon: "clock.fill",
                    value: "\(duration)",
                    label: "分钟",
                    color: .blue
                )
            }
            .padding()

            Spacer()

            // 完成按钮
            Button(action: onDismiss) {
                Text("完成")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(course.category.color)
                    .foregroundColor(.white)
                    .cornerRadius(16)
            }
            .padding(.horizontal)
        }
        .padding()
    }
}

// MARK: - Stat Item
struct StatItem: View {
    let icon: String
    let value: String
    let label: String
    let color: Color

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)

            Text(value)
                .font(.system(size: 28, weight: .bold))

            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

#Preview {
    PlayerView(course: DataService.shared.getSampleCourses()[0])
        .environmentObject(AppState())
}
