import UIKit
import AVFoundation


class ViewController: UIViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    
    
    var isRecording = false
    var animatedView: UIView!
    var recordButton: ButtonReccordView!
    
    var sendResultToSecondVc : ((ShazamResponse?) -> ())?
    @IBOutlet weak var reponseDeCall: UILabel!
    @IBOutlet weak var imageArtist: UIImageView!
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var audioPlayer: AVAudioPlayer!
 /*
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let secondVc = SecondViewController()
        self.present(secondVc, animated: true, completion: nil)
    }
   
*/
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        displayAudioReccord()
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
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
                if let strongSelf = self {
                    // strongSelf.recordButton.performModal(fromViewController: strongSelf)
                    AudioRecorderManager.shared.startRecording()
                }
            }
        }
    }
    
    func displayAudioReccord() {
        
        AudioRecorderManager.shared.sendReccord = { record in
            ApiRequest.sharedInstance.sendSongApi(record.url) {  apiSuccess, shazamData in
                if apiSuccess {
                    DispatchQueue.main.async { [weak self] in
                        if let retrieveArtist = shazamData?.result?.track?.subtitle , let retrieveTitle = shazamData?.result?.track?.title {
                            
                            self?.sendDataToVc(data: shazamData!)
                            
                            let songWithoutFeat = removeFeaturing(from: retrieveTitle)
                            
                            let trackWithoutFeat = formatTrackName(songWithoutFeat)
                            
                            let track = removeContentInParentheses(from: trackWithoutFeat)
                            
                            let artist = removeAndContent(artistName: retrieveArtist)
                            
                            AudioRecorderManager.shared.finishRecording(success: true)
                            if apiSuccess {
                                self?.recordButton.resetButton()
                            }
                            SearchRequest.sharedInstance.myTupleValue = (artist, track)
                            ResultSample.sharedInstance.displayTrack()
                        }
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


func removeContentInParentheses(from track: String) -> String {
    var result = track
    
    // Recherche la première parenthèse ouvrante "("
    if let openParenthesisRange = result.range(of: "(") {
        // Recherche la première parenthèse fermante ")" après la première parenthèse ouvrante
        if let closeParenthesisRange = result.range(of: ")", options: [], range: openParenthesisRange.upperBound..<result.endIndex, locale: nil) {
            // Supprime le contenu entre les parenthèses, y compris les parenthèses elles-mêmes
            result.removeSubrange(openParenthesisRange.lowerBound...closeParenthesisRange.lowerBound)
        }
    }
    
    // Supprime les espaces et retours à la ligne excédentaires autour du texte restant
    result = result.trimmingCharacters(in: .whitespacesAndNewlines)
    
    return result
}
func removeAndContent(artistName : String) -> String {
    
    if let indexAnd = artistName.range(of: "&") {
        var elementWithoutAnd = artistName[..<indexAnd.lowerBound]
        
        return String(elementWithoutAnd)
    }
    
    return artistName
    
}

func performModal(secondVc: UIViewController) {
    
}


func formatTrackName(_ artistName: String) -> String {
    var mediaName = ""
    
    artistName.forEach { char in
        switch char {
        case " ":
            mediaName += "%20"
            
        case "’":
            mediaName += ""
            
        case "'":
            mediaName += "'"
            
            
        case "?":
            
            mediaName += ""
            
            
        case "é":
            
            mediaName += "e"
            
            
        case "à":
            
            mediaName += "a"
            
            
        case "-":
            
            mediaName += "%20"
            
        default:
            mediaName += String(char)
        }
    }
    
    return mediaName
}
extension ViewController : Delegation {
    func superviseResult(result: Bool?) {
        
        //  performModal(fromViewController: self)
        
        
    }
}
