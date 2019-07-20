import UIKit
//ログイン前のアレが色々困るな　ログイン前にトーク画面とか見られたら面倒　required 　意外と案内メールを送るのはむずい　トランザクションも避けたいけどなー　うーん
class SelectViewController: UIViewController {

    let selectView = SelectView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSwipeBack()
        selectView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
    }

    override func viewDidAppear(_ animated: Bool) {
        
        if (uds.object(forKey: "myId") != nil) && imTeacher == true {
            
            let nickName = uds.object(forKey: "name") as? String ?? "未設定"
            if nickName == nil || nickName == "未設定" || nickName == "ゲスト" {
                
                let vc: UIViewController = ImageNameViewController()
                present(vc, animated: true, completion: nil)
               
            }
            else {
                let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let nc = mainStoryboard.instantiateViewController(withIdentifier: "tabBar2") as! UITabBarController
                present(nc, animated: true, completion: nil)
            }
    
        }
        else if (uds.object(forKey: "myId") != nil) && imTeacher == false {
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let nc = mainStoryboard.instantiateViewController(withIdentifier: "tabBar") as! UITabBarController
            
            present(nc, animated: true, completion: nil)
        }
        else {
            view.addSubview(selectView)
            selectView.leftButton.addTarget(self, action: #selector(learn), for: .touchUpInside)
            selectView.rightButton.addTarget(self, action: #selector(teach), for: .touchUpInside)
        }
    }
    
    @objc func learn() {
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let nc = mainStoryboard.instantiateViewController(withIdentifier: "tabBar") as! UITabBarController
        uds.set(false, forKey: "imTeacher")
        present(nc, animated: true, completion: nil)
    }
    
    @objc func teach() {
        //ログイン画面へ
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let nc = mainStoryboard.instantiateViewController(withIdentifier: "teacherRegister")
        uds.set(true, forKey: "imTeacher")
        present(nc, animated: true, completion: nil)
        //ログインでUserDefaultsをあれするのである
    }

}
