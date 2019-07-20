
import Foundation
import UIKit

class SelectView: UIView {
    
    let leftButton = UIButton()
    let rightButton = UIButton()
    let danceText = UILabel()
    
    required override init(frame:CGRect){
        super.init(frame:frame)
        backgroundColor = .white
        addSubview(leftButton)
        addSubview(rightButton)
        addSubview(danceText)
        danceText.text = "ダンスを"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()// これは
        
        leftButton.translatesAutoresizingMaskIntoConstraints = false
        leftButton.setTitle("学ぶ", for: .normal)
        leftButton.setTitleColor(.red, for: .normal)
        leftButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 22.0)
        leftButton.backgroundColor = UIColor.white
        leftButton.layer.masksToBounds = true
        leftButton.layer.cornerRadius = 5.0
        leftButton.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0.0).isActive = true
        leftButton.heightAnchor.constraint(equalToConstant: 100.0).isActive = true
        leftButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 30.0).isActive = true
        leftButton.rightAnchor.constraint(equalTo: self.centerXAnchor, constant: -30.0).isActive = true
        leftButton.layer.borderColor = UIColor.red.cgColor
        leftButton.layer.borderWidth = 1.0
        leftButton.accessibilityIdentifier = "learn"
        
        rightButton.translatesAutoresizingMaskIntoConstraints = false
        rightButton.setTitle("教える", for: .normal)
        rightButton.setTitleColor(.blue, for: .normal)
        rightButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 22.0)
        rightButton.backgroundColor = UIColor.white
        rightButton.layer.masksToBounds = true
        rightButton.layer.cornerRadius = 5.0
        rightButton.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0.0).isActive = true
        rightButton.heightAnchor.constraint(equalToConstant: 100.0).isActive = true
        rightButton.leftAnchor.constraint(equalTo: self.centerXAnchor, constant: 30.0).isActive = true
        rightButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -30.0).isActive = true
        rightButton.layer.borderColor = UIColor.blue.cgColor
        rightButton.layer.borderWidth = 1.0
        rightButton.accessibilityIdentifier = "teach"
        
        danceText.translatesAutoresizingMaskIntoConstraints = false
        danceText.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20.0).isActive = true
        danceText.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20.0).isActive = true
        danceText.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        danceText.bottomAnchor.constraint(equalTo: self.centerYAnchor, constant: -100.0).isActive = true
        danceText.font = UIFont.boldSystemFont(ofSize: 27.0)
        danceText.textAlignment = .center
        
    }
    
}
