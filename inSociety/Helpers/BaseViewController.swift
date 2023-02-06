//
//  BaseViewController.swift
//  inSociety
//
//  Created by Aleksey Libin on 01.12.2022.
//

import UIKit

class BaseViewController: UIViewController {
  
  func present(viewController: UIViewController) {
    present(viewController, animated: true)
  }
  
  func dismiss() {
    dismiss(animated: true)
  }
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    print(" - init \(String(describing: type(of: self)))")
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  deinit {
    print(" - deinit \(String(describing: type(of: self)))")
  }
    
    
    
//    func showAlert(with title: String, and message: String? = nil, completion: @escaping () -> Void = {} ) {
//        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
//        let sumbitButton = UIAlertAction(title: "Submit", style: .default) { _ in
//            completion()
//        }
//        alert.addAction(sumbitButton)
//        present(alert, animated: true)
//    }
    
}
