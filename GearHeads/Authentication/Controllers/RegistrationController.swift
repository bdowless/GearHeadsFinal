//
//  RegistrationController.swift
//  GearHeads
//
//  Created by Brandon Dowless on 8/10/21.
//

import UIKit
import Firebase

class RegistrationController: UIViewController {
    
    //MARK: - Properties
    
    private let imagePicker = UIImagePickerController()
    private var profileImage: UIImage?
    
    private let uploadPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "plus_photo"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.imageView?.clipsToBounds = true
        button.tintColor = .systemRed
        button.addTarget(self, action: #selector(plusPhotoButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    private lazy var emailContainerView: UIView = {
        let view = Utilities().inputContainerView(imageName: "envelope", textField: emailTextField)
        
        return view
        
    }()
    
    private lazy var passwordContainerView: UIView = {
        let iv = Utilities().inputContainerView(imageName: "lock", textField: passwordTextField)
        
        return iv
    }()
    
    private lazy var fullnameContainerView: UIView = {
        let iv = Utilities().inputContainerView(imageName: "person", textField: fullnameTextField)
        
        return iv
    }()
    
    private lazy var usernameContainerView: UIView = {
        let iv = Utilities().inputContainerView(imageName: "person", textField: usernameTextField)
        
        return iv
    }()
    
    
    private let emailTextField: UITextField = {
        let iv = Utilities().textField(placeholder: "Email")
        return iv
    }()
    
    private let passwordTextField: UITextField = {
        let iv = Utilities().textField(placeholder: "Password")
        iv.isSecureTextEntry = true
        return iv
    }()
    
    private let fullnameTextField: UITextField = {
        let iv = Utilities().textField(placeholder: "Full Name")
        return iv
    }()
    
    private let usernameTextField: UITextField = {
        let iv = Utilities().textField(placeholder: "Username")
        return iv
    }()
    
    let registrationButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign Up", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemRed
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        button.heightAnchor.constraint(equalToConstant: 50) .isActive = true
        button.addTarget(self, action: #selector(handleRegistration), for: .touchUpInside)
        return button
    }()
    
    let alreadyHaveAccountButton: UIButton = {
        let button = Utilities().attributedButton("Already have an account? ", "Log In")
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
    }
    
    //MARK: - Selectors
    
    @objc func handleDismiss() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func plusPhotoButton() {
        present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func handleRegistration() {
        guard let profileImage = profileImage else {
            print("Please select profile image")
            return
        }
        
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        guard let username = usernameTextField.text?.lowercased() else { return }
        guard let fullname = fullnameTextField.text else { return }
        let credentials = AuthCredentials(email: email, password: password, fullname: fullname, username: username, profileImage: profileImage)
        
        
        AuthService.shared.registerUser(credentials: credentials) { (error, ref) in
            if let error = error {
                print("DEBUG error is \(error.localizedDescription)")
                return
            }
            guard let uid = ref.key else { return }
            
            UserService.shared.fetchUser(uid: uid) { user in
                
                guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return }
                guard let tab = window.rootViewController as? MainTabController else { return }
                
                tab.user = user
                self.dismiss(animated: true)
            }
            
            
        }
    }

    // MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = .white
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        view.addSubview(uploadPhotoButton)
        uploadPhotoButton.heightAnchor.constraint(equalToConstant: 150) .isActive = true
        uploadPhotoButton.widthAnchor.constraint(equalToConstant: 150) .isActive = true
        uploadPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor) .isActive = true
        uploadPhotoButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 40) .isActive = true
        
        let stack = UIStackView(arrangedSubviews: [emailContainerView, passwordContainerView, fullnameContainerView, usernameContainerView])
        stack.axis = .vertical
        stack.spacing = 20
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stack)
        stack.centerXAnchor.constraint(equalTo: view.centerXAnchor) .isActive = true
        stack.topAnchor.constraint(equalTo: uploadPhotoButton.bottomAnchor, constant: 10) .isActive = true
        stack.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -32) .isActive = true
        
        view.addSubview(registrationButton)
        registrationButton.anchor(top: stack.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor,
        paddingTop: 32, paddingLeft: 32, paddingRight: 32)
        
        view.addSubview(alreadyHaveAccountButton)
        alreadyHaveAccountButton.anchor(left: view.leftAnchor,
                                     bottom: view.safeAreaLayoutGuide.bottomAnchor,
                                     right: view.rightAnchor, paddingLeft: 40, paddingRight: 40)
        }
    }


// MARK: - UIImagePickerControllerDelegate

extension RegistrationController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let profileImage = info[.editedImage] as? UIImage else { return }
        self.profileImage = profileImage
        
        uploadPhotoButton.layer.cornerRadius = 150 / 2
        uploadPhotoButton.layer.masksToBounds = true
        uploadPhotoButton.imageView?.contentMode = .scaleAspectFill
        uploadPhotoButton.imageView?.clipsToBounds = true
        uploadPhotoButton.layer.borderColor = UIColor.white.cgColor
        uploadPhotoButton.layer.borderWidth = 2
        self.uploadPhotoButton.setImage(profileImage.withRenderingMode(.alwaysOriginal), for: .normal)
        dismiss(animated: true, completion: nil)
        }
    }

