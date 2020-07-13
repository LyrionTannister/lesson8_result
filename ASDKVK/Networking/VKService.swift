//
//  VKService.swift
//  Geekbrains Weather
//
//  Created by user on 06.10.2018.
//  Copyright © 2018 Andrey Antropov. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class VKService {
    
    var request: URLRequest? = nil
    private let apiVersion = "5.92"
    private let baseUrl = "https://api.vk.com"
    
    init() {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "oauth.vk.com"
        urlComponents.path = "/authorize"
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: "6704883"),
            URLQueryItem(name: "display", value: "mobile"),
            URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
            URLQueryItem(name: "scope", value: "274438"),
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "v", value: apiVersion)
        ]
        
        self.request = URLRequest(url: urlComponents.url!)
    }
    
    func loadNews(startFrom: String = "",
                  startTime: Double? = nil,
                  completion: @escaping (Swift.Result<[NewsItem], Error>, String) -> Void) {
        
        let path = "/method/newsfeed.get"
        var params: Parameters = [
            "access_token": Session.shared.token,
            "filters": "post",
            "v": "5.87",
            "count": "20",
            "start_from": startFrom
        ]
        
        if let startTime = startTime {
            params["start_time"] = startTime
        }
        
        Alamofire.request(baseUrl + path, method: .get, parameters: params).responseJSON(queue: .global()) { response in
            switch response.result {
            case .failure(let error):
                completion(.failure(error), "")
            case .success(let value):
                let json = JSON(value)
                var friends = [Friend]()
                var groups = [Group]()
                let nextFrom = json["response"]["next_from"].stringValue
                
                let parsingGroup = DispatchGroup()
                DispatchQueue.global().async(group: parsingGroup) {
                    friends = json["response"]["profiles"].arrayValue.map { Friend(json: $0) }
                }
                DispatchQueue.global().async(group: parsingGroup) {
                    groups = json["response"]["groups"].arrayValue.map { Group(json: $0) }
                }
                parsingGroup.notify(queue: .global()) {
                    let news = json["response"]["items"].arrayValue.map { NewsItem(json: $0) }
                    
                    news.forEach { newsItem in
                        if newsItem.sourceId > 0 {
                            let source = friends.first(where: { $0.id == newsItem.sourceId })
                            newsItem.source = source
                        } else {
                            let source = groups.first(where: { $0.id == -newsItem.sourceId })
                            newsItem.source = source
                        }
                    }
                    DispatchQueue.main.async {
                        completion(.success(news), nextFrom)
                    }
                }
            }
        }
    }
}
