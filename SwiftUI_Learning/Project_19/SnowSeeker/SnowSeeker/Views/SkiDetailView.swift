//
//  SkiDetailView.swift
//  SnowSeeker
//
//  Created by D F on 9/2/25.
//

import SwiftUI

struct SkiDetailsView: View {
    @Environment(ResortVM.self) var vm


    var body: some View {
        Group {
            VStack {
                Text("Elevation")
                    .font(.caption.bold())
                Text("\(vm.resort.elevation)m")
                    .font(.title3)
            }

            VStack {
                Text("Snow")
                    .font(.caption.bold())
                Text("\(vm.resort.snowDepth)cm")
                    .font(.title3)
            }
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    SkiDetailsView()
        .environment(ResortVM(resort: .example))
}
