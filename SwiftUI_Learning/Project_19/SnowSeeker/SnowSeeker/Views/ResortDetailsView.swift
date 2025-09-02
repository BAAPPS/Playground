//
//  ResortDetailView.swift
//  SnowSeeker
//
//  Created by D F on 9/2/25.
//

import SwiftUI

struct ResortDetailsView: View {
    @Environment(ResortVM.self) var vm


    var body: some View {
        Group {
            VStack {
                Text("Size")
                    .font(.caption.bold())
                Text(vm.size)
                    .font(.title3)
            }

            VStack {
                Text("Price")
                    .font(.caption.bold())
                Text(vm.price)
                    .font(.title3)
            }
        }
        .frame(maxWidth: .infinity)
    }

}

#Preview {
    ResortDetailsView()
        .environment(ResortVM(resort: .example))
}
