//
//  ChatBot.swift
//  BlueHack2017
//
//  Created by Carlos Doki on 25/03/17.
//  Copyright © 2017 Carlos Doki. All rights reserved.
//
////        curl -X POST -u "8e6b56a5-ed30-4e54-9b20-c8ab3c3a26ca:tGdRglq4nB8r" —-header "Content-Type:application/json" --data "{\"input\": {\"text\": \"Turn on the lights\"}, \"context\": {\"conversation_id\": \"1b7b67c0-90ed-45dc-8508-9488bc483d5b\", \"system\": {\"dialog_stack\":[{\"dialog_node\":\"root\"}], \"dialog_turn_counter\": 1, \"dialog_request_counter\": 1}}}" "https://gateway.watsonplatform.net/conversation/api/v1/workspaces/516a6e4a-fdf9-4aa7-9502-ae6e03bd0c32/message?version=2017-02-03"


import Foundation
import Alamofire


public class Chatbot {
    private var _texto : String!
    private var _resposta: String!
    
    var texto: String {
        return _texto
    }
    
    var resposta: String {
        return _resposta
    }
    
    init(texto : String) {
        self._texto = texto
        self._resposta = ""
    }
    
    func sendChat (completed: @escaping DownloadComplete) {
        let parameters: [String: Any] = [
            "input" : [
                "text" : texto,
                "context" : [
                    "conversation_id": "1b7b67c0-90ed-45dc-8508-9488bc483d5b",
                    "system" : [
                        "dialog_stack" : [
                            [ "dialog_node" : "root" ]
                        ],
                        "dialog_turn_counter" : 1,
                        "dialog_request_counter" : 1
                    ]
                ]
            ]
        ]
        
        let headers = [ "Content-Type" : "application/json" ]

        let chatUrl = "\(URL_CONVERSATION)/\(CONVERSATION_WORKSPACE)/message?\(CONVERTION_VERSION)"
        Alamofire.request(chatUrl, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .authenticate(user: Credentials.ConversationUsername, password: Credentials.ConversationPAssword)
            .responseJSON { (response) in
                if let dict = response.result.value as? Dictionary<String, AnyObject> {
                    if let output = dict["output"] as?  Dictionary<String, AnyObject> {
                        if let text = output["text"] as? [String] {
                            for x in 0..<text.count {
                                //print(text[x])
                                self._resposta = self._resposta + text[x]
                            }
                        }
                    }
                }
                completed()
        }
    }
}
