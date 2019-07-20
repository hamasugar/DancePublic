
import Foundation
import UIKit

class QuestionView: UIView {
    
    let topLabel = UILabel()
    let form = UITextView()
    let submitButton = myButton(frame: CGRect())
    
    required override init(frame:CGRect){
        super.init(frame:frame)
        backgroundColor = .white
        addSubview(topLabel)
        addSubview(form)
        addSubview(submitButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        //ここでイニシャライザ化すればaddSubViewの後にあれ　順番がわからない
        super.layoutSubviews()// これはいるのだろうか　理由はわからんけどいります
        self.topLabel.text = "お問い合わせ・要望の内容"
        self.topLabel.textColor = orangeColor
        self.form.layer.borderColor = UIColor.black.cgColor
        self.form.layer.borderWidth = 1.0
        self.form.layer.masksToBounds = true
        self.form.layer.cornerRadius = 10.0
        self.submitButton.setTitle("送信", for: .normal)
        
        self.topLabel.translatesAutoresizingMaskIntoConstraints = false
        self.form.translatesAutoresizingMaskIntoConstraints = false
        
        self.topLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 100.0).isActive = true
        self.topLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 50.0).isActive = true
        self.topLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -50.0).isActive = true
        self.topLabel.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        
        self.form.topAnchor.constraint(equalTo: self.topLabel.bottomAnchor, constant: 0.0).isActive = true
        self.form.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 50.0).isActive = true
        self.form.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -50.0).isActive = true
        self.form.heightAnchor.constraint(equalToConstant: 200.0).isActive = true
        
        self.submitButton.topAnchor.constraint(equalTo: self.form.bottomAnchor, constant: 50.0).isActive = true
        self.submitButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 50.0).isActive = true
        self.submitButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -50.0).isActive = true
        self.submitButton.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        
    }
    

}
