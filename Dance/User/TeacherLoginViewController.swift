import UIKit
import Alamofire
import SwiftyJSON
//ログインも会員登録も本質的には変わらない ログインから戻れないー
class TeacherLoginViewController: UIViewController {
    
    let topLabel = UILabel()
    let mailLabel = UILabel()
    let mailTextField = UITextField()
    let passwordLabel = UILabel()
    let passwordTextField = UITextField()
    let button = UIButton()
    let cancelButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.topLabel.text = "講師用ログイン"
        self.mailLabel.text = "メールアドレス"
        self.passwordLabel.text = "パスワード"
        self.button.setTitle("ログイン", for: .normal)
        self.cancelButton.setTitle("キャンセル", for: .normal)
        
        self.topLabel.font = UIFont.boldSystemFont(ofSize: 22.0)
        self.button.titleLabel!.font = UIFont.boldSystemFont(ofSize: 20.0)
        self.mailLabel.font = UIFont.systemFont(ofSize: 12.0)
        self.passwordLabel.font = UIFont.systemFont(ofSize: 12.0)
        self.cancelButton.titleLabel!.font = UIFont.systemFont(ofSize: 20.0)
        
        self.mailTextField.borderStyle = .roundedRect
        self.passwordTextField.borderStyle = .roundedRect
        
        button.addTarget(self, action: #selector(login), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        
        self.passwordTextField.isSecureTextEntry = true
        
        self.view.addSubview(topLabel)
        self.view.addSubview(mailLabel)
        self.view.addSubview(mailTextField)
        self.view.addSubview(passwordLabel)
        self.view.addSubview(passwordTextField)
        self.view.addSubview(button)
        self.view.addSubview(cancelButton)
        
        self.topLabel.textAlignment = .center
        self.mailLabel.textAlignment = .left
        self.passwordLabel.textAlignment = .left
        
        self.topLabel.textColor = orangeColor
        self.button.setTitleColor(UIColor.white, for: .normal)
        self.button.backgroundColor = orangeColor
        self.cancelButton.backgroundColor = UIColor.white
        self.cancelButton.setTitleColor(orangeColor, for: .normal)
        
        self.topLabel.translatesAutoresizingMaskIntoConstraints = false
        self.mailLabel.translatesAutoresizingMaskIntoConstraints = false
        self.mailTextField.translatesAutoresizingMaskIntoConstraints = false
        self.passwordLabel.translatesAutoresizingMaskIntoConstraints = false
        self.passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        self.button.translatesAutoresizingMaskIntoConstraints = false
        self.cancelButton.translatesAutoresizingMaskIntoConstraints = false
        
        
        self.topLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 50.0).isActive = true
        self.topLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 50.0).isActive = true
        self.topLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -50.0).isActive = true
        self.topLabel.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        
        self.mailLabel.topAnchor.constraint(equalTo: self.topLabel.bottomAnchor, constant: 20.0).isActive = true
        self.mailLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 50.0).isActive = true
        self.mailLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -50.0).isActive = true
        self.mailLabel.heightAnchor.constraint(equalToConstant: 25.0).isActive = true
        
        self.mailTextField.topAnchor.constraint(equalTo: self.mailLabel.bottomAnchor, constant: 0.0).isActive = true
        self.mailTextField.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 50.0).isActive = true
        self.mailTextField.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -50.0).isActive = true
        self.mailTextField.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        
        self.passwordLabel.topAnchor.constraint(equalTo: self.mailTextField.bottomAnchor, constant: 0.0).isActive = true
        self.passwordLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 50.0).isActive = true
        self.passwordLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -50.0).isActive = true
        self.passwordLabel.heightAnchor.constraint(equalToConstant: 25.0).isActive = true
        
        self.passwordTextField.topAnchor.constraint(equalTo: self.passwordLabel.bottomAnchor, constant: 0.0).isActive = true
        self.passwordTextField.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 50.0).isActive = true
        self.passwordTextField.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -50.0).isActive = true
        self.passwordTextField.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        
        self.button.topAnchor.constraint(equalTo: self.passwordTextField.bottomAnchor, constant: 20.0).isActive = true
        self.button.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 50.0).isActive = true
        self.button.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -50.0).isActive = true
        self.button.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        
        self.button.layer.masksToBounds = true
        self.button.layer.cornerRadius = 25.0
        
        self.cancelButton.topAnchor.constraint(equalTo: self.button.bottomAnchor, constant: 20.0).isActive = true
        self.cancelButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 50.0).isActive = true
        self.cancelButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -50.0).isActive = true
        self.cancelButton.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        
        self.cancelButton.layer.masksToBounds = true
        self.cancelButton.layer.cornerRadius = 25.0
    }
    
    @objc func login() {
        guard let mail = mailTextField.text else {
            return
        }
        guard let password = passwordTextField.text else {
            return
        }
        
        if textJudge(mail: mail, password: password) {
            let endURL = awsURL + "/teacher/login"
            let parameters:[String: String] = ["email": self.mailTextField.text!, "password": self.passwordTextField.text!.md5()]
            
            let apimanager = APIManager(url: endURL, method: .post, parameters: parameters, view: self)
            apimanager.request(fail: { () in
                self.makeAlert(message: "メールアドレスかパスワードが誤っています")
            }, success: { (json: JSON) in
                let myUser = Teacher()
                myUser.setUserDefaults(id: self.mailTextField.text!)
                fetchData(myId: self.mailTextField.text!)
                
                let alert = UIAlertController(title: "ログインが完了しました", message: nil, preferredStyle: .alert)
                let action = UIAlertAction(title: "ホームへ", style: .default, handler: {
                    (action: UIAlertAction!) in
                    
                    let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let nc = mainStoryboard.instantiateViewController(withIdentifier: "tabBar2") as! UITabBarController
                    
                    self.present(nc, animated: true, completion: nil)
                })
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            })
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
        
    @objc func cancel() {
        dismiss(animated: true, completion: nil)
    }
    
}
