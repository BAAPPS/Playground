//
//  CardEntitiy.swift
//  Flashzilla
//
//  Created by D F on 8/26/25.
//

import SwiftData
import SwiftUI


@Model
final class CardEntity {
    @Attribute(.unique) var id: UUID
    var prompt: String
    var answer: String

    init(prompt: String, answer: String, id: UUID = UUID()) {
        self.id = id
        self.prompt = prompt
        self.answer = answer
    }
}
