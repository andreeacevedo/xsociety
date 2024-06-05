//
//  RegistrationController.swift
//  XSocietyAppx
//
//  Created by Administrador on 4/7/24.
//

import UIKit
import Firebase

class RegistrationController: UIViewController {
    // MARK: - Properties
    
    private let imagePicker = UIImagePickerController()
    private var profileImage: UIImage?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "XSociety"
        label.font = UIFont(name: "Chewy-Regular", size: 40)
        label.textColor = .black
        return label
    }()
    
    private let holoBar: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.image = #imageLiteral(resourceName: "holo2 2")
        return iv
    }()
    
    let loginTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Registrate en XSociety"
        label.font = UIFont(name: "Chewy-Regular", size: 24)
        label.textColor = .black
        return label
    }()
    
    private let plusPhotoBtn: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "plus_photo"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(handleAddProfilePic), for: .touchUpInside)
        return button
    }()
    
    //containerview
    private lazy var usernameContainerView: UIView = {
        let image = #imageLiteral(resourceName: "user")
        let view = Utilities().inputContainerView(withImage: image, textField: usernameTextField)
        
        return view
    }()
    
    private lazy var fullnameContainerView: UIView = {
        let image = #imageLiteral(resourceName: "user")
        let view = Utilities().inputContainerView(withImage: image, textField: fullNameTextField)
        
        return view
    }()
    
    private lazy var emailContainerView: UIView = {
        let image = #imageLiteral(resourceName: "email")
        let view = Utilities().inputContainerView(withImage: image, textField: emailTextField)
        
        return view
    }()
    
    private lazy var passwordContainerView: UIView = {
        let image = #imageLiteral(resourceName: "password")
        let view = Utilities().inputContainerView(withImage: image, textField: passwordTextField)
        
        return view
    }()
    
    //textfield
    
    private let usernameTextField: UITextField = {
        let tf = Utilities().textField(withPlaceholder: "Username")
        return tf
    }()
    
    private let fullNameTextField: UITextField = {
        let tf = Utilities().textField(withPlaceholder: "Full Name")
        return tf
    }()
    
    private let emailTextField: UITextField = {
        let tf = Utilities().textField(withPlaceholder: "Email")
        return tf
    }()
    
    private let passwordTextField: UITextField = {
        let tf = Utilities().textField(withPlaceholder: "Password")
        tf.isSecureTextEntry = true
        return tf
    }()

    private let regisButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Registrarse", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.titleLabel?.font = UIFont(name: "CormorantGaramond-Regular", size: 20)
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.layer.cornerRadius = 12
        button.addTarget(self, action: #selector(handleRegis), for: .touchUpInside)
        return button
    }()
    
    private let siAccountButton: UIButton = {
        let button = Utilities().attributedButton("Ya tienes una cuenta? ", "Inicia sesión")
        button.addTarget(self, action: #selector(handleShowRegis), for: .touchUpInside)

        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Selectors
    
    @objc func handleAddProfilePic(){
        present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func handleRegis(){
        guard let profileImage = profileImage else {
            print("DEBUG: Please select a profile image")
            return
        }
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        guard let fullname = fullNameTextField.text else { return }
        guard let username = usernameTextField.text?.lowercased() else { return }
        
        let credentials = AuthCredentials(email: email, password: password, fullname: fullname, username: username, profileImage: profileImage)
        
        AuthService.shared.registerUser(credentials: credentials) { (error, ref) in
            guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return }

            guard let tab = window.rootViewController as? MainTabController else { return }
            tab.authenticateUserAndConfigureUI()
            self.dismiss(animated: true, completion: nil)
        }
        
 
    }
    
    @objc func handleShowRegis(){
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Helpers
    func configureUI(){
        view.backgroundColor = .white
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isHidden = true
        
        view.addSubview(titleLabel)
        titleLabel.centerX(inView: view)
        titleLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 40)
        
        // logo
        view.addSubview(holoBar)
        holoBar.centerX(inView: view)
        holoBar.anchor(top: titleLabel.bottomAnchor, paddingTop: 8)
        holoBar.setDimensions(width: 200, height: 30)
        
        view.addSubview(loginTitleLabel)
        loginTitleLabel.centerX(inView: view)
        loginTitleLabel.anchor(top: holoBar.bottomAnchor, paddingTop: 8)
        
        view.addSubview(plusPhotoBtn)
        plusPhotoBtn.centerX(inView: view)
        plusPhotoBtn.anchor(top: loginTitleLabel.bottomAnchor, paddingTop: 10)
        plusPhotoBtn.setDimensions(width: 128, height: 128)
        
        let stack = UIStackView(arrangedSubviews: [usernameContainerView, fullnameContainerView, emailContainerView, passwordContainerView, regisButton])
        stack.axis = .vertical
        stack.spacing = 20
        stack.distribution = .fillEqually
        
        view.addSubview(stack)
        stack.anchor(top: plusPhotoBtn.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 8, paddingLeft: 32, paddingRight: 32)
        
        view.addSubview(siAccountButton)
        siAccountButton.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingLeft: 40, paddingRight: 40)
    }
}

// MARK: - Selector de Imagen

extension RegistrationController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let profileImage = info[.editedImage] as? UIImage else {return}
        self.profileImage = profileImage
        
        plusPhotoBtn.layer.cornerRadius = 128 / 2
        plusPhotoBtn.layer.masksToBounds = true
        plusPhotoBtn.imageView?.contentMode = .scaleToFill
        plusPhotoBtn.imageView?.clipsToBounds = true
        plusPhotoBtn.layer.borderColor = UIColor.black.cgColor
        plusPhotoBtn.layer.borderWidth = 3
        
        self.plusPhotoBtn.setImage(profileImage.withRenderingMode(.alwaysOriginal), for: .normal)
        
        dismiss(animated: true, completion: nil)
    }
}
