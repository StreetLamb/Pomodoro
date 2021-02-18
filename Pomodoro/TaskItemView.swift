//
//  TaskItemView.swift
//  Pomodoro
//
//  Created by Jerron Lim on 14/2/21.
//

import SwiftUI

struct TaskItemView: View {
    @ObservedObject var pomodoroModelView: PomodoroModelView
    var task: PomodoroModel.Task
    @State var toStrike: Bool = false
    @State var toEdit: Bool = false
    
    var body: some View {
        HStack {
            
            Text(task.name)
                .strikethrough(toStrike)
            Spacer()
            Text("\(task.completedPomodoro)/\(task.totalPomodoro)")
        }
        .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealWidth: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, minHeight: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealHeight: 70, maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
        .onTapGesture {
            toEdit = !toEdit
        }
        .sheet(isPresented: $toEdit, content: {
            EditTaskView(isPresented: $toEdit, pomodorModelView: pomodoroModelView, task: task)
        })
    }
}

//struct TaskItemView_Previews: PreviewProvider {
//    static var previews: some View {
//        TaskItemView()
//    }
//}
