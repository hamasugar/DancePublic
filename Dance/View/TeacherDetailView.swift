import Foundation
import UIKit

class TeacherDetailView: UIView {
    
    let scrollView = UIScrollView()
    let imageView = UIImageView()
    let topLabel = UILabel()
    let commentLabel = UILabel()
    let infoTableView = UITableView()
    
    
    required override init(frame: CGRect){
        
        super.init(frame:frame)
        backgroundColor = .white
        addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(topLabel)
        scrollView.addSubview(commentLabel)
        scrollView.addSubview(infoTableView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        scrollView.backgroundColor = UIColor.white
        scrollView.frame = frame
        scrollView.contentSize.width = frame.width
        scrollView.bounces = false
        scrollView.indicatorStyle = .default
        scrollView.scrollIndicatorInsets = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: self.scrollView.topAnchor, constant: 0).isActive = true
        imageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        imageView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
        imageView.heightAnchor.constraint(equalTo: self.imageView.widthAnchor).isActive = true
        
        topLabel.translatesAutoresizingMaskIntoConstraints = false
        topLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 15).isActive = true
        topLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 30).isActive = true
        topLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -30).isActive = true
        topLabel.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        topLabel.font = UIFont.boldSystemFont(ofSize: 22.0)
        
        commentLabel.translatesAutoresizingMaskIntoConstraints = false
        commentLabel.topAnchor.constraint(equalTo: topLabel.bottomAnchor, constant: 15).isActive = true
        commentLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 30).isActive = true
        commentLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -30).isActive = true
        commentLabel.sizeToFit()
        commentLabel.font = UIFont.systemFont(ofSize: 17.0)
        commentLabel.numberOfLines = 0
        
        infoTableView.translatesAutoresizingMaskIntoConstraints = false
        infoTableView.topAnchor.constraint(equalTo: commentLabel.bottomAnchor, constant: 20.0).isActive = true
        infoTableView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        infoTableView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
        infoTableView.heightAnchor.constraint(equalToConstant: 300.0).isActive = true
        infoTableView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -200.0).isActive = true
        
        
    }
    
}
