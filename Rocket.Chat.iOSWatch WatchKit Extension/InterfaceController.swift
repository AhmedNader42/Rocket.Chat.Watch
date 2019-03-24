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

class InterfaceController: WKInterfaceController {

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        // Configure interface objects here.
        let url = URL(string: "http://192.168.1.11:3000/api/v1/login")
        let parameters = [ "user" : "ahmednader111@gmail.com",
                           "password": "123456"
        ]
        let headers = [ "content-type" : "application/json" ]
        Alamofire
            .request(url!, parameters: parameters, headers: headers)
            .responseJSON { response in
                guard response.result.isSuccess, let _ = response.result.value else {
                    print("Error in the request")
                    return
                }
                
                print("Success")
                print(response.data!)
                
        }
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
