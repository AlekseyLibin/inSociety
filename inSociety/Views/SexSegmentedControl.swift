//
//  SexSegmentedControl.swift
//  inSociety
//
//  Created by Aleksey Libin on 14.10.2022.
//

import UIKit

final class SexSegmentedControl: UISegmentedControl {
  init() {
    super.init(frame: .zero)
    for (index, element) in UserModel.Sex.allCases.enumerated() {
      insertSegment(withTitle: element.localized, at: index, animated: true)
    }
//    selectedSegmentIndex = 2
    
    let yellowAttribute = [NSAttributedString.Key.foregroundColor: UIColor.mainYellow]
    let blackAttribute = [NSAttributedString.Key.foregroundColor: UIColor.black]
    selectedSegmentTintColor = UIColor.mainYellow
    setTitleTextAttributes(yellowAttribute, for:.normal)
    setTitleTextAttributes(blackAttribute, for:.selected)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  var selectedSex: UserModel.Sex {
    UserModel.Sex(by: selectedSegmentIndex)
  }
  
  func selectSex(_ sex: UserModel.Sex) {
    selectedSegmentIndex = sex.intValue
  }
  
}
