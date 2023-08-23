//
//  SendMessageTextField.swift
//  inSociety
//
//  Created by Aleksey Libin on 18.10.2022.
//

import UIKit

final class MessageInputView: UIView {
  
  enum ButtonType {
    case send, done
  }
  
  let textField = UITextField()
  let sendButton = UIButton(type: .system)
  private var blurEffect: UIBlurEffect
  private var blurView: UIVisualEffectView

  override init(frame: CGRect) {
    self.blurEffect = UIBlurEffect(style: .regular)
    self.blurView = UIVisualEffectView(effect: nil)
    super.init(frame: frame)
    setupViews()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func changeButtonType(to buttonType: ButtonType) {
    switch buttonType {
    case .send:
      sendButton.setImage(UIImage(named: "sendButton"), for: .normal)
    case .done:
      sendButton.setImage(UIImage(named: "doneButton"), for: .normal)
    }
  }
  
  func isBlured(_ isBlured: Bool) {
    if isBlured {
      blurView.effect = blurEffect
    } else {
      blurView.effect = nil
    }
  }
  
  private func setupViews() {
    blurView.frame = bounds
    blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    blurView.translatesAutoresizingMaskIntoConstraints = false
    addSubview(blurView)
    blurView.contentView.addSubview(textField)
    blurView.contentView.addSubview(sendButton)
    
    textField.placeholder = "Сообщение"
    textField.font = UIFont.systemFont(ofSize: 14)
    textField.borderStyle = .none
    textField.clearButtonMode = .whileEditing
    textField.backgroundColor = .secondaryDark()
    textField.layer.cornerRadius = 20
    textField.layer.masksToBounds = true
    textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    textField.translatesAutoresizingMaskIntoConstraints = false
    
    let indentView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 1))
    textField.leftView = indentView
    textField.leftViewMode = .always
    
    sendButton.setImage(UIImage(named: "sendButton"), for: .normal)
    sendButton.tintColor = .mainYellow()
    sendButton.isEnabled = false
    sendButton.imageView?.contentMode = .scaleAspectFit
    sendButton.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      blurView.topAnchor.constraint(equalTo: topAnchor),
      blurView.leadingAnchor.constraint(equalTo: leadingAnchor),
      blurView.trailingAnchor.constraint(equalTo: trailingAnchor),
      blurView.bottomAnchor.constraint(equalTo: bottomAnchor),
      
      textField.topAnchor.constraint(equalTo: topAnchor, constant: 5),
      textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
      textField.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -10),
      textField.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
      
      sendButton.topAnchor.constraint(equalTo: topAnchor, constant: 10),
      sendButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
      sendButton.widthAnchor.constraint(equalTo: sendButton.heightAnchor),
      sendButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
    ])
  }
  
  @objc private func textFieldDidChange() {
    sendButton.isEnabled = textField.text != "" && textField.text != nil
  }
  
}
