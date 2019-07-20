import Foundation
import Alamofire
import SwiftyJSON


struct APIManager {
    
    let url: String
    let method: HTTPMethod
    let parameters: Parameters
    let view: UIViewController
    
    init(url: String, method: HTTPMethod, parameters: Parameters = [:], view: UIViewController) {
        self.url = url
        self.method = method
        self.parameters = parameters
        self.view = view
    }
    
    func request(fail: @escaping () -> Void, success: @escaping (_ data: JSON) -> Void) {
        view.setIndicator2()
        Alamofire.request(self.url, method: self.method, parameters: self.parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            
            self.view.removeIndicator2()
            if (response.error != nil) {
                fail()
                return
            }
            guard let object = response.result.value else {
                fail()
                return
            }
            let json = JSON(object)
            
            if let _ = json["errorMessage"].string {
                fail()
                return
            }
            success(json)
        }
    }

}
