//
//  ListViewController.swift
//  inSociety
//
//  Created by Aleksey Libin on 14.10.2022.
//

import UIKit

struct ActiveChatModel: Hashable, Decodable {
    var userName: String
    var userImageString: String
    var lastMessage: String
    var id: Int
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: ActiveChatModel, rhs: ActiveChatModel) -> Bool {
        return lhs.id == rhs.id
    }
}

class ListViewController: UIViewController {
    
    enum Section: Int, CaseIterable {
        case waitingChats, activeChats
    }
    
    let waitingChats = Bundle.main.decode([ActiveChatModel].self, from: "WaitingChats.json")
    let activeChats = Bundle.main.decode([ActiveChatModel].self, from: "ActiveChats.json")

    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, ActiveChatModel>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        setupSearchController()
        createDataSource()
        reloadData()
        
        
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
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "waitingChatCell")
        collectionView.register(ActiveChatCell.self, forCellWithReuseIdentifier: ActiveChatCell.reuseId)
        
    }
    
    func reloadData() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, ActiveChatModel>()
        snapshot.appendSections([.waitingChats, .activeChats])
        snapshot.appendItems(waitingChats, toSection: .waitingChats)
        snapshot.appendItems(activeChats, toSection: .activeChats)
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
    
}



//MARK: - Data Source
extension ListViewController {
    
    private func configure<T: SelfConfiguringCell>(cellType: T.Type, with value: ActiveChatModel, for indexPath: IndexPath) -> T {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellType.reuseId, for: indexPath) as? T else { fatalError("Unable to dequeue \(cellType)") }
        
        cell.configure(with: value)
        return cell
        
        
    }
    
    private func createDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, ActiveChatModel>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, itemIdentifier) -> UICollectionViewCell? in
            
            guard let section = Section(rawValue: indexPath.section) else {
                fatalError("No such section foud")
            }
            
            
            switch section {
            case .waitingChats:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "waitingChatCell", for: indexPath)
                cell.backgroundColor = .systemRed
                return cell
            case .activeChats:
                return self.configure(cellType: ActiveChatCell.self,
                                 with: itemIdentifier,
                                 for: indexPath)
            }
        })
    }
}


//MARK: - Setup CollectionView
extension ListViewController {
    
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnviroment in
            
            guard let section = Section(rawValue: sectionIndex) else {
                fatalError("No such section foud")
            }
            
            switch section {
            case .waitingChats:
                return self.createWaitingChatsSection()
            case .activeChats:
                return self.createActiveChatsSection()
            }
            
        }
        return layout
    }
    
    private func createWaitingChatsSection() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(88),
                                               heightDimension: .absolute(88))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 16
        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 20, bottom: 0, trailing: 20)
        
        return section
    }
    
    private func createActiveChatsSection() -> NSCollectionLayoutSection {
        
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                  heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                   heightDimension: .absolute(80))
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize,
                                                         subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 10
            section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20,
                                                            bottom: 0, trailing: 20)
            return section
    }
}



//MARK: - UISearchBarDelegate
extension ListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
    }
}



//MARK: - SwiftUI
import SwiftUI

struct ListVCProvider: PreviewProvider {
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
