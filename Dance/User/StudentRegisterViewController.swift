import UIKit
import Alamofire
import SwiftyJSON

class StudentRegisterViewController: UIViewController {
    
    let topLabel = UILabel()
    let mailLabel = UILabel()
    let mailTextField = UITextField()
    let passwordLabel = UILabel()
    let passwordTextField = UITextField()
    let passwordLabel2 = UILabel()
    let passwordTextField2 = UITextField()
    let button = UIButton()
    let loginButton = UIButton()
    let cancelButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.topLabel.text = "新規登録(生徒)"
        self.mailLabel.text = "メールアドレス"
        self.passwordLabel.text = "パスワード"
        self.passwordLabel2.text = "パスワード(確認用)"
        self.button.setTitle("登録する", for: .normal)
        self.cancelButton.setTitle("キャンセル", for: .normal)
        self.loginButton.setTitle("ログインはこちら", for: .normal)
        
        self.topLabel.font = UIFont.boldSystemFont(ofSize: 22.0)
        self.button.titleLabel!.font = UIFont.boldSystemFont(ofSize: 20.0)
        self.cancelButton.titleLabel!.font = UIFont.systemFont(ofSize: 20.0)
        self.mailLabel.font = UIFont.systemFont(ofSize: 12.0)
        self.passwordLabel.font = UIFont.systemFont(ofSize: 12.0)
        self.passwordLabel2.font = UIFont.systemFont(ofSize: 12.0)
        
        self.mailTextField.borderStyle = .roundedRect
        self.passwordTextField.borderStyle = .roundedRect
        self.passwordTextField2.borderStyle = .roundedRect
        
        button.addTarget(self, action: #selector(register), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(goLogin), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        
        self.passwordTextField.isSecureTextEntry = true
        self.passwordTextField2.isSecureTextEntry = true
        
        self.view.addSubview(topLabel)
        self.view.addSubview(mailLabel)
        self.view.addSubview(mailTextField)
        self.view.addSubview(passwordLabel)
        self.view.addSubview(passwordTextField)
        self.view.addSubview(passwordLabel2)
        self.view.addSubview(passwordTextField2)
        self.view.addSubview(button)
        self.view.addSubview(cancelButton)
        self.view.addSubview(loginButton)
        
        self.topLabel.textAlignment = .center
        self.mailLabel.textAlignment = .left
        self.passwordLabel.textAlignment = .left
        self.passwordLabel2.textAlignment = .left
        
        self.topLabel.textColor = orangeColor
        self.button.titleLabel?.textColor = UIColor.white
        self.button.backgroundColor = orangeColor
        
        self.cancelButton.backgroundColor = UIColor.white
        self.cancelButton.setTitleColor(orangeColor, for: .normal)
        
        self.loginButton.setTitleColor(orangeColor, for: .normal)
        self.loginButton.layer.borderColor = orangeColor.cgColor
        self.loginButton.layer.borderWidth = 1.0
        
        
        self.topLabel.translatesAutoresizingMaskIntoConstraints = false
        self.mailLabel.translatesAutoresizingMaskIntoConstraints = false
        self.mailTextField.translatesAutoresizingMaskIntoConstraints = false
        self.passwordLabel.translatesAutoresizingMaskIntoConstraints = false
        self.passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        self.passwordLabel2.translatesAutoresizingMaskIntoConstraints = false
        self.passwordTextField2.translatesAutoresizingMaskIntoConstraints = false
        self.button.translatesAutoresizingMaskIntoConstraints = false
        self.cancelButton.translatesAutoresizingMaskIntoConstraints = false
        self.loginButton.translatesAutoresizingMaskIntoConstraints = false
        
        
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
        
        self.passwordLabel2.topAnchor.constraint(equalTo: self.passwordTextField.bottomAnchor, constant: 0.0).isActive = true
        self.passwordLabel2.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 50.0).isActive = true
        self.passwordLabel2.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -50.0).isActive = true
        self.passwordLabel2.heightAnchor.constraint(equalToConstant: 25.0).isActive = true
        
        
        self.passwordTextField2.topAnchor.constraint(equalTo: self.passwordLabel2.bottomAnchor, constant: 0.0).isActive = true
        self.passwordTextField2.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 50.0).isActive = true
        self.passwordTextField2.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -50.0).isActive = true
        self.passwordTextField2.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        
        self.button.topAnchor.constraint(equalTo: self.passwordTextField2.bottomAnchor, constant: 20.0).isActive = true
        self.button.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 50.0).isActive = true
        self.button.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -50.0).isActive = true
        self.button.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        
        self.button.layer.masksToBounds = true
        self.button.layer.cornerRadius = 25.0
        
        self.loginButton.topAnchor.constraint(equalTo: self.button.bottomAnchor, constant: 20.0).isActive = true
        self.loginButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 50.0).isActive = true
        self.loginButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -50.0).isActive = true
        self.loginButton.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        
        self.loginButton.layer.masksToBounds = true
        self.loginButton.layer.cornerRadius = 25.0
        
        self.cancelButton.topAnchor.constraint(equalTo: self.loginButton.bottomAnchor, constant: 20.0).isActive = true
        self.cancelButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 50.0).isActive = true
        self.cancelButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -50.0).isActive = true
        self.cancelButton.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        
        self.cancelButton.layer.masksToBounds = true
        self.cancelButton.layer.cornerRadius = 25.0
    
    }
    
    @objc func register() {
        
        guard let mail = mailTextField.text else {
            return
        }
        guard let password = passwordTextField.text else {
            return
        }
        
        if passwordTextField.text != passwordTextField2.text {
            makeAlert(message: "パスワードが一致しません")
        }
            
        else if textJudge(mail: mail, password: password) {
            
            let endURL = awsURL + "/student/create"
            let timeStamp = Int(NSDate().timeIntervalSince1970)
            
            let parameters:[String: Any] = ["email": self.mailTextField.text!, "password": self.passwordTextField.text!.md5(), "timeStamp": timeStamp]
            
            setIndicator2()
            Alamofire.request(endURL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
                self.removeIndicator2()
                
                if (response.error != nil) {
                    self.makeAlert(message: "このメールアドレスはすでに使われています")
                }
                else if let object = response.result.value {
                    let json = JSON(object)
                    
                    if let message = json["errorMessage"].string {
                        self.makeAlert(message: "このメールアドレスはすでに使われています")
                    }
                    else {
                        let myStudent = Student()
                        myStudent.setUserDefaults(id: self.mailTextField.text!)
                        
                        let reSize  = CGSize(width: 100, height: 100)
                        let resizedImage = UIImage(named: "no_image.jpg")!.reSizeImage(reSize: reSize)
                        uds.set(resizedImage.jpegData(compressionQuality: 1.0), forKey: "imagePath")
                        uploadSaveImage(image: UIImage(named: "no_image.jpg")!, path: uds.object(forKey: "myId") as! String)
                        
                        let alert = UIAlertController(title: "登録が完了しました。詳しい使い方はマイページの使い方ガイドをご覧ください。", message: nil, preferredStyle: .alert)
                        let action = UIAlertAction(title: "ホームへ", style: .default, handler: {
                            (action: UIAlertAction!) in
                            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                            let nc = mainStoryboard.instantiateViewController(withIdentifier: "tabBar") as! UITabBarController
                            
                            self.present(nc, animated: true, completion: nil)
                        })
                        
                        alert.addAction(action)
                        self.present(alert, animated: true, completion: nil)
                        
                    }
                    
                }
                else {
                    self.makeAlert(message: "エラーが発生しました")
                }
            
            
            }
        }

        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc func cancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func goLogin() {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let nc = mainStoryboard.instantiateViewController(withIdentifier: "studentLogin")
        present(nc, animated: true, completion: nil)
    }

    
}
