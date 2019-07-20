import UIKit
import Alamofire
import SwiftyJSON
import Stripe
//lessonの状態にスタジオ代のアレをかける必要があるのか 文字の大きさは16.0でちょうど良かったのかもな
class ChatDetail2ViewController: UIViewController, UITableViewDelegate {
    
    let scrollView = UIScrollView()
    let textField = UITextField()
    let sendButton = UIButton()
    var yourEmail: String! //fromOtherVC
    let myEmail = uds.object(forKey: "myId") as! String
    var yourName: String! //fromOtherVC
    let lessonLabel = UILabel()
    let applyButton = UIButton()
    let checkButton = UIButton()
    var newLessonTimeStamp: Int!
    var chattingTeacher = Teacher()
    var keyBoard: CGFloat = 0
    lazy var textFieldBottom1 = textField.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -10.0)
    lazy var textFieldBottom2 = textField.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -10.0 - keyBoard - 60.0)
    //keyboardの高さだと変換の分のスペースがない
    lazy var scrollBottom1 = scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -60.0)
    lazy var scrollBottom2 = scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -60.0 - keyBoard - 60.0)
    
    var payStudioMoney: Int!
    var payTimeStamp: Int!
    var isKeyBoardOpen: Bool = false
    
    init(name: String, email: String) {
        self.yourEmail = email
        self.yourName = name
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.edgesForExtendedLayout = []
        self.navigationController?.navigationBar.isTranslucent = false
        setSwipeBack()
        makeScrollView()
        getData()
        getLesson()
        
        if imTeacher {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "プロフィール", style: .done, target: self, action: #selector(goStudent))
        }
        else {
            getProfile()
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "プロフィール", style: .done, target: self, action: #selector(goProfile))
            getStudioMoney()
        }
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(textField)
        textField.backgroundColor = commonBackgroundColor
        textField.topAnchor.constraint(equalTo: self.scrollView.bottomAnchor, constant: 10.0).isActive = true
        textField.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10.0).isActive = true
        textField.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -100.0).isActive = true
        self.textFieldBottom1.isActive = true
        
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(sendButton)
        sendButton.topAnchor.constraint(equalTo: self.textField.topAnchor, constant: 0).isActive = true
        sendButton.leftAnchor.constraint(equalTo: self.textField.rightAnchor, constant: 10.0).isActive = true
        sendButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10.0).isActive = true
        sendButton.bottomAnchor.constraint(equalTo: self.textField.bottomAnchor, constant: 0.0).isActive = true
        sendButton.setTitle("送信", for: .normal)
        sendButton.setTitleColor(UIColor.white, for: .normal)
        sendButton.backgroundColor = orangeColor
        sendButton.titleLabel!.font = UIFont.boldSystemFont(ofSize: 19.0)
        sendButton.layer.masksToBounds = true
        sendButton.layer.cornerRadius = 20.0
        sendButton.addTarget(self, action: #selector(send), for: .touchUpInside)
        
        self.lessonLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(lessonLabel)
        lessonLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
        lessonLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0.0).isActive = true
        lessonLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -100.0).isActive = true
        lessonLabel.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        lessonLabel.adjustsFontSizeToFitWidth = true
        lessonLabel.minimumScaleFactor = 0.3
        
        navigationItem.title = yourName
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func makeScrollView() {
        scrollView.frame.size = CGSize(width: view.frame.width, height: view.frame.height)
        scrollView.center = self.view.center
        scrollView.contentSize = CGSize(width: view.frame.width, height: 10)
        scrollView.bounces = false
        scrollView.indicatorStyle = .default
        scrollView.scrollIndicatorInsets = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        scrollView.delegate = self
        self.view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 50.0).isActive = true
        scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0.0).isActive = true
        scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0.0).isActive = true
        self.scrollBottom1.isActive = true
        self.scrollView.backgroundColor = commonBackgroundColor
        scrollView.keyboardDismissMode = .onDrag
    }

    @objc private func keyboardWillShow(_ notification: Notification) {
        
        guard let userInfo = notification.userInfo as? [String: Any] else {
            return
        }
        guard let keyboardInfo = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        guard let _ = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else {
            return
        }
        let keyboardHeight = keyboardInfo.cgRectValue.size.height
        print ("keyboardopen")
        
        self.keyBoard = keyboardHeight
        
        self.scrollBottom1.isActive = false
        self.scrollBottom2.isActive = true
        self.textFieldBottom1.isActive = false
        self.textFieldBottom2.isActive = true
        //  2回これが呼ばれてしまって面倒である
        if !isKeyBoardOpen {
            isKeyBoardOpen = true
            self.scrollView.setContentOffset(CGPoint(x: 0, y: self.scrollView.contentSize.height - self.scrollView.frame.size.height + 60.0 + keyBoard), animated: false)
        }
        
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        print ("keyboardhide")
        // viewを動的に変更させる場合はそもそもオートレイアウトが向いていなかった　制約エラーが出る
        isKeyBoardOpen = false
        self.scrollBottom1.isActive = true
        self.scrollBottom2.isActive = false
        self.textFieldBottom1.isActive = true
        self.textFieldBottom2.isActive = false
        self.scrollView.setContentOffset(CGPoint(x: 0, y: self.scrollView.contentSize.height - self.scrollView.frame.size.height), animated: false)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc func send() {
        
        if let text = textField.text, text.count > 0 {
            self.textField.text = ""
            let endURL = awsURL + "/chat"
            let timeStamp = Int(NSDate().timeIntervalSince1970)
            var parameters:[String: Any] = ["senderEmail": myEmail, "recieverEmail": yourEmail!, "isTeacher": imTeacher,
                                            "timeStamp": timeStamp, "value": text]
            parameters["studentName"] = imTeacher ? yourName as Any : uds.object(forKey: "name")! as Any
            parameters["teacherName"] = imTeacher ? uds.object(forKey: "name")! as Any: yourName as Any
            
            let apimanager = APIManager(url: endURL, method: .post, parameters: parameters, view: self)
            apimanager.request(fail: { () in
                self.sendButton.isEnabled = true
                self.makeAlert(message: "エラーが発生しました")
            }, success: { (json: JSON) in
                self.sendButton.isEnabled = true
                self.addText(text: text)
            })
        }
    }
    
    func addText(text: String) {
        let height = self.scrollView.contentSize.height
        let label = UILabel()
        label.text = text
        label.numberOfLines = 0
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 10.0
        label.textAlignment = .left
        label.backgroundColor = greenColor
        label.textColor = UIColor.black
        label.frame = CGRect(x: self.view.frame.size.width/2-50.0, y: height, width: self.view.frame.size.width/2 + 40.0, height: 100)
        label.font = UIFont.systemFont(ofSize: 16.0)
        label.sizeToFit()
        label.frame.size.height += 20.0
        label.frame.size.width += 10.0
        self.scrollView.addSubview(label)
        
        let dayLabel = UILabel()
        dayLabel.text = unixToString(unix: Int(NSDate().timeIntervalSince1970))
        dayLabel.numberOfLines = 1
        dayLabel.textAlignment = .right
        dayLabel.backgroundColor = commonBackgroundColor
        dayLabel.textColor = UIColor.black
        dayLabel.frame = CGRect(x: 0, y: height, width: self.view.frame.size.width/2 - 60, height: 40)
        dayLabel.font = UIFont.systemFont(ofSize: 11.0)
        self.scrollView.addSubview(dayLabel)
        self.scrollView.contentSize.height = height + label.frame.height + 10
    }
    
    
    func setMyText(text: String, timeStamp: Int) {
        let height = self.scrollView.contentSize.height
        let label = UILabel()
        
        label.text = text
        label.numberOfLines = 0
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 10.0
        label.textAlignment = .left
        label.backgroundColor = greenColor
        label.textColor = UIColor.black
        label.frame = CGRect(x: self.view.frame.size.width/2-50, y: height, width: self.view.frame.size.width/2 + 40, height: 100)
        label.font = UIFont.systemFont(ofSize: 16.0)
        label.sizeToFit()
        label.frame.size.height += 20.0
        label.frame.size.width += 10.0
        self.scrollView.addSubview(label)
        
        let dayLabel = UILabel()
        dayLabel.text = unixToString(unix: timeStamp)
        dayLabel.numberOfLines = 1
        dayLabel.textAlignment = .right
        dayLabel.backgroundColor = commonBackgroundColor
        dayLabel.textColor = UIColor.black
        dayLabel.frame = CGRect(x: 0, y: height, width: self.view.frame.size.width/2 - 60, height: 40)
        dayLabel.font = UIFont.systemFont(ofSize: 11.0)
        self.scrollView.addSubview(dayLabel)
        
        self.scrollView.contentSize.height = height + label.frame.size.height + 10
    }
    
    func setYourText(text: String, timeStamp: Int) {
        let height = self.scrollView.contentSize.height
        let label = UILabel()
        label.text = text
        label.numberOfLines = 0
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 10.0
        label.textAlignment = .left
        label.backgroundColor = UIColor.white
        label.textColor = UIColor.black
        label.frame = CGRect(x: 10, y: height, width: self.view.frame.size.width/2 + 40, height: 100)
        label.font = UIFont.systemFont(ofSize: 16.0)
        //autolayoutで右を基準にしてsizetofitしたらどうなるのか気になる
        label.sizeToFit()
        label.frame.size.height += 20.0
        label.frame.size.width += 10.0
        self.scrollView.addSubview(label)
        
        let dayLabel = UILabel()
        dayLabel.text = unixToString(unix: timeStamp)
        dayLabel.numberOfLines = 1
        dayLabel.textAlignment = .left
        dayLabel.backgroundColor = commonBackgroundColor
        dayLabel.textColor = UIColor.black
        //オートレイアウトにすれば右端問題と下揃え問題が同時に解決できる
        dayLabel.frame = CGRect(x: self.view.frame.size.width/2 + 60, y: height, width: self.view.frame.size.width/2 - 20, height: 40)
        dayLabel.font = UIFont.systemFont(ofSize: 11.0)
        self.scrollView.addSubview(dayLabel)
        self.scrollView.contentSize.height = height + label.frame.size.height + 10
    }
    
    func getData() {
        //ここに生徒か講師かを伝える 基本は使わないけど "true"か"false"が送られる
        let endURL = awsURL + "/chat?email1=\(myEmail)&email2=\(yourEmail!)&imTeacher=\(imTeacher)"
        
        let apimanager = APIManager(url: endURL, method: .get, parameters: [:], view: self)
        apimanager.request(fail: { () in
            self.makeAlert(message: "履歴を読み込めませんでした")
        }, success: { (json: JSON) in
            if let array = json.array {
                for value in array {
                    
                    if  value["isTeacher"].bool == imTeacher {
                        self.setMyText(text: value["value"].string!, timeStamp: value["timeStamp"].int!)
                    }
                    else {
                        self.setYourText(text: value["value"].string!,timeStamp: value["timeStamp"].int!)
                    }
                }
                self.scrollView.setContentOffset(
                    CGPoint(x: 0, y: self.scrollView.contentSize.height - self.scrollView.frame.size.height),
                    animated: false)
            }

        })
    }
    
    func getLesson() {
        var endURL = ""
        if imTeacher {
            endURL = awsURL + "/lesson/new" + "?teacherEmail=\(myEmail)&timeStamp=\(NSDate().timeIntervalSince1970)&studentEmail=\(self.yourEmail!)"
        }
        else {
            endURL = awsURL + "/lesson/new" + "?studentEmail=\(myEmail)&timeStamp=\(NSDate().timeIntervalSince1970)&teacherEmail=\(self.yourEmail!)"
        }
        
        let apimanager = APIManager(url: endURL, method: .get, parameters: [:], view: self)
        apimanager.request(fail: { () in
            self.makeAlert(message: "エラーが発生しました")
        }, success: { (json: JSON) in
            
            guard let _ = json["timeStamp"].int else {
                self.lessonLabel.text = "予約されたレッスンはありません"
                self.setButton(lesson: false)
                return
            }
            
            if json["DanceState"] == 1 {
                let timeString = unixToString(unix: json["timeStamp"].int!)
                self.lessonLabel.text = "承認待ち  \(timeString)開始 \(json["allMoney"])円"
                self.newLessonTimeStamp = json["timeStamp"].int!
                self.setButton(lesson: true)
                //生徒側に　新規予約　　キャンセルはレッスン一覧からだけにしよう　　教師は承認ね
                
            }
            else if json["DanceState"] == 2 {
                let timeString = unixToString(unix: json["timeStamp"].int!)
                self.lessonLabel.text = "直近のレッスン　\(timeString)開始 \(json["allMoney"])円"
                self.newLessonTimeStamp = json["timeStamp"].int!
                self.setButton(lesson: false)
                //生徒側に新規予約画面を入れるだけ
            }
            else {
                self.lessonLabel.text = "予約されたレッスンはありません"
                self.setButton(lesson: false)
            }
            
        })
        
    }
    
    func setButton(lesson: Bool) {
        // 先生なら　承認か拒否　生徒なら予約とキャンセルを表示させる キャンセルはいらないし　承認もあるときだけ
        if imTeacher && lesson {
            checkButton.setTitle("詳細", for: .normal)
            checkButton.setTitleColor(UIColor.white, for: .normal)
            checkButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20.0)
            checkButton.backgroundColor = orangeColor
            checkButton.layer.masksToBounds = true
            checkButton.layer.cornerRadius = 20.0
            checkButton.addTarget(self, action: #selector(check), for: .touchUpInside)
            self.view.addSubview(checkButton)
            checkButton.translatesAutoresizingMaskIntoConstraints = false
            checkButton.topAnchor.constraint(equalTo: self.lessonLabel.topAnchor, constant: 5.0).isActive = true
            checkButton.leftAnchor.constraint(equalTo: self.lessonLabel.rightAnchor, constant: 0.0).isActive = true
            checkButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0.0).isActive = true
            checkButton.bottomAnchor.constraint(equalTo: self.lessonLabel.bottomAnchor, constant: -5.0).isActive = true
        }
        
        if !imTeacher {
                applyButton.setTitle("新規予約", for: .normal)
                applyButton.setTitleColor(UIColor.white, for: .normal)
                applyButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20.0)
                applyButton.backgroundColor = orangeColor
                applyButton.layer.masksToBounds = true
                applyButton.layer.cornerRadius = 20.0
                applyButton.addTarget(self, action: #selector(apply), for: .touchUpInside)
                self.view.addSubview(applyButton)
                applyButton.translatesAutoresizingMaskIntoConstraints = false
            
                applyButton.topAnchor.constraint(equalTo: self.lessonLabel.topAnchor, constant: 5.0).isActive = true
            
                applyButton.leftAnchor.constraint(equalTo: self.lessonLabel.rightAnchor, constant: 0.0).isActive = true
                applyButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10.0).isActive = true
                applyButton.bottomAnchor.constraint(equalTo: self.lessonLabel.bottomAnchor, constant: -5.0).isActive = true
        }
    }
    
    @objc func apply() {
        let vc = LessonCreate2ViewController(name: self.yourName, email: self.yourEmail!)
        navigationController!.pushViewController(vc, animated: true)
    }
    @objc func goStudent() {
        var student = Student()
        
        let endURL = awsURL + "/student?email=\(yourEmail!)"
        let apimanager = APIManager(url: endURL, method: .get, parameters: [:], view: self)
        apimanager.request(fail: { () in
            self.makeAlert(message: "プロフィールが見つかりません")
        }, success: { (json: JSON) in
            if let name = json["nickName"].string {
                student.name = name
            }
            if let live = json["live"].string {
                student.live = live
            }
            if let email = json["email"].string {
                student.email = email
            }
            if let age = json["age"].string {
                student.age = age
            }
            if let comment = json["Comments"].string {
                student.comment = comment
            }
            let vc = StudentDetailViewController(student: student)
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        })

    }

    @objc func check() {
    //ここに金額を表示しないとトラブルの元になる
    let alert = UIAlertController(title: "レッスンリクエストを承認しますか？", message: lessonLabel.text! + "(スタジオ代込み)", preferredStyle: .alert)
        let action1 = UIAlertAction(title: "承認する", style: .default, handler: {
            (action: UIAlertAction!) in
            self.changeNumber(sendState: 2)
        })
        alert.addAction(action1)
        
        let action2 = UIAlertAction(title: "承認しない", style: .default, handler: {
            (action: UIAlertAction!) in
            self.changeNumber(sendState: 0)
        })
        alert.addAction(action2)
        alert.addAction(UIAlertAction(title: "戻る", style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
        
        self.changeNumber(sendState: 2)
    }
    
    func changeNumber(sendState: Int) {
        let endURL = awsURL + "/lesson/studentcancel"
        let studentEmail = imTeacher ? yourEmail : myEmail
        
        let parameters:[String: Any] = ["email": studentEmail, "timeStamp": self.newLessonTimeStamp,"state": sendState]
        
        let apimanager = APIManager(url: endURL, method: .post, parameters: parameters, view: self)
        apimanager.request(fail: { () in
            self.makeAlert(message: "エラーが発生しました")
        }, success: { (json: JSON) in
            if sendState == 0 {
                self.makeGoodAlert(message: "レッスンのキャンセルが完了しました")
            }
            else if sendState == 2 {
                self.makeGoodAlert(message: "レッスンの承認が完了しました")
            }
            else if sendState == 4 {
                self.makeGoodAlert(message: "レッスンのキャンセルが完了しました")
            }
        })
    }
    
    func getStudioMoney() {
        let endURL = awsURL + "/studio?studentEmail=\(uds.object(forKey: "myId")!)"
        setIndicator2()
        Alamofire.request(endURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            self.removeIndicator2()
            if let _ = response.error {
                self.makeAlert(message: "履歴を読み込めませんでした")
                return
            }
            guard let object = response.result.value else {
                self.makeAlert(message: "履歴を読み込めませんでした")
                return
            }
            
            let json = JSON(object)
            let firstText = "スタジオ代の請求が届いています。"
            var secondText = "講師からのコメント: "
            
            if let comment = json["Items"][0]["Comment"].string, let money = json["Items"][0]["money"].string, let timeStamp = json["Items"][0]["timeStamp"].int {
                secondText += comment
                
                let alert = UIAlertController(title: "\(money)円の" + firstText + secondText, message: nil, preferredStyle: .alert)
                let action1 = UIAlertAction(title: "決済する", style: .default, handler: {
                    (action: UIAlertAction!) in
                    self.payTimeStamp = timeStamp
                    self.payStudioMoney = Int(money)
                    self.pay(state: 2)
                })
                alert.addAction(action1)
                
                let action2 = UIAlertAction(title: "決済しない", style: .default, handler: {
                    (action: UIAlertAction!) in
                    self.payTimeStamp = timeStamp
                    self.payStudioMoney = Int(money)
                    self.pay(state: 3)
                })
                alert.addAction(action2)
                alert.addAction(UIAlertAction(title: "戻る", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
            }
            
        }
    }
    
    func getProfile() {
        let endURL = awsURL + "/teacher?email=\(yourEmail!)"
        
        let apimanager = APIManager(url: endURL, method: .get, parameters: [:], view: self)
        apimanager.request(fail: { () in
            self.makeAlert(message: "講師のプロフィールが見つかりません")
        }, success: { (json: JSON) in
            if let name = json["nickName"].string {
                self.chattingTeacher.name = "\(name)先生"
                self.yourName = "\(name)先生"
            }
            if let live = json["live"].string {
                self.chattingTeacher.live = live
            }
            if let money = json["money"].string {
                self.chattingTeacher.money = "\(money)円"
            }
            if let email = json["email"].string {
                self.chattingTeacher.email = email
            }
            if let able = json["able"].string {
                self.chattingTeacher.able = able
            }
            if let age = json["age"].string {
                self.chattingTeacher.age = "\(age)歳"
            }
            if let country = json["country"].string {
                self.chattingTeacher.country = "\(country)"
            }
            if let evaluate = json["evaluate"].int {
                self.chattingTeacher.evaluate = evaluate
            }
            if let lessonCount = json["lessonCount"].int {
                self.chattingTeacher.lessonCount = lessonCount
            }
            if let comment = json["comments"].string {
                self.chattingTeacher.comment = comment
            }
        })

    }
    
    @objc func goProfile() {
        let vc = TeacherDetailViewController(teacher: chattingTeacher)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func pay(state: Int) {
        let endURL = awsURL + "/studio/change"
        let parameters:[String:Any] = ["DanceState": state, "studentEmail": myEmail, "amount": String(payStudioMoney), "timeStamp": payTimeStamp!]
        let apimanager = APIManager(url: endURL, method: .post, parameters: parameters, view: self)
        apimanager.request(fail: { () in
            self.makeAlert(message: "処理に失敗しました")
        }, success: { (json: JSON) in
            self.makeGoodAlert(message: "処理が完了しました")
            self.getStudioMoney()
        })
    }
    
}


