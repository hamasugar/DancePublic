import UIKit
import SwiftyJSON
import AWSS3
import AWSCore
import Cosmos

// ここが決済が絡むので一番重要であります　条件分岐が複雑ー 
class LessonScanViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let tableView = UITableView()
    var lessonArray = [Lesson]()
    let tempPath = NSTemporaryDirectory()
    let indicator = UIActivityIndicatorView()
    let grayView = UIView()
    let refreshCtl = UIRefreshControl()
    let starView = UIView()
    
    var payStudioMoney: String!
    var payTimeStamp: Int!
    var payStudentEmail: String!
    var payDanceState: Int!
    var payTeacherEmail: String!
    var starCount: Int = 5
    
    let cancelText1 = "キャンセルする"
    let cancelText2 = "キャンセルする（承認待ち）"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = commonBackgroundColor
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "lesson")
        tableView.frame = CGRect(x: 10, y: 0, width: self.view.frame.size.width-20, height: self.view.frame.size.height-100)
        self.view.addSubview(tableView)
        self.navigationItem.title = "レッスン一覧"
        self.edgesForExtendedLayout = []
        self.navigationController?.navigationBar.isTranslucent = false
        
        if uds.object(forKey: "myId") == nil {
            return
        }
        
        tableView.refreshControl = refreshCtl
        refreshCtl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        loadData()
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lessonArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "lesson")
        cell.selectionStyle = .none
        let topImageView = UIImageView()
        let topLabel = UILabel()
        let bottomLabel = UILabel()
        let button = UIButton()
        let dammyLabel = UILabel()
        
        cell.addSubview(topImageView)
        cell.addSubview(topLabel)
        cell.addSubview(bottomLabel)
        cell.addSubview(button)
        cell.addSubview(dammyLabel)
        
        topImageView.translatesAutoresizingMaskIntoConstraints = false
        topLabel.translatesAutoresizingMaskIntoConstraints = false
        bottomLabel.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false
        dammyLabel.translatesAutoresizingMaskIntoConstraints = false
        
        topImageView.topAnchor.constraint(equalTo: cell.topAnchor, constant: 10.0).isActive = true
        topImageView.leftAnchor.constraint(equalTo: cell.leftAnchor, constant: 10.0).isActive = true
        topImageView.widthAnchor.constraint(equalToConstant: self.view.frame.size.width*0.3).isActive = true
        topImageView.heightAnchor.constraint(equalToConstant: self.view.frame.size.width*0.3).isActive = true
        topImageView.contentMode = .scaleAspectFill
        topImageView.clipsToBounds = true
        topImageView.tag = indexPath.row
        if !imTeacher {
            topImageView.isUserInteractionEnabled = true
            let gesture = UITapGestureRecognizer(target: self, action: #selector(goProfile))
            topImageView.addGestureRecognizer(gesture)
        }
        
        topLabel.topAnchor.constraint(equalTo: cell.topAnchor, constant: 10.0).isActive = true
        topLabel.leftAnchor.constraint(equalTo: topImageView.rightAnchor, constant: 10.0).isActive = true
        topLabel.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
        topLabel.rightAnchor.constraint(equalTo: cell.rightAnchor, constant: -10.0).isActive = true
        
        bottomLabel.topAnchor.constraint(equalTo: topLabel.bottomAnchor, constant: 10.0).isActive = true
        bottomLabel.leftAnchor.constraint(equalTo: topLabel.leftAnchor, constant: 0.0).isActive = true
        bottomLabel.heightAnchor.constraint(equalTo: topLabel.heightAnchor).isActive = true
        bottomLabel.rightAnchor.constraint(equalTo: cell.rightAnchor, constant: -10.0).isActive = true
        
        button.topAnchor.constraint(equalTo: bottomLabel.bottomAnchor, constant: 10.0).isActive = true
        button.bottomAnchor.constraint(equalTo: dammyLabel.topAnchor, constant: -10.0).isActive = true
        button.leftAnchor.constraint(equalTo: bottomLabel.leftAnchor, constant: 0.0).isActive = true
        button.rightAnchor.constraint(equalTo: bottomLabel.rightAnchor, constant: -10.0).isActive = true
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 20.0
        
        dammyLabel.leftAnchor.constraint(equalTo: cell.leftAnchor, constant: 0.0).isActive = true
        dammyLabel.heightAnchor.constraint(equalToConstant: 5.0).isActive = true
        dammyLabel.rightAnchor.constraint(equalTo: cell.rightAnchor, constant: 0.0).isActive = true
        dammyLabel.backgroundColor = commonBackgroundColor
        
        let state = lessonArray[indexPath.row].state!
        
        if state == 1 {
            if imTeacher {
                button.setTitle("確認画面へ （承認待ち）", for: .normal)
            }
            else {
                button.setTitle(cancelText2, for: .normal)
            }
            
        }
        else if state == 2 {
            
            if lessonArray[indexPath.row].timeStamp! > Int(NSDate().timeIntervalSince1970) {
                button.setTitle(cancelText1, for: .normal)
            }
            else {
                if imTeacher {
                    button.setTitle("決済待ち", for: .normal)
                    button.isEnabled = false
                }
                else {
                    button.setTitle("決済する", for: .normal)
                }
                
            }
            
        }
        else if state == 3 {
            button.setTitle("生徒の直前キャンセル済み", for: .normal)
            button.isEnabled = false
        }
        else if state == 4 {
            button.setTitle("講師の直前キャンセル済み", for: .normal)
            button.isEnabled = false
        }
        //５は来ないのであるよ
        else if state == 6 {
            button.setTitle("決済済み", for: .normal)
            button.isEnabled = false
        }
        else if state == 7 {
            button.setTitle("お問い合わせください", for: .normal)
        }
        
        button.tag = indexPath.row
        button.addTarget(self, action: #selector(push(_:)), for: .touchUpInside)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = orangeColor
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 22.0)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.minimumScaleFactor = 0.3
        
        bottomLabel.adjustsFontSizeToFitWidth = true
        bottomLabel.minimumScaleFactor = 0.3
        
        topLabel.text = lessonArray[indexPath.row].yourName
        bottomLabel.text = lessonArray[indexPath.row].date! + "〜  " + lessonArray[indexPath.row].hour! + "分　" + lessonArray[indexPath.row].money! + "円"
        
        let path = lessonArray[indexPath.row].yourEmail
        
        let fileURLPathss = URL(fileURLWithPath: self.tempPath).appendingPathComponent("\(path).jpg")
        
        if let image = UIImage(contentsOfFile: fileURLPathss.path) {
            topImageView.image = image
        }
        else {
            downLoadImage(path: path, imageView: topImageView, tempPath: tempPath)
        }
       
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150.0
    }
    
    func loadData() {
        
        let endURL = "https://3l3lsb42w0.execute-api.us-east-2.amazonaws.com/dev/lesson?email=\(uds.object(forKey: "myId") as! String)&imTeacher=\(imTeacher)"
        let apimanager = APIManager(url: endURL, method: .get, parameters: [:], view: self)
        apimanager.request(fail: { () in
            self.refreshCtl.endRefreshing()
            self.makeAlert(message: "エラーが発生しました")
        }, success: { (json: JSON) in
            self.refreshCtl.endRefreshing()
            guard let count = json["Count"].int else {
                self.makeAlert(message: "データが読み込めません")
                return
            }
            self.lessonArray = [Lesson]()
            if count == 0 {
                let alert = UIAlertController(title: nil, message: "レッスンの履歴がありません", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true, completion: nil)
                //これがないと１から０になった後に消えなくなるという問題が発生する
                self.tableView.reloadData()
                return
            }
            //生徒が違うコーチにリクエストできないことにしよう　一応セカンダリも設けられたし
            for i in 0...count-1 {
                
                var lesson = Lesson()
                if let name = json["Items"][i]["teacherName"].string {
                    lesson.teacherName = "\(name)"
                }
                if let name = json["Items"][i]["studentName"].string {
                    lesson.studentName = name
                }
                if let allMoney = json["Items"][i]["allMoney"].string{
                    lesson.money = allMoney
                }
                if let date = json["Items"][i]["timeStamp"].int {
                    lesson.date = unixToString(unix: date)
                    lesson.timeStamp = date
                }
                if let state = json["Items"][i]["DanceState"].int {
                    lesson.state = state
                }
                if let email = json["Items"][i]["studentEmail"].string {
                    lesson.studentEmail = email
                }
                if let email = json["Items"][i]["teacherEmail"].string {
                    lesson.teacherEmail = email
                }
                if let hour = json["Items"][i]["hour"].string {
                    lesson.hour = hour
                }
                
                self.lessonArray.append(lesson)
            }
            self.lessonArray.sort{$0.timeStamp > $1.timeStamp}
            self.tableView.reloadData()
        })
    }
    
    @objc func push(_ sender: UIButton) {
        //ここは絶対に直す
        if sender.titleLabel?.text == cancelText1 ||  sender.titleLabel?.text == cancelText2 {
            
            let cancelText = imTeacher ? "本当にレッスンをキャンセルしますか？" : "本当にレッスンをキャンセルしますか? (レッスン開始48時間前以降の場合キャンセル料が発生します)"
            
            let alert = UIAlertController(title: cancelText, message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "戻る", style: .default))
            
            let action2 = UIAlertAction(title: "レッスンをキャンセル", style: .default, handler: {
                (action: UIAlertAction!) in
            
                
                if self.lessonArray[sender.tag].timeStamp! - Int(NSDate().timeIntervalSince1970) > 60*60*24*2 {
                    self.change(sendState: 0, cellNumber: sender.tag)//消去してしまう
                    
                }
                else {
                    self.payStudioMoney = String(Int(self.lessonArray[sender.tag].money)! + 1000)
                    self.payTimeStamp = self.lessonArray[sender.tag].timeStamp
                    self.payDanceState = imTeacher ? 4 : 3
                    self.payStudentEmail = self.lessonArray[sender.tag].studentEmail
                    self.payTeacherEmail = self.lessonArray[sender.tag].teacherEmail
                    //4なら決済は行われないよ
                    if self.payDanceState == 3 {
                        self.pay()
                    }
                    else {
                        self.change(sendState: 4, cellNumber: sender.tag)
                    }
                }
            })
            alert.addAction(action2)
            
            self.present(alert, animated: true, completion: nil)
        }
        if sender.titleLabel?.text == "決済する" {
            let alert = UIAlertController(title: "決済しますか？", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "いいえ", style: .default))
            
            let action2 = UIAlertAction(title: "はい", style: .default, handler: {
                (action: UIAlertAction!) in
                //ここで決済処理　スタジオ代を含めたマネーということ 1000円を追加で徴収する
                self.payStudioMoney = String(Int(self.lessonArray[sender.tag].money)! + 1000)
                self.payTimeStamp = self.lessonArray[sender.tag].timeStamp
                self.payDanceState = 6
                self.payStudentEmail = self.lessonArray[sender.tag].studentEmail
                self.payTeacherEmail = self.lessonArray[sender.tag].teacherEmail
                self.pay()
                
            })
            alert.addAction(action2)
            
            self.present(alert, animated: true, completion: nil)
            
        }
        if sender.titleLabel?.text == "確認画面へ （承認待ち）" {
            let alert = UIAlertController(title: "レッスンリクエストを承認しますか？", message: nil, preferredStyle: .alert)
            let action1 = UIAlertAction(title: "承認する", style: .default, handler: {
                (action: UIAlertAction!) in
                self.change(sendState: 2, cellNumber: sender.tag)
            })
            alert.addAction(action1)
            
            let action2 = UIAlertAction(title: "承認しない", style: .default, handler: {
                (action: UIAlertAction!) in
                self.change(sendState: 0, cellNumber: sender.tag)
            })
            alert.addAction(action2)
            alert.addAction(UIAlertAction(title: "戻る", style: .default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
            
        }
        
        if sender.titleLabel?.text == "お問い合わせください" {
            let vc = QuestionViewController()
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        }
        
        
    }
    
    func change(sendState: Int, cellNumber: Int) {
        // 教師もあれも共通しててチェンジ ただし決済無しの０か２か４しか回ってこない
        let endURL = awsURL + "/lesson/studentcancel"
        let parameters: [String: Any] = ["email": lessonArray[cellNumber].studentEmail!, "timeStamp": lessonArray[cellNumber].timeStamp!,"state": sendState]
       
        let apimanager = APIManager(url: endURL, method: .post, parameters: parameters, view: self)
        apimanager.request(fail: { () in
            self.makeAlert(message: "エラーが発生しました")
        }, success: { (json: JSON) in
            // 1は作られたとき　５は時間を過ぎていたら　７はスタッフが判断する
            if sendState == 0 {
                self.makeGoodAlert(message: "レッスンのキャンセルが完了しました　トーク画面でその旨をお伝えください")
            }
            else  if sendState == 2 {
                self.makeGoodAlert(message: "レッスンの承認が完了しました")
            }
            else  if sendState == 4 {
                self.makeGoodAlert(message: "レッスンのキャンセルが完了しました")
            }
            //ここで更新処理が必要
            self.loadData()
        })
    }
    
    @objc func refresh() {
        loadData()
    }
}
//決済
extension LessonScanViewController {
    func pay() {
        //カードが登録されていなければ戻らせる
        if (uds.object(forKey: "credit") == nil) {
            self.makeAlert(message: "カードが登録されていません。マイページからクレジットカード情報を登録してください")
            return
        }
        
        let endURL = awsURL + "/lesson/studentcancel"
        let parameters:[String:Any] = ["state": payDanceState!, "email": uds.object(forKey: "myId"), "amount": payStudioMoney, "timeStamp": payTimeStamp!]
        let apimanager = APIManager(url: endURL, method: .post, parameters: parameters, view: self)
        apimanager.request(fail: { () in
            self.makeAlert(message: "決済に失敗しました")
        }, success: { (json: JSON) in
            self.makeGoodAlert(message: "決済が完了しました")
            if self.payDanceState == 6 {
                //キャンセルしたときは当然レビューもない
                self.makeStarView()
            }
        })
    }
    
}
//以下は評価制度の実装とプロフィールに飛ぶ実装
extension LessonScanViewController {
    
    func makeStarView() {
        
        let cosmosView = CosmosView()
        let submitButton = UIButton()
        
        starView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(starView)
        starView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0.0).isActive = true
        starView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20.0).isActive = true
        starView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20.0).isActive = true
        starView.backgroundColor = commonBackgroundColor
        
        cosmosView.translatesAutoresizingMaskIntoConstraints = false
        starView.addSubview(cosmosView)
        cosmosView.heightAnchor.constraint(equalToConstant: self.view.frame.size.width / 7).isActive = true
        cosmosView.topAnchor.constraint(equalTo: starView.topAnchor, constant: 20.0).isActive = true
        cosmosView.centerXAnchor.constraint(equalTo: starView.centerXAnchor, constant: 0.0).isActive = true
        
        cosmosView.rating = 5.0
        cosmosView.settings.totalStars = 5
        cosmosView.settings.starSize = Double(self.view.frame.size.width / 7)
        cosmosView.settings.fillMode = .full
        cosmosView.settings.filledColor = UIColor.orange
        cosmosView.settings.updateOnTouch = true
        cosmosView.didTouchCosmos = { rating in
           self.starCount = Int(rating)
        }
        cosmosView.sizeToFit()
        
        starView.layer.masksToBounds = true
        starView.layer.cornerRadius = 10.0
        
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        starView.addSubview(submitButton)
        submitButton.titleLabel!.font = UIFont.boldSystemFont(ofSize: 19.0)
        
        submitButton.topAnchor.constraint(equalTo: cosmosView.bottomAnchor, constant: 20.0).isActive = true
        submitButton.centerXAnchor.constraint(equalTo: starView.centerXAnchor).isActive = true
        submitButton.leftAnchor.constraint(equalTo: starView.leftAnchor, constant: 20.0).isActive = true
        submitButton.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        submitButton.bottomAnchor.constraint(equalTo: starView.bottomAnchor, constant: -20.0).isActive = true
        submitButton.layer.masksToBounds = true
        submitButton.layer.cornerRadius = 20.0
        submitButton.backgroundColor = orangeColor
        submitButton.setTitle("レッスンの評価を送信", for: .normal)
        submitButton.setTitleColor(.white, for: .normal)
        submitButton.addTarget(self, action: #selector(starSubmit), for: .touchUpInside)
    }
    
    @objc func starSubmit() {
        
        let endURL = awsURL + "/evaluate"
        let parameters: [String: Any] = ["teacherEmail": payTeacherEmail, "evaluate": starCount]
        let apimanager = APIManager(url: endURL, method: .post, parameters: parameters, view: self)
        apimanager.request(fail: { () in
            self.starView.removeFromSuperview()
            self.makeAlert(message: "エラーが発生しました")
        }, success: { (json: JSON) in
            self.starView.removeFromSuperview()
            self.makeGoodAlert(message: "評価が完了しました。ご協力ありがとうございました。")
            self.loadData()
        })
    }

    @objc func goProfile(sender: UIGestureRecognizer) {
        var teacher = Teacher()
        var tag = 0
        
        guard let imageView = sender.view as? UIImageView else {
            return
        }
        tag = imageView.tag
        let endURL = awsURL + "/teacher?email=\(lessonArray[tag].yourEmail)"
        
        let apimanager = APIManager(url: endURL, method: .get, parameters: [:], view: self)
        apimanager.request(fail: { () in
            self.makeAlert(message: "エラーが発生しました")
        }, success: { (json: JSON) in
            if let name = json["nickName"].string {
                teacher.name = "\(name)先生"
            }
            if let live = json["live"].string {
                teacher.live = live
            }
            if let money = json["money"].int {
                teacher.money = "\(money)円"
            }
            if let email = json["email"].string {
                teacher.email = email
            }
            if let able = json["able"].string {
                teacher.able = able
            }
            if let age = json["age"].string {
                teacher.age = "\(age)歳"
            }
            if let country = json["country"].string {
                teacher.country = "\(country)"
            }
            if let evaluate = json["evaluate"].int {
                teacher.evaluate = evaluate
            }
            if let lessonCount = json["lessonCount"].int {
                teacher.lessonCount = lessonCount
            }
            if let comment = json["comments"].string {
                teacher.comment = comment
            }
            
            let vc = TeacherDetailViewController(teacher: teacher)
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        })
        
    }

}
