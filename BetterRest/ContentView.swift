//
//  ContentView.swift
//  BetterRest
//
//  Created by lorenc_D_K on 01.02.2025.
//

import CoreML
import SwiftUI

struct ContentView: View {
    
    @State private var wakeup = Date.now
    @State private var sleepAmount = 8.0
    @State private var cofeeAmount = 1
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var isAlertShown = false
    
    var body: some View {
        NavigationStack {
            Form {
                Section("When do you want to wake up?") {
                    DatePicker("Please enter a time", selection: $wakeup, displayedComponents: .hourAndMinute)
                }
                
                Section("Desired amount of sleep") {
                    Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
                }
                
                Section("Daily cofee intake") {
                    Picker("Cups amount", selection: $cofeeAmount) {
                        ForEach(0..<21) {
                            Text("\($0) cup(s)").tag($0)
                        }
                    }
                    Stepper("\(cofeeAmount) cup(s)", value: $cofeeAmount, in: 1...20)
                }
            }
            .padding()
            .toolbar {
                Button("Calculate", action: calculateBadTime)
                    .opacity(isAlertShown ? 0 : 1)
            }
            .alert(alertTitle, isPresented: $isAlertShown) {
                Button("OK") {}
            } message: {
                Text(alertMessage)
                    .font(.headline)
            }
            .navigationTitle("BetterRest")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    func calculateBadTime() {
        do {
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeup)
            let secondsInHour = (components.hour ?? 0) * 60 * 60
            let secondsInMinute = (components.minute ?? 0) * 60
            let prediction = try model.prediction(wake: Double(secondsInHour + secondsInMinute), estimatedSleep: sleepAmount, coffee: Double(cofeeAmount))
            let sleepTime = wakeup - prediction.actualSleep
            alertTitle = "Your ideal bedtime is..."
            alertMessage = sleepTime.formatted(date: .omitted, time: .shortened)
        } catch {
            alertTitle = "Error"
            alertMessage = "Sorry, there was a problem calculating your bedtime"
        }
        isAlertShown = true
    }
}

#Preview {
    ContentView()
}
