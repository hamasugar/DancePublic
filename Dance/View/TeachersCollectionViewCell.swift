
import UIKit

class TeachersCollectionViewCell: UICollectionViewCell {
    let image = UIImageView()
    let topLabel = UILabel()
    let bottomLabel = UILabel()
    var imageURL = String()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        image.image = UIImage(named: "no_image.jpg")
        //メモリ効率の向上を測る　これなら前の画像が残らないかもしれないね　再利用ならaddしても下のものは残るからか
        for subview in self.contentView.subviews{
            subview.removeFromSuperview()
        }
        self.contentView.addSubview(bottomLabel)
        self.contentView.addSubview(topLabel)
        self.contentView.addSubview(image)
        
        image.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        image.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        image.heightAnchor.constraint(equalTo: self.image.widthAnchor).isActive = true
        image.topAnchor.constraint(equalTo: self.topAnchor, constant: 0.0).isActive = true
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true

        topLabel.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 10.0).isActive = true
        topLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10.0).isActive = true
        topLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10.0).isActive = true
        topLabel.heightAnchor.constraint(equalToConstant: 20.0)
        
        bottomLabel.topAnchor.constraint(equalTo: topLabel.bottomAnchor, constant: 10.0).isActive = true
        bottomLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10.0).isActive = true
        bottomLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10.0).isActive = true
        bottomLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10.0).isActive = true
        bottomLabel.adjustsFontSizeToFitWidth = true
        bottomLabel.minimumScaleFactor = 0.7
        topLabel.adjustsFontSizeToFitWidth = true
        topLabel.minimumScaleFactor = 0.7
        
        bottomLabel.translatesAutoresizingMaskIntoConstraints = false
        topLabel.translatesAutoresizingMaskIntoConstraints = false
        image.translatesAutoresizingMaskIntoConstraints = false
    }
    
}

