//
//  InterfaceController.swift
//  Rocket.Chat.iOSWatch WatchKit Extension
//
//  Created by ahmed on 3/24/19.
//  Copyright © 2019 ahmed. All rights reserved.
//

import WatchKit
import Foundation
import Alamofire

class MyController: WKInterfaceController {
    
    @IBOutlet weak var nameLabel : WKInterfaceLabel!
    @IBOutlet weak var table     : WKInterfaceTable!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        loginUser()
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
                    DispatchQueue.main.async {
                        self.nameLabel.setText("Logged in as \(name)")
                        self.getChannels(authToken: authToken, userID: id)
                        
                    }
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
        
        if let url = URL(string: url) {
            var request = URLRequest(url: url)
            // Set headers
            request.setValue("headerValue", forHTTPHeaderField: "headerField")
            request.setValue("anotherHeaderValue", forHTTPHeaderField: "anotherHeaderField")
            let completionHandler = {(data: Data?, response: URLResponse?, error: Error?) -> Void in
                // Do something
            }
            URLSession.shared.dataTask(with: request, completionHandler: completionHandler).resume()
        } else {
            // Something went wrong
        }
        
        
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
                    
                    
                    
                    DispatchQueue.main.async {
//                        self.nameLabel.setText("\(data.count) channels")
                        self.table.setNumberOfRows(data.count, withRowType: "row")
                        for (index, each) in data.enumerated() {
                            let row = self.table.rowController(at: index) as! channelNameRowController
                            row.channelNameLabel.setText(String(describing: each["name"] ?? ""))
                        }


                    }
                } catch let parsingError {
                    print("Error : \(parsingError)")
                }
        }
        
    }


}





























