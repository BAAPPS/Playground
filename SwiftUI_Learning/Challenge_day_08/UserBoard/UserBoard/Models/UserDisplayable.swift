//
//  UserDisplayable.swift
//  UserBoard
//
//  Created by D F on 7/13/25.
//

import Foundation

protocol UserDisplayable: Identifiable {
    var username: String { get }
    var createdAt: Date { get }
}
