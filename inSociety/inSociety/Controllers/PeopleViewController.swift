//
//  PeopleViewController.swift
//  inSociety
//
//  Created by Aleksey Libin on 14.10.2022.
//

import UIKit

class PeopleViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .mainWhite()
        setupSearchController()
    }
    
    private func setupSearchController() {
//        navigationController?.navigationBar.barTintColor = .mainWhite()
//        navigationController?.navigationBar.shadowImage = UIImage()
        
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
    }
    
    
}



//MARK: - UISearchBarDelegate
extension PeopleViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
    }
}



//MARK: - SwiftUI
import SwiftUI

struct PeopleVCProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        let mainTabBarController = MainTabBarController()
        
        func makeUIViewController(context: Context) -> some UIViewController {
            return mainTabBarController
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
            
        }
    }
}
