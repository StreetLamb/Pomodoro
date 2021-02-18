//
//  PomodoroModelView.swift
//  Pomodoro
//
//  Created by Jerron Lim on 14/2/21.
//

import SwiftUI
import Combine
class PomodoroModelView: ObservableObject {
    @Published private var pomodoroModel: PomodoroModel
    
    @ObservedObject var notificationManager = LocalNotificationManager()
        
    private var autosaveCancellable: AnyCancellable?
    init() {
        pomodoroModel = PomodoroModel(json: UserDefaults.standard.data(forKey: "Model")) ?? PomodoroModel()
        autosaveCancellable = $pomodoroModel.sink { PomodoroModel in
            UserDefaults.standard.set(PomodoroModel.json, forKey: "Model")
        }
        print(pomodoroModel.timestamp ?? "no timestamp")
        if let timestamp = pomodoroModel.timestamp {
            if !Calendar.current.isDateInToday(timestamp) {
                print("update date")
                pomodoroModel.completed = 0
                pomodoroModel.timestamp = Date()
            }
        } else {
            print("update date")
            pomodoroModel.timestamp = Date()
        }
    }
    
    private var timer: Timer?
    
    private var countdownTime: Int {
        if mode == 0 {
            return focus
        } else if mode == 1 {
            return shortBreak
        } else {
            return longBreak
        }
    }
    
    @Published var remainingTime: Int?
    
    var mode: Int = 0 {
        didSet {
            if mode == 0 {
                remainingTime = focus
                interval = 0
            } else if mode == 1 {
                remainingTime = shortBreak
                interval = 0
            } else {
                remainingTime = longBreak
                interval = 0
            }
        }
    }
    
    @Published private(set) var startTimer: Bool = false
    
    private var startDate: Date?
    
    private var interval: Double = 0
    
    private var notificationText: String {
        mode == 0 ? "Take a break!😁 You earned it!" : "Get back to the grind!💪"
    }
    
    
    //MARK: - Access to model
    
    var focus: Int {
        pomodoroModel.focus
    }
    
    var shortBreak: Int {
        pomodoroModel.shortBreak
    }
    
    var longBreak: Int {
        pomodoroModel.longBreak
    }
    
    var tasks: Array<PomodoroModel.Task> {
        pomodoroModel.tasks
    }
    
    
    var completed: Int {
        pomodoroModel.completed
    }
    
    var countdownRemaining: String {
        let minutes = String(format: "%02d", (remainingTime ?? countdownTime) / 60)
        let seconds = String(format: "%02d", (remainingTime ?? countdownTime) % 60)
        return "\(minutes):\(seconds)"
    }
    
    
    //MARK: - Intent
    
    func addTask(name: String, pomodoro: Int) {
        pomodoroModel.addTask(name: name, pomodoro: pomodoro)
    }
    
    func editTask(for id: PomodoroModel.Task.ID, name: String, pomodoro: Int) {
        pomodoroModel.editTask(for: id, name: name, pomodoro: pomodoro)
    }
    
    func deleteTask(at indices: IndexSet) {
        pomodoroModel.deleteTask(at: indices)
    }
    
    func startCountdown() {
        startTimer = true
        startDate = Date().addingTimeInterval(interval)
        remainingTime = countdownTime + Int(startDate!.timeIntervalSinceNow)
        //start an alert
        notificationManager.sendNotification(title: "Time's up!", subtitle: nil, body: notificationText, launchIn: Double(remainingTime!))
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [self] tempTimer in
            if remainingTime! > 0 {
                remainingTime = countdownTime + Int(startDate!.timeIntervalSinceNow)
            } else {
                tempTimer.invalidate()
                startTimer = false
                resetCountdown()
            }
        }
    }
    
    
    func stopCountdown() {
        notificationManager.cancelNotifications()
        startTimer = false
        interval = startDate?.timeIntervalSinceNow ?? 0
        timer?.invalidate()
    }
    
    
    private func resetCountdown() {
        if mode == 0 {
            pomodoroModel.completed += 1
            if pomodoroModel.tasks.count > 0 && mode == 0 {
                pomodoroModel.tasks[0].completedPomodoro += 1
            }
        }
        if completed % 4 != 0 && mode == 0 {
            setCountdownRemaining(mode: 1)
        } else if completed % 4 == 0 && mode != 2 {
            setCountdownRemaining(mode: 2)
        } else {
            setCountdownRemaining(mode: 0)
        }
        
        setCountdownRemaining(mode: mode)
    }
    
    func setCountdownRemaining(mode: Int) {
        stopCountdown()
        self.mode = mode
    }

}
