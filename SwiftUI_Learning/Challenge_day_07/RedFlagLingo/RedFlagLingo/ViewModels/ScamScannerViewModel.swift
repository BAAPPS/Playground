//
//  ScamScannerViewModel.swift
//  RedFlagLingo
//
//  Created by D F on 7/6/25.
//

import Foundation
import Observation

@Observable
class ScamScannerViewModel {
    var scamKeywordMap: ScamKeywordMap = [:]
    var scamAlertMessagesMap: [String:String] = [:]
    
    init(){
        loadScamKeywords()
        extractAlertMessages()
    }
    
    func loadScamKeywords(){
        self.scamKeywordMap = Bundle.main.decode("scamKeywords.json")
    }
    
    func extractAlertMessages(){
        self.scamAlertMessagesMap = Bundle.main.decode("alertMessages.json")
    }
    
    func scan(messageText:String) -> (scamType: String, severity: String, matchedKeywords: [String])? {
        for (scamType, data) in scamKeywordMap{
            let matches = data.keywords.filter {messageText.localizedCaseInsensitiveContains($0)}
            
            if !matches.isEmpty {
                return (scamType, data.severity, matches)
            }
        }
        return nil
    }
    
}
