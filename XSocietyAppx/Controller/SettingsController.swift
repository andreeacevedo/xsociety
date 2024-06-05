//
//  SettingsController.swift
//  XSocietyAppx
//
//  Created by Administrador on 4/19/24.
//

import UIKit
import Firebase

private let reuseIdentifier = "SettingsCell"

class SettingsController: UIViewController {
    
    // MARK: - Properties
    
    private let tableView = UITableView()
    private let settingsOptions = ["Modo Oscuro", "Privacidad y Seguridad", "Notificaciones y Sonidos", "Ayuda"]
    private let settingsIcons = ["moon", "shield", "bell", "questionmark.circle"]
    
    private lazy var logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Log Out", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .lightGray
        button.layer.cornerRadius = 5
        button.setDimensions(width: 200, height: 50)
        button.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Selectors

    @objc func handleLogout() {
        do {
            try Auth.auth().signOut()
            let loginController = LoginController()
            let nav = UINavigationController(rootViewController: loginController)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: true, completion: nil)
        } catch let error {
            print("Failed to sign out with error \(error.localizedDescription)")
        }
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = .white
        
        let customFont = UIFont(name: "Chewy-Regular", size: 20.0)
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: customFont ?? UIFont.systemFont(ofSize: 20.0)]
        
        navigationItem.title = "Settings"
        
        // Configure table view
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SettingsCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 60
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        
        view.addSubview(tableView)
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor,
                         bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor)
        
        view.addSubview(logoutButton)
        logoutButton.centerX(inView: view)
        logoutButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingBottom: 20)
    }
}

// MARK: - UITableViewDelegate/DataSource

extension SettingsController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! SettingsCell
        cell.iconImageView.image = UIImage(systemName: settingsIcons[indexPath.row])
        cell.titleLabel.text = settingsOptions[indexPath.row]
        return cell
    }
}
