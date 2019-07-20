
struct Teacher {
    
    var name: String!
    var email: String!
    var money: String!
    var live: String!
    var able: String!
    var age: String!
    var country: String!
    var comment: String!
    var evaluate: Int!
    var lessonCount: Int!
    
    init() {
        self.name = "ゲスト講師"
        self.money = "金額未設定"
        self.live = "地域未設定"
        self.able = ""
        self.email = ""
        self.age = "年齢未設定"
        self.country = "国籍未設定"
        self.comment = "自己紹介コメントがありません"
        self.evaluate = 0
        self.lessonCount = 0
        
    }
    
    func setUserDefaults(id: String) {
        uds.set(id, forKey: "myId")
        uds.set(id, forKey: "teacherId")
        uds.set("ゲスト", forKey: "name")
        uds.set("未設定", forKey: "live")
        uds.set("年齢未設定", forKey: "age")
        uds.set("自己紹介コメントがありません", forKey: "comment")
        uds.set(0, forKey: "chatLastTime")
        uds.set([String: [Any]](), forKey: "hash")
        uds.set(true, forKey: "imTeacher")
        uds.set("", forKey: "money")
        uds.set("", forKey: "able")
        uds.set("", forKey: "bank")
        uds.set("", forKey: "bs")
        uds.set("", forKey: "bn")
        uds.set("", forKey: "fullname")
        uds.set("", forKey: "country")
    }
    
}


struct Student {
    
    var name: String!
    var email: String!
    var live: String!
    var age: String!
    var comment: String!
    
    init() {
        self.name = "ゲスト"
        self.live = "地域未設定"
        self.email = ""
        self.age = "年齢未設定"
        self.comment = "自己紹介コメントがありません"
    }
    
    func setUserDefaults(id: String) {
        uds.set(id, forKey: "myId")
        uds.set(id, forKey: "studentId")
        uds.set("ゲスト", forKey: "name")
        uds.set("未設定", forKey: "live")
        uds.set("年齢未設定", forKey: "age")
        uds.set("自己紹介コメントがありません", forKey: "comment")
        uds.set(0, forKey: "chatLastTime")
        uds.set([String: [Any]](), forKey: "hash")
        uds.set(false, forKey: "imTeacher")
    }
    
}


struct Lesson {
    
    var teacherName: String!
    var teacherEmail: String!
    var studentName: String!
    var studentEmail: String!
    var money: String!
    var date: String!
    var state: Int!
    var timeStamp: Int!
    var hour: String!
    
    var yourEmail: String{return imTeacher ? studentEmail : teacherEmail}
    var myEmail: String{return imTeacher ? teacherEmail : studentEmail}
    
    var yourName: String{return imTeacher ? studentName : teacherName}
    var myName: String{return imTeacher ? teacherName : studentName}
    
    init() {
        self.teacherName = "ゲスト講師"
        self.teacherEmail = ""
        self.studentName = "名前未設定"
        self.studentEmail = ""
        self.money = "？円"
        self.date = ""
        self.state = 0
        self.timeStamp = 0
        self.hour = "0"
        
    }
    
    
}

class Chat {
    
    var teacherName: String!
    var teacherEmail: String!
    var studentName: String!
    var studentEmail: String!
    var timeStamp: Int!
    
    init() {
        self.teacherName = ""
        self.teacherEmail = ""
        self.studentName = ""
        self.studentEmail = ""
        self.timeStamp = 0

    }

}
