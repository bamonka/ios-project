//
//  AuthViewController.swift
//  MusicExpress
//
//  Created by Лексус on 21.04.2021.
//

import UIKit
import WebKit

class AuthViewController: UIViewController, WKNavigationDelegate {
    
    private let login: UITextField = {
        let tf = UITextField()
        tf.borderStyle = .none
        tf.layer.cornerRadius = 5
        tf.backgroundColor = UIColor(red: 70 / 255, green: 70 / 255, blue: 70 / 255, alpha: 70 / 255)
        tf.textColor = UIColor(red: 255 / 255, green: 255 / 255, blue: 255 / 255, alpha: 0 / 255)
        tf.font = UIFont.systemFont(ofSize: 17)
        tf.autocorrectionType = .no

        var placeholder = NSMutableAttributedString()
        placeholder = NSMutableAttributedString(
            attributedString: NSAttributedString(
                string: "Login",
                attributes: [
                    NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18),
                    .foregroundColor: UIColor(white: 1, alpha: 0.7)
                ]
            )
        )

        tf.attributedPlaceholder = placeholder
        tf.frame = CGRect(
            x: 0,
            y: 0,
            width: 0,
            height: 20
        )
        
        return tf
    }()
    
    private let password: UITextField = {
        let tf = UITextField()
        tf.borderStyle = .none
        tf.layer.cornerRadius = 5
        tf.backgroundColor = UIColor(red: 70 / 255, green: 70 / 255, blue: 70 / 255, alpha: 70 / 255)
        tf.textColor = UIColor(red: 255 / 255, green: 255 / 255, blue: 255 / 255, alpha: 0 / 255)
        tf.font = UIFont.systemFont(ofSize: 17)
        tf.autocorrectionType = .no

        var placeholder = NSMutableAttributedString()
        placeholder = NSMutableAttributedString(
            attributedString: NSAttributedString(
                string: "Password",
                attributes: [
                    NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18),
                    .foregroundColor: UIColor(white: 1, alpha: 0.7)
                ]
            )
        )

        tf.attributedPlaceholder = placeholder
        tf.frame = CGRect(
            x: 0,
            y: 0,
            width: 0,
            height: 20
        )
        
        return tf
    }()
    
    let loginButton: UIButton = {
        let button = UIButton()
        let attributedString = NSMutableAttributedString(
            attributedString: NSAttributedString(
                string: "Login",
                attributes: [
                    NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18),
                    .foregroundColor: UIColor.white
                ]
            )
        )
        
        button.setAttributedTitle(attributedString, for: .normal)
        
        button.backgroundColor = UIColor(red: 70 / 255, green: 70 / 255, blue: 70 / 255, alpha: 70 / 255)

        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        
        button.layer.borderColor = CGColor(
            red: 5 / 255,
            green: 7 / 255,
            blue: 8 / 255,
            alpha: 4 / 10
        )
        
        button.frame = CGRect(
            x: 0,
            y: 0,
            width: 0,
            height: 20
        )
        
        return button
    }()
    
    public var completionHandler: ((Bool) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Sign In"
        view.backgroundColor = .systemBackground
        
        let stackView = mainStackView()
        view.addSubview(stackView)
        stackView.frame = CGRect(
            x: 20,
            y: view.height / 2,
            width: view.width - 40,
            height: 210
        )
        
        /* webView.navigationDelegate = self
        view.addSubview(webView)
        
        guard let url = AuthManager.shared.signInUrl else {
            return
        }
        
        webView.load(URLRequest(url: url))*/
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    func mainStackView() -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: [login, password, loginButton])
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 10
        
        return stackView
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
