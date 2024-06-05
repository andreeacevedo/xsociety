//
//  LoginController.swift
//  XSocietyAppx
//
//  Created by Administrador on 4/7/24.
//

import UIKit

class LoginController: UIViewController {
    // MARK: - Properties
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "XSociety"
        label.font = UIFont(name: "Chewy-Regular", size: 40)
        label.textColor = .black
        return label
    }()
    
    private let logoImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.image = #imageLiteral(resourceName: "login")
        return iv
    }()
    
    let loginTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Inicia sesión en XSociety"
        label.font = UIFont(name: "Chewy-Regular", size: 24)
        label.textColor = .black
        return label
    }()
    
    private lazy var emailContainerView: UIView = {
        let image = #imageLiteral(resourceName: "user")
        let view = Utilities().inputContainerView(withImage: image, textField: emailTextField)
        
        return view
    }()
    
    private lazy var passwordContainerView: UIView = {
        let image = #imageLiteral(resourceName: "password")
        let view = Utilities().inputContainerView(withImage: image, textField: passwordTextField)
        
        return view
    }()
    
    private let emailTextField: UITextField = {
        let tf = Utilities().textField(withPlaceholder: "Email or username")
        return tf
    }()
    
    private let passwordTextField: UITextField = {
        let tf = Utilities().textField(withPlaceholder: "Password")
        tf.isSecureTextEntry = true
        return tf
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.titleLabel?.font = UIFont(name: "CormorantGaramond-Regular", size: 20)
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.layer.cornerRadius = 12
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()
    
    private let noAccountButton: UIButton = {
        let button = Utilities().attributedButton("No tienes una cuenta? ", "Registrate")
        button.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)

        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Selectors
    
    @objc func handleLogin(){
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        AuthService.shared.logUserIn(withEmail: email, password: password) { (result, error) in
            if let error = error {
                print("DEBUG: Error logging in \(error.localizedDescription)")
                return
            }
            guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return }

            guard let tab = window.rootViewController as? MainTabController else { return }
            tab.authenticateUserAndConfigureUI()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func handleShowSignUp(){
        let controller = RegistrationController()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    // MARK: - Helpers
    func configureUI(){
        view.backgroundColor = .white
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isHidden = true
        
        view.addSubview(titleLabel)
        titleLabel.centerX(inView: view)
        titleLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 40)
        
        // logo
        view.addSubview(logoImageView)
        logoImageView.centerX(inView: view)
        logoImageView.anchor(top: titleLabel.bottomAnchor, paddingTop: 20)
        logoImageView.setDimensions(width: 150, height: 150)
        
        view.addSubview(loginTitleLabel)
        loginTitleLabel.centerX(inView: view)
        loginTitleLabel.anchor(top: logoImageView.bottomAnchor, paddingTop: 20)
        
        let stack = UIStackView(arrangedSubviews: [emailContainerView, passwordContainerView, loginButton])
        stack.axis = .vertical
        stack.spacing = 20
        stack.distribution = .fillEqually
        
        view.addSubview(stack)
        stack.anchor(top: loginTitleLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 28, paddingLeft: 32, paddingRight: 32)
        
        view.addSubview(noAccountButton)
        noAccountButton.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingLeft: 40, paddingRight: 40)
    }
}
