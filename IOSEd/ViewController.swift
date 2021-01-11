//
//  ViewController.swift
//  IOSEd
//
//  Created by Anna Yatsun on 11.01.2021.
//
import GoogleSignIn
import UIKit
import AuthenticationServices
import Firebase
import FirebaseAuth


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .red
        let play = UIBarButtonItem(title: "Play", style: .plain, target: self, action: #selector(playTapped))
        navigationItem.rightBarButtonItems = [play]
        let dataBase = DatabaseManager()
        dataBase.writeMessage()
    }

    @objc
    func playTapped() {
        print("action")
        try? Auth.auth().signOut()
        self.dismiss(animated: false)
    }
} 
//
