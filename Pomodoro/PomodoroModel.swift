//
//  PomodoroModel.swift
//  Pomodoro
//
//  Created by Jerron Lim on 13/2/21.
//

import Foundation

struct PomodoroModel: Codable {
    private(set) var focus: Int = 25 * 60
    private(set) var shortBreak: Int = 5 * 60
    private(set) var longBreak: Int = 15 * 60

    var completed: Int = 0 // number of focus session completed
    
    var timestamp: Date?
    
    var tasks = [Task]()
    
    var json: Data? {
        return try? JSONEncoder().encode(self)
    }
    
    init?(json: Data?) {
        if json != nil, let newPomodoroModel = try? JSONDecoder().decode(PomodoroModel.self, from: json!) {
            self = newPomodoroModel
        } else {
            return nil
        }
    }
    
    init(){}
    
    struct Task: Identifiable, Codable {
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
