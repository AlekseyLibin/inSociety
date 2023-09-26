//
//  CustomButton.swift
//  inSociety
//
//  Created by Aleksey Libin on 12.10.2022.
//

import UIKit

final class CustomButton: UIButton {
  private var mainBackgroundColor: UIColor?
  private var secondaryBackgroundColor: UIColor
  private let shouldBeHighlighted: Bool
  
  init(title: String,
       titleColor: UIColor,
       font: UIFont? = .light20,
       mainBackgroundColor: UIColor? = nil,
       secondaryBackgroundColor: UIColor? = nil,
       highlight: Bool = true,
       cornerRadius: CGFloat = 20) {
    self.mainBackgroundColor = mainBackgroundColor
    self.shouldBeHighlighted = highlight
    if mainBackgroundColor == nil {
      self.secondaryBackgroundColor = secondaryBackgroundColor ?? .lightGray.withAlphaComponent(0.1)
    } else {
      self.secondaryBackgroundColor = secondaryBackgroundColor ?? mainBackgroundColor!.withAlphaComponent(0.5)
    }
    super.init(frame: .zero)
    self.setTitle(title, for: .normal)
    self.setTitleColor(titleColor, for: .normal)
    self.titleLabel?.font = font
    self.backgroundColor = mainBackgroundColor
    self.layer.cornerRadius = cornerRadius
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func addBaseShadow() {
    self.layer.shadowColor = UIColor.mainDark.cgColor
    self.layer.shadowRadius = 4
    self.layer.shadowOpacity = 0.2
    self.layer.shadowOffset = CGSize(width: 0, height: 4)
  }
  
  public override var isHighlighted: Bool {
    didSet {
      if shouldBeHighlighted, isHighlighted {
        backgroundColor = secondaryBackgroundColor
      } else if shouldBeHighlighted{
        backgroundColor = mainBackgroundColor
      }
    }
  }
}
