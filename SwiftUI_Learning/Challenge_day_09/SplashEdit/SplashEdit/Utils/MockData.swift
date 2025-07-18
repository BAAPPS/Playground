//
//  MockData.swift
//  SplashEdit
//
//  Created by D F on 7/18/25.
//

import Foundation

struct MockData {
    static let mockPhoto =  UnsplashPhotosModel(
        id: "CzwL_vn445k",
        description: "Arabian Oryx walk the sands of NEOM for the first time in 100 years as part of NEOM’s nature reserve wildlife release initiative, Nature Reserve – NEOM, Saudi Arabia | The NEOM Nature Reserve region is being designed to deliver protection and restoration of biodiversity across 95% of NEOM.",
        alt_description: "an antelope standing in the middle of the desert",
        urls: UnsplashPhotosModel.PhotoURLs(
            raw: "https://images.unsplash.com/photo-1682687220247-9f786e34d472?ixid=M3w3NzgzMzh8MXwxfGFsbHwxfHx8fHx8fHwxNzUyODY2OTY5fA&ixlib=rb-4.1.0",
            full: "https://images.unsplash.com/photo-1682687220247-9f786e34d472?crop=entropy&cs=srgb&fm=jpg&ixid=M3w3NzgzMzh8MXwxfGFsbHwxfHx8fHx8fHwxNzUyODY2OTY5fA&ixlib=rb-4.1.0&q=85",
            regular: "https://images.unsplash.com/photo-1682687220247-9f786e34d472?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3NzgzMzh8MXwxfGFsbHwxfHx8fHx8fHwxNzUyODY2OTY5fA&ixlib=rb-4.1.0&q=80&w=1080",
            small: "https://images.unsplash.com/photo-1682687220247-9f786e34d472?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3NzgzMzh8MXwxfGFsbHwxfHx8fHx8fHwxNzUyODY2OTY5fA&ixlib=rb-4.1.0&q=80&w=400",
            thumb: "https://images.unsplash.com/photo-1682687220247-9f786e34d472?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3NzgzMzh8MXwxfGFsbHwxfHx8fHx8fHwxNzUyODY2OTY5fA&ixlib=rb-4.1.0&q=80&w=200",
            
        ),
        user: UnsplashPhotosModel.UnsplashUser(
            name: "NEOM",
            username: "neom",
            profile_image: UnsplashPhotosModel.UnsplashUser.ProfileImage(
                small: "https://images.unsplash.com/profile-1679489218992-ebe823c797dfimage?ixlib=rb-4.1.0&crop=faces&fit=crop&w=32&h=32",
                medium: "https://images.unsplash.com/profile-1679489218992-ebe823c797dfimage?ixlib=rb-4.1.0&crop=faces&fit=crop&w=64&h=64",
                large: "https://images.unsplash.com/profile-1679489218992-ebe823c797dfimage?ixlib=rb-4.1.0&crop=faces&fit=crop&w=128&h=128"
                
            )
        )
    )
    static let mockPhotos = [
        UnsplashPhotosModel(
            id: "twjBMeSe0Gg",
            description: "A woman by the seaside",
            alt_description: "A person walks alone on the beach.",
            urls: UnsplashPhotosModel.PhotoURLs(
                raw: "https://images.unsplash.com/photo-1741696482470-37544b32e8e6?ixid=M3w3NzgzMzh8MHwxfGFsbHwyfHx8fHx8fHwxNzUyODY2OTY5fA&ixlib=rb-4.1.0",
                full: "https://images.unsplash.com/photo-1741696482470-37544b32e8e6?crop=entropy&cs=srgb&fm=jpg&ixid=M3w3NzgzMzh8MHwxfGFsbHwyfHx8fHx8fHwxNzUyODY2OTY5fA&ixlib=rb-4.1.0&q=85",
                regular: "https://images.unsplash.com/photo-1741696482470-37544b32e8e6?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3NzgzMzh8MHwxfGFsbHwyfHx8fHx8fHwxNzUyODY2OTY5fA&ixlib=rb-4.1.0&q=80&w=1080",
                small: "https://images.unsplash.com/photo-1741696482470-37544b32e8e6?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3NzgzMzh8MHwxfGFsbHwyfHx8fHx8fHwxNzUyODY2OTY5fA&ixlib=rb-4.1.0&q=80&w=400",
                thumb: "https://images.unsplash.com/photo-1741696482470-37544b32e8e6?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3NzgzMzh8MHwxfGFsbHwyfHx8fHx8fHwxNzUyODY2OTY5fA&ixlib=rb-4.1.0&q=80&w=200"
            ),
            user: UnsplashPhotosModel.UnsplashUser(
                name: "PAN XIAOZHEN",
                username: "zhenhappy",
                profile_image: UnsplashPhotosModel.UnsplashUser.ProfileImage(
                    small: "https://images.unsplash.com/profile-1493799582036-f14b1513b3c7?ixlib=rb-4.1.0&crop=faces&fit=crop&w=32&h=32",
                    medium: "https://images.unsplash.com/profile-1493799582036-f14b1513b3c7?ixlib=rb-4.1.0&crop=faces&fit=crop&w=64&h=64",
                    large: "https://images.unsplash.com/profile-1493799582036-f14b1513b3c7?ixlib=rb-4.1.0&crop=faces&fit=crop&w=128&h=128"
                )
            )
        ),
        
        UnsplashPhotosModel(
            id: "5WPP8Pb2wsc",
            description: nil,
            alt_description: "An empty airport waiting area in black and white.",
            urls: UnsplashPhotosModel.PhotoURLs(
                raw: "https://images.unsplash.com/photo-1743291393141-0047030d2544?ixid=M3w3NzgzMzh8MHwxfGFsbHwzfHx8fHx8fHwxNzUyODY2OTY5fA&ixlib=rb-4.1.0",
                full: "https://images.unsplash.com/photo-1743291393141-0047030d2544?crop=entropy&cs=srgb&fm=jpg&ixid=M3w3NzgzMzh8MHwxfGFsbHwzfHx8fHx8fHwxNzUyODY2OTY5fA&ixlib=rb-4.1.0&q=85",
                regular: "https://images.unsplash.com/photo-1743291393141-0047030d2544?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3NzgzMzh8MHwxfGFsbHwzfHx8fHx8fHwxNzUyODY2OTY5fA&ixlib=rb-4.1.0&q=80&w=1080",
                small: "https://images.unsplash.com/photo-1743291393141-0047030d2544?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3NzgzMzh8MHwxfGFsbHwzfHx8fHx8fHwxNzUyODY2OTY5fA&ixlib=rb-4.1.0&q=80&w=400",
                thumb: "https://images.unsplash.com/photo-1743291393141-0047030d2544?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3NzgzMzh8MHwxfGFsbHwzfHx8fHx8fHwxNzUyODY2OTY5fA&ixlib=rb-4.1.0&q=80&w=200"
            ),
            user: UnsplashPhotosModel.UnsplashUser(
                name: "Antonio Groß",
                username: "angro",
                profile_image: UnsplashPhotosModel.UnsplashUser.ProfileImage(
                    small: "https://images.unsplash.com/profile-1735680577552-83a46258297c?ixlib=rb-4.1.0&crop=faces&fit=crop&w=32&h=32",
                    medium: "https://images.unsplash.com/profile-1735680577552-83a46258297c?ixlib=rb-4.1.0&crop=faces&fit=crop&w=64&h=64",
                    large: "https://images.unsplash.com/profile-1735680577552-83a46258297c?ixlib=rb-4.1.0&crop=faces&fit=crop&w=128&h=128"
                )
            )
        ),
        
        UnsplashPhotosModel(
            id: "Hqkx4vRhrIU",
            description: "By FAKURIANDESIGN",
            alt_description: "The word \"fade\" blurred over a bright orange circle.",
            urls: UnsplashPhotosModel.PhotoURLs(
                raw: "https://images.unsplash.com/photo-1744646338661-c1e6530dfef4?ixid=M3w3NzgzMzh8MHwxfGFsbHw0fHx8fHx8fHwxNzUyODY2OTY5fA&ixlib=rb-4.1.0",
                full: "https://images.unsplash.com/photo-1744646338661-c1e6530dfef4?crop=entropy&cs=srgb&fm=jpg&ixid=M3w3NzgzMzh8MHwxfGFsbHw0fHx8fHx8fHwxNzUyODY2OTY5fA&ixlib=rb-4.1.0&q=85",
                regular: "https://images.unsplash.com/photo-1744646338661-c1e6530dfef4?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3NzgzMzh8MHwxfGFsbHw0fHx8fHx8fHwxNzUyODY2OTY5fA&ixlib=rb-4.1.0&q=80&w=1080",
                small: "https://images.unsplash.com/photo-1744646338661-c1e6530dfef4?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3NzgzMzh8MHwxfGFsbHw0fHx8fHx8fHwxNzUyODY2OTY5fA&ixlib=rb-4.1.0&q=80&w=400",
                thumb: "https://images.unsplash.com/photo-1744646338661-c1e6530dfef4?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3NzgzMzh8MHwxfGFsbHw0fHx8fHx8fHwxNzUyODY2OTY5fA&ixlib=rb-4.1.0&q=80&w=200"
            ),
            user: UnsplashPhotosModel.UnsplashUser(
                name: "Milad Fakurian",
                username: "fakurian",
                profile_image: UnsplashPhotosModel.UnsplashUser.ProfileImage(
                    small: "https://images.unsplash.com/profile-1750862142281-e7e85c5b2203image?ixlib=rb-4.1.0&crop=faces&fit=crop&w=32&h=32",
                    medium: "https://images.unsplash.com/profile-1750862142281-e7e85c5b2203image?ixlib=rb-4.1.0&crop=faces&fit=crop&w=64&h=64",
                    large: "https://images.unsplash.com/profile-1750862142281-e7e85c5b2203image?ixlib=rb-4.1.0&crop=faces&fit=crop&w=128&h=128"
                )
            )
        )
    ]
}
