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
    private var _audio: URL!
    
    var texto: String {
        return _texto
    }
    
    var audio: URL {
        return _audio
    }
    
    init(texto: String) {
        self._texto = texto
    }
    
    func getAudio(completed: @escaping DownloadComplete) {
        let toneUrl = "\(URL_TEXT_SPEECH)\(self.texto.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)\(TEXT_SPEECH_VOICE)"
        let destination = DownloadRequest.suggestedDownloadDestination(for: .cachesDirectory, in: .userDomainMask)
        
        Alamofire.download(toneUrl, to: destination)
            .authenticate(user: Credentials.TextToSpeechUsername, password: Credentials.TextToSpeechPassword)
            .responseData { response in
            print(response.destinationURL!)
            self._audio = response.destinationURL!
            completed()
        }
    }
}

