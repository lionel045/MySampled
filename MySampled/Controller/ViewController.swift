import AVFoundation
import UIKit

protocol Delegation {
    func sendData(data: ShazamResponse)
}

class ViewController: UIViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    var animatedView: UIView!
    var recordButton: ButtonReccordView!
    var checkIfSongFound: ((Bool?) -> Void)?
    var songFound = false
    var sendResultToSecondVc: ((ShazamResponse?) -> Void)?
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var delegate: Delegation?

    //    override func viewDidAppear(_ animated: Bool) {
    //        super.viewDidAppear(animated)
    //
    //        let secondVc = SecondViewController()
    //        present(secondVc, animated: true, completion: nil)
    //    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "darkMode")
        setupView()
        initReccordButton()
        displayAudioRecord()
    }

    private func showNoSoundFoundAlert() {
        let alert = UIAlertController(title: "Error", message: "No sound found", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }

    func sendDataToVc(data: ShazamResponse, sampleData: ([TrackSample?], [TrackSample?])) async {
        let shazamObject = data
        guard let backgroundImage = shazamObject.result?.track?.images?.background else { return }
        guard let artist: String = shazamObject.result?.track?.subtitle else { return }
        guard let song: String = shazamObject.result?.track?.title else { return }

        let artistAndSong = (artist, song)

        let secondVc = SecondViewController()
        Task {
            await secondVc.addCoverImage(imageCoverURL: backgroundImage, label: artistAndSong)
            await secondVc.addSampleArray(containSample: sampleData.0, sampledIn: sampleData.1)
        }

        let feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
        feedbackGenerator.impactOccurred()
        secondVc.modalTransitionStyle = .flipHorizontal
        present(secondVc, animated: true)
    }

    func setupView() {
        recordingSession = AVAudioSession.sharedInstance()

        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default, options: [.mixWithOthers, .allowBluetoothA2DP, .defaultToSpeaker])
            try recordingSession.setActive(true, options: .notifyOthersOnDeactivation)
            recordingSession.requestRecordPermission { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                    } else {
                        self.recordButton.isEnabled = false
                    }
                }
            }
        } catch {}
    }

    func initReccordButton() {
        recordButton = ButtonReccordView(frame: view.bounds)
        view.addSubview(recordButton)
        recordButton.translatesAutoresizingMaskIntoConstraints = false
        recordButton.clipsToBounds = false
        NSLayoutConstraint.activate([
            recordButton.topAnchor.constraint(equalTo: view.topAnchor),
            recordButton.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            recordButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            recordButton.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        recordButton.ringBack = { [weak self] _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
                if let strongSelf = self {
                    AudioRecorderManager.shared.startRecording()
                    strongSelf.startMonitoringSongFound()
                }
            }
        }
    }

    func startMonitoringSongFound() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 6) { [weak self] in
            guard let strongSelf = self else { return }

            if !strongSelf.songFound {
                // AudioRecorderManager.shared.startRecording()
                // print("Deuxieme tentative")
            } else {}
        }
    }

    func displayAudioRecord() {
        AudioRecorderManager.shared.sendReccord = { [weak self] record in
            Task {
                do {
                    let shazamData = try await ApiRequest.sharedInstance.sendSongApi(record)
                    if let retrieveArtist = shazamData.result?.track?.subtitle,
                       let retrieveTitle = shazamData.result?.track?.title {

                        let songWithoutFeat = retrieveTitle.removingContentInParenthesesAndBrackets()
                        let trackWithoutFeat = songWithoutFeat.formattedTrackName()
                        let artist = retrieveArtist.removingAndContent()

                        DispatchQueue.main.async {
                            SearchRequest.sharedInstance.myTupleValue = (artist.lowercased(), trackWithoutFeat, retrieveTitle)

                            Task {
                                let sampleData = await ResultSample.sharedInstance.displayTrack()
                                await self?.sendDataToVc(data: shazamData, sampleData: sampleData)
                            }
                        }
                    } else {
                        DispatchQueue.main.async {
                            self?.showNoSoundFoundAlert()
                        }
                    }
                } catch {
                    print("Erreur lors de la requête : \(error)")

                }
            }
        }
    }

}
