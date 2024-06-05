//  ChatController.swift
//  XSocietyAppx
//
//  Created by Administrador on 5/12/24.
//

import UIKit
import Firebase

class ChatController: UIViewController {
    
    // MARK: - Properties
    private var user: User?
    private var conversation: Conversation?
    private var messages = [Message]()
    private let tableView = UITableView()
    private let messageInputContainerView = UIView()
    private let messageInputTextView = UITextView()
    private let sendButton = UIButton(type: .system)
    
    // MARK: - Lifecycle
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
        createConversation()
    }
    
    init(conversation: Conversation) {
        self.conversation = conversation
        super.init(nibName: nil, bundle: nil)
        fetchMessages()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - API
    func createConversation() {
        guard let user = user, let currentUserId = Auth.auth().currentUser?.uid else { return }
        
        let db = Firestore.firestore()
        let conversationId = UUID().uuidString
        
        let conversationData: [String: Any] = [
            "id": conversationId,
            "participants": [user.uid, currentUserId],
            "lastMessage": "",
            "timestamp": Timestamp(date: Date())
        ]
        
        db.collection("conversations").document(conversationId).setData(conversationData) { error in
            if let error = error {
                print("Failed to create conversation: \(error.localizedDescription)")
                return
            }
            
            self.conversation = Conversation(dictionary: conversationData)
            self.fetchMessages()
        }
    }
    
    func fetchMessages() {
        guard let conversationId = conversation?.id else { return }
        
        let db = Firestore.firestore()
        db.collection("conversations").document(conversationId).collection("messages").order(by: "timestamp").addSnapshotListener { snapshot, error in
            if let error = error {
                print("Failed to fetch messages: \(error.localizedDescription)")
                return
            }
            
            guard let documents = snapshot?.documents else { return }
            self.messages = documents.map({ Message(dictionary: $0.data()) })
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .white
        navigationItem.title = user?.username ?? "Chat"
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MessageCell.self, forCellReuseIdentifier: "MessageCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50
        tableView.separatorStyle = .none
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
        
        view.addSubview(messageInputContainerView)
        messageInputContainerView.backgroundColor = .white
        messageInputContainerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            messageInputContainerView.leftAnchor.constraint(equalTo: view.leftAnchor),
            messageInputContainerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            messageInputContainerView.rightAnchor.constraint(equalTo: view.rightAnchor),
            messageInputContainerView.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        messageInputContainerView.addSubview(messageInputTextView)
        messageInputTextView.layer.cornerRadius = 8
        messageInputTextView.layer.borderColor = UIColor.lightGray.cgColor
        messageInputTextView.layer.borderWidth = 0.5
        messageInputTextView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            messageInputTextView.topAnchor.constraint(equalTo: messageInputContainerView.topAnchor, constant: 8),
            messageInputTextView.leftAnchor.constraint(equalTo: messageInputContainerView.leftAnchor, constant: 8),
            messageInputTextView.bottomAnchor.constraint(equalTo: messageInputContainerView.bottomAnchor, constant: -8),
            messageInputTextView.rightAnchor.constraint(equalTo: sendButton.leftAnchor, constant: -8)
        ])
        
        messageInputContainerView.addSubview(sendButton)
        sendButton.setTitle("Enviar", for: .normal)
        sendButton.addTarget(self, action: #selector(handleSendMessage), for: .touchUpInside)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            sendButton.topAnchor.constraint(equalTo: messageInputContainerView.topAnchor, constant: 8),
            sendButton.rightAnchor.constraint(equalTo: messageInputContainerView.rightAnchor, constant: -8),
            sendButton.bottomAnchor.constraint(equalTo: messageInputContainerView.bottomAnchor, constant: -8),
            sendButton.widthAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    // MARK: - Selectors
    @objc func handleSendMessage() {
        guard let messageText = messageInputTextView.text, !messageText.isEmpty else { return }
        
        let db = Firestore.firestore()
        guard let conversationId = conversation?.id else { return }
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        
        let data: [String: Any] = [
            "text": messageText,
            "fromId": currentUserId,
            "toId": user?.uid ?? "",
            "timestamp": Timestamp(date: Date())
        ]
        
        db.collection("conversations").document(conversationId).collection("messages").addDocument(data: data) { error in
            if let error = error {
                print("Failed to send message: \(error.localizedDescription)")
                return
            }
            
            self.messageInputTextView.text = nil
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension ChatController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as! MessageCell
        cell.message = messages[indexPath.row]
        return cell
    }
}
