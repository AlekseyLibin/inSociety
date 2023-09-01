//
//  ChatsViewController.swift
//  inSociety
//
//  Created by Aleksey Libin on 14.10.2022.
//

import UIKit
import FirebaseFirestore

protocol ChatsViewControllerProtocol: BaseViewCotrollerProtocol {
  func showAlert(with title: String, and message: String?)
  func changeValueFor(waitingChats: [ChatModel])
  func changeValueFor(activeChats: [ChatModel])
  func emptyWaitingChatsLabel(isActive: Bool)
  func emptyActiveChatsLabel(isActive: Bool)
  
  var waitingChats: [ChatModel] { get }
  var activeChats: [ChatModel] { get }
}

final class ChatsViewController: BaseViewController {
  
  enum Section: Int, CaseIterable {
    case waitingChatsSection, activeChatsSection
    
    func description() -> String {
      switch self {
      case .waitingChatsSection:
        return ChatsString.waitingChats.localized
      case .activeChatsSection:
        return ChatsString.activeChats.localized
      }
    }
  }
  
  private let currentUser: UserModel
  
  private(set) var waitingChats = [ChatModel]()
  private(set) var activeChats = [ChatModel]()
  
  private var waitingChatsListener: ListenerRegistration?
  private var activeChatsListener: ListenerRegistration?
  
  private var collectionView: UICollectionView!
  private let refreshControl = UIRefreshControl()
  private let searchController: UISearchController
  private var dataSource: UICollectionViewDiffableDataSource<Section, ChatModel>?
  private let emptyWaitingChatsLabel = UILabel()
  private let emptyActiveChatsLabel = UILabel()
  
  private let configurator: ChatsConfiguratorProtocol = ChatsConfigurator()
  var presenter: ChatsPresenterProtocol!
  
  init(currentUser: UserModel) {
    self.currentUser = currentUser
    self.searchController = UISearchController(searchResultsController: nil)
    super.init(nibName: nil, bundle: nil)
    configurator.configure(viewController: self)
    presenter.setupListeners(&waitingChatsListener, &activeChatsListener)
    setupTopBar()
    setupCollectionView()
    createDataSource()
    setupLabels()
  }
  
  deinit {
    waitingChatsListener?.remove()
    activeChatsListener?.remove()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    reloadData()
    presenter.updateActiveChats { [weak self] result in
      switch result {
      case .success(let newActiveChats):
        DispatchQueue.global().asyncAfter(deadline: .now() + 1, execute: {
          DispatchQueue.main.async {
            if newActiveChats.sorted() != self?.activeChats.sorted() {
              self?.changeValueFor(activeChats: newActiveChats)
              self?.reloadData()
            }
          }
        })
      case .failure(let failure):
        self?.showAlert(with: ChatsString.error.localized, and: failure.localizedDescription)
      }
    }
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    reloadData()
  }
  
  private func setupLabels() {
    emptyWaitingChatsLabel.text = ChatsString.waitingChatsMessage.localized
    emptyWaitingChatsLabel.textColor = .darkGray
    emptyWaitingChatsLabel.alpha = 0.5
    emptyWaitingChatsLabel.font = .italicSystemFont(ofSize: 20)
    emptyWaitingChatsLabel.textAlignment = .center
    emptyWaitingChatsLabel.numberOfLines = 0
    emptyWaitingChatsLabel.isHidden = !waitingChats.isEmpty
    collectionView.addSubview(emptyWaitingChatsLabel)
    emptyWaitingChatsLabel.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      emptyWaitingChatsLabel.topAnchor.constraint(equalTo: collectionView.safeAreaLayoutGuide.topAnchor, constant: 60),
      emptyWaitingChatsLabel.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor),
      emptyWaitingChatsLabel.widthAnchor.constraint(equalTo: collectionView.widthAnchor, multiplier: 0.8)
    ])
    
    emptyActiveChatsLabel.text = ChatsString.activeChatsMessage.localized
    emptyActiveChatsLabel.textColor = .darkGray
    emptyActiveChatsLabel.alpha = 0.5
    emptyActiveChatsLabel.font = .italicSystemFont(ofSize: 20)
    emptyActiveChatsLabel.textAlignment = .center
    emptyActiveChatsLabel.numberOfLines = 0
    emptyActiveChatsLabel.isHidden = !activeChats.isEmpty
    collectionView.addSubview(emptyActiveChatsLabel)
    emptyActiveChatsLabel.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      emptyActiveChatsLabel.topAnchor.constraint(equalTo: emptyWaitingChatsLabel.bottomAnchor, constant: 100),
      emptyActiveChatsLabel.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor),
      emptyActiveChatsLabel.widthAnchor.constraint(equalTo: collectionView.widthAnchor, multiplier: 0.8)
    ])
  }
  
  private func setupTopBar() {
    let appearance = UINavigationBarAppearance()
    appearance.backgroundColor = .mainDark
    
    let titleLabel = UILabel(text: ChatsString.chats.localized)
    titleLabel.font = .systemFont(ofSize: 23)
    titleLabel.textColor = .systemGray
    
    navigationController?.navigationBar.standardAppearance = appearance
    navigationController?.navigationBar.scrollEdgeAppearance = appearance
    
    navigationItem.searchController = searchController
    navigationItem.titleView = titleLabel
    
    navigationItem.hidesSearchBarWhenScrolling = true
    searchController.hidesNavigationBarDuringPresentation = false
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.searchBar.delegate = self
  }
  
  private func reloadData(with searchText: String? = "") {
    let filteredActiveChats = activeChats.filter { $0.contains(filter: searchText) }
    let sortedActiveChats = filteredActiveChats.sorted()

    var snapshot = NSDiffableDataSourceSnapshot<Section, ChatModel>()
    snapshot.appendSections([.waitingChatsSection, .activeChatsSection])
    snapshot.appendItems(self.waitingChats, toSection: .waitingChatsSection)
    snapshot.appendItems(sortedActiveChats, toSection: .activeChatsSection)
    self.dataSource?.apply(snapshot, animatingDifferences: true)

    for (index, chat) in sortedActiveChats.enumerated() {
      if let activeChatCell = collectionView?.cellForItem(at: IndexPath(item: index, section: 1)) as? ActiveChatCell,
         let lastMessage = chat.messages.sorted().last {
        activeChatCell.updateLastMessage(with: lastMessage)
      }
    }
  }
  
  @objc private func refreshData() {
    presenter.updateActiveChats { [weak self] result in
      switch result {
      case .success(let activeChats):
        DispatchQueue.global().asyncAfter(deadline: .now() + 1, execute: {
          DispatchQueue.main.async {
            self?.changeValueFor(activeChats: activeChats)
            self?.reloadData()
            self?.refreshControl.endRefreshing()
          }
        })
      case .failure(let failure):
        self?.showAlert(with: ChatsString.error.localized, and: failure.localizedDescription)
      }
    }
  }
  
}

// MARK: - ChatsViewControllerProtocol
extension ChatsViewController: ChatsViewControllerProtocol {
  func changeValueFor(waitingChats: [ChatModel]) {
    self.waitingChats = waitingChats
    emptyWaitingChatsLabel.isHidden = !waitingChats.isEmpty
    collectionView.reloadData()
  }
  
  func changeValueFor(activeChats: [ChatModel]) {
    self.activeChats = activeChats
    self.activeChats.sort()
    emptyActiveChatsLabel.isHidden = !activeChats.isEmpty
  }
  
  func emptyWaitingChatsLabel(isActive: Bool) {
    emptyWaitingChatsLabel.isHidden = !isActive
  }
  
  func emptyActiveChatsLabel(isActive: Bool) {
    emptyActiveChatsLabel.isHidden = !isActive
  }
}

// MARK: - WaitingChatsNavigationDelegate
extension ChatsViewController: WaitingChatsNavigationDelegate {
  func removeWaitingChat(chat: ChatModel) {
    presenter.waitingChat(remove: chat)
  }
  
  func moveToActive(chat: ChatModel) {
    presenter.waitingChat(moveToActive: chat)
  }
}

// MARK: - Data Source
private extension ChatsViewController {
  func createDataSource() {
    dataSource = UICollectionViewDiffableDataSource<Section, ChatModel>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, itemIdentifier) -> UICollectionViewCell? in
      
      guard let section = Section(rawValue: indexPath.section) else {
        fatalError("No such section foud")
      }
      
      switch section {
      case .waitingChatsSection:
        return self.configure(collectionView: collectionView,
                              cellType: WaitingChatCell.self,
                              with: itemIdentifier,
                              for: indexPath)
      case .activeChatsSection:
        return self.configure(collectionView: collectionView,
                              cellType: ActiveChatCell.self,
                              with: itemIdentifier,
                              for: indexPath)
      }
    })
    
    dataSource?.supplementaryViewProvider = { collectionView, kind, indexPath in
      guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                                withReuseIdentifier: SectionHeader.reuseId, for: indexPath) as? SectionHeader
      else { fatalError("Cannot create new section header") }
      
      guard let section = Section(rawValue: indexPath.section) else { fatalError("Uknown section kind") }
      sectionHeader.configure(text: section.description(),
                              font: .light20,
                              textColor: .systemGray)
      
      return sectionHeader
    }
  }
}

// MARK: - UISearchBarDelegate
extension ChatsViewController: UISearchBarDelegate {
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    reloadData(with: searchText)
  }
  
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    reloadData()
  }
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    reloadData(with: searchBar.text ?? "")
  }
}

// MARK: - UICollectionViewDelegate
extension ChatsViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard
      let chat = self.dataSource?.itemIdentifier(for: indexPath),
      let section = Section(rawValue: indexPath.section)
    else { return }
    
    switch section {
    case .waitingChatsSection:
      presenter.navigate(toChatRequestVC: chat)
    case .activeChatsSection:
      presenter.navigate(toChatVC: currentUser, chat: chat)
    }
  }
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    emptyWaitingChatsLabel.alpha = 0.5 - emptyWaitingChatsLabel.frame.midY/500
  }
}

// MARK: - Setup CollectionView
private extension ChatsViewController {
  func setupCollectionView() {
    collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
    collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
    collectionView.refreshControl = refreshControl
    collectionView.backgroundColor = .mainDark
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
      case .waitingChatsSection:
        return self.createWaitingChatsSection()
      case .activeChatsSection:
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
