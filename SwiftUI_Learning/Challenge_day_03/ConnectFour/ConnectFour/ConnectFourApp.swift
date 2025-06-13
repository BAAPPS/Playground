//
//  ConnectFourApp.swift
//  ConnectFour
//
//  Created by D F on 6/12/25.
//

import SwiftUI

@main
struct ConnectFourApp: App {
    
    init() {
         // Customize all the appearance of segmented pickers within this app
         let selectedAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
         let normalAttributes = [NSAttributedString.Key.foregroundColor: UIColor.blue]
         
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(red: 0.0, green: 0.34, blue: 0.72, alpha: 0.8)
         UISegmentedControl.appearance().setTitleTextAttributes(selectedAttributes, for: .selected)
         UISegmentedControl.appearance().setTitleTextAttributes(normalAttributes, for: .normal)
     }

    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
