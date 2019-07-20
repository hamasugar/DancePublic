
import Foundation
import UIKit

class RuleView: UIView {
    
    let scrollView = UIScrollView()
    let label = UILabel()
    
    required override init(frame:CGRect){
        super.init(frame:frame)
        backgroundColor = .white
        addSubview(scrollView)
        scrollView.addSubview(label)
        //これならaddSubViewが一番最初だからheightAnchorとかできないかな　viewを引数にできないのが辛いな
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()// これはいるのだろうか　理由はわからんけどいります
        scrollView.frame = frame
        scrollView.contentSize.width = frame.width
        scrollView.bounces = false
        scrollView.indicatorStyle = .default
        scrollView.scrollIndicatorInsets = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        scrollView.backgroundColor = UIColor.white
        
        label.font = UIFont.systemFont(ofSize: 15.0)
        label.backgroundColor = UIColor.white
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.firstBaselineAnchor.constraint(equalTo: self.topAnchor, constant: 30.0).isActive = true
        label.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10.0).isActive = true
        label.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10.0).isActive = true
    }
    //順番が保証されないから説もある
    
    func setText(text: String) {
        label.text = text
        label.sizeToFit()
        label.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -200.0).isActive = true
    }
    
    
}
