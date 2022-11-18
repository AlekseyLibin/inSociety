//
//  PeopleViewController.swift
//  inSociety
//
//  Created by Aleksey Libin on 14.10.2022.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

final class PeopleViewController: UIViewController {
    
    enum Section: Int, CaseIterable {
        case users
        
        func description(usersCount: Int) -> String {
            switch self {
            case .users:
                return "\(usersCount) people nearby"
            }
        }
    }
    
    private var users = [UserModel]()
    private var usersListener: ListenerRegistration?
    private var numberOfUsersListener: ListenerRegistration?
    
    private let currentUser: UserModel
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, UserModel>!
    
    init(currentUser: UserModel) {
        self.currentUser = currentUser
        super.init(nibName: nil, bundle: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchController()
        setupTabBar()
        setupCollectionView()
        createDataSource()
        
        usersListener = ListenerService.shared.usersObserve(users: users, completion: { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let updatedUsers):
                self.users = updatedUsers
                self.reloadData(with: nil)
            case .failure(let error):
                self.showAlert(with: "Error", and: error.localizedDescription)
            }
        })
    }
    
    deinit {
        numberOfUsersListener?.remove()
        usersListener?.remove()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


//MARK: - Setup collectionView
private extension PeopleViewController {
    func setupCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        collectionView.backgroundColor = .mainDark()
        view.addSubview(collectionView)
        
        collectionView.register(SectionHeader.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeader.reuseId)
        
        
        collectionView.register(UserCell.self, forCellWithReuseIdentifier: UserCell.reuseID)
        collectionView.delegate = self
        
    }

    func reloadData(with searchText: String?) {
        
        let filteredUsers = users.filter { (user) -> Bool in
            user.contains(filter: searchText)
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, UserModel>()
        snapshot.appendSections([.users])
        snapshot.appendItems(filteredUsers, toSection: .users)
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
}


//MARK: - UICollectionViewDelegate
extension PeopleViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let selectedUser = self.dataSource.itemIdentifier(for: indexPath) else { return }
        FirestoreService.shared.checkNoChats(with: selectedUser) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success:
                let sendRequestVC = SendRequestViewController(user: selectedUser)
                self.present(sendRequestVC, animated: true)
            case .failure(let error):
                self.showAlert(with: error.localizedDescription, and: "")
            }
        }
    }
}


//MARK: - Create Data Source
private extension PeopleViewController {
    func createDataSource() {
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
            else { fatalError("Cannot create new section header")}
            guard let section = Section(rawValue: indexPath.section) else { fatalError("Uknown section kind") }
            self.numberOfUsersListener = ListenerService.shared.usersObserve(users: self.users) { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success(let allUsers):
                    sectionHeader.configure(text: section.description(usersCount: allUsers.count),
                                            font: .systemFont(ofSize: 36, weight: .light),
                                            textColor: .mainYellow())
                case .failure(let error):
                    self.showAlert(with: "Error", and: error.localizedDescription)
                }
            }
            
            return sectionHeader
        }
    }
}


//MARK: - Create Compositional Layout
private extension PeopleViewController {
    func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
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


//MARK: - SetupSearchController
private extension PeopleViewController {
    func setupSearchController() {
        navigationController?.navigationBar.barTintColor = .mainDark()
        
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
        reloadData(with: searchText)
    }
}


//MARK: - SetupTabBar
private extension PeopleViewController {
    func setupTabBar() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .mainDark()
        
        self.tabBarController?.tabBar.standardAppearance = appearance
        self.tabBarController?.tabBar.scrollEdgeAppearance = appearance
    }
    
}
