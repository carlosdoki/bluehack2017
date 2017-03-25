//
//  MogoDB.swift
//  BlueHack2017
//
//  Created by Carlos Doki on 25/03/17.
//  Copyright © 2017 Carlos Doki. All rights reserved.
//

import Foundation
import Alamofire


public class MongoDB {
    private var _chat: String!
    private var _chatDate: Double!
    private var _angerScore: Double!
    private var _disgustScore: Double!
    private var _fearScore: Double!
    private var _joyScore: Double!
    private var _sadnessScore: Double!

    var chat: String {
        return _chat
    }
    
    var chatDate: Double {
        return _chatDate
    }
    
    var angerScore: Double {
        return _angerScore
    }
    
    var disgustScore: Double {
        return _disgustScore
    }
    
    var fearScore: Double {
        return _fearScore
    }
    
    var joyScore: Double {
        return _joyScore
    }
    
    var sadnessScore: Double {
        return _sadnessScore
    }
    
    init (chat: String, chatDate: Double, anger: Double, disgust: Double, fear: Double, sandness: Double, joy: Double) {
        self._chatDate  = chatDate
        self._chat = chat
        self._angerScore = anger
        self._disgustScore = disgust
        self._fearScore = fear
        self._sadnessScore = sandness
        self._joyScore = joy
    }
    
    func postData (completed: @escaping DownloadComplete) {
//        https://api.mlab.com/api/1/databases?apiKey=7VU8cPeR_7i4w_SoOMYvg1sA4y3nCk-7
//        
//        
//        $.ajax( { url: "https://api.mlab.com/api/1/databases/my-db/collections/my-coll?apiKey=myAPIKey",
//        data: JSON.stringify( { "x" : 1 } ),
//        type: "POST",
//        contentType: "application/json" } );
        let Url = "https://api.mlab.com/api/1/databases/master/collections/ollie?apiKey=7VU8cPeR_7i4w_SoOMYvg1sA4y3nCk-7"
        let parameters = [
            "chat" : "\(self.chat)",
            "chatDate" : self.chatDate,
            "angerScore" : self.angerScore,
            "disgustScore" : self.disgustScore,
            "fearScore" : self.fearScore,
            "joyScore" : self.joyScore,
            "sadnessScore" : self.sadnessScore
        ] as [String : Any]
        
        Alamofire.request(Url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil)
            .responseJSON { response in
                //debugPrint(response)
                completed()
            }
        
    }
}
