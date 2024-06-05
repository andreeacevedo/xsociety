//  PerfilHeader.swift
//  XSocietyAppx
//
//  Created by Administrador on 5/22/24.
//

import UIKit
import Kingfisher

protocol PerfilHeaderDelegate: AnyObject {
    func handleDismiss()
}

class PerfilHeader: UICollectionReusableView {
    
    // MARK: - Properties
    
    var user: User? {
        didSet { configure() }
    }
    weak var delegate: PerfilHeaderDelegate?
    private let filterBar = PerfilFilterView()
    
    private lazy var containerView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.image = UIImage(named: "holo header")
        
        iv.addSubview(backButton)
        backButton.anchor(top: iv.topAnchor, left: iv.leftAnchor, paddingTop: 42, paddingLeft: 16)
        backButton.setDimensions(width: 30, height: 30)
        
        return iv
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "baseline_arrow_back_white_24dp").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return button
    }()
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        iv.layer.borderColor = UIColor.white.cgColor
        iv.layer.borderWidth = 4
        return iv
    }()
    
    private lazy var editPerfilSegButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Loading", for: .normal)
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1.25
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(handleEditPerfilSeguir), for: .touchUpInside)
        return button
    }()
    
    private let fullNameLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    private let usernameLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .lightGray
        return label
    }()
    
    private let bioLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.numberOfLines = 3
        label.text = "Estudiante - Ingenieria en Sistemas"
        return label
    }()
    
    private let underlineView: UIView = {
       let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    private let seguidorLabel: UILabel = {
        let label = UILabel()
        label.text = "2 Seguidores"
        let followTap = UITapGestureRecognizer(target: self, action: #selector(handleFollowersTapped))
        label.addGestureRecognizer(followTap)
        return label
    }()
    
    private let siguiendoLabel: UILabel = {
        let label = UILabel()
        label.text = "0 Siguiendo"
        let followTap = UITapGestureRecognizer(target: self, action: #selector(handleFollowingTapped))
        label.addGestureRecognizer(followTap)
        return label
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        filterBar.delegate = self
        
        addSubview(containerView)
        containerView.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, height: 108)
        
        addSubview(profileImageView)
        profileImageView.anchor(top: containerView.bottomAnchor, left: leftAnchor, paddingTop: -24, paddingLeft: 150)
        profileImageView.setDimensions(width: 80, height: 80)
        profileImageView.layer.cornerRadius = 80 / 2
        
        addSubview(editPerfilSegButton)
        editPerfilSegButton.anchor(top: containerView.bottomAnchor, right: rightAnchor, paddingTop: 64, paddingRight: 12)
        editPerfilSegButton.setDimensions(width: 100, height: 36)
        editPerfilSegButton.layer.cornerRadius = 36 / 2
        
        let userDetailsStack = UIStackView(arrangedSubviews: [fullNameLabel, usernameLabel, bioLabel])
        
        userDetailsStack.axis = .vertical
        userDetailsStack.distribution = .fillProportionally
        userDetailsStack.spacing = 4
        
        addSubview(userDetailsStack)
        userDetailsStack.anchor(top: profileImageView.bottomAnchor, left: leftAnchor,
                                right: rightAnchor, paddingTop: 8, paddingLeft: 12, paddingRight: 12)
        
        let followStack = UIStackView(arrangedSubviews: [seguidorLabel, siguiendoLabel])
        followStack.axis = .horizontal
        followStack.spacing = 8
        followStack.distribution = .fillEqually
        
        addSubview(followStack)
        followStack.anchor(top: userDetailsStack.bottomAnchor, left: leftAnchor, paddingTop: 8, paddingLeft: 12)
        
        addSubview(filterBar)
        filterBar.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, height: 50)
        
        addSubview(underlineView)
        underlineView.anchor(left: leftAnchor, bottom: bottomAnchor, width: frame.width / 3, height: 2)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Selectors
    
    @objc func handleDismiss() {
        print("Back button pressed") // Añade un log para verificar si se llama este método
        if let delegate = delegate {
            print("Delegate is not nil")
            delegate.handleDismiss()
        } else {
            print("Delegate is nil")
        }
    }
    
    @objc func handleEditPerfilSeguir() {
        
    }
    
    @objc func handleFollowersTapped() {
        
    }
    
    @objc func handleFollowingTapped() {
        
    }

    // MARK: - Helpers
    
    func configure() {
        guard let user = user else { return }
        let viewModel = PerfilHeaderViewModel(user: user)
        
        profileImageView.kf.setImage(with: user.profileImageUrl)
        editPerfilSegButton.setTitle(viewModel.actionBuuttonTittle, for: .normal)
        siguiendoLabel.attributedText = viewModel.followingString
        seguidorLabel.attributedText = viewModel.followerString
        
        fullNameLabel.text = user.fullname
        usernameLabel.text = viewModel.usernameText
    }
}

// MARK: - PerfilFilterViewDelegate
extension PerfilHeader: PerfilFilterViewDelegate {
    func filterView(_ view: PerfilFilterView, didSelect indexPath: IndexPath) {
        guard let cell = view.collectionView.cellForItem(at: indexPath) as? PerfilFilterCell else {
            return
        }
        
        let xPosition = cell.frame.origin.x
        UIView.animate(withDuration: 0.3) {
            self.underlineView.frame.origin.x = xPosition
        }
    }
}
