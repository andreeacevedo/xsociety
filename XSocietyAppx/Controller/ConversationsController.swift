//  ConversationsController.swift
//  XSocietyAppx
//
//  Created by Administrador on 5/12/24.
//

import UIKit
import Firebase

class ConversationsController: UITableViewController {
    
    // MARK: - Properties
    private let reuseIdentifier = "ConversationCell"
    private var conversations = [Conversation]()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchConversations()
    }
    
    // MARK: - API
    func fetchConversations() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let db = Firestore.firestore()
        db.collection("conversations").whereField("participants", arrayContains: uid).addSnapshotListener { snapshot, error in
            if let error = error {
                print("Failed to fetch conversations: \(error.localizedDescription)")
                return
            }
            
            guard let documents = snapshot?.documents else { return }
            self.conversations = documents.map({ Conversation(dictionary: $0.data()) })
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .white
        let customFont = UIFont(name: "Chewy-Regular", size: 20.0)
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: customFont ?? UIFont.systemFont(ofSize: 20.0)]
        
        navigationItem.title = "Chats"
        
        tableView.register(ConversationCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 80
        tableView.separatorStyle = .none
        
        let searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(handleSearchUsers))
        navigationItem.rightBarButtonItem = searchButton
    }
    
    @objc func handleSearchUsers() {
        let searchUserController = SearchUserController()
        navigationController?.pushViewController(searchUserController, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension ConversationsController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversations.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! ConversationCell
        cell.conversation = conversations[indexPath.row]
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ConversationsController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let conversation = conversations[indexPath.row]
        let chatController = ChatController(conversation: conversation)
        navigationController?.pushViewController(chatController, animated: true)
    }
}

