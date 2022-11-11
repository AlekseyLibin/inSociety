//
//  SectionHeader.swift
//  inSociety
//
//  Created by Aleksey Libin on 18.10.2022.
//

import UIKit

class SectionHeader: UICollectionReusableView {
    
    static let reuseId = "SectionHeader"
    private let title = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        title.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(title)
        
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: self.topAnchor),
            title.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            title.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            title.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
    
    func configure(text: String, font: UIFont?, textColor: UIColor) {
        title.text = text
        title.font = font
        title.textColor = textColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
