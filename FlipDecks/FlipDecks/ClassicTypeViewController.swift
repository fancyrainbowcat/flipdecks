//
//  ClassicTypeViewController.swift
//  FlipDecks
//
//  Created by Sabine Kaupp on 12.06.17.
//  Copyright © 2017 Nicola Greth. All rights reserved.
//

import UIKit
import Speech


class ClassicTypeViewController: UIViewController, SFSpeechRecognizerDelegate {
    
    // current deck and language
    var deck : Deck = Deck(name: "", languageName: "", fileEnding: "")
    var language : Language = Language(name: "")
    var array = [String] ()
    var strValue = ""
    var currentCardIndex = 0
    var currentCards = [Card]()
    
    //speech recognition
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    //create speech recognizer for english !!! attention: we need to switch the language according to the unit
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "en-US"))

    @IBOutlet weak var microphoneButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        microphoneButton.isEnabled = false
        speechRecognizer?.delegate = self
        
        //reqeust authorization to use speech recognition
        SFSpeechRecognizer.requestAuthorization { (authStatus) in
            var isButtonEnabled = false
            
            switch authStatus {
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

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        //only not finished cards are relevant
        currentCards = self.deck.returnAllNotFinishedCards()
        currentCards.shuffle()
        
        printQuestion()
        ShowType.isHidden = true
        ContinueType.isHidden = true
        
        //to determine when the Application is entering into background
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterBackground), name: .UIApplicationDidEnterBackground, object: nil)
        
        //to determine when the Application is terminated
        NotificationCenter.default.addObserver(self, selector: #selector(willTerminate), name: .UIApplicationWillTerminate, object: nil)

    }
    
    //records user input from microphone
    func startRecording() {
        
        //can not double start a recognition task
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
        //AV Audio Session prepares for audio recording
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryRecord)
            try audioSession.setMode(AVAudioSessionModeMeasurement)
            try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }
        
        //create new request object
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        
        //check for audio input
        guard let inputNode = audioEngine.inputNode else {
            fatalError("Audio engine has no input node")
        }
        
        //check if request object is valid
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        }
        
        //partial results should be recorded while the user speaks
        recognitionRequest.shouldReportPartialResults = true
        
        
        //do speech recognition
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
            //check if recognition is finished
            var isFinal = false
            
            //if there is a result it will be printed into textFieldType
            if result != nil {
                self.TextFieldType.text = result?.bestTranscription.formattedString
                isFinal = (result?.isFinal)!
            }
            
            //ifstop audio engine and recognition task when input is finished
            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
                
                self.microphoneButton.isEnabled = true
            }
        })
        
        //combine audio input and recognition reqeust
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }
        
        //prepare and then start audio engine
        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch {
            print("audioEngine couldn't start because of an error.")
        }
        
        TextFieldType.text = "Say something, I'm listening!"
        
    }
    
    //changes status of microphone button
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            microphoneButton.isEnabled = true
        } else {
            microphoneButton.isEnabled = false
        }
    }
    
    //use speech input instead of text
    @IBAction func useSpeechInput(_ sender: Any) {
        //stop audio engine if already running and start recording
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
            microphoneButton.isEnabled = false
            microphoneButton.setTitle("Start Recording", for: .normal)
        } //start recording
        else {
            startRecording()
            microphoneButton.setTitle("Stop Recording", for: .normal)
        }
    }
    
    //Print question on label
    @IBAction func printQuestion() {
        if (currentCardIndex < currentCards.count) {
            strValue = currentCards[currentCardIndex].getQuestion()
            QuestionTypeLabel.text = strValue
            NextType.isHidden = true
            ShelveType.isHidden = false
            CheckType.isHidden = false
        }
        else {
            strValue = "Congratulations!"
            QuestionTypeLabel.text = strValue
            NextType.isHidden = true
            ShelveType.isHidden = true
            CheckType.isHidden = true
        }
    }
    
    //Print answer on label
    @IBAction func printAnswer() {
        strValue = currentCards[currentCardIndex].getAnswer()
        AnswerTypeLabel.text = strValue
        ShelveType.isHidden = true
        CheckType.isHidden = true
        NextType.isHidden = false
        flip()
    }
  
    
    
    //Flip Label
    func flip() {
        let transitionOptions: UIViewAnimationOptions = [.transitionFlipFromRight, .showHideTransitionViews]
        
        UIView.transition(with: QuestionTypeView, duration: 1.0, options: transitionOptions, animations: {
            self.QuestionTypeView.isHidden = true
        })
        
        UIView.transition(with: AnswerTypeView, duration: 1.0, options: transitionOptions, animations: {
            self.AnswerTypeView.isHidden = false
        })
    }
    
    // Shelve cards
    @IBAction func shelveCard() {
        appendCard()
        currentCardIndex += 1
        printQuestion()
    }
    
    // Show previously played card
    @IBAction func PreviousCard() {
        if currentCardIndex > 0 {
            currentCardIndex = currentCardIndex-1
            printQuestion()
            self.QuestionTypeView.isHidden = false
            self.AnswerTypeView.isHidden = true
            TextFieldType.isHidden = true
            ShowType.isHidden = false
            CheckType.isHidden = true
            ShelveType.isHidden = true
        }
    }
    
    // Show Answer When PreviousCard has been selected
    @IBAction func showAnswerForPreviousCard() {
    printAnswer()
    ShelveType.isHidden = true
    CheckType.isHidden = true
    NextType.isHidden = false
    flip()
    ShowType.isHidden = true
    ContinueType.isHidden = false
    NextType.isHidden = true
    }

    //Continue Lection
    @IBAction func continueLection() {
        currentCardIndex += 1
        printQuestion()
        ContinueType.isHidden = true
        ShowType.isHidden = true
        self.AnswerTypeView.isHidden = true
        self.QuestionTypeView.isHidden = false
        TextFieldType.isHidden = false
        CheckType.isHidden = false
        ShelveType.isHidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Play next card
    @IBAction func playNextCard() {
        currentCardIndex += 1
        printQuestion()
        self.QuestionTypeView.isHidden = false
        self.AnswerTypeView.isHidden = true
    }

    // Append current card to retry later
    @IBAction func appendCard() {
        currentCards.append(currentCards[currentCardIndex])
    }
    
    
    // Check Input
    @IBAction func checkInput() {
    let userInput = String(describing: TextFieldType.text)
        if userInput == currentCards[currentCardIndex].getQuestion() {
        currentCards[currentCardIndex].cardPlayed(result: "correct")
            if (currentCards[currentCardIndex].getCorrectCount() < 3) {
                appendCard()
            }
        }
        else {
        currentCards[currentCardIndex].cardPlayed(result: "incorrect")
        appendCard()
        }
    printAnswer()
    }
    
    //function that will be called once the app is entering into background
    func willEnterBackground(_ notification: Notification) {
        self.deck.saveToFile()
    }
    
    //function that will be called once the app is terminated
    func willTerminate(_ notification: Notification) {
        self.deck.saveToFile()
    }

    @IBOutlet weak var ContinueType: UIButton!
    @IBOutlet weak var ShowType: UIButton!
    @IBOutlet weak var AnswerTypeView: UIView!
    @IBOutlet weak var AnswerTypeLabel: UILabel!
    @IBOutlet weak var QuestionTypeView: UIView!
    @IBOutlet weak var QuestionTypeLabel: UILabel!
    
    @IBOutlet weak var ShelveType: UIButton!
    @IBOutlet weak var CheckType: UIButton!

    @IBOutlet weak var NextType: UIButton!
    @IBOutlet weak var TextFieldType: UITextField!
}
