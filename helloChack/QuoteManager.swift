//
//  QuoteManager.swift
//  helloChack
//
//  Created by Ярослав  Мартынов on 02.06.2024.
//

import Foundation
import RealmSwift

struct QuoteManager {
    static let encryptionKey: Data = {
        
        var keyData = Data(count: 64)
           _ = keyData.withUnsafeMutableBytes { bytes in
               SecRandomCopyBytes(kSecRandomDefault, 64, bytes.baseAddress!)
           }
    
        return keyData
    }()
    
    static func realmInstance() -> Realm {
        let config = Realm.Configuration(encryptionKey: encryptionKey)
        return try! Realm(configuration: config)
    }

    static func addItem(quote: Quote) {
        let realm = realmInstance()
        
        try! realm.write {
            realm.add(QuoteRealm(quote: quote))
        }
    }
    
    static func allQuote() -> [QuoteRealm] {
        let realm = realmInstance()
        
        let quotesRealm = realm.objects(QuoteRealm.self)
        return quotesRealm.map({ $0 })
    }
    
    static func getAllCategory() -> [String] {
        let realm = realmInstance()
        
        let quotesRealm = realm.objects(QuoteRealm.self).map({ $0 })
        var allCategory = [String]()
        quotesRealm.forEach({ quotes in
            quotes.categories.forEach({ category in
                allCategory.append(category)
            })
        })
        allCategory.append("no Category")
        return Array(Set(allCategory))
    }
    
    static func getQuoteForCategory(category: String) -> [QuoteRealm] {
        let realm = realmInstance()
        
        let quotesRealm = realm.objects(QuoteRealm.self)
        let allQuoteRealm = quotesRealm.filter({
            if category == "no Category" {
                return $0.categories.isEmpty
            } else {
                return $0.categories.contains(category)
            }
        })
        
        return allQuoteRealm.map({ $0 })
    }
}
