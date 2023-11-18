import UIKit
import AVFoundation


class ViewController: UIViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate, Delegation{
    func superviseResult(result: Bool?) {
        print("ok")
    }
    var isRecording = false
    var animatedView: UIView!
    var recordButton: ButtonReccordView!
    var checkIfSongFound: ((Bool?) -> ())?
    var songFound = false
    var sendResultToSecondVc : ((ShazamResponse?) -> ())?
    @IBOutlet weak var reponseDeCall: UILabel!
    @IBOutlet weak var imageArtist: UIImageView!
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    
     override func viewDidAppear(_ animated: Bool) {
     super.viewDidAppear(animated)
     
     let secondVc = SecondViewController()
     self.present(secondVc, animated: true, completion: nil)
     }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
      //®  displayAudioReccord()

    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            print("La lecture s'est terminée avec succès.")
        } else {
            print("La lecture est terminée, mais pas avec succès.")
        }
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        print("Une erreur de décodage lors de la lecture est survenue: \(String(describing: error))")
    }
    
    @objc func audioDidFinish(_ notification: Notification) {
        print("La lecture de l'audio est terminée.")
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    func sendDataToVc(data: ShazamResponse) {
        
        guard let backgroundImage = data.result?.track?.images?.background else {return}
        let vc = SecondViewController()
        vc.addCoverImage(imageCoverURL: backgroundImage)
        vc.delegate = self
        vc.modalTransitionStyle = .flipHorizontal
        self.present(vc, animated: true)
    }
    
    func setupView() {
        recordingSession = AVAudioSession.sharedInstance()
        
        do {
            
            try recordingSession.setCategory(.playAndRecord, options: [.mixWithOthers, .defaultToSpeaker])
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
    
    func initReccordButton() {
        
        recordButton = ButtonReccordView(frame: self.view.bounds)
        self.view.addSubview(recordButton)
        recordButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            recordButton.topAnchor.constraint(equalTo: view.topAnchor),
            recordButton.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            recordButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            recordButton.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        recordButton.ringBack = { [weak self] button in
            DispatchQueue.main.asyncAfter(deadline: .now()) { [weak self] in
                if let strongSelf = self {
                    // strongSelf.recordButton.performModal(fromViewController: strongSelf)
                    AudioRecorderManager.shared.startRecording()
                    self?.startMonitoringSongFound()

                }
            }
        }
        
    }
    
    func startMonitoringSongFound() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 6) { [weak self] in
            guard let strongSelf = self else { return }

            if !strongSelf.songFound{
                AudioRecorderManager.shared.startRecording()
                print("Deuxieme tentative")
              //  self?.displayAudioReccord()
            }
            else {
            }
        }
    }

    
    
    func displayAudioReccord() {
        
        AudioRecorderManager.shared.sendReccord = { record in
            ApiRequest.sharedInstance.sendSongApi(record) {  apiSuccess, shazamData in
                if apiSuccess {
                    self.songFound = true
                    DispatchQueue.main.async { [weak self] in
                        if let retrieveArtist = shazamData?.result?.track?.subtitle,
                           let retrieveTitle = shazamData?.result?.track?.title {
                            
                            self?.sendDataToVc(data: shazamData!)
                            
                            let songWithoutFeat = retrieveTitle.removingContentInParentheses()
                            let trackWithoutFeat = songWithoutFeat.formattedTrackName()
                            let artist = retrieveArtist.removingAndContent()
                            print(trackWithoutFeat)
                            print(songWithoutFeat)
                            AudioRecorderManager.shared.finishRecording(success: true)
                            if apiSuccess {
                               // self?.recordButton.resetButton()
                            }
                            SearchRequest.sharedInstance.myTupleValue = (artist, trackWithoutFeat)
                            ResultSample.sharedInstance.displayTrack()
                        }
                    }
                }
                else {
                    self.songFound = false
                }
            }
        }
        
    }
    
    
    
}
extension String {
    func formattedTrackName() -> String {
        self.replacingOccurrences(of: " ", with: "%20")
            .replacingOccurrences(of: "’", with: "")
            .replacingOccurrences(of: "'", with: "'")
            .replacingOccurrences(of: "?", with: "")
            .replacingOccurrences(of: "é", with: "e")
            .replacingOccurrences(of: "à", with: "a")
            .replacingOccurrences(of: "-", with: "%20")
    }
    
    func removingAndContent() -> String {
        if let indexAnd = self.range(of: "&") {
            return String(self[..<indexAnd.lowerBound])
        }
        return self
    }
    
    func removingContentInParentheses() -> String {
        var result = self
        while let openParenthesisRange = result.range(of: "(") {
            if let closeParenthesisRange = result.range(of: ")", options: [], range: openParenthesisRange.upperBound..<result.endIndex) {
                result.removeSubrange(openParenthesisRange.lowerBound...closeParenthesisRange.lowerBound)
            } else {
                break // No matching closing parenthesis
            }
        }
        return result.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
