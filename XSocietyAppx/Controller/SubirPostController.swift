//
//  SubirPostController.swift
//  XSocietyAppx
//
//  Created by Administrador on 5/12/24.
//

import UIKit

class SubirPostController: UIViewController {
    
    // MARK: - Properties
    private let user: User
    private var selectedImage: UIImage?
    
    private lazy var actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .black
        button.setTitle("Publicar", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(.white, for: .normal)
        
        button.frame = CGRect(x: 0, y: 0, width: 80, height: 32)
        button.layer.cornerRadius = 32 / 2
        
        button.addTarget(self, action: #selector(handleSubirPost), for: .touchUpInside)
        
        return button
    }()
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.setDimensions(width: 48, height: 48)
        iv.layer.cornerRadius = 48 / 2
        iv.backgroundColor = .purple
        return iv
    }()

    private let capTextView = CapTextView()
    
    private lazy var imageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "photo"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(handleSelectPhoto), for: .touchUpInside)
        return button
    }()
    
    private let selectedImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.setDimensions(width: 100, height: 100)
        iv.isHidden = true
        return iv
    }()
    
    // MARK: - Lifecycle
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Selectors
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleSubirPost() {
        guard let caption = capTextView.text else { return }
        
        PostService.shared.subirPost(caption: caption, image: selectedImage) { (error, ref) in
            if let error = error {
                print("DEBUG: Failed to upload post with error \(error.localizedDescription)")
                return
            }
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func handleSelectPhoto() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    // MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .white
        configureNavBar()
        
        let stack = UIStackView(arrangedSubviews: [profileImageView, capTextView])
        stack.axis = .horizontal
        stack.spacing = 12
        stack.alignment = .leading
        
        view.addSubview(stack)
        stack.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 16, paddingLeft: 16, paddingRight: 16)
        
        profileImageView.kf.setImage(with: user.profileImageUrl)
        
        view.addSubview(imageButton)
        imageButton.anchor(top: stack.bottomAnchor, left: view.leftAnchor, paddingTop: 16, paddingLeft: 16)
        
        view.addSubview(selectedImageView)
        selectedImageView.anchor(top: imageButton.bottomAnchor, left: view.leftAnchor, paddingTop: 16, paddingLeft: 16)
    }
    
    func configureNavBar() {
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.isTranslucent = false
                
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
        cancelButton.tintColor = .black
        cancelButton.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17)], for: .normal)
        navigationItem.leftBarButtonItem = cancelButton
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: actionButton)
    }
}

// MARK: - UIImagePickerControllerDelegate
extension SubirPostController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        selectedImage = image
        selectedImageView.image = image
        selectedImageView.isHidden = false
        dismiss(animated: true, completion: nil)
    }
}
