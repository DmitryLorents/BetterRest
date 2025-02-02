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
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
