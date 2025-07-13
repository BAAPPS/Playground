//
//  NavBarAppearance.swift
//  UserBoard
//
//  Created by D F on 7/13/25.
//

import Foundation
import UIKit

func setUpNavBarAppearance() {
    let appearance = UINavigationBarAppearance()
    appearance.configureWithOpaqueBackground()
    appearance.backgroundEffect = UIBlurEffect(style: .systemMaterial)
    appearance.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
    appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
    
    UINavigationBar.appearance().standardAppearance = appearance
    UINavigationBar.appearance().scrollEdgeAppearance = appearance
    UINavigationBar.appearance().prefersLargeTitles = true
}
