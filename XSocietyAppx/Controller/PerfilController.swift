//  PerfilController.swift
//  XSocietyAppx
//
//  Created by Administrador on 4/6/24.
//

import UIKit
import Kingfisher

private let reuseIdentifier = "PostCell"
private let headerIdentifier = "PerfilHeader"

class PerfilController: UICollectionViewController {
    
    // MARK: - Properties
    private let user: User
    
    private var posts = [Post]() {
        didSet { collectionView.reloadData() }
    }
    
    // MARK: - Lifecycle
    init(user: User)  {
        self.user = user
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        fetchPosts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: - API
    func fetchPosts() {
        PostService.shared.fetchPosts(forUser: user) { posts in
            self.posts = posts
        }
    }
    
    // MARK: - Helpers
    func configureCollectionView() {
        collectionView.backgroundColor = .white
        collectionView.contentInsetAdjustmentBehavior = .never

        collectionView.register(PostCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.register(PerfilHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
    }
}

// MARK: - UICollectionViewDataSource
extension PerfilController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PostCell
        cell.post = posts[indexPath.row]
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension PerfilController {
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! PerfilHeader
        header.user = user
        header.delegate = self
        return header
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension PerfilController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 350)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let viewModel = PostViewModel(post: posts[indexPath.row])
        let height = viewModel.size(forWidth: view.frame.width).height
        return CGSize(width: view.frame.width, height: height + 80)
    }
}

// Implementación del delegado PerfilHeaderDelegate
extension PerfilController: PerfilHeaderDelegate {
    func handleDismiss() {
        print("Back button tapped in PerfilController") // Log para verificar que el método se llama
        navigationController?.popViewController(animated: true)
    }
}
