import Foundation
import UIKit

class StudioMoneyView: UIView {
    
    let topLabel = UILabel()
    let form = UITextView()
    let textField = UITextField()
    let submitButton = myButton(frame: CGRect())
    let alertLabel = UILabel()
    
    required override init(frame:CGRect){
        super.init(frame:frame)
        backgroundColor = .white
        addSubview(topLabel)
        addSubview(form)
        addSubview(textField)
        addSubview(submitButton)
        addSubview(alertLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        self.topLabel.text = "スタジオ代請求のコメント"
        self.alertLabel.text = "注意：この請求は生徒側がレッスンをキャンセルし、スタジオ代にキャンセル料がかかる場合のみ利用できます。"
        self.topLabel.textColor = orangeColor
        self.textField.borderStyle = .roundedRect
        self.textField.keyboardType = .numberPad
        self.form.layer.borderColor = UIColor.black.cgColor
        self.form.layer.borderWidth = 1.0
        self.form.layer.masksToBounds = true
        self.form.layer.cornerRadius = 10.0
        
        self.submitButton.setTitle("請求する", for: .normal)
        self.submitButton.backgroundColor = pulpleColor
        
        self.topLabel.translatesAutoresizingMaskIntoConstraints = false
        self.form.translatesAutoresizingMaskIntoConstraints = false
        self.textField.translatesAutoresizingMaskIntoConstraints = false
        self.alertLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.textField.topAnchor.constraint(equalTo: self.topAnchor, constant: 50.0).isActive = true
        self.textField.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 50.0).isActive = true
        self.textField.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -50.0).isActive = true
        self.textField.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        self.textField.placeholder = "スタジオのキャンセル料(円)"
        
        self.topLabel.topAnchor.constraint(equalTo: self.textField.bottomAnchor, constant: 30.0).isActive = true
        self.topLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 50.0).isActive = true
        self.topLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -50.0).isActive = true
        self.topLabel.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        
        self.form.topAnchor.constraint(equalTo: self.topLabel.bottomAnchor, constant: 0.0).isActive = true
        self.form.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 50.0).isActive = true
        self.form.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -50.0).isActive = true
        self.form.heightAnchor.constraint(equalToConstant: 150.0).isActive = true
        
        self.submitButton.topAnchor.constraint(equalTo: self.form.bottomAnchor, constant: 50.0).isActive = true
        self.submitButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 50.0).isActive = true
        self.submitButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -50.0).isActive = true
        self.submitButton.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        
        self.alertLabel.topAnchor.constraint(equalTo: self.submitButton.bottomAnchor, constant: 10.0).isActive = true
        self.alertLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20.0).isActive = true
        self.alertLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20.0).isActive = true
        self.alertLabel.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        self.alertLabel.font = UIFont.systemFont(ofSize: 13.0)
        self.alertLabel.numberOfLines = 0
    }
    
    
}
