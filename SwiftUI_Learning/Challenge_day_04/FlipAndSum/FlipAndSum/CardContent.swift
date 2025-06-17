//
//  CardContent.swift
//  FlipAndSum
//
//  Created by D F on 6/17/25.
//

import SwiftUI

struct ImageAsset: View {
    let number: Int
    var body: some View {
        Image(systemName: "\(number).circle.fill")
            .resizable()
            .scaledToFit()
            .foregroundColor(.white)
    }
}

struct CadFront: View{
    let number: Int
    var body: some View{
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(.blue)
                .shadow(color: Color.black.opacity(0.3), radius: 6, x: 0, y: 4)
                .frame(width:200, height:220)
            
            VStack {
                HStack {
                    ImageAsset(number:number)
                        .frame(width:30, height:30)
                        .padding([.top, .leading], 10)
                        .offset(x:60, y:100)
                    
                    Spacer()
                }
                
                Spacer()
                
                ImageAsset(number:number)
                    .frame(width:60, height:60)
                
                Spacer()
                
                HStack{
                    Spacer()
                    ImageAsset(number: number)
                        .frame(width:30, height:30)
                        .padding([.bottom, .trailing], 10)
                        .rotationEffect(.degrees(180))
                        .offset(x:-60, y:-100)
                }
            }
            .frame(width:300, height:400)
        }
        .cornerRadius(12)
    }
}

struct CardBack:View{
    var body: some View{
        ZStack{
            RoundedRectangle(cornerRadius: 12)
                .fill(.blue)
                .shadow(color: Color.black.opacity(0.3), radius: 6, x: 0, y: 4)
                .frame(width:200, height:220)
            Image(systemName: "questionmark.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)
                .foregroundColor(.white)
        }
    }
}

struct CardContent: View {
    let number: Int
    @Binding var isFlipped: Bool
    
    var body: some View {
        ZStack {
            if isFlipped {
                CadFront(number: number)
            
            } else {
                CardBack()
            }
        }
    }
}

#Preview {
    CardContent(number:10, isFlipped: .constant(true))
}
