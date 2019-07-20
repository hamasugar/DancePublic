import UIKit
import Stripe
import SwiftyJSON
import StoreKit
// MVCはなかなかの難関ですな　
class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, STPAddCardViewControllerDelegate {
    
    let topImage = UIImageView()
    let nameLabel = UILabel()
    let editButton = UIButton()
    let settingTable = UITableView()
    let questionText = "お問い合わせ・要望"
    let ruleText = "利用規約"
    let cardText = "クレジットカード情報の追加,更新"
    let logoutText = imTeacher ? "ダンスを教わる" : "ダンスを教える"
    let revueText = "Dancyを評価する"
    let guideText = "使い方ガイド"
    //  教える教わるを交換するからログインボタンが必要になる
    var cellTitleArray = [String]()
    let registerButton = myButton(frame: CGRect())
    let cellHeight: CGFloat = 40.0

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = commonBackgroundColor
        settingTable.delegate = self
        settingTable.dataSource = self
        self.settingTable.bounces = false
        settingTable.register(UITableViewCell.self, forCellReuseIdentifier: "table")
        self.settingTable.sizeToFit()
        self.navigationItem.title = "マイページ"
        self.navigationController?.navigationBar.isTranslucent = false
        self.tabBarController?.tabBar.isTranslucent = false
        self.edgesForExtendedLayout = []
        self.topImage.image = UIImage(named: "no_image.jpg")
        
        cellTitleArray = !imTeacher && (uds.object(forKey: "myId") != nil) ? [guideText,ruleText,questionText,cardText,logoutText,revueText]: [guideText,ruleText,questionText, logoutText, revueText]
        
        self.nameLabel.text = "ゲスト"
        self.nameLabel.font = UIFont.boldSystemFont(ofSize: 25.0)
        self.nameLabel.textAlignment = .left
        
        self.editButton.setTitle("プロフィールの編集", for: .normal)
        self.editButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16.0)
        self.editButton.setTitleColor(orangeColor, for: .normal)
        self.editButton.backgroundColor = commonBackgroundColor
        
        self.editButton.addTarget(self, action: #selector(goEdit), for: .touchUpInside)
        self.registerButton.addTarget(self, action: #selector(goRegister), for: .touchUpInside)
        
        self.topImage.translatesAutoresizingMaskIntoConstraints = false
        self.nameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.editButton.translatesAutoresizingMaskIntoConstraints = false
        self.settingTable.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(topImage)
        self.view.addSubview(nameLabel)
        
        self.topImage.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 10.0).isActive = true
        self.topImage.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20.0).isActive = true
        self.topImage.widthAnchor.constraint(equalToConstant: self.view.frame.size.width*0.4).isActive = true
        self.topImage.heightAnchor.constraint(equalToConstant: self.view.frame.size.width*0.4).isActive = true
        
        
        self.nameLabel.topAnchor.constraint(equalTo: self.topImage.topAnchor, constant: 0.0).isActive = true
        self.nameLabel.leftAnchor.constraint(equalTo: self.topImage.rightAnchor, constant: 20.0).isActive = true
        self.nameLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20.0).isActive = true
        self.nameLabel.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let myImage = uds.object(forKey: "imagePath") {
            let data = myImage as! NSData
            self.topImage.image = UIImage(data: data as Data)
            self.topImage.contentMode = .scaleAspectFill
            self.topImage.clipsToBounds = true
        }
        
        if (uds.object(forKey: "myId") != nil) {
            
            self.view.addSubview(editButton)
            self.view.addSubview(settingTable)
            
            self.editButton.topAnchor.constraint(equalTo: self.nameLabel.bottomAnchor, constant: 10.0).isActive = true
            self.editButton.leftAnchor.constraint(equalTo: self.topImage.rightAnchor, constant: 10.0).isActive = true
            self.editButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10.0).isActive = true
            self.editButton.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
            
            self.settingTable.topAnchor.constraint(equalTo: self.topImage.bottomAnchor, constant: 20.0).isActive = true
            self.settingTable.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0.0).isActive = true
            self.settingTable.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0.0).isActive = true
            self.settingTable.heightAnchor.constraint(equalToConstant: cellHeight * CGFloat(cellTitleArray.count)).isActive = true
            //ここに持ってこないと会員登録後に困る
            cellTitleArray = !imTeacher && (uds.object(forKey: "myId") != nil) ? [guideText,ruleText,questionText,cardText,logoutText,revueText]: [guideText,ruleText,questionText, logoutText, revueText]
            
            if let name = uds.object(forKey: "name") {
                nameLabel.text = name as! String
            }
            
        }
        else {
            self.view.addSubview(registerButton)
            self.view.addSubview(settingTable)
            
            self.settingTable.topAnchor.constraint(equalTo: self.topImage.bottomAnchor, constant: 20.0).isActive = true
            self.settingTable.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0.0).isActive = true
            self.settingTable.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0.0).isActive = true
            self.settingTable.heightAnchor.constraint(equalToConstant: cellHeight * CGFloat(cellTitleArray.count)).isActive = true
            self.registerButton.setTitle("登録・ログイン", for: .normal)
            self.registerButton.topAnchor.constraint(equalTo: self.settingTable.bottomAnchor, constant: 10.0).isActive = true
            self.registerButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 50.0).isActive = true
            self.registerButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -50.0).isActive = true
            self.registerButton.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
            
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellTitleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: "table")
        cell.textLabel!.text = self.cellTitleArray[indexPath.row]
        cell.selectionStyle = .none
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if  cellTitleArray[indexPath.row] == questionText {
            let vc = QuestionViewController()
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        }
        else if cellTitleArray[indexPath.row] == ruleText {
            let vc = RuleViewController()
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        }
        else if  cellTitleArray[indexPath.row] == cardText {
            let addCardVC = STPAddCardViewController()
            addCardVC.delegate = self
            let navigationC = UINavigationController(rootViewController: addCardVC)
            present(navigationC, animated: true)
        }
        else if cellTitleArray[indexPath.row] == self.logoutText {
            let alert = UIAlertController(title: "ログアウトします。よろしいですか？", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "戻る", style: .default))
            
            let action2 = UIAlertAction(title: "ログアウトする", style: .default, handler: {
                (action: UIAlertAction!) in
                
                deleteData()
                let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let nc = mainStoryboard.instantiateViewController(withIdentifier: "select")
                self.present(nc, animated: true, completion: nil)
            
            })
            alert.addAction(action2)
            
            self.present(alert, animated: true, completion: nil)
        }
        
        else if cellTitleArray[indexPath.row] == self.revueText {
            if #available(iOS 10.3, *) {
                SKStoreReviewController.requestReview()
            } else {
                self.makeNoTitleAlert(message: "OSのバージョンが対応していません。評価をつけるにはOSをアップデートしてください")
            }
        }
        else if cellTitleArray[indexPath.row] == guideText {
            
            let vc = GuideViewController()
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }

    @objc func goEdit() {
        let vc = ProfileEditViewController(image: topImage.image!)
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func goRegister() {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let nc = mainStoryboard.instantiateViewController(withIdentifier: "studentRegister") 
        
        present(nc, animated: true, completion: nil)
    }
    
    func addCardViewControllerDidCancel(_ addCardViewController: STPAddCardViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func addCardViewController(_ addCardViewController: STPAddCardViewController, didCreateToken token: STPToken, completion: @escaping STPErrorBlock) {
        
        dismiss(animated: true)
        let endURL = awsURL + "/student/addcard"
        let parameters:[String:Any] = ["token": token.tokenId, "email": uds.object(forKey: "myId")!]
        
        let apimanager = APIManager(url: endURL, method: .post, parameters: parameters, view: self)
        apimanager.request(fail: { () in
            self.makeAlert(message: "入力された情報が誤っています")
        }, success: { (json: JSON) in
            uds.set(token.tokenId, forKey: "credit")
            self.makeGoodAlert(message: "カードの登録が完了しました")
        })
        
    }

}

