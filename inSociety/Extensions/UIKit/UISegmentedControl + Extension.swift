//
//  SegmentedControl + Extension.swift
//  inSociety
//
//  Created by Aleksey Libin on 14.10.2022.
//

import UIKit

extension UISegmentedControl {
  convenience init(elements: [UserModel.Sex]) {
    self.init()
    self.selectedSegmentIndex = 2
    
    for index in 0..<elements.count {
      self.insertSegment(withTitle: elements[index].rawValue, at: index, animated: true)
    }
  }
}
