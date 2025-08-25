//
//  CombinedViewModel.swift
//  DramaBox
//
//  Created by D F on 8/12/25.
//

import Foundation
import Supabase
import UserNotifications


@MainActor
@Observable
class CombinedViewModel {
    let tvbShowsVM = TVBShowsVM()
    let showSQLVM = ShowSQLViewModel()
    
    /// Fetch all shows (cached + online) for UI consumption
    func fetchMergedShows(isOnline: Bool) async -> [ShowDisplayable] {
        // Load cached SQL shows
        var sqlShows = showSQLVM.loadCachedShowsDirectly()
        
        // Update online shows if online
        if isOnline {
            await showSQLVM.loadOnlineShows() // fetch fresh online shows + cache
            sqlShows = showSQLVM.shows
        }
        
        // 3️⃣ Load local TVB shows
        let tvbLocal = tvbShowsVM.loadShowDetailsLocally() ?? []
        var localDict: [String: ShowDetails] = Dictionary(uniqueKeysWithValues: sqlShows.map { ($0.id, $0) })
        
        for show in tvbLocal {
            let details = show.asShowDetails()
            if let old = localDict[show.id] {
                let mergedEpisodes = (details.episodes ?? []) + (old.episodes ?? [])
                localDict[show.id] = ShowDetails(
                    schedule: details.schedule,
                    subtitle: details.subtitle,
                    genres: details.genres,
                    year: details.year,
                    description: details.description,
                    thumbImageURL: details.thumbImageURL,
                    cast: details.cast,
                    title: details.title,
                    bannerImageURL: details.bannerImageURL,
                    episodes: Array(Set(mergedEpisodes))
                )
            } else {
                localDict[show.id] = details
            }
        }
        
        return Array(localDict.values)
    }
    
    
    func scrapeAndUploadNewShows(isOnline: Bool) async -> Result<String, Error> {
        guard isOnline else { return .success("📴 Offline, skipping upload") }
        
        //  Fetch existing merged shows
        let existingShows = await fetchMergedShows(isOnline: true)
        let existingIDs = Set(existingShows.map { $0.id })
        
        // Fetch all scraped shows
        let allScraped = await tvbShowsVM.fetchAllShowDetailsAndSave()
        let newShows = allScraped.filter { !existingIDs.contains($0.id) }
        let existingScraped = allScraped.filter { existingIDs.contains($0.id) }
        
        var resultMessage = ""
        
        // Collect new episodes and shows for notifications
        var newEpisodesForNotifications: [(Episode, String)] = []
        var concreteNewShows: [ShowDetails] = []
        
        // 4️⃣ Upload new shows + episodes
        if !newShows.isEmpty {
            let inserts = newShows.map { show in
                (show: ShowDetails.Insert(
                    title: show.title,
                    subtitle: show.subtitle ?? "",
                    schedule: show.schedule,
                    genres: show.genres,
                    cast: show.cast,
                    year: show.year,
                    description: show.description,
                    thumb_image_url: show.thumbImageURL,
                    banner_image_url: show.bannerImageURL
                ), episodes: show.episodes)
            }
            
            let result = await showSQLVM.uploadShows(inserts)
            switch result {
            case .success(let msg):
                resultMessage += msg + "\n"
                // Add episodes for notifications
                for show in newShows {
                    if let concreteShow = show as? ShowDetails {
                        concreteNewShows.append(concreteShow)
                        if let episodes = concreteShow.episodes {
                            for ep in episodes {
                                newEpisodesForNotifications.append((ep, concreteShow.title))
                            }
                        }
                    }
                }
                
            case .failure(let err):
                resultMessage += "Failed: \(err)\n"
            }
        }
        
        // 5️⃣ Update episodes for existing shows
        for show in existingScraped {
            let existingTitles = try? await showSQLVM.fetchEpisodesByShowTitle(title: show.title, year: show.year)
            let missingEpisodes = (show.episodes ?? []).filter { !(existingTitles ?? []).contains($0.title) }
            if !missingEpisodes.isEmpty {
                let result = await showSQLVM.uploadShows([
                    (
                        show: ShowDetails.Insert(
                            title: show.title,
                            subtitle: show.subtitle ?? "",
                            schedule: show.schedule,
                            genres: show.genres,
                            cast: show.cast,
                            year: show.year,
                            description: show.description,
                            thumb_image_url: show.thumbImageURL,
                            banner_image_url: show.bannerImageURL
                        ),
                        episodes: missingEpisodes
                    )
                ])
                switch result {
                case .success(let message):
                    print("⬆️ Upload succeeded:", message)
                    for ep in missingEpisodes {
                        newEpisodesForNotifications.append((ep, show.title))
                    }
                case .failure(let error):
                    print("❌ Upload failed:", error.localizedDescription)
                }
            }
        }
        
        // 6️⃣ Trigger all notifications at once
        if !concreteNewShows.isEmpty || !newEpisodesForNotifications.isEmpty {
            notifyNewShowsAndEpisodes(newShows: concreteNewShows, newEpisodes: newEpisodesForNotifications)
        }
        
        return .success(resultMessage.isEmpty ? "No new shows or episodes" : resultMessage)
    }
    
    
    @MainActor
    func requestNotificationPermission() async {
        let granted = await withCheckedContinuation { continuation in
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
                if let error = error {
                    print("❌ Notification permission error:", error)
                } else {
                    print("✅ Notification permission granted:", granted)
                }
                continuation.resume(returning: granted)
            }
        }
        
        if granted {
            let content = UNMutableNotificationContent()
            content.title = "Welcome to DramaBox!"
            content.body = "You're all set to get notified about new shows and episodes."
            content.sound = .default
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            let request = UNNotificationRequest(identifier: "welcome-notification", content: content, trigger: trigger)
            
            do {
                try await UNUserNotificationCenter.current().add(request)
                print("✅ Notification scheduled")
                
                // Debug log: check pending requests
                let pending = await UNUserNotificationCenter.current().pendingNotificationRequests()
                for req in pending {
                    print("📌 Pending notification:", req.identifier, req.content.title, req.content.body)
                }
                
                // Delivered notifications 
                let delivered = await UNUserNotificationCenter.current().deliveredNotifications()
                for notif in delivered {
                    print("📬 Delivered:", notif.request.identifier, notif.request.content.title)
                }
                
            } catch {
                print("❌ Failed to schedule notification:", error)
            }
        }
    }
    
    
    
    @MainActor
    func notifyNewShowsAndEpisodes(newShows: [ShowDetails], newEpisodes: [(Episode, String)]) {
        let center = UNUserNotificationCenter.current()
        
        // Notify for new shows
        for show in newShows {
            let content = UNMutableNotificationContent()
            content.title = "New Show Added!"
            content.body = "\(show.title) (\(show.year)) is now available."
            content.sound = .default
            
            // Unique ID: show-id + timestamp
            let uniqueID = "show-\(show.id)-\(Int(Date().timeIntervalSince1970))"
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
            let request = UNNotificationRequest(identifier: uniqueID, content: content, trigger: trigger)
            center.add(request)
        }
        
        // Notify for new episodes
        for (episode, showTitle) in newEpisodes {
            let content = UNMutableNotificationContent()
            content.title = "New Episode Released!"
            content.body = "\(episode.title) of \(showTitle) is now available."
            content.sound = .default
            
            // Unique ID: episode-title + show-title + timestamp, sanitized
            let sanitizedTitle = episode.title.replacingOccurrences(of: " ", with: "-")
            let sanitizedShow = showTitle.replacingOccurrences(of: " ", with: "-")
            let uniqueID = "episode-\(sanitizedShow)-\(sanitizedTitle)-\(Int(Date().timeIntervalSince1970))"
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
            let request = UNNotificationRequest(identifier: uniqueID, content: content, trigger: trigger)
            center.add(request)
        }
    }
    
    
}
