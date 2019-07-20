import UIKit
import AWSS3
import AWSCore
import SwiftyJSON
//初期メッセージを端末に保存しておく作戦でいきましょう。 相手のメアド：時間　内容　名前の順であります
class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // email 時間　内容　名前
    let chatTable = UITableView()
    let refreshCtl = UIRefreshControl()
    let tempPath = NSTemporaryDirectory()
    var hashDictionary = [String: [String]]()

    var resultDictionary: [[String]] {
        var returnArray = [[String]]()
        for value in hashDictionary {
            returnArray.append([value.key, value.value[0], value.value[1], value.value[2]])
        }
        return returnArray.sorted(by: { Int($0[1])! > Int($1[1])! } )
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "トーク一覧"
        self.edgesForExtendedLayout = []
        self.navigationController?.navigationBar.isTranslucent = false
        self.view.addSubview(chatTable)
        chatTable.translatesAutoresizingMaskIntoConstraints = false
        chatTable.register(UITableViewCell.self, forCellReuseIdentifier: "chat")
        chatTable.delegate = self
        chatTable.dataSource = self
        chatTable.refreshControl = refreshCtl
        refreshCtl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        
        chatTable.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
        chatTable.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        chatTable.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        chatTable.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -100).isActive = true
        //returnのタイミングが早すぎるとてテーブル自体が表示されなくなってしまう　
        if uds.object(forKey: "myId") == nil {
            let alert = UIAlertController(title: nil, message: "会員登録後にトーク履歴が表示されます", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        if let hash = uds.dictionary(forKey: "hash") {
            self.hashDictionary = hash as! [String : [String]]
        }
        loadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultDictionary.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "chat")
        cell.selectionStyle = .none
        cell.textLabel!.text = self.resultDictionary[indexPath.row][3]
        cell.detailTextLabel!.text = self.resultDictionary[indexPath.row][2]
        cell.imageView?.image = UIImage(named: "no_image.jpg")
        cell.imageView?.contentMode = .scaleAspectFill
        cell.imageView?.clipsToBounds = true
        cell.accessoryType = .disclosureIndicator
        downLoadImage(path: self.resultDictionary[indexPath.row][0], imageView: cell.imageView!, tempPath:tempPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ChatDetail2ViewController(name: self.resultDictionary[indexPath.row][3] , email: self.resultDictionary[indexPath.row][0])
        chatTable.deselectRow(at: indexPath, animated: true)
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    @objc func refresh(sender: UIRefreshControl) {
        loadData()
    }
    
    func loadData() {
        
        let endURL = awsURL + "/chat/scan" + "?email=\(uds.object(forKey: "myId")!)&timeStamp=\(uds.object(forKey: "chatLastTime")!)"
        
        let apimanager = APIManager(url: endURL, method: .get, parameters: [:], view: self)
        apimanager.request(fail: { () in
                self.refreshCtl.endRefreshing()
                self.makeAlert(message: "エラーが発生しました")
                return
                }, success: { (json: JSON) in
                self.refreshCtl.endRefreshing()
                guard let array = json.array else {
                    self.makeGoodAlert(message: "トーク履歴がありません")
                    return
                }
            
            uds.set(Int(NSDate().timeIntervalSince1970), forKey: "chatLastTime")
            
            for value in array {
                let yourEmail: String =  (imTeacher == value["isTeacher"].bool ? value["recieverEmail"].string : value["senderEmail"].string)!
                
                if imTeacher {
                    self.hashDictionary[yourEmail] = [String(value["timeStamp"].int!), value["value"].string!, value["studentName"].string!]
                }
                else {
                    self.hashDictionary[yourEmail] = [String(value["timeStamp"].int!), value["value"].string!, value["teacherName"].string!]
                }
                
            }
            uds.set(self.hashDictionary, forKey: "hash")
            self.chatTable.reloadData()
            
            })
        }

}
