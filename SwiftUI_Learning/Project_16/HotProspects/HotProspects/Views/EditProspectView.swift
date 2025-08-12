//
//  EditProspectView.swift
//  HotProspects
//
//  Created by D F on 8/12/25.
//

import SwiftUI
import SwiftData

struct EditProspectView: View {
    @Bindable var prospect: ProspectModel
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    var body: some View {
        Form {
            TextField("Name", text: $prospect.name)
            TextField("Email", text: $prospect.emailAddress)
            Toggle("Contacted", isOn: $prospect.isContacted)
        }
        .navigationTitle("Edit Prospect")
        .toolbar {
            Button("Save") {
                // Changes are automatically saved to the model context because
                // prospect is @Observable and we're editing its properties via bindings
                dismiss()
            }
        }
    }
}

#Preview {
    EditProspectView(prospect: ProspectModel(name: "dee", emailAddress: "dee@baapps.com", isContacted: true))
}
