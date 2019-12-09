//
//  ContentView.swift
//  BetterRest
//
//  Created by PBB on 2019/10/21.
//  Copyright © 2019 PBB. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    let model = SleepCalculator()
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    
    private var idealBedtimeString: String {
        let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
        let hour = (components.hour ?? 0) * 60 * 60
        let minute = (components.minute ?? 0) * 60
        
        do {
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            let sleepTime = wakeUp - prediction.actualSleep
            
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            return formatter.string(from: sleepTime)
            
        } catch {
            return "Sorry, there was a problem calculating your bedtime."
        }
    }
    //    @State private var alertTitle = ""
    //    @State private var alertMessage = ""
//    @State private var showingAlert = false
    
//    @State private lazy var idealBedtimeString: String = calculateBedtime(self)
    
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date()
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("When do you want to wake up?")) {
                    DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                        .datePickerStyle(WheelDatePickerStyle())
                }
                
                Section(header: Text("Desired amount of sleep")) {
                    Stepper(value: $sleepAmount, in: 4...12, step: 0.25) {
                        Text("\(sleepAmount, specifier: "%g") hours")
                    }
                .accessibility(value: Text("\(sleepAmount, specifier: "%g") hours"))
                }
                
                Section(header: Text("Daily coffee intake")) {
//                    Stepper(value: $coffeeAmount, in: 1...20) {
//                        Text("\(coffeeAmount) cups")
//                    }
                    Picker("Daily coffee intake", selection: $coffeeAmount) {
                        ForEach(1...20, id: \.self) {
                             Text("\($0) cups")
                        }
                    }
//                    .pickerStyle(WheelPickerStyle())
                    .labelsHidden()
                }
                
                Section(header: Text("Your ideal bedtime is…")) {
                    Text(idealBedtimeString)
                        .font(.largeTitle)
                }
            }
            .navigationBarTitle("Better Rest")
//            .navigationBarItems(trailing: Button(action: calculateBedtime, label: {
//                Text("Calculate")
//            }))
//                .alert(isPresented: $showingAlert) {
//                    Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
//            }
        }
    }
    
    /*
    func calculateBedtime() {
        let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
        let hour = (components.hour ?? 0) * 60 * 60
        let minute = (components.minute ?? 0) * 60
        
        do {
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            let sleepTime = wakeUp - prediction.actualSleep
            
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            idealBedtimeString = formatter.string(from: sleepTime)
//            alertMessage = formatter.string(from: sleepTime)
//            alertTitle = "Your ideal bedtime is…"
            
        } catch {
            idealBedtimeString = "Sorry, there was a problem calculating your bedtime."
//            alertTitle = "Error"
//            alertMessage = "Sorry, there was a problem calculating your bedtime."
        }
        
//        showingAlert = true
//        return alertMessage
        
    }
 */
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
