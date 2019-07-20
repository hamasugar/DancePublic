import UIKit
import SwiftyJSON
import AWSS3
import AWSCore
//  お気に入りボタンをつけてもいいかもしれない　右上に点3つでpairsみたいにつけてもいいかな
class TeacherDetailViewController: UIViewController, UITableViewDelegate {
    
    var teacher = Teacher()
    let tempPath = NSTemporaryDirectory()
    let applyButton = myButton(frame: CGRect())
    
    let teacherDetailView = TeacherDetailView()
    var tdModel: TeacherDetailModel!
    //ここは誰でも見れてしまうので　確かにここにアクセルできないのはまずい
    var emailList = [String]()
    
    init(teacher: Teacher) {
        self.teacher = teacher
        super.init(nibName: nil, bundle: nil)
        self.tdModel = TeacherDetailModel(teacher: teacher)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSwipeBack()
        //navigationControllerがあらわれてからにすべきなのかも
        teacherDetailView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height - (self.navigationController?.navigationBar.frame.height)!)
        view.addSubview(teacherDetailView)
        
        if uds.array(forKey: "emailList") != nil {
            self.emailList = uds.array(forKey: "emailList") as! [String]
        }
        
        teacherDetailView.scrollView.delegate = self
        self.navigationItem.title = "講師詳細"
        
        self.view.addSubview(applyButton)
        applyButton.backgroundColor = .red
        applyButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 50.0).isActive = true
        applyButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -50.0).isActive = true
        applyButton.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        applyButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -20.0).isActive = true
        applyButton.setTitle("話を聞いてみる", for: .normal)
        
        teacherDetailView.topLabel.text = self.teacher.name
        teacherDetailView.commentLabel.text = teacher.comment!
        teacherDetailView.infoTableView.delegate = self
        teacherDetailView.infoTableView.dataSource = tdModel
        teacherDetailView.infoTableView.register(UITableViewCell.self, forCellReuseIdentifier: "table")
        applyButton.addTarget(self, action: #selector(apply), for: .touchUpInside)
        
        if emailList.contains(teacher.email!) {
            applyButton.setTitle("応募済み", for: .normal)
            applyButton.isEnabled = false
        }
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(report))
        self.downLoadImage(path: teacher.email!, imageView: teacherDetailView.imageView, tempPath: tempPath)
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40.0
    }
    
    @objc func report() {
        let alert: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle:  .actionSheet)
        let action1: UIAlertAction = UIAlertAction(title: "お気に入りに追加", style: .default, handler:{
            (action: UIAlertAction!) -> Void in
            
            if let favoriteList = uds.object(forKey: "favoriteList") {
                var favoriteArray = favoriteList as! [String]
                favoriteArray.append(self.teacher.email)
                uds.set(favoriteArray.removeDouble(), forKey: "favoriteList")
            }
            else {
                let favoriteArray = [self.teacher.email]
                uds.set(favoriteArray, forKey: "favoriteList")
            }
            self.makeNoTitleAlert(message: "追加が完了しました")
        })
        let action2: UIAlertAction = UIAlertAction(title: "違反報告", style: .destructive, handler:{
            (action: UIAlertAction!) -> Void in
            self.sendReport(value: "【違反報告】" + self.teacher.email, vc: self)
        })
        let action3: UIAlertAction = UIAlertAction(title: "戻る", style: .default, handler: nil)
        alert.addAction(action1)
        alert.addAction(action2)
        alert.addAction(action3)
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func apply() {
        guard let studentId = uds.object(forKey: "studentId") else {
            //登録画面に遷移
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let nc = mainStoryboard.instantiateViewController(withIdentifier: "studentRegister")
            present(nc, animated: true, completion: nil)
            return
        }
        
        if let udComment2 = uds.object(forKey: "comment"),udComment2 as! String == "自己紹介コメントがありません" {
            self.makeNoTitleAlert(message: "応募にはマイページから自己紹介を入力する必要があります")
            return
        }
        
        if let udComment = uds.object(forKey: "comment"),udComment as! String == "未設定" {
            self.makeNoTitleAlert(message: "応募にはマイページから自己紹介を入力する必要があります")
            return
        }
        
        applyButton.isEnabled = false
        
        let endURL = awsURL + "/chat"
        let timeStamp = NSDate().timeIntervalSince1970
        let parameters:[String: Any] = ["senderEmail": studentId, "recieverEmail": teacher.email!, "isTeacher": false,"timeStamp": Int(timeStamp), "value": tdModel.makeText(),"teacherName": teacher.name!,"studentName": uds.object(forKey: "name")]
        let apimanager = APIManager(url: endURL, method: .post, parameters: parameters, view: self)
        apimanager.request(fail: { () in
            self.applyButton.isEnabled = true
            self.makeAlert(message: "エラーが発生しました")
        }, success: { (json: JSON) in
            
            self.applyButton.isEnabled = true
            self.emailList.append(self.teacher.email!)
            self.makeGoodAlert(message: "応募が完了しました")
            self.applyButton.setTitle("応募済み", for: .normal)
            self.applyButton.isEnabled = false
            uds.set(self.emailList, forKey: "emailList")
            
        })
    }
}

