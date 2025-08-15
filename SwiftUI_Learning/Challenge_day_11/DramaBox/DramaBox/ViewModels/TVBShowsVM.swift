//
//  TVBShowsVM.swift
//  DramaBox
//
//  Created by D F on 8/12/25.
//

import Foundation
import SwiftSoup

@Observable
class TVBShowsVM {
    
    private let baseURL = URL(string: "https://tvbanywherena.com")!
    private let showsPath = "/english"
    
    // MARK: - Public API
    
    func fetchAndParseShows() async throws -> [String: [(title: String, url: URL, imageURL: URL)]] {
        let url = baseURL.appendingPathComponent(showsPath)
        let html = try await fetchHTML(from: url)
        let doc = try SwiftSoup.parse(html)
        
        let categoryHeaders = try doc.select("div.container.section-header")
        var categorizedShows: [String: [(title: String, url: URL, imageURL: URL)]] = [:]
        
        for header in categoryHeaders.array() {
            let categoryTitle = try header.select("h3").text()
            var shows: [(title: String, url: URL, imageURL: URL)] = []
            
            // Extract shows from next sibling container
            if let showContainer = try header.nextElementSibling() {
                shows.append(contentsOf: try extractShows(from: showContainer))
            }
            
            // Check for "More >>" link and fetch additional shows if available
            if let moreHref = try? header.select("h4 a").first()?.attr("href"),
               !moreHref.isEmpty,
               let moreURL = URL(string: moreHref, relativeTo: baseURL) {
                let moreHTML = try await fetchHTML(from: moreURL)
                let moreDoc = try SwiftSoup.parse(moreHTML)
                if let moreShowsContainer = try moreDoc.select("div.drama-section").first() {
                    shows.append(contentsOf: try extractShows(from: moreShowsContainer))
                }
            }
            
            // Remove duplicates by URL
            var uniqueShows = [URL: (String, URL)]()
            for show in shows {
                uniqueShows[show.url] = (show.title, show.imageURL)
            }
            
            categorizedShows[categoryTitle] = uniqueShows.map { (url, value) in
                (title: value.0, url: url, imageURL: value.1)
            }
        }
        
        return categorizedShows
    }
    
    func fetchAndParseShowDetails(from url: URL) async throws -> ShowDetails {
        let html = try await fetchHTML(from: url)
        let doc = try SwiftSoup.parse(html)
        
        guard let topDiv = try doc.select("div.top-div").first() else {
            throw NSError(domain: "HTML parsing", code: 3,
                          userInfo: [NSLocalizedDescriptionKey: "top-div not found"])
        }
        
        let thumbImageURL = try makeURL(from: try topDiv.select("div.thumb-div img").attr("src"))
        let bannerImageURL = try makeURL(from: try topDiv.select("div.banner-div img").attr("src"))
        let infoDiv = try topDiv.select("div.info-div").first()!
        
        let title = try infoDiv.select("h1").text()
        let subtitle = try infoDiv.select("h4").first()?.text() ?? ""
        let schedule = try infoDiv.select("h4").get(1).text()
        
        let genres = try extractButtonsText(from: infoDiv, withTitle: "Genre")
        let cast = try extractButtonsText(from: infoDiv, withTitle: "Cast")
        let year = try extractButtonsText(from: infoDiv, withTitle: "Year").first ?? ""
        let description = try infoDiv.select("div.info-description").text()
        
        let episodes = try extractEpisodes(from: doc)
        
        return ShowDetails(
            schedule: schedule,
            subtitle: subtitle,
            genres: genres,
            year: year,
            description: description,
            thumbImageURL: thumbImageURL.absoluteString,
            cast: cast,
            title: title,
            bannerImageURL: bannerImageURL.absoluteString,
            episodes: episodes
        )

    }
    
    func fetchAllShowDetailsAndSave() async -> [ShowDetails] {
        do {
            let categorizedShows = try await fetchAndParseShows()
            
            // Load saved details and build a set of saved URLs
            let savedDetails = loadShowDetailsLocally() ?? []
            let savedTitles = Set(savedDetails.map { $0.title.lowercased().trimmingCharacters(in: .whitespacesAndNewlines) })
            
            
            var allDetails = savedDetails
            
            // Concurrency: fetch details in parallel
            try await withThrowingTaskGroup(of: ShowDetails?.self) { group in
                for (_, shows) in categorizedShows {
                    for show in shows {
                        if savedTitles.contains(show.title.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)) {
                            // Skip already saved shows
                            continue
                        }
                        group.addTask {
                            do {
                                return try await self.fetchAndParseShowDetails(from: show.url)
                            } catch {
                                print("❌ Failed to fetch details for \(show.title): \(error)")
                                return nil
                            }
                        }
                    }
                }
                
                for try await detail in group {
                    if let detail = detail {
                        allDetails.append(detail)
                        print("✅ Fetched details for: \(detail.title)")
                    }
                }
            }
            
            saveShowDetailsLocally(allDetails)
            print("✅ Saved all show details locally, total: \(allDetails.count) shows")
            
            return allDetails
            
        } catch {
            print("Failed to fetch shows or save details: \(error)")
            return []
        }
    }
    
    func saveShowDetailsLocally(_ showDetails: [ShowDetails], fileName: String = "ShowDetails.json") {
        let saver = SaveDataLocallyVM<ShowDetails>(fileName: fileName)
        do {
            try saver.saveLocally(showDetails)
        } catch {
            print("Failed to save locally: \(error)")
        }
    }
    
    func loadShowDetailsLocally(fileName: String = "ShowDetails.json") -> [ShowDetails]? {
        let saver = SaveDataLocallyVM<ShowDetails>(fileName: fileName)
        do {
            return try saver.loadLocally()
        } catch {
            print("Failed to load show details: \(error)")
            return nil
        }
    }
    
    
    // MARK: - Private Helpers
    
    private func fetchHTML(from url: URL) async throws -> String {
        let request = URLRequest(url: url, timeoutInterval: 15)
        let (data, _) = try await URLSession.shared.data(for: request)
        guard let html = String(data: data, encoding: .utf8) else {
            throw NSError(domain: "Failed to decode HTML", code: 2)
        }
        return html
    }
    
    private func extractShows(from container: Element) throws -> [(title: String, url: URL, imageURL: URL)] {
        var shows: [(String, URL, URL)] = []
        let dramas = try container.select("div.drama")
        
        for drama in dramas.array() {
            guard
                let aTag = try? drama.select("a").first(),
                let href = try? aTag.attr("href"),
                let url = URL(string: href, relativeTo: baseURL),
                let title = try? aTag.select("div.title").text(),
                !title.isEmpty
            else { continue }
            
            var imageURL: URL
            if let img = try? drama.select("img").first(),
               let src = try? img.attr("src"),
               let imgURL = URL(string: src, relativeTo: baseURL) {
                imageURL = imgURL
            } else {
                imageURL = URL(string: "https://via.placeholder.com/150")!
            }
            
            shows.append((title, url, imageURL))
        }
        
        return shows
    }
    
    private func extractButtonsText(from infoDiv: Element, withTitle title: String) throws -> [String] {
        guard
            let parent = try infoDiv.select("td.info-table-title:contains(\(title))").first()?.parent()
        else { return [] }
        
        let buttons = try parent.select("td.info-table-val button")
        return try buttons.array().map { try $0.text() }
    }
    
    private func extractEpisodes(from doc: Document) throws -> [Episode] {
        var episodes: [Episode] = []
        if let episodeDiv = try doc.select("div.episodeDiv").first() {
            let items = try episodeDiv.select("div.item.nopadding")
            for item in items.array() {
                let aTag = try item.select("a").first()
                let epUrl = try aTag?.attr("href") ?? ""
                let epTitle = try aTag?.select("div.episodeName").text() ?? ""
                let epThumb = try aTag?.select("img").attr("src") ?? ""
                
                guard let episodeURL = URL(string: epUrl, relativeTo: baseURL) else { continue }
                
                episodes.append(Episode(
                    title: epTitle,
                    url: episodeURL.absoluteString,
                    thumbnailURL: epThumb))
            }
        }
        return episodes
    }
    
    private func makeURL(from string: String) throws -> URL {
        if let url = URL(string: string), url.scheme != nil {
            return url
        }
        guard let url = URL(string: string, relativeTo: baseURL) else {
            throw NSError(domain: "Invalid URL", code: 4)
        }
        return url
    }
}
