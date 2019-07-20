import UIKit
import SwiftyJSON
import AWSS3
import AWSCore
// ここの画面に来る前にトーク画面かなんかの方でalamofireを済ませておく必要がある
class StudentDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let scrollView = UIScrollView()
    let imageView = UIImageView()
    let topLabel = UILabel()
    let commentLabel = UILabel()
    let infoTableView = UITableView()
    let claimButton = myButton(frame: CGRect())
    var student = Student()
    let tempPath = NSTemporaryDirectory()
    var cellTitleArray = [String]()
    var cellDetailArray = [String]()
    
    init(student: Student) {
        self.student = student
        super.init(nibName: nil, bundle: nil)
        //ここでalamofireをやったほうがいいかもしれない説が出てきた　
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSwipeBack()
        cellTitleArray = ["表示名","年齢","地域"]
        cellDetailArray = [student.name!, student.age!, student.live!]
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "違反報告", style: .done, target: self, action: #selector(report))
        self.makeScrollView()
        self.makeView()
        self.navigationItem.title = student.name!
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        self.downLoadImage(path: student.email!, imageView: self.imageView, tempPath: self.tempPath)
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellTitleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "table")
        cell.selectionStyle = .none
        cell.textLabel!.text = self.cellTitleArray[indexPath.row]
        cell.detailTextLabel?.textColor = UIColor.black
        cell.detailTextLabel!.text = self.cellDetailArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40.0
    }
    
    func makeScrollView() {
        scrollView.backgroundColor = UIColor.white
        scrollView.frame.size = CGSize(width: view.frame.width, height: view.frame.height)
        scrollView.center = self.view.center
        scrollView.contentSize = CGSize(width: view.frame.width, height: self.view.frame.size.height + 100)
        scrollView.bounces = false
        scrollView.indicatorStyle = .default
        scrollView.scrollIndicatorInsets = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        scrollView.delegate = self
        self.view.addSubview(scrollView)
    }
    
    func makeView() {
        self.scrollView.addSubview(imageView)
        //テザリングするとここになぜか黒い隙間ができることがある
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        self.imageView.topAnchor.constraint(equalTo: self.scrollView.topAnchor, constant: 0).isActive = true
        self.imageView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        self.imageView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        self.imageView.heightAnchor.constraint(equalTo: self.imageView.widthAnchor).isActive = true
        
        self.scrollView.addSubview(topLabel)
        self.topLabel.translatesAutoresizingMaskIntoConstraints = false
        self.topLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 15).isActive = true
        self.topLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.topLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.topLabel.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        self.topLabel.font = UIFont.boldSystemFont(ofSize: 22.0)
        self.topLabel.text = self.student.name
        
        self.scrollView.addSubview(commentLabel)
        commentLabel.text = student.comment!
        self.commentLabel.translatesAutoresizingMaskIntoConstraints = false
        self.commentLabel.topAnchor.constraint(equalTo: topLabel.bottomAnchor, constant: 15).isActive = true
        self.commentLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.commentLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.commentLabel.sizeToFit()
        self.commentLabel.font = UIFont.systemFont(ofSize: 17.0)
        self.commentLabel.numberOfLines = 0
        
        
        self.scrollView.addSubview(infoTableView)
        self.infoTableView.translatesAutoresizingMaskIntoConstraints = false
        self.infoTableView.topAnchor.constraint(equalTo: commentLabel.bottomAnchor, constant: 20.0).isActive = true
        self.infoTableView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        self.infoTableView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        self.infoTableView.heightAnchor.constraint(equalToConstant: 130.0).isActive = true
        self.infoTableView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor, constant: -200.0).isActive = true
        //制約を5個にしたら可変になってうまくいった　オートレイアウト凄えな
        self.infoTableView.delegate = self
        self.infoTableView.dataSource = self
        self.infoTableView.register(UITableViewCell.self, forCellReuseIdentifier: "table")
        
        self.claimButton.setTitle("スタジオ代を請求", for: .normal)
        self.view.addSubview(claimButton)
        self.claimButton.backgroundColor = .red
        self.claimButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 50.0).isActive = true
        self.claimButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -50.0).isActive = true
        self.claimButton.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        self.claimButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -20.0).isActive = true
        self.claimButton.addTarget(self, action: #selector(claim), for: .touchUpInside)
    }
    
    @objc func claim() {
        let vc = StudioMoneyViewController(studentEmail: self.student.email!)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func report() {
        
        let alert = UIAlertController(title: nil, message: "違反報告しますか？このユーザーはブロックされます。", preferredStyle: .alert)
        let action1 = UIAlertAction(title: "報告する", style: .default, handler: {
            (action: UIAlertAction!) in
            self.sendReport(value: "【違反報告】" + self.student.email, vc: self)
        })
        alert.addAction(action1)
        alert.addAction(UIAlertAction(title: "戻る", style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    
}


