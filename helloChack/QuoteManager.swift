//
//  QuoteManager.swift
//  helloChack
//
//  Created by Ярослав  Мартынов on 02.06.2024.
//

import Foundation
import RealmSwift


struct QuoteManager {
    
    static func addItem(quote: Quote) {
        let realm = try! Realm()

        try! realm.write {
            realm.add(QuoteRealm(quote: quote))
        }
    }
    
    
    static func allQuote() -> [QuoteRealm]{
        let realm = try! Realm()
        
        let quotesRealm = realm.objects(QuoteRealm.self)
        return quotesRealm.map({$0})
        
    }
    
    static func getAllCategory() -> [String]{
        let realm = try! Realm()
        
        let quotesRealm = realm.objects(QuoteRealm.self).map({$0})
        var allCategory = [String]()
        quotesRealm.forEach({quotes in
            quotes.categories.forEach({category in
                allCategory.append(category)
            })
        })
        allCategory.append("no Category")
        return Array(Set(allCategory))
        
    }
    
    static func getQuoteForCategory(category: String) -> [QuoteRealm]{
        
        
        let realm = try! Realm()
        
        let quotesRealm = realm.objects(QuoteRealm.self)
        let allQuoteRealm = quotesRealm.filter({
            if(category == "no Category"){
                $0.categories.isEmpty
            }else{
                $0.categories.contains(category)
            }
        })
        


        
        return allQuoteRealm.map({$0})
        
    }
    
    
    
}
