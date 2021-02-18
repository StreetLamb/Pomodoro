//
//  AddTaskView.swift
//  Pomodoro
//
//  Created by Jerron Lim on 14/2/21.
//

import SwiftUI

struct AddTaskView: View {
    @ObservedObject var pomodoroModelView: PomodoroModelView
    @State private var name: String = ""
    @State private var pomodoro: Int = 1
    @Binding var isPresented: Bool
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("What are you working on?", text: $name)
                        .multilineTextAlignment(.leading)
                    Stepper("\(pomodoro) Pomodoro") {
                        pomodoro += 1
                    } onDecrement: {
                        if pomodoro > 1 {
                            pomodoro -= 1
                        }
                    }
                }
            }
            .navigationBarTitle("Add Task", displayMode: .inline)
            .navigationBarItems(leading: Button(action: {
                isPresented = false
            }, label: {
                Text("Cancel")
            }), trailing: Button(action: {
                //TODO: Add action here
                pomodoroModelView.addTask(name: name, pomodoro: pomodoro)
                isPresented = false
            }, label: {
                Text("Add")
            })
            .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
            )
        }
    }
}

//struct AddTaskView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddTaskView()
//    }
//}
