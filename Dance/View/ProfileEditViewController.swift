import UIKit
import SwiftyJSON
import Photos

class ProfileEditViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let profileLabel = UILabel()
    let privateLabel = UILabel()
    let topImageView = UIImageView()
    let pictureButton = UIButton()
    var isChangedPhoto = false
    
    let profileTable = UITableView()
    let submitButton = myButton(frame: CGRect())
    let scrollView = UIScrollView()
    
    let textField1 = UITextField()
    let textField2 = UITextField()
    let textField3 = UITextField()
    let textField4 = UITextField()
    let textField5 = UITextField()
    let textField6 = UITextField()
    let textField7 = UITextField()
    let textField8 = UITextField()
    let textField9 = UITextField()
    let textField10 = UITextField()
    
    let detailLabel = UILabel()
    let textView = UITextView()
    let myEmail = uds.object(forKey: "myId")!
    
    // ここでimTeacherすればいいのか  regionはだめであったよ fullNameは銀行振込のためです
    let profileTitleArray = imTeacher ? ["Email","年齢", "表示名","教える地域", "レッスン料/時","得意ジャンル","銀行コード", "支店番号", "口座番号", "氏名(カタカナ)", "国籍"] : ["Email","年齢", "表示名","地域"]
    let userDefaultsArray = imTeacher ?  ["myId","age", "name","live","money", "able","bank", "bs", "bn","fullname", "country"] : ["myId","age", "name","live"]
    
    lazy var textFieldArray = imTeacher ? [nil,textField1,textField2,textField3,textField4,textField5,textField6, textField7, textField8, textField9, textField10] : [nil,textField1,textField2,textField3]

    init(image: UIImage) {
        super.init(nibName: nil, bundle: nil)
        self.topImageView.image = image
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.scrollView.addSubview(topImageView)
        self.view.backgroundColor = commonBackgroundColor
        setSwipeBack()
        self.makeScrollView()
        
        profileTable.delegate = self
        profileTable.dataSource = self
        self.profileTable.register(UITableViewCell.self, forCellReuseIdentifier: "profile")
        profileTable.bounces = false
        
        submitButton.addTarget(self, action: #selector(submit), for: .touchUpInside)
        pictureButton.addTarget(self, action: #selector(picture), for: .touchUpInside)
        
        self.submitButton.setTitle("更新", for: .normal)
        
        self.pictureButton.setTitle("写真を変更", for: .normal)
        self.pictureButton.setTitleColor(UIColor.red, for: .normal)
        self.pictureButton.backgroundColor = commonBackgroundColor
        self.pictureButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 22.0)
        
        self.detailLabel.text = "自己紹介を記入しよう！"
        self.detailLabel.font = UIFont.boldSystemFont(ofSize: 22.0)
        
        self.profileTable.translatesAutoresizingMaskIntoConstraints = false
        self.pictureButton.translatesAutoresizingMaskIntoConstraints = false
        self.topImageView.translatesAutoresizingMaskIntoConstraints = false
        self.textView.translatesAutoresizingMaskIntoConstraints = false
        self.detailLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        self.scrollView.addSubview(profileTable)
        self.view.addSubview(submitButton)
        self.scrollView.addSubview(pictureButton)
        self.scrollView.addSubview(textView)
        self.scrollView.addSubview(detailLabel)
        
        
        self.profileTable.topAnchor.constraint(equalTo: self.topImageView.bottomAnchor, constant: 20.0).isActive = true
        self.profileTable.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        self.profileTable.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        self.profileTable.heightAnchor.constraint(equalToConstant: CGFloat(50 * textFieldArray.count)).isActive = true
        
        self.detailLabel.topAnchor.constraint(equalTo: self.profileTable.bottomAnchor, constant: 20.0).isActive = true
        self.detailLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        self.detailLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        self.detailLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.textView.topAnchor.constraint(equalTo: self.detailLabel.bottomAnchor, constant: 10.0).isActive = true
        self.textView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 50).isActive = true
        self.textView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -50).isActive = true
        self.textView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        self.textView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor, constant: -300).isActive = true
        self.textView.layer.masksToBounds = true
        self.textView.layer.cornerRadius = 10.0
        self.textView.font = UIFont.systemFont(ofSize: 16.0)
        if let commentText = uds.object(forKey: "comment") {
            textView.text = commentText as? String
        }
        
        self.submitButton.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        self.submitButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 40).isActive = true
        self.submitButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -40).isActive = true
        self.submitButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -20).isActive = true
        
        self.pictureButton.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        self.pictureButton.leftAnchor.constraint(equalTo: self.topImageView.rightAnchor, constant: 20.0).isActive = true
        self.pictureButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        self.pictureButton.centerYAnchor.constraint(equalTo: self.topImageView.centerYAnchor).isActive = true
        
        self.topImageView.heightAnchor.constraint(equalToConstant: 150.0).isActive = true
        self.topImageView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20.0).isActive = true
        self.topImageView.widthAnchor.constraint(equalToConstant: 150.0).isActive = true
        self.topImageView.topAnchor.constraint(equalTo: self.scrollView.topAnchor, constant: 30.0).isActive = true
        self.topImageView.contentMode = .scaleAspectFill
        self.topImageView.clipsToBounds = true
        
        // このあたりをもっとスマートに書きたい
        textField1.keyboardType = .numberPad
        textField4.keyboardType = .numberPad
        textField6.keyboardType = .numberPad
        textField7.keyboardType = .numberPad
        textField8.keyboardType = .numberPad
    }
    
    func makeScrollView() {
        scrollView.backgroundColor = commonBackgroundColor
        scrollView.frame.size = CGSize(width: view.frame.width, height: view.frame.height)
        scrollView.center = self.view.center
        scrollView.contentSize = CGSize(width: view.frame.width, height: 1000)
        scrollView.bounces = false
        scrollView.indicatorStyle = .default
        scrollView.scrollIndicatorInsets = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        scrollView.delegate = self
        scrollView.keyboardDismissMode = .onDrag
        self.view.addSubview(scrollView)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.profileTitleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "profile")
        cell.textLabel?.text = profileTitleArray[indexPath.row]
        cell.selectionStyle = .none
       
        if indexPath.row == 0 {
           let rightLabel = UILabel()
            rightLabel.frame = CGRect(x: 80, y: 5, width: self.view.frame.size.width - 90, height: cell.frame.height - 5)
            cell.addSubview(rightLabel)
            rightLabel.textAlignment = .right
            //これで一回あれするとよくなるという変な感じ
            if let text = uds.object(forKey: "myId") {
                rightLabel.text = text as! String
            }
        }
        
        else {
            let textField = self.textFieldArray[indexPath.row]
            textField?.frame = CGRect(x: 130, y: 5, width: self.view.frame.size.width - 140, height: cell.frame.height - 5)
            cell.addSubview(textField!)
            textField!.textAlignment = .right
            textField!.delegate = self
            //単純にダサいんですよね  roundedRectにしようじゃないか
            textField!.backgroundColor = UIColor.white
            textField!.borderStyle = .roundedRect
            textField!.layer.borderWidth = 0.5
            textField!.layer.masksToBounds = true
            textField!.layer.cornerRadius = 10.0
            
            if let text = uds.object(forKey: userDefaultsArray[indexPath.row]) {
                textField!.text = text as! String
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    
    @objc func submit() {
        if imTeacher, let money = textField4.text, money.count > 0, Int(money)! > 5000 {
            makeAlert(message: "1時間のレッスン料は5000円以下に設定してください。")
            return
        }
        if textField2.text?.count == 0 {
            makeAlert(message: "表示名は必須です")
            //これがないとトークが送れないのだ
            return
        }
        
        let endURL = imTeacher ? awsURL + "/teacher" : awsURL + "/student"
        
        var parameters = [String: String]()
        if imTeacher {
            parameters["email"] = myEmail as! String
            parameters["age"] = textField1.text!.count > 0 ? textField1.text : "未設定"
            parameters["nickName"] = textField2.text!.count > 0 ? textField2.text : "ゲスト"
            parameters["live"] = textField3.text!.count > 0 ? textField3.text : "未設定"
            parameters["money"] = textField4.text!.count > 0 ? textField4.text: "未設定"
            parameters["able"] = textField5.text!.count > 0 ? textField5.text : "未設定"
            parameters["bank"] = textField6.text!.count > 0 ? textField6.text : "未設定"
            parameters["bs"] = textField7.text!.count > 0 ? textField7.text : "未設定"
            parameters["bn"] = textField8.text!.count > 0 ? textField8.text : "未設定"
            parameters["fullName"] = textField9.text!.count > 0 ? textField9.text : "未設定"
            parameters["country"] = textField10.text!.count > 0 ? textField10.text : "未設定"
            parameters["Comments"] = textView.text!.count > 0 ? textView.text : "自己紹介コメントがありません"
        }
        else {
            parameters["email"] = myEmail as! String
            parameters["age"] = textField1.text!.count > 0 ? textField1.text : "未設定"
            parameters["nickName"] = textField2.text!.count > 0 ? textField2.text : "未設定"
            parameters["live"] = textField3.text!.count > 0 ? textField3.text : "未設定"
            parameters["Comments"] = textView.text!.count > 0 ? textView.text : "自己紹介コメントがありません"
        }
        
        let apimanager = APIManager(url: endURL, method: .post, parameters: parameters, view: self)
        apimanager.request(fail: { () in
            self.makeAlert(message: "エラーが発生しました")
            return
        }, success: { (json: JSON) in
            self.makeGoodAlert(message: "プロフィールの更新が完了しました")
            self.saveData()
        })
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func picture() {
        checkPermission()
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    func checkPermission(){
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        
        switch photoAuthorizationStatus {
        case .authorized:
            print("auth")
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({
                (newStatus) in
                print("status is \(newStatus)")
                if newStatus ==  PHAuthorizationStatus.authorized {
                    /* do stuff here */
                    print("success")
                }
            })
            print("not Determined")
        case .restricted:
            print("restricted")
        case .denied:
            print("denied")
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        isChangedPhoto = true
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        self.topImageView.image = image
        self.dismiss(animated: true)
    }
    
    func saveData() {
        if imTeacher {
            uds.set(self.textView.text,forKey: "comment")
            
            for i in 1...10 {
                uds.set(self.textFieldArray[i]!.text, forKey: self.userDefaultsArray[i])
            }
        }
        else {
            uds.set(self.textField1.text, forKey: self.userDefaultsArray[1])
            uds.set(self.textField2.text, forKey: self.userDefaultsArray[2])
            uds.set(self.textField3.text, forKey: self.userDefaultsArray[3])
            uds.set(self.textView.text,forKey: "comment")
        }
        
    
        if self.isChangedPhoto {
            uploadSaveImage(image: self.topImageView.image!, path: uds.object(forKey: "myId") as! String)
            
            if let image = self.topImageView.image {
                let height = image.size.height
                let width = image.size.width
                let reSize  = CGSize(width: 200, height: 200*height/width)
                let resizedImage = image.reSizeImage(reSize: reSize)
                uds.set(resizedImage.jpegData(compressionQuality: 1.0), forKey: "imagePath")
            }
        }
    }

}


