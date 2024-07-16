//
//  QuoteManager.swift
//  helloChack
//
//  Created by Ярослав  Мартынов on 02.06.2024.
//

import Foundation
import RealmSwift

struct QuoteManager {
    
    static func realmInstance() -> Realm {
        let config = Realm.Configuration(encryptionKey: getKey())
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
    
    static func getKey() -> Data {
        let keychainIdentifier = "io.Realm.EncryptionExampleKey"
        let keychainIdentifierData = keychainIdentifier.data(using: String.Encoding.utf8, allowLossyConversion: false)!
        var query: [NSString: AnyObject] = [
            kSecClass: kSecClassKey,
            kSecAttrApplicationTag: keychainIdentifierData as AnyObject,
            kSecAttrKeySizeInBits: 512 as AnyObject,
            kSecReturnData: true as AnyObject
        ]
    
        var dataTypeRef: AnyObject?
        var status = withUnsafeMutablePointer(to: &dataTypeRef) { SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0)) }
        if status == errSecSuccess {
            return dataTypeRef as! Data
        }
        var key = Data(count: 64)
        key.withUnsafeMutableBytes({ (pointer: UnsafeMutableRawBufferPointer) in
            let result = SecRandomCopyBytes(kSecRandomDefault, 64, pointer.baseAddress!)
            assert(result == 0, "Failed to get random bytes")
        })
        // Store the key in the keychain
        query = [
            kSecClass: kSecClassKey,
            kSecAttrApplicationTag: keychainIdentifierData as AnyObject,
            kSecAttrKeySizeInBits: 512 as AnyObject,
            kSecValueData: key as AnyObject
        ]
        status = SecItemAdd(query as CFDictionary, nil)
        assert(status == errSecSuccess, "Failed to insert the new key in the keychain")
        return key
    }
}

