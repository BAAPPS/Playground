//
//  RestaurantStepView.swift
//  TrackBite
//
//  Created by D F on 7/28/25.
//

import SwiftUI

struct RestaurantStepView: View {
    @Environment(RestaurantVM.self) var restaurantVM
    let step: RestaurantOnboardingStep
    var onNext: () -> Void = {}
    var body: some View {
        Group{
            switch step {
            case .restaurantLocationInfo:
                RestaurantLocationView(step:step, onNext: onNext)
                
            case .restaurantStoreInfo:
                RestaurantStoreView(step: step, onNext: onNext)
                
            case .summary:
                RestaurantSummaryView(step: step, onNext: onNext)
            }
        }
        .onboardingNavigation(title: step.title, progress: step.progressText)
    }
}

#Preview {
    let restaurantVM = RestaurantVM(
       restaurantModel: RestaurantModel(
           id: UUID(),
           name: "",
           description: nil,
           imageURL: nil,
           address: "",
           latitude: 0.0,
           longitude: 0.0,
           phone: nil,
           website: nil,
           ownerID: UUID(),
           createdAt: Date()
       )
   )
    RestaurantStepView(step: .restaurantLocationInfo, onNext: {})
        .environment(restaurantVM)
}
