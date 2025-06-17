//
//  FlipCardView.swift
//  FlipAndSum
//
//  Created by D F on 6/17/25.
//

import SwiftUI

struct FlipCardView: View {
    let number: Int
    @Binding var isFlipped: Bool
    var onFlip: (() -> Void)? = nil
    var body: some View {
        CardContent(number: number, isFlipped: $isFlipped)
            .onTapGesture {
                if !isFlipped{
                    withAnimation(.easeInOut(duration:0.5)){
                        isFlipped = true
                    }
                    
                    onFlip?() 
                }
            }
            .rotation3DEffect(.degrees(isFlipped ? 360 : 0), axis: (x:0, y:1, z:0))
    }
}

#Preview {
    FlipCardView(number: 10, isFlipped: .constant(true))
}
