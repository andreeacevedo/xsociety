//  SearchUserController.swift
//  XSocietyAppx
//
//  Created by Administrador on 5/12/24.
//

import UIKit
import Firebase

class SearchUserController: UITableViewController {

    // MARK: - Properties
    private var users = [User]()
    private var filteredUsers = [User]()
    private let searchController = UISearchController(searchResultsController: nil)

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchUsers()
    }

    // MARK: - API
    func fetchUsers() {
        Firestore.firestore().collection("users").getDocuments { snapshot, error in
            if let error = error {
                print("Failed to fetch users: \(error.localizedDescription)")
                return
            }
            
            guard let documents = snapshot?.documents else { return }
            self.users = documents.compactMap { document in
                let data = document.data() as [String: AnyObject]
                let uid = document.documentID
                return User(uid: uid, dictionary: data)
            }
            self.tableView.reloadData()
        }
    }

    // MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .white
        navigationItem.title = "Buscar Usuario"
        
        tableView.register(UserCell.self, forCellReuseIdentifier: "UserCell")
        tableView.rowHeight = 80
        tableView.separatorStyle = .none
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Buscar Usuario"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        let backButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(handleBack))
        navigationItem.leftBarButtonItem = backButton
    }
    
    @objc func handleBack() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UITableViewDataSource
extension SearchUserController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFiltering ? filteredUsers.count : users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserCell
        let user = isFiltering ? filteredUsers[indexPath.row] : users[indexPath.row]
        cell.user = user
        cell.delegate = self
        return cell
    }
}

// MARK: - UITableViewDelegate
extension SearchUserController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = isFiltering ? filteredUsers[indexPath.row] : users[indexPath.row]
        let chatController = ChatController(user: user)
        navigationController?.pushViewController(chatController, animated: true)
    }
}

// MARK: - UISearchResultsUpdating
extension SearchUserController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text?.lowercased() else { return }
        filteredUsers = users.filter({ $0.username.lowercased().contains(searchText) })
        tableView.reloadData()
    }
    
    var isFiltering: Bool {
        return searchController.isActive && !searchController.searchBar.text!.isEmpty
    }
}

// MARK: - UserCellDelegate
extension SearchUserController: UserCellDelegate {
    func didTapMessageButton(for user: User) {
        let chatController = ChatController(user: user)
        navigationController?.pushViewController(chatController, animated: true)
    }
}

