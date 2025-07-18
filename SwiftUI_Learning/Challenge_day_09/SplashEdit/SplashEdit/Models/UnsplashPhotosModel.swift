//
//  UnsplashPhotosModel.swift
//  SplashEdit
//
//  Created by D F on 7/15/25.
//

import Foundation
import Observation

@Observable
class UnsplashPhotosModel: Identifiable, Codable {
    let id: String
    let description: String?
    let alt_description: String?
    let urls: PhotoURLs
    let user: UnsplashUser
    
    init(id: String, description: String?, alt_description: String?, urls: PhotoURLs, user: UnsplashUser) {
        self.id = id
        self.description = description
        self.alt_description = alt_description
        self.urls = urls
        self.user = user
    }

    enum CodingKeys: String, CodingKey {
        case id
        case description
        case alt_description
        case urls
        case user
    }

    struct PhotoURLs: Codable {
        let raw: String
        let full: String
        let regular: String
        let small: String
        let thumb: String

        enum CodingKeys: String, CodingKey {
            case raw
            case full
            case regular
            case small
            case thumb
        }
    }

    struct UnsplashUser: Codable {
        let name: String
        let username: String
        let profile_image: ProfileImage

        enum CodingKeys: String, CodingKey {
            case name
            case username
            case profile_image
        }

        struct ProfileImage: Codable {
            let small: String
            let medium: String
            let large: String

            enum CodingKeys: String, CodingKey {
                case small
                case medium
                case large
            }
        }
    }
}

