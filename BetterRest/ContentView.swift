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
            VStack {
                Text("When do you want to wake up?")
                    .font(.headline)
                
                DatePicker("Please enter a time", selection: $wakeup, displayedComponents: .hourAndMinute)
                    .labelsHidden()
                
                Text("Desired amount of sleep")
                    .font(.headline)
                
                Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
                
                Text("Daily cofee intake")
                    .font(.headline)
                
                Stepper("\(cofeeAmount) cup(s)", value: $cofeeAmount, in: 1...20)
            }
            .padding()
            .toolbar {
                Button("Calculate", action: calculateBadTime)
            }
            .alert(alertTitle, isPresented: $isAlertShown) {
                Button("OK") {}
            } message: {
                Text(alertMessage)
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
