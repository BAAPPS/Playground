//
//  CustomSegmentedControl.swift
//  TrackBite
//
//  Created by D F on 7/25/25.
//

import SwiftUI
import UIKit

struct CustomSegmentedControl: UIViewRepresentable {
    @Binding var selectedIndex: Int
    let segments: [String]
    
    var selectedTintColor: UIColor = .white
    var unselectedTintColor: UIColor = .gray
    var backgroundColor: UIColor = .clear
    var selectedTextColor: UIColor = .clear
    var unselectedTextColor: UIColor = .gray
    var font: UIFont = UIFont.systemFont(ofSize: 14, weight: .medium)
    
    func makeUIView(context: Context) -> UISegmentedControl {
        let control = UISegmentedControl(items: segments)
        control.selectedSegmentIndex = selectedIndex
        
        control.addTarget(
            context.coordinator,
            action: #selector(Coordinator.valueChanged(_:)),
            for: .valueChanged
        )
        
        // Customize appearance
        control.backgroundColor = backgroundColor
        control.selectedSegmentTintColor = selectedTintColor
        
        
        let normalAttributes = [
            NSAttributedString.Key.foregroundColor: unselectedTextColor,
            NSAttributedString.Key.font: font
        ]
        let selectedAttributes = [
            NSAttributedString.Key.foregroundColor: selectedTextColor,  
            NSAttributedString.Key.font: font
        ]
        
        control.setTitleTextAttributes(normalAttributes, for: .normal)
        control.setTitleTextAttributes(selectedAttributes, for: .selected)
        
        return control
    }
    
    func updateUIView(_ uiView: UISegmentedControl, context: Context) {
        uiView.selectedSegmentIndex = selectedIndex
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    
    class Coordinator: NSObject {
        var parent: CustomSegmentedControl
        
        init(_ parent: CustomSegmentedControl) {
            self.parent = parent
        }
        
        @objc func valueChanged(_ sender: UISegmentedControl) {
            parent.selectedIndex = sender.selectedSegmentIndex
        }
    }
}
