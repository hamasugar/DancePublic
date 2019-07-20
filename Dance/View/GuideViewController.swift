import UIKit
//View以外のロジックがないのでもはやVCに分ける必要がない
class GuideViewController: UIViewController {
    
    let scrollView = UIScrollView()
    let firstLabel = UILabel()
    let secondLabel = UILabel()
    let thirdLabel = UILabel()
    
    let firstImage = UIImageView()
    let secondImage = UIImageView()
    let thirdImage = UIImageView()
    let firstImage2 = UIImageView()
    let secondImage2 = UIImageView()
    let thirdImage2 = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setSwipeBack()
        self.navigationItem.title = "使い方ガイド"
        
        scrollView.frame = self.view.frame
        scrollView.contentSize.width = view.frame.width
        scrollView.bounces = false
        scrollView.indicatorStyle = .default
        scrollView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        scrollView.backgroundColor = UIColor.white
        self.view.addSubview(scrollView)
        
        self.scrollView.addSubview(firstLabel)
        self.scrollView.addSubview(secondLabel)
        self.scrollView.addSubview(thirdLabel)
        self.scrollView.addSubview(firstImage)
        self.scrollView.addSubview(secondImage)
        self.scrollView.addSubview(thirdImage)
        self.scrollView.addSubview(firstImage2)
        self.scrollView.addSubview(secondImage2)
        self.scrollView.addSubview(thirdImage2)
        
        firstLabel.translatesAutoresizingMaskIntoConstraints = false
        secondLabel.translatesAutoresizingMaskIntoConstraints = false
        thirdLabel.translatesAutoresizingMaskIntoConstraints = false
        firstImage.translatesAutoresizingMaskIntoConstraints = false
        secondImage.translatesAutoresizingMaskIntoConstraints = false
        thirdImage.translatesAutoresizingMaskIntoConstraints = false
        firstImage2.translatesAutoresizingMaskIntoConstraints = false
        secondImage2.translatesAutoresizingMaskIntoConstraints = false
        thirdImage2.translatesAutoresizingMaskIntoConstraints = false
        
        
        firstLabel.numberOfLines = 0
        secondLabel.numberOfLines = 0
        thirdLabel.numberOfLines = 0
        
        firstLabel.font = UIFont.systemFont(ofSize: 16.0)
        secondLabel.font = UIFont.systemFont(ofSize: 16.0)
        thirdLabel.font = UIFont.systemFont(ofSize: 16.0)
        
        firstLabel.textAlignment = .left
        secondLabel.textAlignment = .left
        thirdLabel.textAlignment = .left
        
        firstLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20.0).isActive = true
        firstLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20.0).isActive = true
        firstLabel.topAnchor.constraint(equalTo: self.scrollView.topAnchor, constant: 20.0).isActive = true
        
        secondLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20.0).isActive = true
        secondLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20.0).isActive = true
        secondLabel.topAnchor.constraint(equalTo: self.firstImage2.bottomAnchor, constant: 50.0).isActive = true
        
        thirdLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20.0).isActive = true
        thirdLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20.0).isActive = true
        thirdLabel.topAnchor.constraint(equalTo: self.secondImage2.bottomAnchor, constant: 50.0).isActive = true
        
        if imTeacher {
            firstLabel.text = "1. 会員登録をしたら、プロフィールと自己紹介、画像を登録します。魅力的なプロフィールを作ることでレッスンのリクエストを貰いやすくなります。"
            secondLabel.text = "2. 生徒とレッスンの日時、レッスン料、スタジオを話し合います。レッスンの正式な予約を受けて承諾するとレッスン成立となります。スタジオの予約は原則講師が行ってください。"
            thirdLabel.text = "3 スタジオへ行きレッスンをします。レッスンが終了したら、その場で生徒のスマートフォンのレッスン一覧画面から決済を行うよう促してください。"
        }
        else {
            firstLabel.text = "1. ホーム画面で講師を探します。教わりたい講師を見つけたら、「話を聞いてみる」ボタンを押すとトークが可能となります"
            secondLabel.text = "2. 講師とレッスンの日時、レッスン料、スタジオを話し合った後、正式に予約画面からレッスンを予約します。"
            thirdLabel.text = "3 スタジオへ行きレッスンを受講します。終了後はレッスン一覧画面から決済を行い、講師を５段階で評価します。"
        }
        
        firstLabel.sizeToFit()
        secondLabel.sizeToFit()
        thirdLabel.sizeToFit()
        
        firstImage.centerXAnchor.constraint(equalTo: self.scrollView.centerXAnchor, constant: 0.0).isActive = true
        firstImage.widthAnchor.constraint(equalToConstant: 250.0).isActive = true
        firstImage.topAnchor.constraint(equalTo: self.firstLabel.bottomAnchor, constant: 20.0).isActive = true
        firstImage.heightAnchor.constraint(equalToConstant: 442.0).isActive = true
        
        firstImage2.centerXAnchor.constraint(equalTo: self.scrollView.centerXAnchor, constant: 0.0).isActive = true
        firstImage2.widthAnchor.constraint(equalToConstant: 250.0).isActive = true
        firstImage2.topAnchor.constraint(equalTo: self.firstImage.bottomAnchor, constant: 50.0).isActive = true
        firstImage2.heightAnchor.constraint(equalToConstant: 442.0).isActive = true
        
        secondImage.centerXAnchor.constraint(equalTo: self.scrollView.centerXAnchor, constant: 0.0).isActive = true
        secondImage.widthAnchor.constraint(equalToConstant: 250.0).isActive = true
        secondImage.topAnchor.constraint(equalTo: self.secondLabel.bottomAnchor, constant: 20.0).isActive = true
        secondImage.heightAnchor.constraint(equalToConstant: 442.0).isActive = true
        
        secondImage2.centerXAnchor.constraint(equalTo: self.scrollView.centerXAnchor, constant: 0.0).isActive = true
        secondImage2.widthAnchor.constraint(equalToConstant: 250.0).isActive = true
        secondImage2.topAnchor.constraint(equalTo: self.secondImage.bottomAnchor, constant: 50.0).isActive = true
        secondImage2.heightAnchor.constraint(equalToConstant: 442.0).isActive = true
        
        thirdImage.centerXAnchor.constraint(equalTo: self.scrollView.centerXAnchor, constant: 0.0).isActive = true
        thirdImage.widthAnchor.constraint(equalToConstant: 250.0).isActive = true
        thirdImage.topAnchor.constraint(equalTo: self.thirdLabel.bottomAnchor, constant: 20.0).isActive = true
        thirdImage.heightAnchor.constraint(equalToConstant: 442.0).isActive = true
        
        thirdImage2.centerXAnchor.constraint(equalTo: self.scrollView.centerXAnchor, constant: 0.0).isActive = true
        thirdImage2.widthAnchor.constraint(equalToConstant: 250.0).isActive = true
        thirdImage2.topAnchor.constraint(equalTo: self.thirdImage.bottomAnchor, constant: 50.0).isActive = true
        thirdImage2.heightAnchor.constraint(equalToConstant: 442.0).isActive = true
        thirdImage2.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor, constant: -200.0).isActive = true
        
        firstImage.layer.borderColor = UIColor.black.cgColor
        firstImage.layer.borderWidth = 1.0
        firstImage2.layer.borderColor = UIColor.black.cgColor
        firstImage2.layer.borderWidth = 1.0
        secondImage.layer.borderColor = UIColor.black.cgColor
        secondImage.layer.borderWidth = 1.0
        secondImage2.layer.borderColor = UIColor.black.cgColor
        secondImage2.layer.borderWidth = 1.0
        thirdImage.layer.borderColor = UIColor.black.cgColor
        thirdImage.layer.borderWidth = 1.0
        thirdImage2.layer.borderColor = UIColor.black.cgColor
        thirdImage2.layer.borderWidth = 1.0
        
        if imTeacher {
            firstImage.image = UIImage(named: "Guide7.PNG")
            firstImage2.image = UIImage(named: "Guide8.PNG")
            secondImage.image = UIImage(named: "Guide9.PNG")
            secondImage2.image = UIImage(named: "Guide10.PNG")
            thirdImage.image = UIImage(named: "Guide5.PNG")
            thirdImage2.image = UIImage(named: "Guide6.PNG")
        }
        else {
            firstImage.image = UIImage(named: "Guide1.PNG")
            firstImage2.image = UIImage(named: "Guide2.PNG")
            secondImage.image = UIImage(named: "Guide3.PNG")
            secondImage2.image = UIImage(named: "Guide4.PNG")
            thirdImage.image = UIImage(named: "Guide5.PNG")
            thirdImage2.image = UIImage(named: "Guide6.PNG")
        }
        
        
        firstImage.contentMode = .scaleAspectFill
        firstImage2.contentMode = .scaleAspectFill
        secondImage.contentMode = .scaleAspectFill
        secondImage2.contentMode = .scaleAspectFill
        thirdImage.contentMode = .scaleAspectFill
        
        firstImage.clipsToBounds = true
        firstImage2.clipsToBounds = true
        secondImage.clipsToBounds = true
        secondImage2.clipsToBounds = true
        thirdImage.clipsToBounds = true
        
    }
    
}
