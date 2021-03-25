//
//  BookmarkButton.swift
//  DevTestApp
//
//  Created by Jovanie Molas on 3/24/21.
//

import UIKit

class BookmarkButton: UIButton {
    
    init() {
        super.init(frame: .zero)
        self.setImage(#imageLiteral(resourceName: "bookmark_inactive"), for: .normal)
        self.setImage(#imageLiteral(resourceName: "bookmark_active"), for: .selected)
        self.contentHorizontalAlignment = .center
        self.contentVerticalAlignment = .center
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
