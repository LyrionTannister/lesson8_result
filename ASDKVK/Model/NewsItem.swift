//
//  NewsItem.swift
//  ASDKVK
//
//  Created by user on 24/04/2019.
//  Copyright © 2019 Morizo Digital. All rights reserved.
//

import Foundation
import SwiftyJSON

class NewsItem {
    enum CellType {
        case header(author: NewsSource)
        case photo(photo: Photo)
        case gif(gif: GIF)
    }
    
    var displayedNodes: [CellType] {
        guard let headerSource = source else { return [] }
        var nodes: [CellType] = [.header(author: headerSource)]
        if let photo = photos.first {
            nodes.append(.photo(photo: photo))
        }
        if let gif = self.gif {
            nodes.append(.gif(gif: gif))
        }
        return nodes
    }
    
    let id: Int
    let sourceId: Int
    let text: String
    let date: Date
    var source: NewsSource?
    var photos: [Photo]
    var gif: GIF?
    
    init(json: JSON) {
        self.id = json["id"].intValue
        self.sourceId = json["source_id"].intValue
        self.text = json["text"].stringValue
        
        let timeInterval = json["date"].doubleValue
        self.date = Date(timeIntervalSince1970: timeInterval)
        
        let photosJSON = json["attachments"].arrayValue.filter({ $0["type"].stringValue == "photo" })
        self.photos = photosJSON.compactMap { Photo(json: $0) }
        
        let docsJSON = json["attachments"].arrayValue
            .filter({ $0["type"].stringValue == "doc" })
            .map { $0["doc"] }
        
        if !docsJSON.isEmpty {
            let gifsJSON = docsJSON.filter { $0["type"].intValue == 3 }
            if !gifsJSON.isEmpty {
                self.gif = GIF(json: gifsJSON[0])
            }
        }
    }
}

protocol ImageNodeRepresentable {
    var url: URL { get }
    var aspectRatio: CGFloat { get }
}

class Photo: ImageNodeRepresentable {
    let id: Int
    let date: Date
    let width: Int
    let height: Int
    let url: URL
    var aspectRatio: CGFloat { width != 0 ? CGFloat(height)/CGFloat(width) : 0 }
    
    init?(json: JSON) {
        guard let sizesArray = json["photo"]["sizes"].array,
            let xSize = sizesArray.first(where: { $0["type"].stringValue == "x" }),
            let url = URL(string: xSize["url"].stringValue) else { return nil }
        
        self.width = xSize["width"].intValue
        self.height = xSize["height"].intValue
        self.url = url
        let timeInterval = json["date"].doubleValue
        self.date = Date(timeIntervalSince1970: timeInterval)
        self.id = json["id"].intValue
    }
}

class GIF: ImageNodeRepresentable {
    let id: Int
    let date: Date
    let url: URL
    let width: Int
    let height: Int
    var aspectRatio: CGFloat {
        width != 0 ? CGFloat(height)/CGFloat(width) : 0
    }
    
    init?(json: JSON) {
        guard let url = URL(string: json["url"].stringValue) else { return nil }
        self.id = json["id"].intValue
        self.url = url
        let timeInterval = json["date"].doubleValue
        self.date = Date(timeIntervalSince1970: timeInterval)
        self.width = json["preview"]["video"]["width"].intValue
        self.height = json["preview"]["video"]["height"].intValue
    }
}

