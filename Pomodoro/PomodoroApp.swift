//
//  PomodoroApp.swift
//  Pomodoro
//
//  Created by Jerron Lim on 13/2/21.
//

import SwiftUI

@main
struct PomodoroApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            PomodoroView(pomodoroModelView: PomodoroModelView())
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
