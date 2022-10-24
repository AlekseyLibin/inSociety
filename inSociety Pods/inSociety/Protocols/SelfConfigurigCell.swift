//
//  SelfConfigurigCell.swift
//  inSociety
//
//  Created by Aleksey Libin on 18.10.2022.
//

import Foundation

protocol SelfConfiguringCell {
    static var reuseId: String { get }
    func configure<U: Hashable>(with value: U)
}
