//
//  utilities.swift
//  XSocietyAppx
//
//  Created by Administrador on 4/15/24.
//

import UIKit

class Utilities {
    func inputContainerView(withImage image: UIImage, textField: UITextField) -> UIView {
        let view = UIView()
        let iv = UIImageView()
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true

        iv.image = image
        
        view.addSubview(iv)
        iv.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, paddingLeft: 8, paddingBottom: 8)
        iv.setDimensions(width: 24, height: 24)
        
        view.addSubview(textField)
        textField.anchor(left: iv.rightAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingLeft: 8, paddingBottom: 8)
        
        let dividerView = UIView()
        dividerView.backgroundColor = .black
        view.addSubview(dividerView)
        dividerView.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingLeft: 8, height: 0.75)

        
        return view
    }
    
    func textField(withPlaceholder placeholder: String) -> UITextField {
        let tf = UITextField()
        tf.textColor = .black
        tf.font = UIFont(name: "CormorantGaramond-Regular", size: 20)
        tf.attributedPlaceholder = NSAttributedString(string: placeholder)
        return tf
    }
    
    func attributedButton(_ firstPart: String, _ secondPart: String) -> UIButton {
        let button = UIButton(type: .system)
        
        let attributedTitle = NSMutableAttributedString(string: firstPart, attributes: [NSAttributedString.Key.font: UIFont(name: "CormorantGaramond-Regular", size: 20), NSAttributedString.Key.foregroundColor: UIColor.black])
        
        attributedTitle.append(NSMutableAttributedString(string: secondPart, attributes: [NSAttributedString.Key.font: UIFont(name: "CormorantGaramond-Bold", size: 20), NSAttributedString.Key.foregroundColor: UIColor.black]))
        
        button.setAttributedTitle(attributedTitle, for: .normal)
        
        return button
    }
}
