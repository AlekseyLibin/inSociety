//
//  PeopleViewController.swift
//  inSociety
//
//  Created by Aleksey Libin on 14.10.2022.
//

import UIKit
import FirebaseAuth

class PeopleViewController: UIViewController {
    
    enum Section: Int, CaseIterable {
        case users
        
        func description(usersCount: Int) -> String {
            
            switch self {
            case .users:
                return "\(usersCount) people nearby"
            }
        }
    }
    
//    let users = Bundle.main.decode([UserModel].self, from: "Users.json")
    let users = [UserModel]()
    private let currentUser: UserModel
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, UserModel>!
    
    
    init(currentUser: UserModel) {
        self.currentUser = currentUser
        super.init(nibName: nil, bundle: nil)
        title = currentUser.userName
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchController()
        setupCollectionView()
        createDataSource()
        reloadData(with: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log out", style: .plain, target: self, action: #selector(logOutButton))
        view.backgroundColor = .mainWhite()
    }
    
    @objc private func logOutButton() {
        let ac = UIAlertController(title: "Are you sure you want to log out?", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.addAction(UIAlertAction(title: "Log out", style: .destructive, handler: { _ in
            do {
                try Auth.auth().signOut()
                UIApplication.shared.keyWindow?.rootViewController = AuthViewController()
            } catch {
                print(error.localizedDescription)
            }
            
        }))
        present(ac, animated: true)
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
    
    private func setupCollectionView() {
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        collectionView.backgroundColor = .mainWhite()
        view.addSubview(collectionView)
        
        collectionView.register(SectionHeader.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeader.reuseId)
        
        
        collectionView.register(UserCell.self, forCellWithReuseIdentifier: UserCell.reuseId )
        
    }
    
    private func reloadData(with searchText: String?) {
        
        let filteredUsers = users.filter { (user) -> Bool in
            user.contains(filter: searchText)
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, UserModel>()
        snapshot.appendSections([.users])
        snapshot.appendItems(filteredUsers, toSection: .users)
        dataSource?.apply(snapshot, animatingDifferences: true)
    }

    
    
}



//MARK: - UISearchBarDelegate
extension PeopleViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        reloadData(with: searchText)
    }
}


extension PeopleViewController {
    
    private func createDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, UserModel>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, itemIdentifier) -> UICollectionViewCell? in
            
            guard let section = Section(rawValue: indexPath.section) else { fatalError("Unknown section kind") }
            
            switch  section {
            case .users:
                return self.configure(collectionView: collectionView,
                                      cellType: UserCell.self,
                                      with: itemIdentifier,
                                      for: indexPath)
            }
        })
        
        dataSource?.supplementaryViewProvider = {
            collectionView, kind, indexPath in
            
            guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                                withReuseIdentifier: SectionHeader.reuseId, for: indexPath) as? SectionHeader
            else { fatalError("Cannot create neu section header")}
            guard let section = Section(rawValue: indexPath.section) else { fatalError("Uknown section kind") }
            let numberOfUsers = self.dataSource.snapshot().numberOfItems(inSection: .users)
            sectionHeader.configure(text: section.description(usersCount: numberOfUsers),
                                    font: .systemFont(ofSize: 36, weight: .light),
                                    textColor: .black)
            
            return sectionHeader
        }
    }
}




//MARK: - Create Compositional Layout
extension PeopleViewController {
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnviroment in
            
            guard let section = Section(rawValue: sectionIndex) else {
                fatalError("No such section foud")
            }
            
            switch section {
            case .users:
                return self.createUsersSection()
            }
        }
        
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        configuration.interSectionSpacing = 20
        layout.configuration = configuration
        
        return layout
    }
    
    private func createUsersSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                            heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                            heightDimension: .fractionalWidth(0.6))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 2)
        group.interItemSpacing = .fixed(15)
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 15
        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 0, trailing: 16)
        
        let sectionHeader = createSectionHeader()
        section.boundarySupplementaryItems = [sectionHeader]
        
        
        return section
    }
    
    private func  createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let sectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                       heightDimension: .estimated(1))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: sectionHeaderSize,
                                                                        elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        return sectionHeader
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