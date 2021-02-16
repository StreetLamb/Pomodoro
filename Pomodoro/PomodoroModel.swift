//
//  PomodoroModel.swift
//  Pomodoro
//
//  Created by Jerron Lim on 13/2/21.
//

import Foundation

struct PomodoroModel {
    private(set) var focus: Int = 25 * 60
    private(set) var shortBreak: Int = 5 * 60
    private(set) var longBreak: Int = 15 * 60
    
    var total: Int {
        var pomodoroCount = 0
        for task in tasks {
            pomodoroCount += task.totalPomodoro
        }
        return pomodoroCount
    }
    var completed: Int = 0 // number of focus session completed
    
    var finishedTime: Date {
        var pomodoroCount = 0
        for task in tasks {
            if !task.done {
                pomodoroCount += task.totalPomodoro
            }
        }
        let longBreaksCount = pomodoroCount / 4
        let durationInSeconds = (pomodoroCount * focus + longBreaksCount * longBreak + ( pomodoroCount - longBreaksCount) * shortBreak)
        return Date().addingTimeInterval(Double(durationInSeconds))
    }
    
    var tasks = [Task]()
    
    var countdownRemaining: Int = 25 * 60
    
    var mode: Int = 0 {
        didSet {
            if mode == 0 {
                countdownRemaining = focus
            } else if mode == 1 {
                countdownRemaining = shortBreak
            } else {
                countdownRemaining = longBreak
            }
        }
    }
    
    var startTimer: Bool = false
        
    struct Task: Identifiable {
        var id = UUID()
        
        var name: String
        var totalPomodoro: Int
        var completedPomodoro: Int = 0
        var done: Bool = false
    }
    
    mutating func addTask(name: String, pomodoro: Int) {
        tasks.append(Task(name: name, totalPomodoro: pomodoro))
    }
    
    mutating func editTask(for id: Task.ID, name: String, pomodoro: Int) {
        if let task = tasks.firstIndex(where: {$0.id == id}) {
            tasks[task].name = name
            tasks[task].totalPomodoro = pomodoro
        }
    }
    
    mutating func deleteTask(at indices: IndexSet) {
        tasks.remove(atOffsets: indices)
    }
    
}
