import AVFoundation

class AudioRecorderManager: NSObject, AVAudioRecorderDelegate {
    static let shared = AudioRecorderManager()
    
    private var audioRecorder: AVAudioRecorder?
    private var completion: ((Data) -> Void)?
     var sendReccord: ((AVAudioRecorder) -> Void)?
    
    
    
    func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playAndRecord, mode: .default, options: [.mixWithOthers, .defaultToSpeaker])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Setting up audio session failed.")
        }
    }

    
    
    
    func startRecording() {
        setupAudioSession()
        let audioFilename = getFileURL()
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 44100,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder?.delegate = self
            audioRecorder?.isMeteringEnabled = true
            audioRecorder?.prepareToRecord()
            audioRecorder?.record(forDuration: 8)
            audioRecorder?.addObserver(self, forKeyPath: "isRecording",options: .new, context: nil)
        } catch {
            
             finishRecording(success: false)
            
            }
    }
    
    func stopRecording(completion: @escaping (Data) -> Void) {
        // Stop the audio recorder and handle the recorded data
        self.completion = completion
        audioRecorder?.stop()
    }
    
    // AVAudioRecorderDelegate method to handle recording completion
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            if let audioData = try? Data(contentsOf: recorder.url) {
                print("Voici l'url de ton enregistrement \(recorder.url)")
                finishRecording(success: true)

                sendReccord?(recorder)
                completion?(audioData)
                
                
            } else {
                finishRecording(success: false)
            }
        }
    }
    
    func finishRecording(success: Bool) {
          if let audioRecorder = audioRecorder {
            
              if audioRecorder.isRecording {
                  audioRecorder.stop()
              }
              if success {
              DispatchQueue.main.async {
                      print("ok")
                  }
              }
          } else {
              print("L'enregistrement a échoué.")
          }
      }
    
    func getDocumentsDirectory() -> URL {
          let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
          return paths[0]
      }
    
    
    private func getFileURL() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0].appendingPathComponent("recording.m4a")
    }
}
