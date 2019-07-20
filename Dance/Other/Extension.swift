import Foundation
import UIKit
import AWSS3
import AWSCore
import SwiftyJSON
import Alamofire
// 94 31 95が一つの候補です 100 65  0でもいい感じのオレンジになったよ　一回ゆっくりスクロールで画像がちゃんと表示されても再度高速で戻ると表示が崩れる
let commonBackgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
let pulpleColor = UIColor(red: 0.94, green: 0.31, blue: 0.95, alpha: 1.0)
let orangeColor = UIColor(red: 1.0, green: 0.65, blue: 0.0, alpha: 1.0)
//134 227 75 が一番LINEに近くなる
let greenColor = UIColor(red: 0.52, green: 0.89, blue: 0.29, alpha: 1.0)

var imTeacher: Bool {
    if UserDefaults.standard.object(forKey: "imTeacher") != nil {
        return UserDefaults.standard.object(forKey: "imTeacher") as! Bool
    }
    else {
        return false
    }
    
}
let uds = UserDefaults.standard
var myEmailAdress = uds.object(forKey: "myId")
let commonGrayView = UIView()
let commonIndicator = UIActivityIndicatorView()
let UneiMail = "unei@gmail.com"
let headers: HTTPHeaders = ["x-api-key": ""]

extension UIImage {
    // resize image 画像が荒くなる
    func reSizeImage(reSize:CGSize)->UIImage {
        UIGraphicsBeginImageContextWithOptions(reSize,true,0.0);
        self.draw(in: CGRect(x: 0, y: 0, width: reSize.width, height: reSize.height));
        let reSizeImage:UIImage! = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return reSizeImage;
    }
    
}

extension Array {
    func removeDouble() -> [String] {
        let orderdSet = NSOrderedSet(array: self)
        let uniqueValues = orderdSet.array as! [String]
        return uniqueValues
    }
}

extension String {
   
    public func addZero() -> String {
        var text = self
        if text.count == 1 {
            text = "0" + text
        }
        return text
    }
    
    public func takeHourMinute() -> [String] {
        var text1 = ""
        var text2 = ""
        var i = 0
        for chr in self {
            if chr == ":" {
                break
            }
            else if i >= 2 {
                text1 = text1 + String(chr)
            }
            i+=1
        }
        text2 = String(self.suffix(self.count - i - 1))
        text2 = String(text2.prefix(text2.count - 1))
        
        if self.contains("後") {
            text1 = String(Int(text1)! + 12)
        }
        
        return [text1, text2]
    }
    
    
    public func takeMonthDate() -> [String] {
        var text1 = ""
        var text2 = ""
        var i = 0
        for chr in self {
            if chr == "/" {
                break
            }
            else {
                text1 = text1 + String(chr)
                i+=1
            }
        }
        text2 = String(self.suffix(self.count - i - 1))
        
        
        return [text1, text2]
    }
    
    public func takeTime() -> String {
        return String(self.prefix(self.count - 2))
    }
}


func generateImageUrl(_ uploadImage: UIImage) -> URL {
    let imageURL = URL(fileURLWithPath: NSTemporaryDirectory().appendingFormat("upload.jpg"))
    //jpegRepresantationの新しい書き方です　1.0でクオリティが最大になる
    if let jpegData = uploadImage.jpegData(compressionQuality: 1.0) {
        try! jpegData.write(to: imageURL, options: [.atomicWrite])
    }
    return imageURL
}

func deleteData() {
    //お気に入りと応募履歴のみ残してローカルのデータを消す
    var emailList = [String]()
    if uds.array(forKey: "emailList") != nil {
        emailList = uds.array(forKey: "emailList") as! [String]
    }
    var favoriteList = [String]()
    if uds.array(forKey: "favoriteList") != nil {
        favoriteList = uds.array(forKey: "favoriteList") as! [String]
    }
    
    let domain = Bundle.main.bundleIdentifier!
    uds.removePersistentDomain(forName: domain)
    uds.synchronize()
    
    uds.set(emailList, forKey: "emailList")
    uds.set(favoriteList, forKey: "favoriteList")
    
}

func fetchData(myId: String) {
    //ログイン時にサーバー側のデータを取ってくる 先生と生徒で違うのかー
    let endURL = imTeacher ? awsURL + "/teacher?email=\(myId)" : awsURL + "/student?email=\(myId)"
    let apimanager = APIManager(url: endURL, method: .get, parameters: [:], view: UIViewController())
    apimanager.request(fail: { () in
        
    }, success: { (json: JSON) in
        if let name = json["nickName"].string {
            uds.set(name, forKey: "name")
        }
        if let live = json["live"].string {
            uds.set(live, forKey: "live")
        }
        if let able = json["able"].string {
            uds.set(able, forKey: "able")
        }
        if let country = json["country"].string {
            uds.set(country, forKey: "country")
        }
        
        if let age = json["age"].string {
            uds.set(age, forKey: "age")
        }
        if let comment = json["Comments"].string {
            uds.set(comment, forKey: "comment")
        }
        if let comment = json["comments"].string {
            uds.set(comment, forKey: "comment")
        }
        if let comment = json["money"].string {
            uds.set(comment, forKey: "money")
        }
        if let bi = json["bankId"].string {
            uds.set(bi, forKey: "bank")
        }
        if let bs = json["binkShop"].string {
            uds.set(bs, forKey: "bs")
        }
        if let bn = json["bankNumber"].string {
            uds.set(bn, forKey: "bn")
        }
        if let fullName = json["fullName"].string {
            uds.set(fullName, forKey: "fullname")
        }
    })

}


func uploadSaveImage(image: UIImage, path: String) {
    
    let height = image.size.height
    let width = image.size.width
    let reSize  = CGSize(width: 200, height: 200*height/width)
    let resizedImage = image.reSizeImage(reSize: reSize)
    
    
    let credentialsProvider = AWSStaticCredentialsProvider(accessKey: "", secretKey: "")
    let serviceConfiguration = AWSServiceConfiguration(region: AWSRegionType.USEast2, credentialsProvider: credentialsProvider)
    AWSServiceManager.default().defaultServiceConfiguration = serviceConfiguration
    let transferManager = AWSS3TransferManager.default()
    
    let uploadRequest = AWSS3TransferManagerUploadRequest()
    uploadRequest?.bucket = "danceimage"
    uploadRequest?.key = "\(path).jpg"
    uploadRequest?.body = generateImageUrl(resizedImage)
    transferManager.upload(uploadRequest!).continueWith(block: { (task: AWSTask) -> Any? in
        
        return nil
    })
    
}

func unixToString(unix: Int) -> String {
    
    let dateUnix: TimeInterval = TimeInterval(unix)
    let date = Date(timeIntervalSince1970: dateUnix)
    
    // NSDate型を日時文字列に変換するためのNSDateFormatterを生成
    let formatter = DateFormatter()
    formatter.dateFormat = "MM月dd日　HH:mm" //年はもはやいらないや
    formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
    // NSDateFormatterを使ってNSDate型 "date" を日時文字列 "dateStr" に変換
    let dateStr: String = formatter.string(from: date)
    return dateStr
}

func getMonth() -> Int {
    
    let dateUnix: TimeInterval = NSDate().timeIntervalSince1970
    let date = Date(timeIntervalSince1970: dateUnix)
    
    let formatter = DateFormatter()
    formatter.dateFormat = "MM"
    formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
    // NSDateFormatterを使ってNSDate型 "date" を日時文字列 "dateStr" に変換
    let dateStr: String = formatter.string(from: date)
    return Int(dateStr)!
}

func getYear() -> Int {
    
    let dateUnix: TimeInterval = NSDate().timeIntervalSince1970
    let date = Date(timeIntervalSince1970: dateUnix)
    
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy"
    formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
    // NSDateFormatterを使ってNSDate型 "date" を日時文字列 "dateStr" に変換
    let dateStr: String = formatter.string(from: date)
    return Int(dateStr)!
}

func dateCheck(year: String, month: String, date: String) -> Bool {
    let intYear = Int(year)
    let intMonth = Int(month)
    let intDate = Int(date)
    
    if intDate! <= 28 {
        return true
    }
    
    if intDate! == 29 {
        if intYear! % 4 == 0 {
            return true
        }
        if intMonth! == 2 {
            return false
        }
        return true
        
    }
    
    if intDate! == 30 {
        if intMonth! == 2 {
            return false
        }
        return true
    }
    if intDate! == 31 {
        
        if intMonth! == 2 || intMonth! == 4 || intMonth! == 6 || intMonth! == 9 || intMonth! == 11 {
            return false
        }
        return true
    }
    else {
        return false
    }
}

class myButton: UIButton {
    
    override init(frame: CGRect) {
//        self.frame = frame
        super.init(frame: frame)
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 25.0
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = orangeColor
        self.setTitleColor(.white, for: .normal)
        self.titleLabel!.font = UIFont.boldSystemFont(ofSize: 22.0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension UIViewController {
    
    func makeAlert(message: String) {
        let alert = UIAlertController(title: "エラーが発生しました", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true, completion: nil)
    }
    
    func makeGoodAlert(message: String) {
        let alert = UIAlertController(title: "完了", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true, completion: nil)
    }
    
    func makeNoTitleAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func returnTransferManager() -> AWSS3TransferManager {
        let credentialsProvider = AWSStaticCredentialsProvider(accessKey: "", secretKey: "")
        let serviceConfiguration = AWSServiceConfiguration(region: AWSRegionType.USEast2, credentialsProvider: credentialsProvider)
        AWSServiceManager.default().defaultServiceConfiguration = serviceConfiguration
        return AWSS3TransferManager.default()
    }
    
        
    func setIndicator2() {
        commonGrayView.frame = UIScreen.main.bounds
        commonGrayView.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5)
        
        self.view.addSubview(commonGrayView)
        commonIndicator.center = self.view.center
        commonIndicator.style = .whiteLarge
        commonIndicator.color = orangeColor
        commonIndicator.hidesWhenStopped = true
        self.view.addSubview(commonIndicator)
        commonIndicator.startAnimating()
        
    }
    
    func removeIndicator2() {
        DispatchQueue.main.async {
            commonGrayView.removeFromSuperview()
            commonIndicator.stopAnimating()
        }
    
    }
    
    func downLoadImage(path: String, imageView: UIImageView, tempPath: String) {
        let transferManager = returnTransferManager()
        let downloadRequest = AWSS3TransferManagerDownloadRequest()
        downloadRequest!.bucket = "danceimage"
        downloadRequest!.key = "\(path).jpg"
        downloadRequest!.downloadingFileURL = URL(fileURLWithPath: tempPath).appendingPathComponent("\(path).jpg")
        //画像を必須にすることで乗り切りましょうか　それしかないね　
        transferManager.download(downloadRequest!).continueWith(block: { (task: AWSTask) -> Any? in
            
            if let result = task.result {
                
                if let body = result.body  {
                    
                    let body2 = body as! NSURL
                    let bodyString = body2.absoluteString
                    // さっきのは解決じゃなくて単にダウンロードされずキャッシュが表示されてただけ　方向性は合っているんだが
                    DispatchQueue.main.async {
                        if URL(string: bodyString!) == URL(fileURLWithPath: tempPath).appendingPathComponent("\(path).jpg") {
                            //セルの高速スクロールへの対策　ダメでした
                            let fileURLPath = URL(fileURLWithPath: tempPath).appendingPathComponent("\(path).jpg")
                            imageView.image = UIImage(contentsOfFile: fileURLPath.path)!
                        }
                    }
                    
                    
                }
            
            }
           
            return nil
        })
        
    }
    
    func setSwipeBack() {
        let target = self.navigationController?.value(forKey: "_cachedInteractionController")
        let recognizer = UIPanGestureRecognizer(target: target, action: Selector(("handleNavigationTransition:")))
        self.view.addGestureRecognizer(recognizer)
    }
    
    func textJudge(mail: String, password: String) -> Bool {
        
        let mailText = mail
        let emailRegEx = "[A-Z0-9a-z@.-_@]{5,40}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        let result1 = emailTest.evaluate(with: mailText)
        
        let passwordText = password
        let passwordRegEx = "[A-Z0-9a-z]{5,20}"//英数字５文字以上2０文字以内の制限
        let _ = NSPredicate(format: "SELF MATCHES %@", passwordRegEx)
        let result2 = emailTest.evaluate(with: passwordText)
        
        if result1 == false {
            self.makeAlert(message: "メールアドレスの形式を正しく入力してください")
            return false
        }
        else if result2 == false{
            self.makeAlert(message: "パスワードは半角英数字５文字以上２０文字以内で入力してください")
            return false
        }
        else{
            return true
        }
        
    }
    
    func sendReport(value: String, vc: UIViewController) {
        let endURL = awsURL + "/question"
        myEmailAdress = myEmailAdress == nil ? "guest@gmail.com" : myEmailAdress
        let parameters:[String: Any] = ["email": myEmailAdress,"timeStamp": Int(NSDate().timeIntervalSince1970), "value": value]
        
        let apimanager = APIManager(url: endURL, method: .post, parameters: parameters, view: vc)
        apimanager.request(fail: { () in
            vc.makeAlert(message: "エラーが発生しました")
        }, success: { (json: JSON) in
            vc.makeNoTitleAlert(message: "違反報告が完了しました")
        })
        
    }
    
}

