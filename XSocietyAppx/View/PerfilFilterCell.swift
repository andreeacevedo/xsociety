//
//  PerfilFilterCell.swift
//  XSocietyAppx
//
//  Created by Administrador on 5/22/24.
//

import UIKit

class PerfilFilterCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    var option: PerfilFilterOptions! {
        didSet { titleLabel.text = option.description }
    }
    
    let titleLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .lightGray
        label.text = "Test"
        return label
    }()
    
    override var isSelected: Bool {
        didSet {
            titleLabel.font = isSelected ? UIFont.boldSystemFont(ofSize: 16) :
                UIFont.systemFont(ofSize: 14)
            titleLabel.textColor = isSelected ? .black : .lightGray
        }
    }
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        addSubview(titleLabel)
        titleLabel.center(inView: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
