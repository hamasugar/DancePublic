
import UIKit
import Alamofire
import SwiftyJSON

class RuleViewController: UIViewController {

    let ruleView = RuleView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "利用規約"
        setSwipeBack()
        ruleView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        view.addSubview(self.ruleView)
        self.load()
    }
    
    //jsonが返ってこないのでapimanagerとは向かない
    fileprivate func load() {
        let endURL = awsURL + "/rule"
        self.setIndicator2()
        
        Alamofire.request(endURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            
            self.removeIndicator2()
            if (response.error != nil) {
                self.makeAlert(message: "エラーが発生しました")
                return
            }
            
            guard let object = response.result.value else {
                self.makeAlert(message: "エラーが発生しました")
                return
            }
            
            let ruleText = object as? String ?? ""
            if ruleText.count > 100 {
                
                let rule2 = String(ruleText.suffix(ruleText.count - 1))
                let rule3 = String(rule2.prefix(rule2.count - 1))
                //Viewに委譲
                self.ruleView.setText(text: rule3)
            }
            
            }
        }
    }


