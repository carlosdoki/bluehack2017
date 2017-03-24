//
//  Credentials.swift
//  BlueHack2017
//
//  Created by Carlos Doki on 24/03/17.
//  Copyright © 2017 Carlos Doki. All rights reserved.
//

import Foundation

let URL_BASE = "https://gateway.watsonplatform.net/tone-analyzer/api/v3"
let TONE_VERSION="version=2016-05-19"

let URL_TEXT_SPEECH = "https://stream.watsonplatform.net/text-to-speech/api/v1/synthesize?accept=audio/wav&text="
let TEXT_SPEECH_VOICE = "&voice=pt-BR_IsabelaVoice"

typealias DownloadComplete = () -> ()

struct Credentials {
    static let SpeechToTextUsername = "your-username-here"
    static let SpeechToTextPassword = "your-password-here"
    static let TextToSpeechUsername = "bf260fdb-5f27-4a57-b382-90ebc4d98d87"
    static let TextToSpeechPassword = "YarSB2JZwNqJ"
    static let ToneAnalyzerUsername = "89e9e9dc-3dc3-4912-bda7-525e127b1fbd"
    static let ToneAnalyzerPassword = "GCG3KYQMLiOB"
}

//https://stream.watsonplatform.net/text-to-speech/api/v1/synthesize?accept=audio/wav&text=oi%20tudo%20bem&voice=pt-BR_IsabelaVoice
