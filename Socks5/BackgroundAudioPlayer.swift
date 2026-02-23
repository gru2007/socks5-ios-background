//
//  BackgroundAudioPlayer.swift
//  Socks5
//

import AVFoundation

class BackgroundAudioPlayer {
    static let shared = BackgroundAudioPlayer()

    private var audioPlayer: AVAudioPlayer?

    private init() {
        setupAudioSession()
        setupAudioPlayer()
    }

    private func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(
                .playback,
                options: .mixWithOthers
            )
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("BackgroundAudioPlayer: Failed to setup audio session: \(error)")
        }
    }

    private func setupAudioPlayer() {
        let audioData = Self.silentAudioData()
        do {
            audioPlayer = try AVAudioPlayer(data: audioData, fileTypeHint: "wav")
            audioPlayer?.volume = 0.01
            audioPlayer?.numberOfLoops = -1
            audioPlayer?.prepareToPlay()
        } catch {
            print("BackgroundAudioPlayer: Failed to setup audio player: \(error)")
        }
    }

    func start() {
        audioPlayer?.play()
    }

    func stop() {
        audioPlayer?.stop()
    }

    // Generates a minimal silent WAV (0.1 second, 44100 Hz, mono, 16-bit PCM)
    private static func silentAudioData() -> Data {
        let sampleRate: Int32 = 44100
        let numSamples: Int32 = 4410
        let numChannels: Int16 = 1
        let bitsPerSample: Int16 = 16
        let byteRate = sampleRate * Int32(numChannels) * Int32(bitsPerSample) / 8
        let blockAlign = numChannels * bitsPerSample / 8
        let dataSize = numSamples * Int32(numChannels) * Int32(bitsPerSample) / 8
        let fileSize = 36 + dataSize

        var data = Data()
        data.append(contentsOf: "RIFF".utf8)
        appendInt32LE(&data, fileSize)
        data.append(contentsOf: "WAVE".utf8)
        data.append(contentsOf: "fmt ".utf8)
        appendInt32LE(&data, 16)
        appendInt16LE(&data, 1)  // PCM format
        appendInt16LE(&data, numChannels)
        appendInt32LE(&data, sampleRate)
        appendInt32LE(&data, byteRate)
        appendInt16LE(&data, blockAlign)
        appendInt16LE(&data, bitsPerSample)
        data.append(contentsOf: "data".utf8)
        appendInt32LE(&data, dataSize)
        data.append(contentsOf: [UInt8](repeating: 0, count: Int(dataSize)))

        return data
    }

    private static func appendInt32LE(_ data: inout Data, _ value: Int32) {
        withUnsafeBytes(of: value.littleEndian) { data.append(contentsOf: $0) }
    }

    private static func appendInt16LE(_ data: inout Data, _ value: Int16) {
        withUnsafeBytes(of: value.littleEndian) { data.append(contentsOf: $0) }
    }
}
