//
//  ToneAnalyzer.swift
//  BlueHack2017
//
//  Created by Carlos Doki on 24/03/17.
//  Copyright © 2017 Carlos Doki. All rights reserved.
//

import Foundation
import Alamofire

public class ToneAnalyzer {
    private var _texto: String!
    private var _angerScore: Double!
    private var _disgustScore: Double!
    private var _fearScore: Double!
    private var _joyScore: Double!
    private var _sadnessScore: Double!

//    "tone_name":"Anger"
//    "tone_name":"Disgust"
//    "tone_name":"Fear"
//    "tone_name":"Joy"
//    "tone_name":"Sadness"
//    
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
    
    var texto: String {
        return _texto
    }
    
    init(texto: String) {
        self._texto = texto
    }
    
    func getTone(completed: @escaping DownloadComplete) {
        let toneUrl = "\(URL_BASE)/tone?\(TONE_VERSION)&text=\(self.texto.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)"
        Alamofire.request(toneUrl)
            .authenticate(user: Credentials.ToneAnalyzerUsername, password: Credentials.ToneAnalyzerPassword)
            .responseJSON { response in
                if let dict = response.result.value as? Dictionary<String, AnyObject> {
                    if let document_tone = dict["document_tone"] as? Dictionary<String, AnyObject> {
                        if let tone_categories = document_tone["tone_categories"] as? [Dictionary<String, AnyObject>], tone_categories.count > 0 {
                            if tone_categories[0]["category_name"] as? String == "Emotion Tone" {
                                if let tones = tone_categories[0]["tones"] as? [Dictionary<String, AnyObject>], tones.count > 0 {
                                    for x in 0..<tones.count {
                                        if tones[x]["tone_name"] as? String == "Anger" {
                                            self._angerScore = tones[x]["score"] as? Double
                                        }
                                        if tones[x]["tone_name"] as? String == "Disgust" {
                                            self._disgustScore = tones[x]["score"] as? Double
                                        }
                                        if tones[x]["tone_name"] as? String == "Fear" {
                                            self._fearScore = tones[x]["score"] as? Double
                                        }
                                        if tones[x]["tone_name"] as? String == "Joy" {
                                            self._joyScore = tones[x]["score"] as? Double
                                        }
                                        if tones[x]["tone_name"] as? String == "Sadness" {
                                            self._sadnessScore = tones[x]["score"] as? Double
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                completed()
        }
    }
}
