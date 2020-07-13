//
//  ImageNode.swift
//  ASDKVK
//
//  Created by user on 24/04/2019.
//  Copyright © 2019 Morizo Digital. All rights reserved.
//

import Foundation
import AsyncDisplayKit

class ImageNode: ASCellNode {
    private let photoImageNode = ASNetworkImageNode()
    private let resource: ImageNodeRepresentable
    
    init(resource: ImageNodeRepresentable) {
        self.resource = resource
        
        super.init()
        setupSubnodes()
    }
    
    
    private func setupSubnodes() {
        addSubnode(photoImageNode)
        photoImageNode.url = resource.url
        photoImageNode.contentMode = .scaleToFill
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let width = constrainedSize.max.width
        photoImageNode.style.preferredSize = CGSize(width: width, height: width*resource.aspectRatio)
        return ASWrapperLayoutSpec(layoutElement: photoImageNode)
    }
}
