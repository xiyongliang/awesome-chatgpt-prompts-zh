//
//  TimerView.swift
//  冥想计时器视图
//
//  Created with Claude Code
//

import SwiftUI

struct TimerView: View {
    @State private var selectedDuration = 600 // 默认 10 分钟
    @State private var isTimerRunning = false
    @State private var remainingTime = 600
    @State private var timer: Timer?
    @State private var showCompletionAlert = false
    @EnvironmentObject var appState: AppState

    let presets = [300, 600, 900, 1200, 1800] // 5, 10, 15, 20, 30 分钟

    var body: some View {
        NavigationView {
            ZStack {
                // 背景渐变
                LinearGradient(
                    colors: [Color.indigo.opacity(0.3), Color.purple.opacity(0.2)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                VStack(spacing: 40) {
                    if isTimerRunning {
                        runningTimerView
                    } else {
                        timerSetupView
                    }
                }
                .padding()
            }
            .navigationTitle("冥想计时器")
        }
        .alert("冥想完成", isPresented: $showCompletionAlert) {
            Button("完成") {
                resetTimer()
            }
        } message: {
            Text("恭喜你完成了 \(selectedDuration / 60) 分钟的冥想!")
        }
    }

    // MARK: - Timer Setup View
    private var timerSetupView: some View {
        VStack(spacing: 40) {
            // 说明文字
            VStack(spacing: 12) {
                Image(systemName: "leaf.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.green)

                Text("自由冥想")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text("选择你想冥想的时长")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            // 时长选择器
            VStack(spacing: 20) {
                Text("\(selectedDuration / 60) 分钟")
                    .font(.system(size: 60, weight: .bold))
                    .foregroundColor(.primary)

                // 预设时长按钮
                VStack(spacing: 12) {
                    ForEach(0..<2) { row in
                        HStack(spacing: 12) {
                            ForEach(0..<3) { col in
                                let index = row * 3 + col
                                if index < presets.count {
                                    PresetButton(
                                        duration: presets[index],
                                        isSelected: selectedDuration == presets[index]
                                    ) {
                                        selectedDuration = presets[index]
                                        remainingTime = presets[index]
                                    }
                                }
                            }
                        }
                    }
                }
            }

            Spacer()

            // 开始按钮
            Button(action: startTimer) {
                HStack {
                    Image(systemName: "play.fill")
                    Text("开始冥想")
                        .fontWeight(.semibold)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(16)
            }
        }
    }

    // MARK: - Running Timer View
    private var runningTimerView: some View {
        VStack(spacing: 50) {
            Spacer()

            // 圆形进度
            ZStack {
                // 背景圆
                Circle()
                    .stroke(Color.gray.opacity(0.3), lineWidth: 12)
                    .frame(width: 280, height: 280)

                // 进度圆
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(Color.green, style: StrokeStyle(lineWidth: 12, lineCap: .round))
                    .frame(width: 280, height: 280)
                    .rotationEffect(.degrees(-90))
                    .animation(.linear(duration: 0.5), value: progress)

                // 剩余时间
                VStack(spacing: 8) {
                    Text(formatTime(remainingTime))
                        .font(.system(size: 50, weight: .light, design: .rounded))

                    Text("剩余时间")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }

            // 控制按钮
            HStack(spacing: 30) {
                // 暂停/继续
                Button(action: toggleTimer) {
                    Image(systemName: timer != nil ? "pause.circle.fill" : "play.circle.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.green)
                }

                // 停止
                Button(action: stopTimer) {
                    Image(systemName: "stop.circle.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.red)
                }
            }

            Spacer()
        }
    }

    // MARK: - Computed Properties
    private var progress: CGFloat {
        let elapsed = Double(selectedDuration - remainingTime)
        let total = Double(selectedDuration)
        return total > 0 ? CGFloat(elapsed / total) : 0
    }

    // MARK: - Timer Control Methods
    private func startTimer() {
        isTimerRunning = true
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if remainingTime > 0 {
                remainingTime -= 1
            } else {
                completeTimer()
            }
        }
    }

    private func toggleTimer() {
        if timer != nil {
            // 暂停
            timer?.invalidate()
            timer = nil
        } else {
            // 继续
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                if remainingTime > 0 {
                    remainingTime -= 1
                } else {
                    completeTimer()
                }
            }
        }
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
        isTimerRunning = false
        remainingTime = selectedDuration
    }

    private func completeTimer() {
        timer?.invalidate()
        timer = nil

        // 保存冥想记录
        let session = MeditationSession(
            courseId: nil,
            date: Date(),
            duration: selectedDuration / 60,
            completed: true
        )
        appState.saveMeditationSession(session)

        showCompletionAlert = true
    }

    private func resetTimer() {
        isTimerRunning = false
        remainingTime = selectedDuration
    }

    private func formatTime(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let secs = seconds % 60
        return String(format: "%d:%02d", minutes, secs)
    }
}

// MARK: - Preset Button
struct PresetButton: View {
    let duration: Int
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text("\(duration / 60) 分钟")
                .font(.headline)
                .foregroundColor(isSelected ? .white : .green)
                .frame(maxWidth: .infinity)
                .padding()
                .background(isSelected ? Color.green : Color.green.opacity(0.2))
                .cornerRadius(12)
        }
    }
}

#Preview {
    TimerView()
        .environmentObject(AppState())
}
