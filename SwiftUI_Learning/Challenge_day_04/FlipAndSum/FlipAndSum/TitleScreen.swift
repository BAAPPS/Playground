//
//  TitleScreen.swift
//  FlipAndSum
//
//  Created by D F on 6/17/25.
//

import SwiftUI

struct HalfCircleScreen: View {
    let geometry: GeometryProxy
    let rotation: Double
    let offsetX: CGFloat
    let offsetY: CGFloat
    
    var body: some View {
        Circle()
            .fill(
                RadialGradient(
                    stops: [
                        .init(color: Color(red: 0.76, green: 0.9, blue: 0.95), location: 0.0),
                        .init(color: Color(red: 0.0, green: 0.34, blue: 0.72), location: 1.0)
                    ],
                    center: .center,
                    startRadius: 0,
                    endRadius: 1500
                )
            )
            .frame(width: geometry.size.width * 1.7, height: geometry.size.width * 1.7)
            .rotationEffect(.degrees(rotation))
            .offset(x: offsetX, y: offsetY)
    }
}



struct TitleScreen: View {
    
    @State private var isPressed = false
    @State private var navigate = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Top-Right (half visible)
                HalfCircleScreen(
                    geometry: geometry,
                    rotation: 360,
                    offsetX: 0,
                    offsetY: -geometry.size.width
                )
                
                
                // Bottom-Left (mirrored)
                HalfCircleScreen(
                    geometry: geometry,
                    rotation: 90,
                    offsetX: -geometry.size.width,
                    offsetY: geometry.size.width
                )
                
                VStack {
                    Text("Flip & Sum")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding()
                        .background(
                            RadialGradient(
                                stops: [
                                    .init(color: Color(red: 0.76, green: 0.9, blue: 0.95), location: 0.0),
                                    .init(color: Color(red: 0.0, green: 0.34, blue: 0.72), location: 1.0)
                                ],
                                center: .center,
                                startRadius: 0,
                                endRadius: 1500
                            )
                        )
                        .clipShape(.rect(cornerRadius: 5))
                        .textCase(.uppercase)
                        .foregroundColor(Color(red: 0.0, green: 0.34, blue: 0.72, opacity: 0.8))
                    
                    Button(action: {
                        isPressed = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            isPressed = false
                            navigate = true
                        }
                    }){
                        Text("Play Game")
                            .fontWeight(.semibold)
                            .padding()
                            .frame(minWidth: 130)
                            .background(isPressed ? Color(red: 0.0, green: 0.34, blue: 0.72, opacity: 0.75) : Color(red: 0.0, green: 0.34, blue: 0.72, opacity: 0.8))
                            .clipShape(.rect(cornerRadius: 10))
                            .foregroundColor(.white)
                            .scaleEffect(isPressed ? 0.95: 1)
                            .shadow(color: Color.black.opacity(0.3), radius: 6, x: 0, y: 4)
                        
                        
                    }
                    .buttonStyle(.plain)
                    .offset(y: 10)
                    .animation(.easeInOut(duration: 0.15), value: isPressed)
                    .fullScreenCover(isPresented: $navigate) {
                        GameScreen()
                    }
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
                .position(x: geometry.size.width / 2, y: geometry.size.height / 1.7)
            }
            .ignoresSafeArea()
        }
        
    }
}

#Preview {
        TitleScreen()
}
