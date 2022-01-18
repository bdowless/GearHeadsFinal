//
//  Utilities.swift
//  GearHeads
//
//  Created by Brandon Dowless on 6/15/21.
//

import UIKit

class Utilities {
    func inputContainerView(imageName: String, textField: UITextField) -> UIView {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        let iv = UIImageView()
        iv.image = UIImage(systemName: imageName)
        iv.contentMode = .scaleAspectFit
        iv.tintColor = .darkGray
        iv.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(iv)
        iv.heightAnchor.constraint(equalToConstant: 24) .isActive = true
        iv.widthAnchor.constraint(equalToConstant: 24) .isActive = true
        iv.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8) .isActive = true
        iv.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8) .isActive = true
        
        view.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.leftAnchor.constraint(equalTo: iv.leftAnchor, constant: 36) .isActive = true
        textField.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8) .isActive = true
        
        
        let dividerView = UIView()
        dividerView.backgroundColor = .systemRed
        dividerView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(dividerView)
        dividerView.widthAnchor.constraint(equalTo: view.widthAnchor) .isActive = true
        dividerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -1) .isActive = true
        dividerView.heightAnchor.constraint(equalToConstant: 0.75) .isActive = true
        
        return view
    }
    
    func textField(placeholder: String) -> UITextField {
        let textfield = UITextField()
        textfield.textColor = .black
        textfield.font = UIFont.systemFont(ofSize: 16)
        textfield.placeholder = placeholder
        
        return textfield
    }
    
    func attributedButton(_ firstPart: String, _ secondPart: String) -> UIButton {
        let button = UIButton(type: .system)
        
        let attributedTitle = NSMutableAttributedString(string: firstPart, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16),
                                                                                        NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        
        attributedTitle.append(NSAttributedString(string: secondPart, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15),
                                                                                   NSAttributedString.Key.foregroundColor: UIColor.black]))
        
        button.setAttributedTitle(attributedTitle, for: .normal)
        
        return button
    }
}
