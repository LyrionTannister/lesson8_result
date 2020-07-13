//
//  NewsHeaderNode.swift
//  ASDKVK
//
//  Created by user on 24/04/2019.
//  Copyright © 2019 Morizo Digital. All rights reserved.
//

import Foundation
import AsyncDisplayKit

class NewsHeaderNode: ASCellNode {
    //MARK: - Properties
    private let nameNode = ASTextNode()
    private let avatarImageNode = ASNetworkImageNode()
    private let imageHeight: CGFloat = 50
    private let inset: CGFloat = 12
    
    private let source: NewsSource
    
    init(source: NewsSource) {
        self.source = source
        
        super.init()
        
        backgroundColor = .random
        
        setupSubnodes()
    }
    
    private func setupSubnodes() {
        addSubnode(nameNode)
        nameNode.attributedText = NSAttributedString(string: source.title, attributes: [.font: UIFont.systemFont(ofSize: 20)])
        nameNode.backgroundColor = .clear
        
        addSubnode(avatarImageNode)
        avatarImageNode.url = source.imageUrl
        avatarImageNode.cornerRadius = imageHeight/2
        avatarImageNode.clipsToBounds = true
        avatarImageNode.contentMode = .scaleAspectFill
        avatarImageNode.shouldRenderProgressImages = true
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        avatarImageNode.style.preferredSize = CGSize(width: imageHeight, height: imageHeight)
        
        let insets = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        let insetSpec = ASInsetLayoutSpec(insets: insets, child: avatarImageNode)
        
        let textCenterSpec = ASCenterLayoutSpec(centeringOptions: .Y, sizingOptions: [], child: nameNode)
        
        let horizontalStackSpec = ASStackLayoutSpec()
        horizontalStackSpec.direction = .horizontal
        horizontalStackSpec.children = [insetSpec, textCenterSpec]
        
        return horizontalStackSpec
    }
}
