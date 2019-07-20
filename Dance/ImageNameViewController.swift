import UIKit
import Photos
import Alamofire
import SwiftyJSON
//講師側に限定にする　自動アップデートしてもらうにはどうしたらいいか　??のシャドーイングをもっとうまく使うべきかもしれない　スキップがないではないか
class ImageNameViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let topLabel = UILabel()
    let nameTextField = UITextField()
    let editButton = myButton(frame: CGRect())
    let sendButton = myButton(frame: CGRect())
    let imageView = UIImageView()
    var isChangedPhoto = false
    let skipButton = UIButton()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(topLabel)
        self.view.addSubview(nameTextField)
        self.view.addSubview(editButton)
        self.view.addSubview(sendButton)
        self.view.addSubview(imageView)
        self.view.addSubview(skipButton)
        self.view.backgroundColor = .white
        
        topLabel.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        skipButton.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "no_image.jpg")
        
        
        topLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 50.0).isActive = true
        topLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        topLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20.0).isActive = true
        topLabel.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        topLabel.text = "表示名と画像を登録しよう"
        topLabel.font = UIFont.boldSystemFont(ofSize: 22.0)
        topLabel.textAlignment = .center
        topLabel.textColor = .black
        
        nameTextField.topAnchor.constraint(equalTo: self.topLabel.bottomAnchor, constant: 30.0).isActive = true
        nameTextField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        nameTextField.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20.0).isActive = true
        nameTextField.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        nameTextField.placeholder = "表示名"
        
        imageView.topAnchor.constraint(equalTo: self.nameTextField.bottomAnchor, constant: 30.0).isActive = true
        imageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 200.0).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 200.0).isActive = true
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        editButton.topAnchor.constraint(equalTo: self.imageView.bottomAnchor, constant: 30.0).isActive = true
        editButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        editButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 50.0).isActive = true
        editButton.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        editButton.backgroundColor = UIColor.red
        editButton.setTitle("画像を選ぶ", for: .normal)
        editButton.addTarget(self, action: #selector(edit), for: .touchUpInside)
        
        sendButton.topAnchor.constraint(equalTo: self.editButton.bottomAnchor, constant: 30.0).isActive = true
        sendButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        sendButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 50.0).isActive = true
        sendButton.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        sendButton.backgroundColor = UIColor.red
        sendButton.setTitle("更新する", for: .normal)
        sendButton.addTarget(self, action: #selector(send), for: .touchUpInside)
        
        skipButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 5.0).isActive = true
        skipButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -5.0).isActive = true
        skipButton.widthAnchor.constraint(equalToConstant: 100.0).isActive = true
        skipButton.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        skipButton.backgroundColor = UIColor.white
        skipButton.setTitle("スキップ", for: .normal)
        skipButton.setTitleColor(.blue, for: .normal)
        skipButton.titleLabel?.adjustsFontSizeToFitWidth = true
        skipButton.addTarget(self, action: #selector(skip), for: .touchUpInside)
        
    }
    

    @objc func skip() {
        print ("skip")
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let nc = mainStoryboard.instantiateViewController(withIdentifier: "tabBar2") as! UITabBarController
        //presentを2回繰り返すのはあまり良くないらしい
        self.present(nc, animated: true, completion: nil)
        
    }
    
    @objc func edit() {
        checkPermission()
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @objc func send() {
        
        if self.isChangedPhoto {
            uploadSaveImage(image: self.imageView.image!, path: uds.object(forKey: "myId") as! String)
            
            if let image = self.imageView.image {
                let height = image.size.height
                let width = image.size.width
                let reSize  = CGSize(width: 200, height: 200*height/width)
                let resizedImage = image.reSizeImage(reSize: reSize)
                uds.set(resizedImage.jpegData(compressionQuality: 1.0), forKey: "imagePath")
            }
        }
        
        if nameTextField.text?.count == 0 {
            makeAlert(message: "表示名は必須です")
            return
        }
        
        let endURL = awsURL + "/teacher"
        var parameters = [String: String]()
        parameters["email"] = uds.object(forKey: "teacherId") as! String
        parameters["nickName"] = nameTextField.text
        
        let apimanager = APIManager(url: endURL, method: .post, parameters: parameters, view: self)
        apimanager.request(fail: { () in
            self.makeAlert(message: "エラーが発生しました")
        }, success: { (json: JSON) in
            uds.set(self.nameTextField.text, forKey: "name")
            self.skip()
        })

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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        isChangedPhoto = true
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        self.imageView.image = image
        self.dismiss(animated: true)
    }
    
}
