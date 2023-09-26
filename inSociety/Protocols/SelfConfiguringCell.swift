//
//  SelfConfigurigCell.swift
//  inSociety
//
//  Created by Aleksey Libin on 18.10.2022.
//

import Foundation

protocol SelfConfiguringCell {
    static var reuseID: String { get }
    func configure<HCell: Hashable>(with cell: HCell)
}
