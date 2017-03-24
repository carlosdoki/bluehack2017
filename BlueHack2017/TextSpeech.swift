//
//  TextSpeech.swift
//  BlueHack2017
//
//  Created by Carlos Doki on 24/03/17.
//  Copyright © 2017 Carlos Doki. All rights reserved.
//

import Foundation
import Alamofire

public class TextSpeech {
    
    private var _texto: String!
    private var _audio: Data!
    
    var texto: String {
        return _texto
    }
    
    var audio: Data {
        return _audio
    }
    
    init(texto: String) {
        self._texto = texto
    }
    
    func getAudio(completed: @escaping DownloadComplete) {
        let toneUrl = "\(URL_TEXT_SPEECH)\(self.texto.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)\(TEXT_SPEECH_VOICE)"
        Alamofire.request(toneUrl)
            .authenticate(user: Credentials.SpeechToTextUsername, password: Credentials.SpeechToTextPassword)
            .responseData { response in
                guard let data = response.result.value else { return }
                self._audio = data
                print("\(data)")
                completed()
        }
    }
}
