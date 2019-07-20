import UIKit
import SwiftyJSON
//ここは絶対にテストが必要
class StudioMoneyViewController: UIViewController {

    var studentEmail: String
    var teacherEmail = uds.object(forKey: "teacherId")
    let StudioView = StudioMoneyView()
    
    init(studentEmail: String) {
        self.studentEmail = studentEmail
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSwipeBack()
        StudioView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        view.addSubview(self.StudioView)
        StudioView.submitButton.addTarget(self, action: #selector(submit), for: .touchUpInside)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc func submit() {
        
        guard let text = StudioView.form.text else {
            return
        }
        if  text.count == 0 {
            self.makeAlert(message: "コメントを入力してください")
            return
        }
        guard let text2 = StudioView.textField.text else {
            return
        }
        if  text2.count == 0 {
            self.makeAlert(message: "金額を入力してください")
            return
        }
        
        if  Int(text2)! < 500 || Int(text2)! > 5000 {
            self.makeAlert(message: "請求できるのは500円以上かつ5000円以下です")
            return
        }
            
        let endURL = awsURL + "/studio"
        let parameters:[String: Any] = ["studentEmail": studentEmail,"timeStamp": Int(NSDate().timeIntervalSince1970), "money": StudioView.textField.text!, "comment": StudioView.form.text!, "teacherEmail": uds.object(forKey: "myId")!]
        
        let apimanager = APIManager(url: endURL, method: .post, parameters: parameters, view: self)
        apimanager.request(fail: { () in
            self.StudioView.form.text = ""
            self.StudioView.textField.text = ""
            self.makeAlert(message: "エラーが発生しました")
        }, success: { (json: JSON) in
            self.StudioView.form.text = ""
            self.StudioView.textField.text = ""
            self.makeGoodAlert(message: "請求が完了しました。請求が承認されると決済が実行されます。")
        })
    }
    
}
