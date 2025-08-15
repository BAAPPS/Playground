//
//  SnapPagingView.swift
//  DramaBox
//
//  Created by D F on 8/15/25.
//

import SwiftUI

struct SnapPagingView<Content: View>: View {
    let pageCount: Int
    @Binding var currentPage: Int
    let content: (CGFloat, CGFloat) -> Content
    
    @GestureState private var dragOffset: CGFloat = 0
    
    var body: some View {
        GeometryReader{ geomery in
            let pageWidth = geomery.size.width
            let pageHeight = geomery.size.height
            let totalOffSet = -CGFloat(currentPage) * pageHeight + dragOffset
            
            content(pageWidth, pageHeight)
                .frame(height: pageHeight * CGFloat(pageCount), alignment: .top)
                .offset(y:totalOffSet)
                .animation(.easeInOut, value: currentPage)
                .gesture(
                    DragGesture()
                        .updating($dragOffset) { value, state, _ in
                            state = value.translation.height
                        }
                        .onEnded{ value in
                            let dragThreshold = pageHeight / 2
                            if value.translation.height < -dragThreshold && currentPage < pageCount - 1 {
                                currentPage += 1
                            }
                            else if value.translation.height > dragThreshold && currentPage > 0 {
                                currentPage -= 1
                            }
                        }
                )
            
        }
        .ignoresSafeArea()

    }
}

#Preview {
    @Previewable @State var page = 0
    SnapPagingView(pageCount: 3, currentPage: $page) {width, height in
        VStack(spacing: 0) {
            ForEach(0..<3) { index in
                ZStack {
                    Color(hue: Double(index) / 3.0, saturation: 0.8, brightness: 0.9)
                    Text("Page \(index + 1)")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.white)
                }
                .frame(width:width, height:height)
            }
        }
    }
}

