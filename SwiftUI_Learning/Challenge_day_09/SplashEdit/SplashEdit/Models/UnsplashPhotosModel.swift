//
//  UnsplashPhotosModel.swift
//  SplashEdit
//
//  Created by D F on 7/15/25.
//

import Foundation
import Observation

@Observable
class UnsplashPhotosModel: Codable, Identifiable{
    let id: String
    let description: String?
    let alt_description: String?
    let urls: PhotoURLs
    let user: UnsplashUser
    
    struct PhotoURLs: Codable {
        let raw: String
        let full: String
        let regular: String
        let small: String
        let thumb: String
    }
    struct UnsplashUser: Codable {
            let name: String
            let username: String
            let profile_image: ProfileImage

            struct ProfileImage: Codable {
                let small: String
                let medium: String
                let large: String
            }
        }
}
