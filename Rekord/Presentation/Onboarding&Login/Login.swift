//
//  Login.swift
//  Rekord
//
//  Created by Julius Cesario on 27/07/21.
//

import UIKit
import AuthenticationServices


class Login: UIViewController {
    
    var userID = ""
    let userDefaults = UserDefaults()

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView(){
        let appleButton = ASAuthorizationAppleIDButton()
        appleButton.translatesAutoresizingMaskIntoConstraints = false
        appleButton.addTarget(self, action: #selector(didTapAppleButton), for: .touchUpInside)
        
        view.addSubview(appleButton)
        NSLayoutConstraint.activate([
            appleButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            appleButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            appleButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30)
        ])
    }
    
    @objc func didTapAppleButton() {
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ToSetupBusinessSegue"{
           
            let destinationVC = segue.destination as? SetupBusinessViewController
   
            destinationVC?.userID = userID
        } else if segue.identifier == "ToKeypadSegue" {
            let destinationVC = segue.destination as! LockScreen
        }
    }
}

extension Login: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        switch authorization.credential{
        
        case let credentials as ASAuthorizationAppleIDCredential:
            userID = credentials.user
            
            let appleId = UserRepository.shared.getUserByAppleId(userID){ (result) in
                if result.airtableId != "" || result.airtableId != nil {
                    
                    if credentials.user == result.appleId{
                        self.toKeypadSegue()
                    } else {
                        self.toSetupBusinessSegue()
                    }
                    
                } else {
                    print("error save")
                }
            }
            
        default: break
        }
    }
    
    func toKeypadSegue(){
        performSegue(withIdentifier: "ToKeypadSegue", sender: self)
    }
    
    func toSetupBusinessSegue(){
        performSegue(withIdentifier: "ToSetupBusinessSegue", sender: self)
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("error")
    }
}

extension Login: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }
    
    
}

