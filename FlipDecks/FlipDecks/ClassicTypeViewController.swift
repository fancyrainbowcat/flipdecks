//
//  ClassicTypeViewController.swift
//  FlipDecks
//
//  Created by Sabine Kaupp on 12.06.17.
//  Copyright © 2017 Nicola Greth. All rights reserved.
//

import UIKit
import Speech


class ClassicTypeViewController: UIViewController, SFSpeechRecognizerDelegate, UITextFieldDelegate {
    
    // deck and language
    var deck : Deck = Deck(name: "", languageName: "", fileEnding: "")
    var language : Language = Language(name: "")
    var array = [String] ()
    var strValue = ""
    var currentCardIndex = 0
    var currentCards = [Card]()
    
    //time modus functionality
    var timeMode = false
    var timer : Timer?
    var secondsCount = 0
    var previousSecondsCount = 0
    
    //IBOutlets for time mode
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var timeSpentLabel: UILabel!
    
    //speech recognition
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    var audioTimer = Timer()
    
    //create speech recognizer for english language
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "en-US"))
    
    //IBOutlets for "siri" modus
    @IBOutlet weak var microphoneButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        RequestAnswer.isHidden = true
        
        self.TextFieldType.delegate = self;
        
        //enable microphone button and set delegate
        microphoneButton.isEnabled = false
        speechRecognizer?.delegate = self
        
        PopUpViewType.isHidden = true
        
        // DESIGN - Background
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "backgroundDark.jpg")!)
        self.AnswerTypeView.backgroundColor = UIColor(patternImage: UIImage(named: "indexCard.jpg")!)
        self.QuestionTypeView.backgroundColor = UIColor(patternImage: UIImage(named: "indexCard.jpg")!)
        self.PopUpViewType.backgroundColor = UIColor(patternImage: UIImage(named: "buttonBLight.png")!)
        
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
        
        //stop audio engine when textfield is clicked
        self.TextFieldType.addTarget(self, action: #selector(textfieldClicked), for: UIControlEvents.allTouchEvents)
        
        //only not finished cards are relevant
        currentCards = self.deck.returnAllNotFinishedCards()
        currentCards.shuffle()
        
        //hide time spent label (should only be visible when modus is finished)
        timeSpentLabel.isHidden = true
        
        //show time if time modus is activated
        if(timeMode == false) {
            timeLabel.isHidden = true
        } else {
            timeLabel.isHidden = false
            self.timeLabel.text = "00:00:00"
        }
        
        printQuestion()
        ShowType.isHidden = true
        ContinueType.isHidden = true
        
        //to determine when the Application is entering into background
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterBackground), name: .UIApplicationDidEnterBackground, object: nil)
        
        //to determine when the Application is terminated
        NotificationCenter.default.addObserver(self, selector: #selector(willTerminate), name: .UIApplicationWillTerminate, object: nil)
        
        //to cancel keyboard when screen is tapped
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    //keyboard should be removed on press of return button
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    //closes keyboard when screen is tapped anywhere
    func dismissKeyboard() {
        view.endEditing(true)
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
        
        //create new recognition request object
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        //check for possibility for audio input
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
                self.TextFieldType.text = result?.bestTranscription.formattedString.lowercased()
                
                //set a timer - after 2 seconds of no speech input the speech input will be cancelled
                self.audioTimer.invalidate()
                self.audioTimer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.didFinishTalk), userInfo: nil, repeats: false)
                isFinal = (result?.isFinal)!
            }

            //ifstop audio engine and recognition task when input is finished
            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                //this method has to be called before setting it to nil. Otherwise I will get an error "Error Domain=kAFAssistantErrorDomain Code=1101" every 5 to 10 cards!!! :(
                self.recognitionRequest?.endAudio()
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
                
                self.microphoneButton.isEnabled = true
                self.audioTimer.invalidate()
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
        
        //inform user about speech recognition running
        TextFieldType.text = "I'm listening!"
    }
    
    func textfieldClicked(textField: UITextField) {
        //stop audioengine and remove text 
        if audioEngine.isRunning {
            didFinishTalk()
            self.TextFieldType.text = ""
        }
    }
    
    //stops audio recognition
    func didFinishTalk() {
        if audioEngine.isRunning {
            self.microphoneButton.isEnabled = false
            audioEngine.stop()
            recognitionRequest?.endAudio()
            self.audioTimer.invalidate()
        }
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

        //stop audio engine if already running
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
        } //start recording
        else {
            startRecording()
        }
    }
    
    //Print question on label
    @IBAction func printQuestion() {
        if (currentCardIndex < currentCards.count) {
            TextFieldType.text = ""
            
            //microphone button should appear
            microphoneButton.isEnabled = true
            microphoneButton.isHidden = false
            
            strValue = currentCards[currentCardIndex].getQuestion()
            QuestionTypeLabel.text = strValue
            NextType.isHidden = true
            ShelveType.isHidden = false
            CheckType.isHidden = false
            TextFieldType.isHidden = false
            
            //starts timer for this question
            if (timeMode == true) {
                timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
            }
        }
        else {
            //time mode functionality
            if (timeMode == true) {
                //convert seconds to correct time format
                let (secondsStr, minutesStr, hoursStr) = splitSeconds(secondsCount: secondsCount)
                self.timeSpentLabel.text = "Time spent in modus: \(hoursStr):\(minutesStr):\(secondsStr)"
                self.timeSpentLabel.isHidden = false
            }
            self.timeLabel.isHidden = true 
            strValue = "Congratulations!"
            QuestionTypeLabel.text = strValue
            NextType.isHidden = true
            ShelveType.isHidden = true
            CheckType.isHidden = true
            microphoneButton.isHidden = true
            TextFieldType.isHidden = true
        }
    }
    
    //transforms counts to double-digit number
    func transformToTime(count : Int) -> String {
        var countStr = ""
        
        if (count < 10) {
            countStr = "0\(count)"
        } else {
            countStr = String(count)
        }
        return countStr
    }
    
    //splits seconds into hours:minutes:seconds format
    func splitSeconds(secondsCount : Int) -> (String, String, String) {
        var minutes = 0
        var seconds = 0
        var hours = 0
        
        //calculates minutes out of seconds
        if (secondsCount >= 60) {
            minutes = secondsCount / 60
            seconds = secondsCount % 60
        } else {
            seconds = secondsCount
        }
        
        //calculates hours out of minutes
        if (minutes >= 60) {
            hours = minutes / 60
            minutes = minutes % 60
        }
        
        //transforms to string
        let secondsStr = transformToTime(count : seconds)
        let minutesStr = transformToTime(count : minutes)
        let hoursStr = transformToTime(count : hours)
        
        return (secondsStr, minutesStr, hoursStr)
    }
    
    //counts seconds per card
    func updateCounter() {
        secondsCount += 1
        
        let (secondsStr, minutesStr, hoursStr) = splitSeconds(secondsCount: secondsCount)
        
        //updates time Label
        self.timeLabel.text = "\(hoursStr):\(minutesStr):\(secondsStr)"
    }
    
    //Print answer on label
    @IBAction func printAnswer() {
        //stop speech recognition
        didFinishTalk()

        //stop timer
        if (timeMode == true) {
            timer?.invalidate()
        }
        
        //microphoneButton should not be used
        microphoneButton.isEnabled = false
        microphoneButton.isHidden = true
        
        strValue = currentCards[currentCardIndex].getAnswer()
        AnswerTypeLabel.text = strValue
        ShelveType.isHidden = true
        CheckType.isHidden = true
        NextType.isHidden = false
        TextFieldType.isHidden = true
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
        //stop speech recognition
        didFinishTalk()

        //stop timer
        if (timeMode == true) {
            timer?.invalidate()
        }
        
        //microphoneButton should not be used
        microphoneButton.isEnabled = false
        microphoneButton.isHidden = true
        
        appendCard()
        currentCards.remove(at:currentCardIndex)
        printQuestion()
    }
    
    // Show previously played card
    @IBAction func PreviousCard() {
        //stop speech recognition
        didFinishTalk()

        //stop timer
        if (timeMode == true) {
            timer?.invalidate()
        }
        
        //microphoneButton should not be used
        microphoneButton.isEnabled = false
        microphoneButton.isHidden = true
        
        if TextFieldType.isHidden == false {
            if currentCardIndex > 0 {
                currentCardIndex = currentCardIndex-1
                printQuestion()
                
                //microphoneButton should not be used
                microphoneButton.isEnabled = false
                microphoneButton.isHidden = true
                
                self.QuestionTypeView.isHidden = false
                self.AnswerTypeView.isHidden = true
                TextFieldType.isHidden = true
                ShowType.isHidden = false
                CheckType.isHidden = true
                ShelveType.isHidden = true
            }
        }
    }
    
    // Show Answer When PreviousCard has been selected
    @IBAction func showAnswerForPreviousCard() {
        //stop timer
        if (timeMode == true) {
            timer?.invalidate()
        }
        
    printAnswer()
    ShelveType.isHidden = true
    CheckType.isHidden = true
    NextType.isHidden = false
    flip()
    ShowType.isHidden = true
    ContinueType.isHidden = false
    NextType.isHidden = true
    PopUpViewType.isHidden = true
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
        //stop timer
        if (timeMode == true) {
            timer?.invalidate()
        }
        currentCardIndex += 1
        printQuestion()
        self.QuestionTypeView.isHidden = false
        self.AnswerTypeView.isHidden = true
        PopUpViewType.isHidden = true
    }

    // Append current card to retry later
    @IBAction func appendCard() {
        currentCards.append(currentCards[currentCardIndex])
    }
    
    
    // Check Input
    @IBAction func checkInput() {
    let userInput = TextFieldType.text!
        
        if TextFieldType.text == "" {
            RequestAnswer.isHidden = false
        }
        
        else {
        if userInput == currentCards[currentCardIndex].getAnswer() {
            PopUpViewType.isHidden = false
            PopUpCorrectLabelType.isHidden = false
            PopUpIncorrectLabelType.isHidden = true
            
            //if time mode is activated store result and time
            if (timeMode == true) {
                let newSecondsCount = secondsCount - previousSecondsCount
                previousSecondsCount = secondsCount
                currentCards[currentCardIndex].cardPlayed(result: "correct", seconds: newSecondsCount)
            } //else store result
            else {
                currentCards[currentCardIndex].cardPlayed(result: "correct")
            }
            if (currentCards[currentCardIndex].getCorrectCount() < 3) {
                appendCard()
            }
        }
        else {
            PopUpViewType.isHidden = false
            PopUpViewType.tintColor = UIColor.red
            PopUpCorrectLabelType.isHidden = true
            PopUpIncorrectLabelType.isHidden = false
            
            //if time mode is activated store result and time
            if (timeMode == true) {
                let newSecondsCount = secondsCount - previousSecondsCount
                previousSecondsCount = secondsCount
                currentCards[currentCardIndex].cardPlayed(result: "incorrect", seconds: newSecondsCount)
            } //else store result
            else {
                currentCards[currentCardIndex].cardPlayed(result: "incorrect")
            }
        appendCard()
        }
    printAnswer()
        }
    }
    
    //function that will be called once the app is entering into background
    func willEnterBackground(_ notification: Notification) {
        self.deck.saveToFile()
    }
    
    //function that will be called once the app is terminated
    func willTerminate(_ notification: Notification) {
        self.deck.saveToFile()
    }

    @IBOutlet weak var PopUpIncorrectLabelType: UILabel!
    @IBOutlet weak var PopUpCorrectLabelType: UILabel!
    @IBOutlet weak var PopUpViewType: UIView!
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
    @IBOutlet weak var RequestAnswer: UILabel!
}
