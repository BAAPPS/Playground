//
//  RestaurantNameDescriptionView.swift
//  TrackBite
//
//  Created by D F on 7/28/25.
//

import SwiftUI
import Kingfisher

struct RestaurantStoreView: View {
    @Environment(RestaurantVM.self) var restaurantVME
    var step: RestaurantOnboardingStep = .restaurantStoreInfo
    var onNext: () -> Void
    var body: some View {
        @Bindable var restaurantVM = restaurantVME
        VStack(spacing: 24) {
            ScrollView {
                if let urlString = restaurantVM.imageURL,
                   let url = URL(string: urlString),
                   !urlString.isEmpty {
                    Group {
                        KFImage(url)
                            .placeholder {
                                Image(systemName: "photo")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(.gray)
                                    .opacity(0.5)
                            }
                            .onFailure { error in
                                print("Kingfisher failed to load image: \(error)")
                            }
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity)
                            .padding(.top, 110)
                    }
                }
                
                VStack(spacing: 24) {
                    Text("Restaurant Details")
                        .font(.headline)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                        .padding(.top, 60)
                        .foregroundColor(.offWhite)
                    
                    HStack(spacing: 16) {
                        LabeledTextFieldView(label:"Restaurant Name", text:$restaurantVM.name)
                        
                        LabeledTextFieldView(label: "Phone Number", text: Binding(
                            get: { restaurantVM.phone ?? "" },
                            set: { restaurantVM.phone = $0 }
                        ))
                        
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    
                    LabeledTextFieldView(label: "Description", text: Binding(
                        get: { restaurantVM.description ?? "" },
                        set: { restaurantVM.description = $0 }
                    ))  .frame(maxWidth: .infinity, alignment: .center)
                    
                    
                    LabeledTextFieldView(label: "Upload Image String", text: Binding(
                        get: { restaurantVM.imageURL ?? "" },
                        set: { restaurantVM.imageURL = $0 }
                    ))  .frame(maxWidth: .infinity, alignment: .center)
                    
                    Spacer()
                }
                .padding(15)
                .frame(minHeight: UIScreen.main.bounds.height)
                .listRowBackground(Color.clear)
                .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                
            }
            .scrollContentBackground(.hidden)
            .frame(maxHeight: .infinity)
            
            Button(action: {
                onNext()
            }) {
                Text("Next")
                    .bold()
                    .foregroundColor(Color(hex:"#801c20"))
                    .frame(maxWidth: 100)
                    .padding()
                    .background(Color(hex: "#fee2e3"))
                    .cornerRadius(10)
                    .padding(.horizontal)
                    .shadow(color: Color.black.opacity(0.25), radius: 10, x: 0, y: 5)
                
            }
            
            
            Spacer()
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .bodyBackground()
    }
}

#Preview {
    let restaurantVM = RestaurantVM(
        restaurantModel: RestaurantModel(
            id: UUID(),
            name: "",
            description: nil,
            imageURL: "https://plus.unsplash.com/premium_photo-1661953124283-76d0a8436b87?q=80&w=2688&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
            address: "",
            latitude: 0.0,
            longitude: 0.0,
            phone: nil,
            website: nil,
            ownerID: UUID(),
            createdAt: Date()
        )
    )
    NavigationStack {
        RestaurantStoreView(step: .restaurantStoreInfo, onNext: {})
            .environment(restaurantVM)
    }
}
