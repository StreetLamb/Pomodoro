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
    @State var showAlert: Bool = false
    @State var nextMode: Int = 0 // temp variable to hold the mode to switch to before confirmation alert
    
    @State var bgColor: Color = Color(red: 219 / 225, green: 82 / 225, blue: 77 / 225)
    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        switchModes(to: 0)
                    }, label: {
                        Text("Pomodoro")
                            .fontWeight(pomodoroModelView.mode == 0 ? .heavy : .regular)
                    })
                    Spacer()
                    Button(action: {
                        switchModes(to: 1)
                    }, label: {
                        Text("Short Break")
                            .fontWeight(pomodoroModelView.mode == 1 ? .heavy : .regular)
                    })
                    Spacer()
                    Button(action: {
                        switchModes(to: 2)
                    }, label: {
                        Text("Long Break")
                            .fontWeight(pomodoroModelView.mode == 2 ? .heavy : .regular)
                    })
                    Spacer()
                }
                .alert(isPresented: $showAlert) {
                    Alert(title: Text(""), message: Text("The timer is still running, are you sure you want to switch?"), primaryButton: .default(Text("Ok")) {
                        
                        switchModes(to: nextMode, ignore: true)
                    }, secondaryButton: .cancel())
                }
                .frame(maxWidth: .infinity, alignment: .top)
                .padding()
                
                Text("\(pomodoroModelView.countdownRemaining)")
                    .font(.system(size: 70))
                HStack(spacing: 30) {
                    Text("Est: \(total)")
                    Text("Act: \(pomodoroModelView.completed)")
                    Text("Finish: \(finishedTime)")
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
        .background(bgColor)
        .edgesIgnoringSafeArea(.all)
        .onChange(of: pomodoroModelView.mode, perform: { value in
            transitionBg(to: value)
        })
        
        
    }
    
    private func switchModes(to mode: Int, ignore: Bool = false) {
        if pomodoroModelView.startTimer && !ignore {
            nextMode = mode
            showAlert = true
        } else {
            pomodoroModelView.setCountdownRemaining(mode: mode)
            transitionBg(to: mode)
        }
    }
    
    private func transitionBg(to mode: Int) {
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

//MARK: - Helpers

extension PomodoroView {
    
    var finishedTime: String {
        var pomodoroCount = 0
        for task in pomodoroModelView.tasks {
            if !task.done {
                pomodoroCount += task.totalPomodoro
            }
        }
        let longBreaksCount = pomodoroCount / 4
        var durationInSeconds = (pomodoroCount * pomodoroModelView.focus + longBreaksCount * pomodoroModelView.longBreak + ( pomodoroCount - longBreaksCount) * pomodoroModelView.shortBreak)
        let isEndWithLongBreak = pomodoroCount % 4 == 0 ? true : false
        
        if isEndWithLongBreak {
            durationInSeconds -= pomodoroModelView.longBreak
        }else {
            durationInSeconds -= pomodoroModelView.shortBreak
        }
        
        let components = Calendar.current.dateComponents([.hour, .minute], from: Date().addingTimeInterval(Double(durationInSeconds)))
        return "\(String(format: "%02d", components.hour!)):\(String(format: "%02d", components.minute!))"
    }
    
    var total: Int {
        var pomodoroCount = 0
        for task in pomodoroModelView.tasks {
            pomodoroCount += task.totalPomodoro
        }
        return pomodoroCount
    }
}

struct PomodoroView_Previews: PreviewProvider {
    static var previews: some View {
        PomodoroView(pomodoroModelView: PomodoroModelView())
    }
}
