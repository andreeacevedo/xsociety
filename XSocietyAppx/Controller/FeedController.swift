//
//  FeedController.swift
//  XSocietyAppx
//
//  Created by Administrador on 4/6/24.
//

import UIKit
import Kingfisher

private let reuseIdentifier = "PostCell"

class FeedController: UICollectionViewController {
    
    // MARK: - Properties
    var user: User? {
        didSet{
            configureLeftBarButton()
        }
    }
    
    private var posts = [Post]() {
        didSet { collectionView.reloadData() }
    }
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchPosts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.isHidden = false
    }
    
    // MARK: - API
    
    func fetchPosts(){
        PostService.shared.fetchPosts { posts in
            self.posts = posts
        }
    }

    // MARK: - Helpers
    
    func configureUI(){
        view.backgroundColor = .white

        let customFont = UIFont(name: "Chewy-Regular", size: 20.0)
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: customFont ?? UIFont.systemFont(ofSize: 20.0)]
        
        navigationItem.title = "XSociety"
        
        collectionView.register(PostCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.backgroundColor = .white
        
    }
    func configureLeftBarButton(){
        guard let user = user else { return }
        let profileImageView = UIImageView()
        profileImageView.setDimensions(width: 32, height: 32)
        profileImageView.layer.cornerRadius = 32 / 2
        profileImageView.layer.masksToBounds = true
        
        profileImageView.kf.setImage(with: user.profileImageUrl)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: profileImageView)
    }
}

    // MARK: - UICollectionViewDelegate / DataSource

extension FeedController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PostCell
        
        cell.delegate  = self
        cell.post = posts[indexPath.row]
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension FeedController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let viewModel = PostViewModel(post: posts[indexPath.row])
        let height = viewModel.size(forWidth: view.frame.width).height
        return CGSize(width: view.frame.width, height: height + 80)
    }
}

extension FeedController: PostCellDelegate {
    func handleFotoPerfilTapped(_ cell: PostCell) {
        guard let user = cell.post?.user else { return }
        let controller = PerfilController(user: user)
        navigationController?.pushViewController(controller, animated: true)
    }
}
