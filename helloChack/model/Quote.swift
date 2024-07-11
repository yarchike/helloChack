//
//  Quotes.swift
//  helloChack
//
//  Created by Ярослав  Мартынов on 02.06.2024.
//

import Foundation
import RealmSwift

struct Quote: Codable {
    let categories: [String]
    let createdAt: String
    let iconURL: String
    let id, updatedAt: String
    let url: String
    let value: String

    enum CodingKeys: String, CodingKey {
        case categories
        case createdAt = "created_at"
        case iconURL = "icon_url"
        case id
        case updatedAt = "updated_at"
        case url, value
    }
}

class QuoteRealm: Object{
    @Persisted var categories: List<String>
    @Persisted var createdAt: String
    @Persisted var iconURL: String
    @Persisted var id: String
    @Persisted var updatedAt: String
    @Persisted var url: String
    @Persisted var value: String
    
    init(quote: Quote){
        let list = List<String>()
        list.append(objectsIn: quote.categories)
        self.categories = list
        self.createdAt = quote.createdAt
        self.iconURL = quote.iconURL
        self.id = quote.id
        self.updatedAt = quote.updatedAt
        self.url = quote.url
        self.value = quote.value
    }
    override init(){}
}




