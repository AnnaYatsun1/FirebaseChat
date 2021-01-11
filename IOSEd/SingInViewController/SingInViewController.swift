//
//  SingInViewController.swift
//  IOSEd
//
//  Created by Anna Yatsun on 11.01.2021.
//

import UIKit
import GoogleSignIn
import AuthenticationServices
import Firebase
import FirebaseAuth

enum Event {
    case logOut
}


class SingInViewController: UIViewController, GIDSignInDelegate, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
//    var eventHandel: (Event) -> ()
    
    
    @IBOutlet weak var singInStackView: UIStackView!

    
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
          if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
            print("The user has not signed in before or they have since signed out.")
          } else {
            print("\(error.localizedDescription)")
          }
          return
        }
        // Perform any operations on signed in user here.
        let userId = user.userID                  // For client-side use only!
        let idToken = user.authentication.idToken // Safe to send to the server
        let accessToken = user.authentication.accessToken
        let fullName = user.profile.name
        let givenName = user.profile.givenName
        let familyName = user.profile.familyName
        let email = user.profile.email
        
        guard  let id = idToken, let token = accessToken else { return }
//        let credential = GoogleAuthProvider.credential(
//            withIDToken: id,
//            accessToken: token
//        )
        
        let creds = GoogleAuthProvider.credential(withIDToken: id, accessToken: token)
        Auth.auth().signIn(with: creds) { (authResult, error) in

            if let authResult = authResult {
                let controller = UINavigationController(rootViewController: ViewController())
                    //ViewController()
                controller.modalPresentationStyle = .fullScreen
                self.present(controller, animated: true) {
                    
                }
            }
        }
        
//        let user = User(userId: userId, idToken: idToken, fullName: fullName, givenName: givenName, familyName: familyName, email: email)
//        Auth.auth().signIn(with: credential) { (authResult, error) in
//
//            print(authResult)
//            print(error)
//
//        }
        print(user)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
        self.view.backgroundColor = .blue
        self.setupProviderLoginView()
        let googleSignInButton = GIDSignInButton(frame: CGRect.init(x: 100, y: 100, width: 100, height: 100))
        self.singInStackView.addArrangedSubview(googleSignInButton)
        // Do any additional setup after loading the view.
    }

    func setupProviderLoginView() {
        let authorizationButton = ASAuthorizationAppleIDButton()
        authorizationButton.addTarget(self, action: #selector(handleAuthorizationAppleIDButtonPress), for: .touchUpInside)
        self.singInStackView.addArrangedSubview(authorizationButton)
    }
    
    @objc
    func handleAuthorizationAppleIDButtonPress() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            
            // Create an account in your system.
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            
            // For the purpose of this demo app, store the `userIdentifier` in the keychain.
//            self.saveUserInKeychain(userIdentifier)
            
            // For the purpose of this demo app, show the Apple ID credential information in the `ResultViewController`.
//            self.showResultViewController(userIdentifier: userIdentifier, fullName: fullName, email: email)
        
        case let passwordCredential as ASPasswordCredential:
        
            // Sign in using an existing iCloud Keychain credential.
            let username = passwordCredential.user
            let password = passwordCredential.password
            
            // For the purpose of this demo app, show the password credential as an alert.
            DispatchQueue.main.async {
//                self.showPasswordCredentialAlert(username: username, password: password)
            }
            
        default:
            break
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print(error.localizedDescription)
    }
}


struct User {
    let userId: String?                // For client-side use only!
    let idToken: String? // Safe to send to the server
    let fullName: String?
    let givenName: String?
    let familyName: String?
    let email: String?
}
