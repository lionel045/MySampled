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
        
        //setup Recorder
    //    createPositionPulseAnimation()
        setupView()
        //  recordButton.addSubview(pulseAnimation)
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
                        // failed to record
                    }
                }
            }
        } catch {
            // failed to record
        }
    }
    
    func initReccordButton(){
    
        recordButton = ButtonReccordView(frame: view.bounds)
        self.view.addSubview(recordButton)
        recordButton.translatesAutoresizingMaskIntoConstraints = false
        recordButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        recordButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

        recordButton.ringBack = { [weak self] button in
            
            if self?.audioRecorder == nil {
                self?.startRecording()
            }
            else {
                self?.finishRecording(success: true)
            }
            
        }
    }
   
   
 
    /*
    */
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
            audioRecorder.record(forDuration: 10)
            audioLevelTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateAudioLevel), userInfo: nil, repeats: true)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 10) { [weak self] in
                self?.overCountdown()
            }
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
    
    @objc func overCountdown() {
        if recordButton.currentTitle == "Enregistrement en cours" {
            recordButton.setTitle(" Veuillez reesayer ", for: .normal)
        }
    }
    
    func finishRecording(success: Bool) {
        audioRecorder.stop()
        audioRecorder = nil
        
        if success {
            DispatchQueue.main.async {
                self.recordButton.setTitle("Enregistrer à nouveau ", for: .normal)
            }
        } else {
            recordButton.setTitle("Tap to Record", for: .normal)
            // recording failed :(
        }
        
        recordButton.isEnabled = true
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
        
        ApiRequest.sharedInstance.sendSongApi(recorder.url)
        
        audioRecorder = nil
    }
        
        
        /*
         ApiRequest.sharedInstance.sendSongApi(recorder.url) { responseApi, state in
         
         DispatchQueue.global().async {
         do {
         
         let imageData = try Data(contentsOf: (responseApi?.result?.track?.share?.image)!)
         DispatchQueue.main.async {
         guard let matchTitle = responseApi?.result?.track?.title else { return }
         self.reponseDeCall.text = matchTitle
         self.imageArtist.image = UIImage(data: imageData)
         }
         } catch {
         print("Erreur lors du téléchargement de l'image : \(error.localizedDescription)")
         }
         }
         
         }
         */
        
        
       
}
