//
//  ContentView.swift
//  BetterRest
//
//  Created by lorenc_D_K on 01.02.2025.
//

import SwiftUI

struct ContentView: View {
    
    @State private var wakeup = Date.now
    
    @State private var sleepAmount = 8.0
    
    var body: some View {
        VStack {
            DatePicker("Please enter a date", selection: $wakeup, in: Date.now...)
                .labelsHidden()
            
            Stepper("We have to sleep \(sleepAmount.formatted()) hours",
                    value: $sleepAmount,
                    in: 4...12,
                    step: 0.25
            )
            
            Text(Date.now, format: .dateTime.hour().minute())
            Text(Date.now.formatted(date: .long, time: .shortened))
        }
        .padding()
    }
    
    func exampleDate() {
//        var components = DateComponents()
//        components.hour = 8
//        components.minute = 0
//        let date = Calendar.current.date(from: components) ?? .now
        
        let components = Calendar.current.dateComponents([.hour, .minute], from: .now)
        let hour = components.hour ?? 0
        let minute = components.minute ?? 0
    }
}

#Preview {
    ContentView()
}
