//
//  ScamDefinition.swift
//  RedFlagLingo
//
//  Created by D F on 7/6/25.
//

import Foundation

struct ScamDefinitionModel: Codable {
    let severity: String
    let keywords: [String]
}

typealias ScamKeywordMap = [String: ScamDefinitionModel]
