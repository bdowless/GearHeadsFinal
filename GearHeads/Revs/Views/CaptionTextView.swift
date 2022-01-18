//
//  CaptionTextView.swift
//  GearHeads
//
//  Created by Brandon Dowless on 10/13/21.
//

import UIKit

class CaptionTextView: UITextView {
    
    let placeholder: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .darkGray
        label.text = "Please Enter Your Rev Here"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        backgroundColor = .white
        font = UIFont.systemFont(ofSize: 16)
        isScrollEnabled = false
        heightAnchor.constraint(equalToConstant: 300) .isActive = true
        
        addSubview(placeholder)
        placeholder.topAnchor.constraint(equalTo: topAnchor, constant: 8) .isActive = true
        placeholder.leftAnchor.constraint(equalTo: leftAnchor, constant: 4) .isActive = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextInputChange), name: UITextView.textDidChangeNotification, object: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    
    @objc func handleTextInputChange() {
        placeholder.isHidden = !text.isEmpty
    }
}
