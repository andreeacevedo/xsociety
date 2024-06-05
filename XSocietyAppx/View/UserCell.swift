import UIKit

protocol UserCellDelegate: AnyObject {
    func didTapMessageButton(for user: User)
}

class UserCell: UITableViewCell {
    
    // MARK: - Properties
    var user: User? {
        didSet {
            configure()
        }
    }
    
    weak var delegate: UserCellDelegate?
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 40 / 2
        iv.backgroundColor = .lightGray
        return iv
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    private lazy var messageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Mensaje", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(handleMessageButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileImageView)
        profileImageView.anchor(left: leftAnchor, paddingLeft: 12)
        profileImageView.setDimensions(width: 40, height: 40)
        profileImageView.centerY(inView: self)
        
        addSubview(usernameLabel)
        usernameLabel.centerY(inView: self)
        usernameLabel.anchor(left: profileImageView.rightAnchor, paddingLeft: 12)
        
        addSubview(messageButton)
        messageButton.centerY(inView: self)
        messageButton.anchor(right: rightAnchor, paddingRight: 12)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    @objc func handleMessageButtonTapped() {
        guard let user = user else { return }
        delegate?.didTapMessageButton(for: user)
    }
    
    // MARK: - Helpers
    func configure() {
        guard let user = user else { return }
        usernameLabel.text = user.username
        if let url = user.profileImageUrl {
            profileImageView.kf.setImage(with: url) // Ensure Kingfisher is imported and added to your project
        } else {
            profileImageView.image = UIImage(named: "default_profile_image") // Image placeholder if profile image is not available
        }
    }
}

