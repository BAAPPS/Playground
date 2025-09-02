//
//  ResortVM.swift
//  SnowSeeker
//
//  Created by D F on 9/2/25.
//

import Foundation


@Observable
class ResortVM {
    let resort: Resort

     init(resort: Resort) {
         self.resort = resort
     }
    
    var size: String {
        switch resort.size {
        case 1: return "Small"
        case 2: return "Average"
        default: return "Large"
        }
    }
    
    var price: String {
        String(repeating: "$", count: resort.price)
    }

}
