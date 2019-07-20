

import UIKit
import Alamofire
import SwiftyJSON
//ここでは年月日と開始時刻と時間を入力させよう　ナビゲーションバーに先生名を書こう　スタジオ代も必要だ yearは入らずに勝手にこっちが判断する説はあるよね　今の日付より前かで判断 ここにお金を入れたほうがいいんだよね
class LessonCreateViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let timeList = [60,90,120,150,180]
    let hourList = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23]
    let minuteList = [00,15,30,45]
    let yearList = [2019,2020]
    let monthList = [1,2,3,4,5,6,7,8,9,10,11,12]
    
    let dayList = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31]
    
    let yearPickerView = UIPickerView()
    let monthPickerView = UIPickerView()
    let dayPickerView = UIPickerView()
    let hourPickerView = UIPickerView()
    let minutePickerView = UIPickerView()
    let timePickerView = UIPickerView()
    
    let yearTextField = UITextField()
    let monthTextField = UITextField()
    let dayTextField = UITextField()
    let hourTextField = UITextField()
    let minuteTextField = UITextField()
    let timeTextField = UITextField()
    let studioTextField = UITextField()
    
    let yearLabel = UILabel()
    let monthLabel = UILabel()
    let hourLabel = UILabel()
    let dayLabel = UILabel()
    let minuteLabel = UILabel()
    let timeLabel = UILabel()
    let studioLabel = UILabel()
    
    var teacherEmail: String!
    var teacherName: String! //from other VC
    
    
    let submitButton = UIButton()
    
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
        
        yearPickerView.tag = 1
        monthPickerView.tag = 2
        dayPickerView.tag = 3
        hourPickerView.tag = 4
        minutePickerView.tag = 5
        timePickerView.tag = 6
        
        yearPickerView.delegate = self
        monthPickerView.delegate = self
        dayPickerView.delegate = self
        hourPickerView.delegate = self
        minutePickerView.delegate = self
        timePickerView.delegate = self
        
        yearPickerView.dataSource = self
        monthPickerView.dataSource = self
        dayPickerView.dataSource = self
        hourPickerView.dataSource = self
        minutePickerView.dataSource = self
        timePickerView.dataSource = self
        
        
        
        yearPickerView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: yearPickerView.bounds.size.height)
        monthPickerView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: monthPickerView.bounds.size.height)
        dayPickerView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: dayPickerView.bounds.size.height)
        hourPickerView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: hourPickerView.bounds.size.height)
        minutePickerView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: minutePickerView.bounds.size.height)
        timePickerView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: timePickerView.bounds.size.height)
        
        
        yearTextField.inputView = yearPickerView
        monthTextField.inputView = monthPickerView
        dayTextField.inputView = dayPickerView
        hourTextField.inputView = hourPickerView
        minuteTextField.inputView = minutePickerView
        timeTextField.inputView = timePickerView
        
        studioTextField.keyboardType = .numberPad
       
        makeToolBar(textField: yearTextField)
        makeToolBar(textField: monthTextField)
        makeToolBar(textField: dayTextField)
        makeToolBar(textField: hourTextField)
        makeToolBar(textField: minuteTextField)
        makeToolBar(textField: timeTextField)
        
        self.view.addSubview(yearTextField)
        self.view.addSubview(monthTextField)
        self.view.addSubview(dayTextField)
        self.view.addSubview(hourTextField)
        self.view.addSubview(minuteTextField)
        self.view.addSubview(timeTextField)
        self.view.addSubview(studioTextField)
        self.view.addSubview(submitButton)
        self.view.addSubview(yearLabel)
        self.view.addSubview(monthLabel)
        self.view.addSubview(dayLabel)
        self.view.addSubview(hourLabel)
        self.view.addSubview(minuteLabel)
        self.view.addSubview(timeLabel)
        self.view.addSubview(studioLabel)
        
        yearLabel.text = " 年"
        monthLabel.text = " 月"
        dayLabel.text = " 日"
        hourLabel.text = " 時"
        minuteLabel.text = " 分(開始時刻）"
        timeLabel.text = " 分(レッスン時間)"
        studioLabel.text = " 円(スタジオ代を含めた総額)"
        
        self.yearTextField.translatesAutoresizingMaskIntoConstraints = false
        self.monthTextField.translatesAutoresizingMaskIntoConstraints = false
        self.dayTextField.translatesAutoresizingMaskIntoConstraints = false
        self.hourTextField.translatesAutoresizingMaskIntoConstraints = false
        self.minuteTextField.translatesAutoresizingMaskIntoConstraints = false
        self.timeTextField.translatesAutoresizingMaskIntoConstraints = false
        self.studioTextField.translatesAutoresizingMaskIntoConstraints = false
        self.submitButton.translatesAutoresizingMaskIntoConstraints = false
        self.yearLabel.translatesAutoresizingMaskIntoConstraints = false
        self.monthLabel.translatesAutoresizingMaskIntoConstraints = false
        self.dayLabel.translatesAutoresizingMaskIntoConstraints = false
        self.hourLabel.translatesAutoresizingMaskIntoConstraints = false
        self.minuteLabel.translatesAutoresizingMaskIntoConstraints = false
        self.timeLabel.translatesAutoresizingMaskIntoConstraints = false
        self.studioLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        self.yearTextField.backgroundColor = commonBackgroundColor
        self.monthTextField.backgroundColor = commonBackgroundColor
        self.dayTextField.backgroundColor = commonBackgroundColor
        self.hourTextField.backgroundColor = commonBackgroundColor
        self.minuteTextField.backgroundColor = commonBackgroundColor
        self.timeTextField.backgroundColor = commonBackgroundColor
        self.studioTextField.backgroundColor = commonBackgroundColor
        
        self.submitButton.setTitle("レッスンをリクエストする", for: .normal)
        self.submitButton.setTitleColor(UIColor.white, for: .normal)
        self.submitButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 22.0)
        self.submitButton.backgroundColor = orangeColor
        self.submitButton.layer.masksToBounds = true
        self.submitButton.layer.cornerRadius = 25.0
        self.submitButton.addTarget(self, action: #selector(submit), for: .touchUpInside)
        
        self.yearTextField.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 80.0).isActive = true
        self.yearTextField.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20.0).isActive = true
        self.yearTextField.rightAnchor.constraint(equalTo: self.view.centerXAnchor, constant: -50.0).isActive = true
        self.yearTextField.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
        
        self.monthTextField.topAnchor.constraint(equalTo: self.yearTextField.bottomAnchor, constant: 20.0).isActive = true
        self.monthTextField.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20.0).isActive = true
        self.monthTextField.rightAnchor.constraint(equalTo: self.view.centerXAnchor, constant: -50.0).isActive = true
        self.monthTextField.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
        
        
        self.dayTextField.topAnchor.constraint(equalTo: self.yearTextField.bottomAnchor, constant: 20.0).isActive = true
        self.dayTextField.leftAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0.0).isActive = true
        self.dayTextField.widthAnchor.constraint(equalToConstant: 80.0).isActive = true
        self.dayTextField.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
        
        
        
        self.hourTextField.topAnchor.constraint(equalTo: self.monthTextField.bottomAnchor, constant: 20.0).isActive = true
        self.hourTextField.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20.0).isActive = true
        self.hourTextField.rightAnchor.constraint(equalTo: self.view.centerXAnchor, constant: -50.0).isActive = true
        self.hourTextField.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
        
        
        self.minuteTextField.topAnchor.constraint(equalTo: self.monthTextField.bottomAnchor, constant: 20.0).isActive = true
        self.minuteTextField.leftAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0.0).isActive = true
        self.minuteTextField.widthAnchor.constraint(equalToConstant: 80.0).isActive = true
        self.minuteTextField.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
        
        self.timeTextField.topAnchor.constraint(equalTo: self.minuteTextField.bottomAnchor, constant: 20.0).isActive = true
        self.timeTextField.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20.0).isActive = true
        self.timeTextField.rightAnchor.constraint(equalTo: self.view.centerXAnchor, constant: -50.0).isActive = true
        self.timeTextField.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
    
        self.studioTextField.topAnchor.constraint(equalTo: self.timeTextField.bottomAnchor, constant: 20.0).isActive = true
        self.studioTextField.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20.0).isActive = true
        self.studioTextField.rightAnchor.constraint(equalTo: self.view.centerXAnchor, constant: -50.0).isActive = true
        self.studioTextField.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
        
        self.submitButton.topAnchor.constraint(equalTo: self.studioTextField.bottomAnchor, constant: 50.0).isActive = true
        self.submitButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20.0).isActive = true
        self.submitButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20.0).isActive = true
        self.submitButton.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        
        self.yearLabel.topAnchor.constraint(equalTo: self.yearTextField.topAnchor).isActive = true
        self.yearLabel.leftAnchor.constraint(equalTo: self.yearTextField.rightAnchor).isActive = true
       self.yearLabel.widthAnchor.constraint(equalToConstant: 30.0).isActive = true
        self.yearLabel.heightAnchor.constraint(equalTo: self.yearTextField.heightAnchor).isActive = true
        
        self.monthLabel.topAnchor.constraint(equalTo: self.monthTextField.topAnchor).isActive = true
        self.monthLabel.leftAnchor.constraint(equalTo: self.yearTextField.rightAnchor).isActive = true
        self.monthLabel.widthAnchor.constraint(equalToConstant: 30.0).isActive = true
        self.monthLabel.heightAnchor.constraint(equalTo: self.yearTextField.heightAnchor).isActive = true
        
        self.dayLabel.topAnchor.constraint(equalTo: self.dayTextField.topAnchor).isActive = true
        self.dayLabel.leftAnchor.constraint(equalTo: self.dayTextField.rightAnchor).isActive = true
        self.dayLabel.widthAnchor.constraint(equalToConstant: 30.0).isActive = true
        self.dayLabel.heightAnchor.constraint(equalTo: self.yearTextField.heightAnchor).isActive = true
        
        self.hourLabel.topAnchor.constraint(equalTo: self.hourTextField.topAnchor).isActive = true
        self.hourLabel.leftAnchor.constraint(equalTo: self.hourTextField.rightAnchor).isActive = true
        self.hourLabel.widthAnchor.constraint(equalToConstant: 30.0).isActive = true
        self.hourLabel.heightAnchor.constraint(equalTo: self.yearTextField.heightAnchor).isActive = true
        
        self.minuteLabel.topAnchor.constraint(equalTo: self.minuteTextField.topAnchor).isActive = true
        self.minuteLabel.leftAnchor.constraint(equalTo: self.minuteTextField.rightAnchor).isActive = true
        self.minuteLabel.widthAnchor.constraint(equalToConstant: 150.0).isActive = true
        self.minuteLabel.heightAnchor.constraint(equalTo: self.yearTextField.heightAnchor).isActive = true
        
        self.timeLabel.topAnchor.constraint(equalTo: self.timeTextField.topAnchor).isActive = true
        self.timeLabel.leftAnchor.constraint(equalTo: self.timeTextField.rightAnchor).isActive = true
        self.timeLabel.widthAnchor.constraint(equalToConstant: 150.0).isActive = true
        self.timeLabel.heightAnchor.constraint(equalTo: self.yearTextField.heightAnchor).isActive = true
        
        self.studioLabel.topAnchor.constraint(equalTo: self.studioTextField.topAnchor).isActive = true
        self.studioLabel.leftAnchor.constraint(equalTo: self.studioTextField.rightAnchor).isActive = true
        self.studioLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30.0).isActive = true
        self.studioLabel.heightAnchor.constraint(equalTo: self.yearTextField.heightAnchor).isActive = true
        
        self.navigationItem.title = self.teacherName
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1 {
            return yearList.count
        }
        if pickerView.tag == 2 {
            return monthList.count
        }
        if pickerView.tag == 3 {
            return dayList.count
        }
        if pickerView.tag == 4 {
            return hourList.count
        }
        if pickerView.tag == 5 {
            return minuteList.count
        }
        if pickerView.tag == 6 {
            return timeList.count
        }
        else{ return 0}
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 {
            yearTextField.text = String(yearList[row])
        }
        if pickerView.tag == 2 {
            monthTextField.text = String(monthList[row])
        }
        if pickerView.tag == 3 {
            dayTextField.text = String(dayList[row])
        }
        if pickerView.tag == 4 {
            hourTextField.text = String(hourList[row])
        }
        if pickerView.tag == 5 {
            minuteTextField.text = String(minuteList[row])
        }
        if pickerView.tag == 6 {
            timeTextField.text = String(timeList[row])
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1 {
            return String(yearList[row])
        }
        if pickerView.tag == 2 {
            return  String(monthList[row])
        }
        if pickerView.tag == 3 {
            return String(dayList[row])
        }
        if pickerView.tag == 4 {
            return String(hourList[row])
        }
        if pickerView.tag == 5 {
            return String(minuteList[row])
        }
        else {
            return String(timeList[row])
        }
    }
    
    func makeToolBar(textField: UITextField) {
        let bar = UIToolbar()
        bar.barStyle = .default
        bar.isTranslucent = true
        bar.tintColor = UIColor.black
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(done))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        bar.setItems([doneButton, spaceButton], animated: false)
        bar.isUserInteractionEnabled = true
        bar.sizeToFit()
        textField.inputAccessoryView = bar
    }
    
    @objc func done() {
        self.view.endEditing(true)
    }
    
    @objc func submit() {
        print ("予約")
        if let year = yearTextField.text, year.count > 0, let month = monthTextField.text, month.count > 0,let day = dayTextField.text, day.count > 0, let hour = hourTextField.text, hour.count > 0,let minute = minuteTextField.text,minute.count > 0, let time = timeTextField.text, time.count > 0 , let studio = studioTextField.text, studio.count > 0 {
            
            if !dateCheck(year: year, month: month, date: day) {
                 makeAlert(message: "日付が正しくありません")
                return
            }
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd-HH-mm"
            
            // NSDateFormatterを使って日時文字列 "dateStr" をNSDate型 "date" に変換
            let dateStr: String = "\(year)-\(month.addZero())-\(day.addZero())-\(hour.addZero())-\(minute.addZero())"
            let date: Date? = formatter.date(from: dateStr)
            
            // NSDate型 "date" をUNIX時間 "dateUnix" に変換
            let dateUnix: TimeInterval? = date?.timeIntervalSince1970
            
            let unixtime = Int(dateUnix!)
            
            let nowUnix = Int(NSDate().timeIntervalSince1970)
            
            if unixtime - nowUnix <= 60*60*24*3 {
                makeAlert(message: "予約日時は72時間後以降となります")
                return
            }
            
            print (unixtime)
            uploadData(timeStamp: unixtime)
            
        }
        else {
            makeAlert(message: "全ての項目を入力してください")
        }
        

    }
    
    
    fileprivate func uploadData(timeStamp: Int) {
        
        let endURL = awsURL + "/lesson"
        
        //moneyはいらない説がでかくなってきたが　うーん　いやいる
        let parameters:[String: Any] = ["teacherEmail": teacherEmail, "studentEmail": uds.object(forKey: "studentId"), "timeStamp": timeStamp,"hour": timeTextField.text, "allMoney": studioTextField.text, "teacherName": self.teacherName,
                                        "studentName": uds.object(forKey: "name")
                                        ]
        self.submitButton.isEnabled = false
        setIndicator2()
        Alamofire.request(endURL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            self.removeIndicator2()
            self.submitButton.isEnabled = true
            print (response)
            if (response.error != nil) {
                
                self.makeAlert(message: "エラーが発生しました")
                return
            }
            guard let object = response.result.value else {
               self.makeAlert(message: "エラーが発生しました")
                return
            }
            
            let json = JSON(object)
            
            if let message = json["errorMessage"].string {
               
                self.makeAlert(message: "エラーが発生しました")
                return
            }
            
            self.navigationController?.popViewController(animated: true)
            self.makeGoodAlert(message: "レッスンのリクエストが完了しました")
            self.submitButton.isEnabled = false
            
        }
    }
    
    
    
}
