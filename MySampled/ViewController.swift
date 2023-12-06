import UIKit
import AVFoundation

protocol Delegation {
    
    func sendData( data: ShazamResponse)
    
    
}

class ViewController: UIViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    
    
    var animatedView: UIView!
    var recordButton: ButtonReccordView!
    var checkIfSongFound: ((Bool?) -> ())?
    var songFound = false
    var sendResultToSecondVc : ((ShazamResponse?) -> ())?
    @IBOutlet weak var reponseDeCall: UILabel!
    @IBOutlet weak var imageArtist: UIImageView!
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var delegate: Delegation?
 
    override func viewDidAppear(_ animated: Bool) {
         super.viewDidAppear(animated)
    
         let secondVc = SecondViewController()
         self.present(secondVc, animated: true, completion: nil)
         }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        displayAudioReccord()
        
    }
    
    
    func sendDataToVc(data: ShazamResponse) async {
        
        let shazamObject = data
        
        guard let backgroundImage = shazamObject.result?.track?.images?.background else { return }
        
        guard let artist: (String) = shazamObject.result?.track?.subtitle else { return }
        
        guard let song: (String) = shazamObject.result?.track?.title else { return }
                
        let artistAndSong =  (artist,song)
        
        let vc = SecondViewController()
        Task {
          //  try await  ImageDownloadService().downloadImage(artistImage: backgroundImage)
          try await vc.artistImageView.addCoverImage(imageCoverURL: backgroundImage)
            
        }
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
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
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
                // AudioRecorderManager.shared.startRecording()
                //print("Deuxieme tentative")
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
                            Task {
                             await self?.sendDataToVc(data: shazamData!)
                            }
                            let songWithoutFeat = retrieveTitle.removingContentInParentheses()
                            let trackWithoutFeat = songWithoutFeat.formattedTrackName()
                            let artist = retrieveArtist.removingAndContent()
                            print(trackWithoutFeat)
                            print(songWithoutFeat)
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


