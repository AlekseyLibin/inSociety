//
//  TermsAndConditionsViewController.swift
//  inSociety
//
//  Created by Aleksey Libin on 18.09.2023.
//

import UIKit
import WebKit

final class DocumentViewController: UIViewController {
  
  enum Document {
    case privacyPolicy, termsOfUse
    
    var rawValue: URL {
      switch self {
      case .privacyPolicy:
        return Bundle.main.url(forResource: "Privacy Policy", withExtension: "pdf")!
      case .termsOfUse:
        return Bundle.main.url(forResource: "Terms and Conditions", withExtension: "pdf")!
      }
    }
  }
  
  var pdfURL: URL
  var webView: WKWebView
  
  init(_ documentType: Document) {
    webView = WKWebView()
    pdfURL = documentType.rawValue
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .mainDark
    setupWebView()
  }
  
  @objc private func doneButtonPressed() {
    dismiss(animated: true)
  }
  
  private func setupWebView() {
    webView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(webView)
    let request = URLRequest(url: pdfURL)
    webView.load(request)
    
    let doneButton = UIButton(type: .system)
    doneButton.setTitle(DocumentString.done.localized, for: .normal)
    doneButton.titleLabel?.font = .systemFont(ofSize: 20)
    doneButton.addTarget(self, action: #selector(doneButtonPressed), for: .touchUpInside)
    doneButton.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(doneButton)
    
    NSLayoutConstraint.activate([
      doneButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
      
      webView.topAnchor.constraint(equalTo: doneButton.bottomAnchor),
      webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
    ])
  }
}
