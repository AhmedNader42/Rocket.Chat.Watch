//
//  ViewController.swift
//  Rocket.Chat.iOSWatch
//
//  Created by ahmed on 3/24/19.
//  Copyright © 2019 ahmed. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view.backgroundColor = .red
//        loginUser()
    }
    
    func loginUser() {
        let url = URL(string: "http://192.168.1.11:3000/api/v1/login")
        let parameters = [ "user" : "ahmednader111@gmail.com",
                           "password": "123456"
        ]
        let headers = [ "content-type" : "application/json" ]
        Alamofire
            .request(url!, method: HTTPMethod.post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
                guard response.result.isSuccess else {
                    print("Error in the request")
                    return
                }
                
                
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String:Any]
                    
                    
                    //                    print("Dcoded data : \(String(describing: json))")
                    guard let data = json?["data"] as? [String:Any] else {
                        print("Erorr getting the data")
                        return
                    }
                    guard let authToken = data["authToken"] as? String, let me = data["me"] as? [String:Any] else {
                        print("Value error in getting the authToken")
                        return
                    }
                    
                    guard let name = me["name"] as? String, let id = me["_id"] as? String else {
                        print("Value error in getting the name")
                        return
                    }
                    print(authToken)
                    print(name)
                    print(id)
                    self.getChannels(authToken: authToken, userID: id)
                    //self.nameLabel.setText("Hello \(name)")
                } catch let parsingError {
                    print("Error : \(parsingError)")
                }
        }

    }
    
    
    func getChannels(authToken: String, userID: String) {
        let url = URL(string: "http://192.168.1.11:3000/api/v1/channels.list")
        
        let headers = [ "content-type" : "application/json",
                        "X-Auth-Token" : authToken,
                        "X-User-Id"    : userID
                        ]
        Alamofire
            .request(url!, method: HTTPMethod.get, parameters: nil, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
                guard response.result.isSuccess else {
                    print("Error in the request")
                    return
                }
                
                
                do {
                    guard let json = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String:Any] else {
                        print("Serialization Error")
                        return
                    }
//                    print(json)
                    guard let data = json["channels"] as? [[String:Any]] else {
                        print("Parsing data error")
                        return
                    }
                    
                    for each in data {
                        print(each["name"] as! String)
                    }
                } catch let parsingError {
                    print("Error : \(parsingError)")
                }
        }

    }
    
}

