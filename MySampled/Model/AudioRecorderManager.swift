import AVFoundation

class AudioRecorderManager: NSObject {
    static let shared = AudioRecorderManager()
    override private init() {}

    private var audioEngine: AVAudioEngine?
    private var audioFile: AVAudioFile?
    var sendReccord: ((URL) -> Void)?
    func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playAndRecord, mode: .default, options: [.mixWithOthers, .allowBluetoothA2DP, .defaultToSpeaker])
            try AVAudioSession.sharedInstance().setActive(true)

        } catch {
            print("Setting up audio session failed.")
        }
    }

    func startRecording() {
        audioEngine = AVAudioEngine()
        let audioSession = AVAudioSession.sharedInstance()
        let sampleRate = audioSession.sampleRate
        let audioFormat = AVAudioFormat(commonFormat: .pcmFormatFloat32, sampleRate: sampleRate, channels: AVAudioChannelCount(audioSession.outputNumberOfChannels), interleaved: false)
        guard let inputNode = audioEngine?.inputNode else {
            print("Error: Couldn't fetch inputNode.")
            return
        }
        let audioFilename = getFileURL()
        // Delete the file if it already exists
        do {
            if FileManager.default.fileExists(atPath: audioFilename.path) {
                try FileManager.default.removeItem(at: audioFilename)
            }
        } catch {
            print("Error: Could not delete existing audio file.")
            return
        }
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: Int(audioFormat!.sampleRate),
            AVNumberOfChannelsKey: Int(audioFormat!.channelCount),
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]

        do {
            audioFile = try AVAudioFile(forWriting: audioFilename, settings: settings)
        } catch {
            print("Error: Couldn't create AVAudioFile for writing. \(error)")
            return
        }

        inputNode.installTap(onBus: 0, bufferSize: 8192, format: audioFormat) { [weak self] buffer, _ in
            do {
                try self?.audioFile?.write(from: buffer)
            } catch let writeError {
                print("Error during buffer write: \(writeError.localizedDescription)")
            }
        }

        do {
            try audioEngine?.start()
        } catch {
            print("Error: Couldn't start AVAudioEngine.")
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak self] in
            self?.stopRecording()
        }
    }

    private func stopRecording() {
        audioEngine?.stop()
        audioEngine?.inputNode.removeTap(onBus: 0)
        finishRecording(success: true)
        finalizeAudioFile() // Nouvelle méthode pour finaliser le fichier
    }

    func finishRecording(success: Bool) {
        if success {
            print("Recording completed successfully.")

        } else {
            print("Recording failed.")
        }
    }

    private func finalizeAudioFile() {
        audioFile = nil // Libère l'objet AVAudioFile, ce qui devrait finaliser l'écriture du fichier
        let fileURL = getFileURL()
        sendReccord?(fileURL)
    }

    private func getFileURL() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0].appendingPathComponent("recording.m4a")
    }
}
