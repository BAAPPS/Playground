//
//  Environment.swift
//  TrackBite
//
//  Created by D F on 8/1/25.
//

import SwiftUI
import SwiftData

private struct SupabaseAuthVMKey: EnvironmentKey {
    static let defaultValue: Bindable<SupabaseAuthVM>? = nil
}




extension EnvironmentValues {
    var supabaseAuthVM: Bindable<SupabaseAuthVM>? {
        get { self[SupabaseAuthVMKey.self] }
        set { self[SupabaseAuthVMKey.self] = newValue }
    }
}


