//
//  KeychainManager.swift
//  TrackBite
//
//  Created by D F on 7/25/25.
//

import Foundation
import Security

struct KeychainManager {
    static func save(key:String, value:String) -> Bool {
        if let data = value.data(using: .utf8) {
            let query = [kSecClass:kSecClassGenericPassword, kSecAttrAccount: key] as CFDictionary
            SecItemDelete(query)
            
            let attributes = [kSecClass:kSecClassGenericPassword, kSecAttrAccount: key, kSecValueData: data] as CFDictionary
            
            return SecItemAdd(attributes, nil) == errSecSuccess
        }
        return false
    }
    
    static func load(key:String) -> String? {
        let query = [kSecClass:kSecClassGenericPassword, kSecAttrAccount: key, kSecReturnData: true, kSecMatchLimit: kSecMatchLimitOne] as CFDictionary
        
        var result: AnyObject?
        
        if SecItemCopyMatching(query, &result) == errSecSuccess, let data = result as? Data, let value = String(data:data, encoding: .utf8) {
            return value
        }
        
        return nil
    }
    
    static func delete(key:String){
        let query = [kSecClass: kSecClassGenericPassword,
               kSecAttrAccount: key] as CFDictionary
        SecItemDelete(query)
    }
}
