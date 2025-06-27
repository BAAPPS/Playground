//
//  Order.swift
//  CupcakeCorner
//
//  Created by D F on 6/27/25.
//

import Foundation
import SwiftUI

struct OrderResponse: Codable {
    let id: String
    let createdAt: String
    let name: String
    let type: Int
    let specialRequestEnabled: Bool
    let streetAddress: String
    let zip: String
    let extraFrosting: Bool
    let addSprinkles: Bool
    let quantity: Int
    let city: String
}


@Observable
class OrderModel: Codable {
    enum CodingKeys: String, CodingKey {
        case _type = "type"
        case _quantity = "quantity"
        case _specialRequestEnabled = "specialRequestEnabled"
        case _extraFrosting = "extraFrosting"
        case _addSprinkles = "addSprinkles"
        case _name = "name"
        case _city = "city"
        case _streetAddress = "streetAddress"
        case _zip = "zip"
    }

    static let types = ["Vanilla", "Strawberry", "Chocolate", "Rainbow"]

    var type = 0
    var quantity = 3

    var specialRequestEnabled = false {
        didSet {
            if specialRequestEnabled == false {
                extraFrosting = false
                addSprinkles = false
            }
        }
    }

    var extraFrosting = false
    var addSprinkles = false

    var name = ""
    var streetAddress = ""
    var city = ""
    var zip = ""

    var hasValidAddress: Bool {
        // Trim whitespaces and newlines, then check for emptiness
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedStreet = streetAddress.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedCity = city.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedZip = zip.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimmedName.isEmpty || trimmedStreet.isEmpty || trimmedCity.isEmpty || trimmedZip.isEmpty {
            return false
        }
        return true
    }

    var cost: Decimal {
        // $2 per cake
        var cost = Decimal(quantity) * 2

        // complicated cakes cost more
        cost += Decimal(type) / 2

        // $1/cake for extra frosting
        if extraFrosting {
            cost += Decimal(quantity)
        }

        // $0.50/cake for sprinkles
        if addSprinkles {
            cost += Decimal(quantity) / 2
        }

        return cost
    }
}

extension OrderModel {
    private static let saveKey = "SavedOrder"

    func save() {
        if let encoded = try? JSONEncoder().encode(self) {
            UserDefaults.standard.set(encoded, forKey: Self.saveKey)
        }
    }

    static func load() -> OrderModel {
        if let savedData = UserDefaults.standard.data(forKey: saveKey),
           let decodedOrder = try? JSONDecoder().decode(OrderModel.self, from: savedData) {
            return decodedOrder
        }
        return OrderModel() // return default if no saved data
    }
}
