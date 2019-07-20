import UIKit
import SwiftyJSON
//ここでは年月日と開始時刻と時間を入力させよう　　に勝手にこっちが判断する説はあるよね　今の日付より前かで判断
class LessonCreate2ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let timeList = ["60分間","90分間","120分間","150分間","180分間"]
    let startTimeList = ["午前0:00〜","午前0:30〜","午前1:00〜","午前1:30〜","午前2:00〜","午前2:30〜","午前3:00〜","午前3:30〜","午前4:00〜","午前4:30〜","午前5:00〜","午前5:30〜","午前6:00〜","午前6:30〜","午前7:00〜","午前7:30〜","午前8:30〜","午前9:00〜","午前9:30〜","午前10:00〜","午前10:30〜","午前11:00〜","午前11:30〜","午後0:00〜","午後0:30〜","午後1:00〜","午後1:30〜","午後2:00〜","午後2:30〜","午後3:00〜","午後3:30〜","午後4:00〜","午後4:30〜","午後5:00〜","午後5:30〜","午後6:00〜","午後6:30〜","午後7:00〜","午後7:30〜","午後8:30〜","午後9:00〜","午後9:30〜","午後10:00〜","午後10:30〜","午後11:00〜","午後11:30〜"]
    
    var dateList = [String]()
    
    lazy var pickerList = [dateList, startTimeList, timeList]
    
    let pickerView = UIPickerView()
    let resultLabel = UILabel()
    let submitButton = myButton(frame: CGRect())
    let moneyTextField = UITextField()
    let nowMonth = getMonth()
    
    var teacherEmail: String!
    var teacherName: String! //from other VC
    
    var year = String(getYear())
    var month = String(getMonth())
    var day = "1"
    var hour = "18"
    var minute = "00"
    var time = "60"
    var totalMoney: Int!
    
    
    init(name: String, email: String) {
        self.teacherEmail = email
        self.teacherName = name
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.edgesForExtendedLayout = []
        self.navigationController?.navigationBar.isTranslucent = false
        setSwipeBack()
        makeDateList()
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        self.view.addSubview(resultLabel)
        self.view.addSubview(submitButton)
        self.view.addSubview(pickerView)
        self.view.addSubview(moneyTextField)
        
        self.resultLabel.text = "5/1 18:00〜  60分間"
        self.resultLabel.backgroundColor = commonBackgroundColor
        self.moneyTextField.backgroundColor = commonBackgroundColor
        self.moneyTextField.placeholder = "スタジオ代込みの総額(円)"
        self.moneyTextField.keyboardType = .numberPad
        
        self.resultLabel.translatesAutoresizingMaskIntoConstraints = false
        self.pickerView.translatesAutoresizingMaskIntoConstraints = false
        self.moneyTextField.translatesAutoresizingMaskIntoConstraints = false
        
        self.submitButton.setTitle("レッスンをリクエストする", for: .normal)
        self.submitButton.addTarget(self, action: #selector(submit), for: .touchUpInside)
        
        
        self.resultLabel.bottomAnchor.constraint(equalTo: self.moneyTextField.topAnchor, constant: -50.0).isActive = true
        self.resultLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20.0).isActive = true
        self.resultLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20.0).isActive = true
        self.resultLabel.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        
        self.moneyTextField.bottomAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -50.0).isActive = true
        self.moneyTextField.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20.0).isActive = true
        self.moneyTextField.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20.0).isActive = true
        self.moneyTextField.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        
        self.submitButton.topAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0.0).isActive = true
        self.submitButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20.0).isActive = true
        self.submitButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20.0).isActive = true
        self.submitButton.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        
        pickerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0.0).isActive = true
        pickerView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0.0).isActive = true
        pickerView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0.0).isActive = true
        pickerView.topAnchor.constraint(equalTo: self.submitButton.bottomAnchor, constant: 30.0).isActive = true
        pickerView.backgroundColor = commonBackgroundColor
        
        self.navigationItem.title = self.teacherName
        
    }

    func makeDateList() {
        //現在の日付から半年分を表示させる作戦でいく
        for i in getMonth()...getMonth() + 8 {
            
            for j in 1...31 {
                
                    if j == 31 {
                        if (i-1)%12+1 == 2 || (i-1)%12+1 == 4 || (i-1)%12+1 == 6 || (i-1)%12+1 == 9 || (i-1)%12+1 == 11 {
                            continue
                        }
                    }
                    if j == 30 {
                        if (i-1)%12+1 == 2 {
                            continue
                        }
                    }
                
                    dateList.append("\((i-1)%12+1)/\(j)")
            }

        }
        
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return pickerList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerList[component].count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let data1 = self.pickerView(pickerView, titleForRow: pickerView.selectedRow(inComponent: 0), forComponent: 0)
        let data2 = self.pickerView(pickerView, titleForRow: pickerView.selectedRow(inComponent: 1), forComponent: 1)
        let data3 = self.pickerView(pickerView, titleForRow: pickerView.selectedRow(inComponent: 2), forComponent: 2)
        
        self.month = data1!.takeMonthDate()[0]
        self.day = data1!.takeMonthDate()[1]
        self.hour = data2!.takeHourMinute()[0]
        self.minute = data2!.takeHourMinute()[1]
        self.time = data3!.takeTime()
        
        if Int(self.month)! < getMonth() {
            self.year = String(getYear() + 1)
        }
        
        resultLabel.text = "\(data1!)　\(data2!)　 \(data3!)"
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerList[component][row]
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 20))
        label.textAlignment = .center
        label.text = pickerList[component][row]
        label.font = UIFont.systemFont(ofSize: 18.0)
        return label
    }

   
    @objc func submit() {
        if uds.object(forKey: "credit") == nil {
            makeNoTitleAlert(message: "マイページよりクレジットカードを登録してください")
            return
        }
        
        if let money = moneyTextField.text, money.count > 0 {
            
            if Int(money)! > 10000 || Int(money)! < 500 {
                makeAlert(message: "金額は500円以上1万円以下に設定してください。")
                return
            }

            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd-HH-mm"
            formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale  // コレがないとバグることがある

            let dateStr: String = "\(year)-\(month.addZero())-\(day.addZero())-\(hour.addZero())-\(minute.addZero())"
            let date: Date? = formatter.date(from: dateStr)
            
            // NSDate型 "date" をUNIX時間 "dateUnix" に変換
            let dateUnix: TimeInterval? = date?.timeIntervalSince1970
            //2/29はここがnilになるのだよ
            let unixtime = Int(dateUnix!)
            let nowUnix = Int(NSDate().timeIntervalSince1970)
            if unixtime - nowUnix <= 60*60*24*3 {
                makeAlert(message: "予約日時は72時間後以降となります")
                return
            }
            
            uploadData(timeStamp: unixtime)

        }
        else {
            makeAlert(message: "金額を入力してください")
        }
        
    }
    
    
    fileprivate func uploadData(timeStamp: Int) {

        let endURL = awsURL + "/lesson"
        let parameters:[String: Any] = ["teacherEmail": teacherEmail, "studentEmail": uds.object(forKey: "studentId"), "timeStamp": timeStamp,"hour": self.time, "allMoney": moneyTextField.text, "teacherName": self.teacherName,
                                        "studentName": uds.object(forKey: "name")
        ]
        self.submitButton.isEnabled = false
        let apimanager = APIManager(url: endURL, method: .post, parameters: parameters, view: self)
        apimanager.request(fail: { () in
            self.submitButton.isEnabled = true
            self.makeAlert(message: "エラーが発生しました")
            return
        }, success: { (json: JSON) in
            self.submitButton.isEnabled = true
            self.makeGoodAlert(message: "レッスンのリクエストが完了しました")
            //ダブルでの予約を防ぐ
            self.submitButton.isEnabled = false
        })
        
    }
    
}

