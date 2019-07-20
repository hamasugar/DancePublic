import Foundation
import UIKit
import Cosmos

class TeacherDetailModel: NSObject, UITableViewDataSource {
    
    var cellTitleArray = [String]()
    var cellDetailArray = [String]()
    var teacher: Teacher!
    
    init(teacher: Teacher) {
        super.init()
        cellTitleArray = ["ニックネーム","年齢","国籍","地域","得意ジャンル","レッスン料金（60分）","評価"]
        cellDetailArray = [teacher.name!, teacher.age!, teacher.country!, teacher.live!, teacher.able!, teacher.money!]
        self.teacher = teacher
    }
    
    func makeText() -> String {
        var text = "【自動送信】レッスン希望のお知らせ　講師の方は返信をお願いします。\nプロフィール"
        text += "\n 年齢: \(uds.object(forKey: "age") as! String)"
        text += "\n 地域: \(uds.object(forKey: "live") as! String)"
        text += "\n 自己紹介: \(uds.object(forKey: "comment") as! String)"
        return text
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print (cellTitleArray.count)
        print (cellTitleArray)
        return cellTitleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //ここはカスタムセルにした方がいいのかもしれない
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "table")
        cell.selectionStyle = .none
        if indexPath.row == 6 {
            cell.textLabel!.text = self.cellTitleArray[indexPath.row]

            if teacher.lessonCount == 0 {
                cell.detailTextLabel?.textColor = UIColor.black
                cell.detailTextLabel!.text = "まだ評価はありません"
            }
            else if let lessonCount = teacher.lessonCount {
                let star = Double(teacher.evaluate) / Double(lessonCount)
                let cosmosView = CosmosView()
                cosmosView.frame.size.height = 40.0
                cosmosView.settings.filledColor = UIColor.orange
                cosmosView.settings.fillMode = .precise
                cosmosView.rating = star
                cosmosView.settings.updateOnTouch = false
                cosmosView.settings.starSize = 30.0
                cosmosView.settings.totalStars = 5
                cell.addSubview(cosmosView)
                cosmosView.translatesAutoresizingMaskIntoConstraints = false
                cosmosView.centerYAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true
                cosmosView.widthAnchor.constraint(equalToConstant: 200.0).isActive = true

                let countLabel = UILabel()
                countLabel.text = "(\(lessonCount)件)"
                countLabel.font = UIFont.systemFont(ofSize: 17.0)
                cell.addSubview(countLabel)
                countLabel.translatesAutoresizingMaskIntoConstraints = false
                countLabel.centerYAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true
                countLabel.rightAnchor.constraint(equalTo: cell.rightAnchor, constant: -10.0).isActive = true
                countLabel.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
                countLabel.leftAnchor.constraint(equalTo: cosmosView.rightAnchor, constant: -20.0).isActive = true
            }
        }
        
        else {
            cell.textLabel!.text = self.cellTitleArray[indexPath.row]
            cell.detailTextLabel?.textColor = UIColor.black
            cell.detailTextLabel!.text = self.cellDetailArray[indexPath.row]
        }
        
        return cell
    }
    
}
