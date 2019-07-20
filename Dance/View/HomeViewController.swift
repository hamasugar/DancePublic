import UIKit
import SwiftyJSON
import AWSS3
import AWSCore
// 先生が承認しないまま過ぎてしまったらそれはキャンセルとみなすべきだろう　先生がキャンセルしたということ　
class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var collectionView: UICollectionView!
    var teacherArray = [Teacher]()
    let tempPath = NSTemporaryDirectory()
    var isFavoriteOnly = false
    var allTeacherArray = [Teacher]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = []
        self.navigationController?.navigationBar.isTranslucent = false
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10.0
        layout.itemSize = CGSize(width: self.view.frame.size.width/2 - 30, height: 250)
        layout.sectionInset = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)//ギリギリ狙いでうまくいった
        self.collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height - 100), collectionViewLayout: layout)
        //-100でようやくちょうど良くなるのだよ
        self.view.backgroundColor = commonBackgroundColor
        self.collectionView.backgroundColor = commonBackgroundColor
        
        collectionView.register(TeachersCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.delegate = self
        collectionView.dataSource = self
        self.view.addSubview(collectionView)
        loadData()
    
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let teacherCell: TeachersCollectionViewCell =
            collectionView.dequeueReusableCell(withReuseIdentifier: "cell",
                                               for: indexPath) as! TeachersCollectionViewCell
        
        teacherCell.topLabel.text = "\(teacherArray[indexPath.row].name!)　 \(teacherArray[indexPath.row].able!)"
        
        teacherCell.bottomLabel.text = "\(teacherArray[indexPath.row].live!) \(teacherArray[indexPath.row].money!)/h  \(teacherArray[indexPath.row].age!)"
        
        teacherCell.backgroundColor = UIColor.white

        let path = teacherArray[indexPath.row].email!
        
        let fileURLPath = URL(fileURLWithPath: self.tempPath).appendingPathComponent("\(path).jpg")
        
        teacherCell.image.image = UIImage(named: "no_image.jpg")
        // カスタムプロパティ　これを挟むことで高速スクロール問題が解決される　変数を直接置くのはうまくいかなかった
        teacherCell.imageURL = "\(self.teacherArray[indexPath.row].email!).jpg"
        
        if let image = UIImage(contentsOfFile: fileURLPath.path) {
            teacherCell.image.image = image
        }
        
        let transferManager = returnTransferManager()
        let downloadRequest = AWSS3TransferManagerDownloadRequest()
        downloadRequest!.bucket = "danceimage"
        downloadRequest!.key = "\(path).jpg"
        downloadRequest!.downloadingFileURL = URL(fileURLWithPath: self.tempPath).appendingPathComponent("\(path).jpg")
        transferManager.download(downloadRequest!).continueWith(block: { (task: AWSTask) -> Any? in
            //taskは引数だからダメなのかな task.errorだからそれは違うな
            if let result = task.result {
                if let body = result.body  {
                    let body2 = body as! NSURL
                    let bodyString = body2.absoluteString
                    // 岸川さんの記事をそのまま真似たらようやくできました　インスタンスは参照渡しであるよ optionalと非でもイコール2つなら比較可能
                    
                        if URL(string: bodyString!) == URL(fileURLWithPath: self.tempPath).appendingPathComponent(teacherCell.imageURL) {
                            let fileURLPath = URL(fileURLWithPath: self.tempPath).appendingPathComponent("\(path).jpg")
                                DispatchQueue.main.async {
                                    teacherCell.image.image = UIImage(contentsOfFile: fileURLPath.path)!
                                }
                            print ("同じ")
                        }
                    
                }
                
            }
            
            return nil
        })
        
        return teacherCell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return teacherArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = TeacherDetailViewController(teacher: teacherArray[indexPath.row])
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func loadData() {
        let endURL = awsURL + "/teachers"
        let apimanager = APIManager(url: endURL, method: .get, parameters: [:], view: self)
        apimanager.request(fail: { () in
            self.makeAlert(message: "エラーが発生しました")
            return
        }, success: { (json: JSON) in
            guard let count = json["Count"].int else {
                self.makeAlert(message: "データが読み込めません")
                return
            }
            self.teacherArray = [Teacher]()//初期化
            
            for i in 0...count - 1 {
                var teacher = Teacher()
                if let name = json["Items"][i]["nickName"].string {
                    teacher.name = "\(name)先生"
                }
                if let live = json["Items"][i]["live"].string {
                    teacher.live = live
                }
                
                if let money = json["Items"][i]["money"].string {
                    teacher.money = "\(money)円"
                }
                
                if let email = json["Items"][i]["email"].string {
                    teacher.email = email
                }
                
                if let able = json["Items"][i]["able"].string {
                    teacher.able = able
                }
                if let age = json["Items"][i]["age"].string {
                    teacher.age = "\(age)歳"
                }
                if let country = json["Items"][i]["country"].string {
                    teacher.country = "\(country)"
                }
                if let evaluate = json["Items"][i]["evaluate"].int {
                    teacher.evaluate = evaluate
                }
                if let lessonCount = json["Items"][i]["lessonCount"].int {
                    teacher.lessonCount = lessonCount
                }
                if let comment = json["Items"][i]["comments"].string {
                    teacher.comment = comment
                }
                
                self.teacherArray.append(teacher)
            }
            
            self.collectionView.reloadData()
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "お気に入り", style: .done, target: self, action: #selector(self.loadFavorite))
        })
        
        
    }
    
    @objc func loadFavorite() {
        //切り替えをする　
        if isFavoriteOnly {
            self.teacherArray = allTeacherArray
            isFavoriteOnly = false
            self.navigationItem.rightBarButtonItem?.title = "お気に入り"
            self.collectionView.reloadData()
        }
        else {
            var favoriteArray = [String]()
            var teacherArray2 = [Teacher]()
            if uds.object(forKey: "favoriteList") != nil {
                favoriteArray = uds.object(forKey: "favoriteList") as! [String]
            }
            else {
                self.makeNoTitleAlert(message: "お気に入りの講師が登録されていません")
                return
            }
            
            for value in self.teacherArray {
                if favoriteArray.contains(value.email) {
                    teacherArray2.append(value)
                }
            }
            self.allTeacherArray = self.teacherArray
            self.teacherArray = teacherArray2
            isFavoriteOnly = true
            self.navigationItem.rightBarButtonItem?.title = "全員を表示"
            self.collectionView.reloadData()
        }
        
    }

}
