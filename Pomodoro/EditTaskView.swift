//
//  EditItemView.swift
//  Pomodoro
//
//  Created by Jerron Lim on 15/2/21.
//

import SwiftUI

struct EditTaskView: View {
    @ObservedObject var pomodoroModelView: PomodoroModelView
    var task: PomodoroModel.Task
    @State private var name: String = ""
    @State private var pomodoro: Int = 1
    @Binding var isPresented: Bool
    
    init(isPresented: Binding<Bool>, pomodorModelView: PomodoroModelView, task: PomodoroModel.Task) {
        self.task = task
        _name = State(wrappedValue: task.name)
        _pomodoro = State(wrappedValue: task.totalPomodoro)
        _isPresented = isPresented
        self.pomodoroModelView = pomodorModelView
    }
    
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("What are you working on?", text: $name)
                        .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                    Stepper("\(pomodoro) Pomodoro") {
                        pomodoro += 1
                    } onDecrement: {
                        if pomodoro > 1 {
                            pomodoro -= 1
                        }
                    }
                }
            }
            .navigationBarTitle("Edit Task", displayMode: .inline)
            .navigationBarItems(leading: Button(action: {
                isPresented = false
            }, label: {
                Text("Cancel")
            }), trailing: Button(action: {
                pomodoroModelView.editTask(for: task.id, name: name, pomodoro: pomodoro)
                isPresented = false
            }, label: {
                Text("Update")
            })
            .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
            
            )
        }
    }
}

//struct EditItemView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditTaskView()
//    }
//}
