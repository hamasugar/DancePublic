
import XCTest
import Alamofire
import SwiftyJSON
//@testable import DanceTests

class DanceTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
//        XCTAssertEqual("7".addZero(), "07")
        //テスト駆動開発で非同期処理を試してみることにした
        let vc = UIViewController()
        let bool = vc.textJudge(mail: "hamazi511@gmail.com", password: "aaaaaa")
        XCTAssert(bool)
        
//        var myResponse: DataResponse<Any>!
//        let expect = expectation(description: "alamofire")
//        let endURL = awsURL + "/teachers"
//        Alamofire.request(endURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
//            myResponse = response
//            expect.fulfill()
//        }
//
//        waitForExpectations(timeout: 20.0, handler: {(error) in
//            if let _ = error {
//                XCTFail()
//            }
//
//            let object = myResponse.result.value
//            let count = JSON(object)["Count"].int as! Int
//            print (count)
//            XCTAssertGreaterThan(count, 20)
//        })
        //やっぱり別々に書くしかないのかあ
//        let app = XCUIApplication()
//        if uds.object(forKey: "imTeacher") == nil {
//            app.buttons["learn"].tap()
//            XCTAssertFalse(uds.object(forKey: "imTeacher") as! Bool)
//        }
        // apimanagerを使ったテストに切り替えました　これでオッケーです　
        let expect1 = expectation(description: "success")
        var result: Bool!
        
        let endURL = awsURL + "/teachers"
        let apimanager = APIManager(url: endURL, method: .get, parameters: [:], view: UIViewController())
        apimanager.request(fail: { () in
            result = false
            expect1.fulfill()
            
        }, success: { (json: JSON) in
            result = false
            expect1.fulfill()
        })
        
        waitForExpectations(timeout: 20.0, handler: {(error) in
            print (result)
            XCTAssert(result)
        })
        
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
