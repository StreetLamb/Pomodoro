//
//  PomodoroView.swift
//  Pomodoro
//
//  Created by Jerron Lim on 13/2/21.
//

import SwiftUI

struct PomodoroView: View {
    @ObservedObject var pomodoroModelView: PomodoroModelView = PomodoroModelView()
    
    @State var showSheet: Bool = false
    
    @State var bgColor: Color = Color(red: 219 / 225, green: 82 / 225, blue: 77 / 225)
    
    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        transitionBg(to: 0)
                    }, label: {
                        Text("Pomodoro")
                            .fontWeight(pomodoroModelView.mode == 0 ? .heavy : .regular)
                    })
                    Spacer()
                    Button(action: {
                        transitionBg(to: 1)
                    }, label: {
                        Text("Short Break")
                            .fontWeight(pomodoroModelView.mode == 1 ? .heavy : .regular)
                    })
                    Spacer()
                    Button(action: {
                        transitionBg(to: 2)
                    }, label: {
                        Text("Long Break")
                            .fontWeight(pomodoroModelView.mode == 2 ? .heavy : .regular)
                    })
                    Spacer()
                }
                .frame(maxWidth: .infinity, alignment: .top)
                .padding()
                
                Text("\(pomodoroModelView.countdownRemaining)")
                    .font(.system(size: 70))
                HStack(spacing: 30) {
                    Text("Est: \(pomodoroModelView.total)")
                    Text("Act: \(pomodoroModelView.completed)")
                    Text("Finish: \(pomodoroModelView.remainingTime)")
                }
                Spacer()
                Button(action: {
                    if !pomodoroModelView.startTimer {
                        pomodoroModelView.startCountdown()
                    } else {
                        pomodoroModelView.stopCountdown()
                    }
                    
                }, label: {
                    Text(!pomodoroModelView.startTimer ? "Start" : "Stop")
                        .font(.largeTitle)
                        .padding()
                })
                .background(Color.white)
                .foregroundColor(bgColor)
                .cornerRadius(10)
                .padding()
                
            }
            .foregroundColor(.white)
            .frame(minWidth: 0, idealWidth: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, maxWidth: .infinity, minHeight: 300, idealHeight: 300, maxHeight: 300, alignment: .top)
            .cornerRadius(10)
            .padding(.vertical)
            
            VStack(alignment: .leading){
                HStack {
                    Text("Tasks")
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                    Spacer()
                    Button(action: {
                        showSheet = true
                    }, label: {
                        Image(systemName: "plus.square.fill")
                            .resizable()
                            .frame(width: 30, height: 30, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        
                    })
                    .sheet(isPresented: $showSheet, content: {
                        AddTaskView(pomodoroModelView: pomodoroModelView, isPresented: $showSheet)
                            .foregroundColor(.none)
                    })
                }
                .foregroundColor(.white)
                
                
                List {
                    if pomodoroModelView.tasks.count == 0 {
                        Text("All tasks completed! 😁")
                            .font(.title2)
                            .foregroundColor(.gray)
                    }
                    ForEach(pomodoroModelView.tasks) { task in
                        TaskItemView(pomodoroModelView: pomodoroModelView, task: task)
                    }
                    .onDelete(perform: { taskIndex in
                        pomodoroModelView.deleteTask(at: taskIndex)
                    })
                }
                .cornerRadius(10)
            }
            
        }
        .padding(.horizontal)
        .padding(.bottom, 50)
        .padding(.top, 30)
        .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealWidth: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, minHeight: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealHeight: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .top)
        .background(bgColor)
        .edgesIgnoringSafeArea(.all)
        .onChange(of: pomodoroModelView.mode, perform: { value in
            transitionBg(to: value)
        })
        
    }
    
    private func transitionBg(to mode: Int) {
        pomodoroModelView.setCountdownRemaining(mode: mode)
        
        withAnimation(.easeIn) {
            if pomodoroModelView.mode == 0 {
                bgColor = Color(red: 219 / 225, green: 82 / 225, blue: 77 / 225)
            } else if pomodoroModelView.mode == 1 {
                //240, 138, 93
                bgColor = Color(red: 70 / 225, green: 142 / 225, blue: 145 / 225)
            } else {
                bgColor = Color(red: 67 / 225, green: 126 / 225, blue: 168 / 225)
            }
        }
    }
}

struct PomodoroView_Previews: PreviewProvider {
    static var previews: some View {
        PomodoroView(pomodoroModelView: PomodoroModelView())
    }
}
