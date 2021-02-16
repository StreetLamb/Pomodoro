//
//  PomodoroModelView.swift
//  Pomodoro
//
//  Created by Jerron Lim on 14/2/21.
//

import SwiftUI

class PomodoroModelView: ObservableObject {
    @Published private var pomodoroModel: PomodoroModel = PomodoroModel()
    
    private var timer: Timer?
    
    
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
    
    var total: Int {
        pomodoroModel.total
    }
    
    var completed: Int {
        pomodoroModel.completed
    }
    
    var remainingTime: String {
        let components = Calendar.current.dateComponents([.hour, .minute], from: pomodoroModel.finishedTime)
        return "\(String(format: "%02d", components.hour!)):\(String(format: "%02d", components.minute!))"
    }
    
    var countdownRemaining: String {
        let minutes = String(format: "%02d", pomodoroModel.countdownRemaining / 60)
        let seconds = String(format: "%02d", pomodoroModel.countdownRemaining % 60)
        return "\(minutes):\(seconds)"
    }
    
    var startTimer: Bool {
        pomodoroModel.startTimer
    }
    
    var mode: Int {
        pomodoroModel.mode
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
        pomodoroModel.startTimer = true
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [self] tempTimer in
            if pomodoroModel.countdownRemaining > 0 {
                pomodoroModel.countdownRemaining -= 1
            } else {
                tempTimer.invalidate()
                pomodoroModel.startTimer = false
                resetCountdown()
                if pomodoroModel.tasks.count > 0 {
                    pomodoroModel.tasks[0].completedPomodoro += 1
                }
            }
        }
    }
    
    func stopCountdown() {
        pomodoroModel.startTimer = false
        timer?.invalidate()
    }
    
    func resetCountdown() {
        if pomodoroModel.mode == 0 {
            pomodoroModel.completed += 1
        }
        
        if completed % 4 != 0 && pomodoroModel.mode == 0 {
            setCountdownRemaining(mode: 1)
        } else if completed % 4 == 0 && pomodoroModel.mode != 2 {
            setCountdownRemaining(mode: 2)
        } else {
            setCountdownRemaining(mode: 0)
        }
        
        setCountdownRemaining(mode: pomodoroModel.mode)
    }
    
    func setCountdownRemaining(mode: Int) {
        stopCountdown()
        pomodoroModel.mode = mode
    }

}
