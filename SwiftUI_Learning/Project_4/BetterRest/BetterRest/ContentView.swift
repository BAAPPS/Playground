//
//  ContentView.swift
//  BetterRest
//
//  Created by D F on 6/11/25.
//

import SwiftUI
import CoreML

struct ContentView: View {
    
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? .now
    }
    
    @State private var sleepAmount = 8.0
    @State private var wakeUp = defaultWakeTime
    @State private var coffeeAmount = 1
    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
    
    
    var idealBedTime: String {
        do {
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60
            
            let prediction = try model.prediction(
                wake: Double(hour + minute),
                estimatedSleep: sleepAmount,
                coffee: Double(coffeeAmount)
            )
            
            let sleepTime = wakeUp - prediction.actualSleep
            return sleepTime.formatted(date: .omitted, time: .shortened)
        } catch {
            return "Error calculating bedtime"
        }
    }
    
    
    func calculateBedtime(){
        do{
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60
            
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            
            let sleepTime = wakeUp - prediction.actualSleep
            
            alertTitle = "Your ideal bedtime is…"
            alertMessage = sleepTime.formatted(date: .omitted, time: .shortened)
        }
        catch{
            alertTitle = "Error"
            alertMessage = "Sorry, there was a problem calculating your bedtime."
        }
        showingAlert = true
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("When do you want to wake up?") {
                    DatePicker("Please enter a time", selection: $wakeUp)
                        .labelsHidden()
                }
                
                VStack {
                    Text("Desired amount of sleep")
                        .font(.headline)
                    HStack {
                        Spacer()
                        Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
                        Spacer()
                    }.padding(20)
                }
                .listRowBackground(Color.clear)
                
                
                VStack {
                    Text("Daily coffee intake")
                        .font(.headline)
                    HStack {
                        Spacer()
                        
                        Picker("^[\(coffeeAmount) cup](inflect: true)", selection: $coffeeAmount){
                            ForEach(0..<21){
                                Text($0, format: .number)
                            }
                        }
                        
                        Spacer()
                    }.padding(20)
                    
                }
                .listRowBackground(Color.clear)
                
                
                
                VStack{
                    Text("Your ideal bedtime is… \(idealBedTime)")
                }
                
                .alert(alertTitle, isPresented: $showingAlert) {
                    Button("OK") { }
                } message: {
                    Text(alertMessage)
                }
            }
            
            .navigationTitle("BetterRest")
            //            .toolbar{
            //                Button("Calculate", action: calculateBedtime)
            //            }
            
        }
    }
}

#Preview {
    ContentView()
}
