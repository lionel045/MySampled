//
//  ViewController.swift
//  VoiceRecorder
//
//  Created by Lion on 11/07/2023.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    // @IBOutlet var recordButton: UIButton!
    var isRecording = false
    var animatedView : UIView!
    var recordButton : ButtonReccordView!
    var pulseAnimation = PulseAnimation()
    
    @IBOutlet weak var reponseDeCall: UILabel!
    
    @IBOutlet weak var imageArtist: UIImageView!

    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var audioPlayer:AVAudioPlayer!
    var audioLevelTimer : Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setupView()
    }
    func setupView() {
        recordingSession = AVAudioSession.sharedInstance()
        
        do {
            
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        self.initReccordButton()
                    } else {
                    }
                }
            }
        } catch {
        }
    }
    
    func initReccordButton(){
        
        recordButton = ButtonReccordView(frame: self.view.bounds)
        self.view.addSubview(recordButton)
        recordButton.translatesAutoresizingMaskIntoConstraints = false
        recordButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        recordButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        recordButton.ringBack = { [weak self] button in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
                self?.startRecording()
            }
        }
    }
    func startRecording() {
        let audioFilename = getFileURL()
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 44100,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        isRecording = true
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.isMeteringEnabled = true
            audioRecorder.prepareToRecord()
            audioRecorder.record(forDuration: 4)
     
        } catch {
            finishRecording(success: false)
        }
    }
    
    @objc func updateAudioLevel(){
        guard let recorder = audioRecorder, recorder.isRecording else {
            // The audioRecorder is nil or not recording, so we can't update meters.
            return
        }
        
        audioRecorder.updateMeters()
        let decibels = audioRecorder.averagePower(forChannel: 0) ?? 0.0
        let normalizedValue = CGFloat((decibels + 160) / 160)
        animateViewWithAudioLevel(normalizedValue)
        
    }
    
    func animateViewWithAudioLevel(_ level: CGFloat){
        
        let scale = 2.0 + level
    }
    
    func finishRecording(success: Bool) {
        audioRecorder.stop()
        audioRecorder = nil
        if success {
            DispatchQueue.main.async {
                print("OK")
            }
        } else {
            // recording failed :(
        }
        }
    
    func preparePlayer() {
        var error: NSError?
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: getFileURL() as URL)
        } catch let error1 as NSError {
            error = error1
            audioPlayer = nil
        }
        
        if let err = error {
            print("AVAudioPlayer error: \(err.localizedDescription)")
        } else {
            audioPlayer.delegate = self
            audioPlayer.prepareToPlay()
            audioPlayer.volume = 10.0
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func getFileURL() -> URL {
        let path = getDocumentsDirectory().appendingPathComponent("recording.m4a")
        return path as URL
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        
        if !flag {
            
            finishRecording(success: false)

        }
        print("Voici l'url de ton enregistrement \(recorder.url)")
        audioRecorder = nil
    
         ApiRequest.sharedInstance.sendSongApi(recorder.url) {  succes, shazamData in
         if succes {
         
         DispatchQueue.main.async {
         
         if let retrieveArtist = shazamData?.result?.track?.subtitle , let retrieveTitle = shazamData?.result?.track?.title {
         
         
         let formatArtist =  formatArtistName(retrieveArtist)
         
         let songWithoutFeat = removeFeaturing(from: retrieveTitle)
         
         let formatTitle = formatArtistName(songWithoutFeat)
         print(formatArtist)
         let url = "https://www.whosampled.com/\(formatArtist)/\(formatTitle)/"
         print(url)
         WebScrap.sharedInstance.retrieveData(currentUrl:url)
         
         }
         
         }
         }
         }
         
    }
}


func removeFeaturing(from artistName: String) -> String {
    if let featRange = artistName.range(of: "feat") {
        let artistWithoutFeaturing = artistName[..<featRange.lowerBound]
        
        if let artistWithoutParenthesis = artistWithoutFeaturing.lastIndex(of: "(") {
            let artistWithoutSpace = artistWithoutFeaturing.prefix(upTo: artistWithoutParenthesis).trimmingCharacters(in: .whitespaces)
            return String(artistWithoutSpace)
        } else {
            return String(artistWithoutFeaturing)
        }
        
    } else {
        return artistName
    }
}

func formatArtistName(_ artistName: String) -> String {
    var mediaName = ""
    
    artistName.forEach { char in
        if char == " " {
            mediaName += "-"
        }
        else if char == "'" {
            mediaName += "%27"
        }
        
        else if char == "?"
        {
            mediaName += "%3F"
            
        }
        
        else {
            mediaName += String(char)
        }
    }
    
    return mediaName
}




