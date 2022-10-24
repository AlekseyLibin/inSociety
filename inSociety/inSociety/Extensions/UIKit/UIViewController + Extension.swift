//
//  UIViewController + Extension.swift
//  inSociety
//
//  Created by Aleksey Libin on 18.10.2022.
//

import UIKit

//MARK: - ShowAlert method
extension UIViewController {
    func showAlert(with title: String, and message: String, completion: @escaping () -> Void = {} ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let sumbitButton = UIAlertAction(title: "Submit", style: .default) { _ in
            completion()
        }
        alert.addAction(sumbitButton)
        present(alert, animated: true)
    }
}



//MARK: - Configure CollectionViewCell
extension UIViewController {
     func configure<T: SelfConfiguringCell, U: Hashable>(collectionView: UICollectionView,
                                                                cellType: T.Type,
                                                                with value: U,
                                                                for indexPath: IndexPath) -> T {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellType.reuseId, for: indexPath) as? T else { fatalError("Unable to dequeue \(cellType)") }
        
        cell.configure(with: value)
        return cell
    }
}
