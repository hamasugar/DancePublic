import UIKit
import SwiftyJSON

class QuestionViewController: UIViewController {
    
    let qview = QuestionView()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSwipeBack()
        qview.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        view.addSubview(self.qview)
        qview.submitButton.addTarget(self, action: #selector(submit), for: .touchUpInside)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc func submit() {
        //ここは本来モデルに委譲するところである
        guard let text = qview.form.text else {
            return
        }
        if  text.count == 0 {
            self.makeAlert(message: "内容を入力してください")
            return
        }
        
        let endURL = awsURL + "/question"
        
        if myEmailAdress == nil {
            myEmailAdress = "guest@gmail.com"
        }
        
        let parameters:[String: Any] = ["email": myEmailAdress,"timeStamp": Int(NSDate().timeIntervalSince1970), "value": text]
       
        let apimanager = APIManager(url: endURL, method: .post, parameters: parameters, view: self)
        apimanager.request(fail: { () in
            self.qview.form.text = ""
            self.makeAlert(message: "エラーが発生しました")
        }, success: { (json: JSON) in
            self.qview.form.text = ""
            let alert = UIAlertController(title: "問い合わせが完了しました", message: nil, preferredStyle: .alert)
            let action = UIAlertAction(title: "戻る", style: .default, handler: {
                (action: UIAlertAction!) in
                self.navigationController?.popViewController(animated: true)
            })
            
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        })
        
    }
}
