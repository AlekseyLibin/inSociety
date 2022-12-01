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
    
    override func showAlert(with title: String, and message: String? = nil, completion: @escaping () -> Void = {}) {
        super.showAlert(with: title, and: message, completion: completion)
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
