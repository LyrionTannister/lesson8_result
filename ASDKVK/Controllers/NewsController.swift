//
//  NewsController.swift
//  ASDKVK
//
//  Created by user on 24/04/2019.
//  Copyright © 2019 Morizo Digital. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class NewsController: ASViewController<ASTableNode> {
    
    // Создаем дополнительный интерфейс для обращения к корневой ноде
    var tableNode: ASTableNode {
        return node
    }
    
    var totalNews = [NewsItem]()
    let vkService: VKService
    var nextFrom = ""
    var lastRefreshed = Date()
    
    var refreshControl: UIRefreshControl = {
        let rc = UIRefreshControl()
        rc.attributedTitle = NSAttributedString(string: "Loading..")
        rc.tintColor = .green
        rc.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return rc
    }()
    

    init(vkService: VKService) {
        self.vkService = vkService
        super.init(node: ASTableNode())
        
        self.tableNode.delegate = self
        self.tableNode.dataSource = self
        
        self.tableNode.allowsSelection = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableNode.view.refreshControl = refreshControl
    }
    
    @objc private func refresh() {
        vkService.loadNews(startTime: lastRefreshed.timeIntervalSince1970 + 1) { [weak self] result, _ in
            guard let self = self else { return }
            
            switch result {
            case let .success(news):
                self.totalNews = news + self.totalNews
                self.tableNode.reloadData()
            case let .failure(error):
                self.showAlert(error: error)
            }
        }
    }
}

extension NewsController: ASTableDelegate {
    func shouldBatchFetch(for tableNode: ASTableNode) -> Bool {
        true
    }
    
    func tableNode(_ tableNode: ASTableNode, willBeginBatchFetchWith context: ASBatchContext) {
        vkService.loadNews(startFrom: nextFrom) { [weak self] result, nextFrom in
            guard let self = self else { return }
            
            self.nextFrom = nextFrom
            
            switch result {
            case let .success(news):
                self.insertNews(news)
                context.completeBatchFetching(true)
            case let .failure(error):
                self.showAlert(error: error)
                context.completeBatchFetching(false)
            }
        }
    }
    
    private func insertNews(_ news: [NewsItem]) {
        let indexSet = IndexSet(integersIn: totalNews.count ..< totalNews.count + news.count)
        totalNews.append(contentsOf: news)
        tableNode.insertSections(indexSet, with: .automatic)
    }
}

extension NewsController: ASTableDataSource {
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        totalNews.count
    }
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        // TODO: Add logic
        return totalNews[section].displayedNodes.count
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        let news = totalNews[indexPath.section]
        let cellType = news.displayedNodes[indexPath.row]
        
        switch cellType {
        case let .header(author):
            return { NewsHeaderNode(source: author) }
        case let .photo(photo):
            return { ImageNode(resource: photo) }
        case let .gif(gif):
            return { ImageNode(resource: gif) }
        }
    }
}
