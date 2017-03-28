//
//  RedNode.swift
//  BlueHack2017
//
//  Created by Carlos Doki on 27/03/17.
//  Copyright © 2017 Carlos Doki. All rights reserved.
//

import Foundation
import Alamofire

public class NodeRed {
    private var _texto: String!
    private var _dado: Data!
    
    var texto : String {
        return _texto
    }
    
    var dado: Data {
        return _dado
    }
    
    init(texto: String) {
        self._texto = texto
    }
    
//    func getOllie(completed: @escaping DownloadComplete) {
    func getOllie() {
        let parameters: [String: Any] = [
            "payload" :  texto
        ]
        
        let headers = [ "Content-Type" : "application/json" ]
        
        let chatUrl = "\(URL_REDNODE)"
        // Send HTTP GET Request
        
        // Define server side script URL
        let scriptUrl = "http://swiftdeveloperblog.com/my-http-get-example-script/"
        
        // Add one parameter
        //let urlWithParams = scriptUrl + "?userName=\(userNameValue!)"
        
        // Create NSURL Ibject
        //let myUrl = NSURL(string: urlWithParams);
        let myUrl = URL(string: "http://swiftdeveloperblog.com/my-http-get-example-script/")
        
        // Creaste URL Request
        let request = NSMutableURLRequest(url:myUrl!);
        
        // Set request HTTP method to GET. It could be POST as well
        request.httpMethod = "POST"
        

        // Excute HTTP Request
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            // Check for error
            if error != nil
            {
                print("error=\(error)")
                return
            }
            
            // Print out response string
            self._dado = data
        }
        
        task.resume()

//        Alamofire.request(chatUrl, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
//            .response { (response) in
//                self._dado = response.data
//                completed()
//        }
    }
}
