//
//  ContentView.swift
//  UnitConverter
//
//  Created by D F on 6/7/25.
//

import SwiftUI

enum TemperatureUnit: String, CaseIterable{
    case celsius = "Celsius"
    case fahrenheit = "Fahrenheit"
    case kelvin = "Kelvin"
}

struct ContentView: View {
    @State private var temperatureInput = 0.0
    @State private var inputTemperatureUnit: TemperatureUnit = .celsius
    @State private var outputTemperatureUnit: TemperatureUnit = .fahrenheit
    
    var convertUnits:Double {
        let celsiusValue: Double
        switch inputTemperatureUnit {
        case  .celsius:
            celsiusValue = temperatureInput
        case .fahrenheit:
            celsiusValue = (temperatureInput - 32) * 5 / 9
        case .kelvin:
            celsiusValue = temperatureInput - 273.15
        }
        
        switch outputTemperatureUnit {
        case .celsius:
            return celsiusValue
        case .fahrenheit:
            return celsiusValue * 9 / 5 + 32
        case .kelvin:
            return celsiusValue + 273.15
        }
    }
    
    var body: some View {
        
        NavigationStack {
            Form {
                Section("Enter a temperature you want to convert"){
                    TextField("Temperature", value: $temperatureInput, format: .number)
                        .keyboardType(.decimalPad)
                }
                Section("Convert from") {
                    Picker("", selection: $inputTemperatureUnit){
                        ForEach(TemperatureUnit.allCases, id:\.self){
                            Text($0.rawValue)
                        }
                    }.pickerStyle(.segmented)
                }
                
                Section("Convert to") {
                    Picker("", selection: $outputTemperatureUnit){
                        ForEach(TemperatureUnit.allCases, id:\.self){
                            Text($0.rawValue)
                        }
                    }.pickerStyle(.segmented)
                }
                
                Section("Result") {
                    Text(convertUnits.formatted(.number.precision(.fractionLength(2))))
                }
            }
            .navigationTitle("Unit Converter")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
#Preview {
    ContentView()
}
