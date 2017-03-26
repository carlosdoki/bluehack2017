//
//  ViewController.swift
//  BlueHack2017
//
//  Created by Carlos Doki on 24/03/17.
//  Copyright © 2017 Carlos Doki. All rights reserved.
//

import UIKit
import Speech
import AVFoundation

class ViewController: UIViewController, SFSpeechRecognizerDelegate, AVAudioPlayerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var microphoneButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var microphoneImg: UIImageView!
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "pt_BR"))  //1
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    var toneAnalyze: ToneAnalyzer!
    var speechUrl : URL!
    var musicPlayer: AVAudioPlayer!
    var chats = [chat]()
    var texto : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        microphoneButton.isEnabled = false  //2
        
        speechRecognizer?.delegate = self  //3
        
        SFSpeechRecognizer.requestAuthorization { (authStatus) in  //4
            
            var isButtonEnabled = false
            
            switch authStatus {  //5
            case .authorized:
                isButtonEnabled = true
                
            case .denied:
                isButtonEnabled = false
                print("User denied access to speech recognition")
                
            case .restricted:
                isButtonEnabled = false
                print("Speech recognition restricted on this device")
                
            case .notDetermined:
                isButtonEnabled = false
                print("Speech recognition not yet authorized")
            }
            
            OperationQueue.main.addOperation() {
                self.microphoneButton.isEnabled = isButtonEnabled
            }
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let chat = chats[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell") as? chatCell {
            cell.configureCell(chat: chat.chat, face: chat.face, usuario: chat.usuario)
            return cell
        } else {
            return chatCell()
        }
    }
    
    func startRecording() {
        
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryRecord)
            try audioSession.setMode(AVAudioSessionModeMeasurement)
            try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        guard let inputNode = audioEngine.inputNode else {
            fatalError("Audio engine has no input node")
        }
        
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        }
        
        recognitionRequest.shouldReportPartialResults = true
        
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
            
            var isFinal = false
            
            if result != nil {
                
                self.texto = result?.bestTranscription.formattedString
                
                isFinal = (result?.isFinal)!
            }
            
            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
                
                self.microphoneButton.isEnabled = true
            }
        })
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        
        do {
            try audioEngine.start()
        } catch {
            print("audioEngine couldn't start because of an error.")
        }
    }
    
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            microphoneButton.isEnabled = true
        } else {
            microphoneButton.isEnabled = false
        }
    }
    
    
    @IBAction func testeBtnTapped(_ sender: UIButton) {
        let texto = "Eu quero comer chocolate"
        let tone = ToneAnalyzer(texto: texto )
        tone.getTone {
            var face : String = "joy"
            
            if tone.angerScore > tone.disgustScore {
                if tone.angerScore > tone.fearScore {
                    if tone.angerScore > tone.joyScore {
                        if tone.angerScore > tone.sadnessScore {
                            face = "anger"
                        }
                    }
                }
            }
            
            if tone.disgustScore > tone.angerScore {
                if tone.disgustScore > tone.fearScore {
                    if tone.disgustScore > tone.joyScore {
                        if tone.disgustScore > tone.sadnessScore {
                            face = "digust"
                        }
                    }
                }
            }
            
            if tone.fearScore > tone.angerScore {
                if tone.fearScore > tone.disgustScore {
                    if tone.fearScore > tone.joyScore {
                        if tone.fearScore > tone.sadnessScore {
                            face = "fear"
                        }
                    }
                }
            }
            
            if tone.joyScore > tone.angerScore {
                if tone.joyScore > tone.disgustScore {
                    if tone.joyScore > tone.fearScore {
                        if tone.joyScore > tone.sadnessScore {
                            face = "joy"
                        }
                    }
                }
            }
            
            if tone.sadnessScore > tone.angerScore {
                if tone.sadnessScore > tone.disgustScore {
                    if tone.sadnessScore > tone.fearScore {
                        if tone.sadnessScore > tone.joyScore {
                            face = "sadness"
                        }
                    }
                }
            }
            
            print("angerScore=\(tone.angerScore)")
            print("disgustScore=\(tone.disgustScore)")
            print("fearScore=\(tone.fearScore)")
            print("sadnessScore=\(tone.sadnessScore)")
            print("joyScore=\(tone.joyScore)")
            
            let currentDate = Date()
            let since1970 = currentDate.timeIntervalSince1970
            let data =  Int(since1970 * 1000)
            let mongo = MongoDB(chat: texto, chatDate: Double(data), anger: tone.angerScore, disgust: tone.disgustScore, fear: tone.fearScore, sandness: tone.sadnessScore, joy: tone.joyScore)
            mongo.postData {
                //print("dados")
            }
            let chat2 = chat(chat: texto, face: face, usuario: true)
            self.chats.append(chat2)
            self.tableView.reloadData()
            
            let chat3 = Chatbot(texto: texto)
            chat3.sendChat {
                let username = Credentials.TextToSpeechUsername
                let password = Credentials.TextToSpeechPassword
                let textToSpeech = TextToSpeech(username: username, password: password)
                
                if chat3.resposta != nil {
                    let text = chat3.resposta
                    let failure = { (error: Error) in print(error) }
                    textToSpeech.synthesize(text, voice: "pt-BR_IsabelaVoice", failure: failure) { data in
                        self.musicPlayer = try! AVAudioPlayer(data: data)
                        self.musicPlayer.prepareToPlay()
                        self.musicPlayer.play()
                        let chat4 = chat(chat: text, face: face, usuario: false)
                        self.chats.append(chat4)
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    

    @IBAction func tappedMicrophone(_ sender: Any) {
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
            microphoneImg.image = UIImage(named: "microphone-off")
            let tone = ToneAnalyzer(texto: self.texto )
            tone.getTone {
                var face : String = "joy"
                
                if tone.angerScore > tone.disgustScore {
                    if tone.angerScore > tone.fearScore {
                        if tone.angerScore > tone.joyScore {
                            if tone.angerScore > tone.sadnessScore {
                                face = "anger"
                            }
                        }
                    }
                }
                
                if tone.disgustScore > tone.angerScore {
                    if tone.disgustScore > tone.fearScore {
                        if tone.disgustScore > tone.joyScore {
                            if tone.disgustScore > tone.sadnessScore {
                                face = "digust"
                            }
                        }
                    }
                }
                
                if tone.fearScore > tone.angerScore {
                    if tone.fearScore > tone.disgustScore {
                        if tone.fearScore > tone.joyScore {
                            if tone.fearScore > tone.sadnessScore {
                                face = "fear"
                            }
                        }
                    }
                }
                
                if tone.joyScore > tone.angerScore {
                    if tone.joyScore > tone.disgustScore {
                        if tone.joyScore > tone.fearScore {
                            if tone.joyScore > tone.sadnessScore {
                                face = "joy"
                            }
                        }
                    }
                }
                
                if tone.sadnessScore > tone.angerScore {
                    if tone.sadnessScore > tone.disgustScore {
                        if tone.sadnessScore > tone.fearScore {
                            if tone.sadnessScore > tone.joyScore {
                                face = "sadness"
                            }
                        }
                    }
                }
                
                let currentDate = Date()
                let since1970 = currentDate.timeIntervalSince1970
                let data =  Int(since1970 * 1000)
                let mongo = MongoDB(chat: "Olá tudo bem", chatDate: Double(data), anger: tone.angerScore, disgust: tone.disgustScore, fear: tone.fearScore, sandness: tone.sadnessScore, joy: tone.joyScore)
                mongo.postData {
                    print("dados")
                }
                
                let chat2 = chat(chat: self.texto, face: face, usuario: true)
                self.chats.append(chat2)
                self.tableView.reloadData()
                
                let chat3 = Chatbot(texto: self.texto)
                chat3.sendChat {
                    let username = Credentials.TextToSpeechUsername
                    let password = Credentials.TextToSpeechPassword
                    let textToSpeech = TextToSpeech(username: username, password: password)
                    
                    if chat3.resposta != nil {
                        let text = chat3.resposta
                        let failure = { (error: Error) in print(error) }
                        textToSpeech.synthesize(text, voice: "pt-BR_IsabelaVoice", failure: failure) { data in
                            self.musicPlayer = try! AVAudioPlayer(data: data)
                            self.musicPlayer.prepareToPlay()
                            self.musicPlayer.play()
                            let chat4 = chat(chat: text, face: face, usuario: false)
                            self.chats.append(chat4)
                            self.tableView.reloadData()
                        }
                    }
                }
            }
        } else {
            startRecording()
            microphoneImg.image = UIImage(named: "microphone-on")
        }
    }
}

