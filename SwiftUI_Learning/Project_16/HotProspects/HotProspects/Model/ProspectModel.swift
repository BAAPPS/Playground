//
//  ProspectModel.swift
//  HotProspects
//
//  Created by D F on 8/12/25.
//

import SwiftData

@Model
class ProspectModel {
    var name: String
    var emailAddress: String
    var isContacted: Bool
    
    init(name: String, emailAddress: String, isContacted: Bool) {
        self.name = name
        self.emailAddress = emailAddress
        self.isContacted = isContacted
    }
}
