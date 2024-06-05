//
//  SettingsCell.swift
//  XSocietyAppx
//
//  Created by Administrador on 5/22/24.
//

import UIKit

class SettingsCell: UITableViewCell {
    
    // MARK: - Properties
    
    let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.tintColor = .black
        iv.setDimensions(width: 24, height: 24)
        return iv
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(iconImageView)
        iconImageView.centerY(inView: self)
        iconImageView.anchor(left: leftAnchor, paddingLeft: 16)
        
        addSubview(titleLabel)
        titleLabel.centerY(inView: self)
        titleLabel.anchor(left: iconImageView.rightAnchor, paddingLeft: 16)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
