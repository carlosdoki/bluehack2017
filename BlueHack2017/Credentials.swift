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

//"https://gateway.watsonplatform.net/conversation/api/v1/workspaces/516a6e4a-fdf9-4aa7-9502-ae6e03bd0c32/message?version=2017-02-03"

let URL_CONVERSATION = "https://gateway.watsonplatform.net/conversation/api/v1/workspaces"
let CONVERTION_VERSION = "version=2017-02-03"
let CONVERSATION_WORKSPACE = "516a6e4a-fdf9-4aa7-9502-ae6e03bd0c32"

typealias DownloadComplete = () -> ()

struct Credentials {
    static let SpeechToTextUsername = "your-username-here"
    static let SpeechToTextPassword = "your-password-here"
    static let TextToSpeechUsername = "bf260fdb-5f27-4a57-b382-90ebc4d98d87"
    static let TextToSpeechPassword = "YarSB2JZwNqJ"
    static let ToneAnalyzerUsername = "89e9e9dc-3dc3-4912-bda7-525e127b1fbd"
    static let ToneAnalyzerPassword = "GCG3KYQMLiOB"
    static let ConversationUsername = "8e6b56a5-ed30-4e54-9b20-c8ab3c3a26ca"
    static let ConversationPAssword = "tGdRglq4nB8r"
    
}


