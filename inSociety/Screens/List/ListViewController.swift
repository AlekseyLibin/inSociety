//
//  ListViewController.swift
//  inSociety
//
//  Created by Aleksey Libin on 14.10.2022.
//

import UIKit
import FirebaseFirestore

protocol ListViewControllerProtocol: WaitingChatsNavigation, AnyObject {
  func showAlert(with title: String, and message: String?)
  func changeValueFor(waitingChats: [ChatModel])
  func changeValueFor(activeChats: [ChatModel])
  func collectionView(updateCellValueBy indexPath: IndexPath, with message: String)

  var waitingChats: [ChatModel] { get }
  var activeChats: [ChatModel] { get }
}

final class ListViewController: BaseViewController {
  
  enum Section: Int, CaseIterable {
    case waitingChats, activeChats
    
    func description() -> String {
      switch self {
      case .waitingChats:
        return "Waiting chats"
      case .activeChats:
        return "Active chats"
      }
    }
  }
  
  private let currentUser: UserModel
  
  var waitingChats = [ChatModel]()
  var activeChats = [ChatModel]()
  
  private var waitingChatsListener: ListenerRegistration?
  private var activeChatsListener: ListenerRegistration?
  
  private var collectionView: UICollectionView!
  private var dataSource: UICollectionViewDiffableDataSource<Section, ChatModel>?
  
  private let configurator: ListConfiguratorProtocol = ListConfigurator()
  var presenter: ListPresenterProtocol!
  
  init(currentUser: UserModel) {
    self.currentUser = currentUser
    super.init(nibName: nil, bundle: nil)
    title = "Chats"
  }
  
  deinit {
    waitingChatsListener?.remove()
    activeChatsListener?.remove()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    updateLastMessage()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configurator.configure(viewController: self)
    tabBarController?.tabBar.backgroundColor = .mainDark()
    let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.gray]
    navigationController?.navigationBar.titleTextAttributes = textAttributes
    
    setupCollectionView()
    setupSearchController()
    createDataSource()
    presenter.setupListeners(&waitingChatsListener, &activeChatsListener)
    reloadData(with: nil)
    
  }
  
  private func setupSearchController() {
    navigationController?.navigationBar.barTintColor = .mainDark()
    
    let searchController = UISearchController(searchResultsController: nil)
    navigationItem.searchController = searchController
    navigationItem.hidesSearchBarWhenScrolling = false
    searchController.hidesNavigationBarDuringPresentation = false
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.searchBar.delegate = self
  }
  
  private func reloadData(with searchText: String?) {
    let filteredActiveChats = activeChats.filter { (chat) -> Bool in
      chat.contains(filter: searchText)
    }
    
    var snapshot = NSDiffableDataSourceSnapshot<Section, ChatModel>()
    snapshot.appendSections([.waitingChats, .activeChats])
    snapshot.appendItems(waitingChats, toSection: .waitingChats)
    snapshot.appendItems(filteredActiveChats, toSection: .activeChats)
    dataSource?.apply(snapshot, animatingDifferences: true)
  }
  
  func updateLastMessage() {
    presenter.updateLastMessage()
  }
  
}

extension ListViewController: ListViewControllerProtocol {
  
  func collectionView(updateCellValueBy indexPath: IndexPath, with message: String) {
    guard let cell = self.collectionView.cellForItem(at: indexPath) as? ActiveChatCell else { return }
    cell.updateLastMessage(with: message)
  }
  
  func changeValueFor(waitingChats: [ChatModel]) {
    self.waitingChats = waitingChats
    reloadData(with: nil)
  }
  
  func changeValueFor(activeChats: [ChatModel]) {
    self.activeChats = activeChats
    reloadData(with: nil)
  }
  
  func removeWaitingChat(chat: ChatModel) {
    presenter.waitingChat(remove: chat)
  }
  
  func moveToActive(chat: ChatModel) {
    presenter.waitingChat(moveToActive: chat)
  }
}

// MARK: - Data Source
private extension ListViewController {
  func createDataSource() {
    dataSource = UICollectionViewDiffableDataSource<Section, ChatModel>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, itemIdentifier) -> UICollectionViewCell? in
      
      guard let section = Section(rawValue: indexPath.section) else {
        fatalError("No such section foud")
      }
      
      switch section {
      case .waitingChats:
        return self.configure(collectionView: collectionView,
                              cellType: WaitingChatCell.self,
                              with: itemIdentifier,
                              for: indexPath)
      case .activeChats:
        return self.configure(collectionView: collectionView,
                              cellType: ActiveChatCell.self,
                              with: itemIdentifier,
                              for: indexPath)
      }
    })
    
    dataSource?.supplementaryViewProvider = { collectionView, kind, indexPath in
      
      guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                                withReuseIdentifier: SectionHeader.reuseId, for: indexPath) as? SectionHeader
      else { fatalError("Cannot create neu section header") }
      
      guard let section = Section(rawValue: indexPath.section) else { fatalError("Uknown section kind") }
      sectionHeader.configure(text: section.description(),
                              font: .laoSangamMN20(),
                              textColor: .systemGray)
      
      return sectionHeader
    }
  }
}

// MARK: - UISearchBarDelegate
extension ListViewController: UISearchBarDelegate {
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    reloadData(with: searchText)
  }
}

// MARK: - UICollectionViewDelegate
extension ListViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard
      let chat = self.dataSource?.itemIdentifier(for: indexPath),
      let section = Section(rawValue: indexPath.section)
    else { return }
    
    switch section {
    case .waitingChats:
      presenter.navigate(toChatRequestVC: chat)
    case .activeChats:
      presenter.navigate(toChatVC: currentUser, chat: chat)
    }
  }
}

// MARK: - Setup CollectionView
private extension ListViewController {
  func setupCollectionView() {
    collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
    collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    collectionView.backgroundColor = .mainDark()
    view.addSubview(collectionView)
    
    collectionView.register(SectionHeader.self,
                            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeader.reuseId)
    
    collectionView.register(WaitingChatCell.self, forCellWithReuseIdentifier: WaitingChatCell.reuseID)
    collectionView.register(ActiveChatCell.self, forCellWithReuseIdentifier: ActiveChatCell.reuseID)
    
    collectionView.delegate = self
    
  }
  
  func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
    let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
      
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
    
    let configuration = UICollectionViewCompositionalLayoutConfiguration()
    configuration.interSectionSpacing = 20
    layout.configuration = configuration
    
    return layout
  }
  
  func createWaitingChatsSection() -> NSCollectionLayoutSection {
    
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
    
    let sectionHeader = createSectionHeader()
    section.boundarySupplementaryItems = [sectionHeader]
    
    return section
  }
  
  func createActiveChatsSection() -> NSCollectionLayoutSection {
    
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
    
    let sectionHeader = createSectionHeader()
    section.boundarySupplementaryItems = [sectionHeader]
    
    return section
  }
  
  func  createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
    let sectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                   heightDimension: .estimated(1))
    let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: sectionHeaderSize,
                                                                    elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
    return sectionHeader
  }
  
}
