import SwiftUI
import AVFoundation

struct VoiceRecorderView: View {
    @State private var isRecording: Bool = false
    @State private var isPlaying: Bool = false
    @State private var audioRecorder: AVAudioRecorder?
    @State private var audioPlayer: AVAudioPlayer?
    @State private var recordedAudioURL: URL?
    @State private var fillColor: Color = .red
    
    fileprivate var waveComponent: some View {
            Image(systemName: "waveform")
                .resizable()
                .frame(width: 75, height: 75)
                .foregroundColor(fillColor)
                .onAppear{
                    withAnimation(.easeInOut(duration: 2.0).repeatForever()){
                        fillColor = .blue
                    }
                }
    }
    var body: some View {
        HStack{
            Spacer()
            VStack {
                waveComponent
                if isRecording {
                    Group{
                        Text("Recording...")
                            .foregroundColor(.red)
                        Button {
                            stopRecording()
                        } label: {
                            Label("Stop", systemImage: "stop.circle")
                        }
                    }
                    .padding()
                    
                } else if !isPlaying{
                    Button {
                        startRecording()
                    } label: {
                        Label("Record", systemImage: "record.circle")
                    }
                    .padding()
                    
                }
                if isPlaying {
                    Group{
                        Text("Playing...")
                            .foregroundColor(.green)
                        Button {
                            stopPlaying()
                        } label: {
                            Label("Stop",systemImage: "stop.circle")
                        }
                        
                    }
                    .padding()
                } else if recordedAudioURL != nil, !isRecording {
                    Button {
                        playRecording()
                    } label: {
                        Label("Play", systemImage: "play.circle")
                    }
                    .padding()
                }
            }
            Spacer()
        }
    }

    private func startRecording() {
        let audioSession = AVAudioSession.sharedInstance()

        do {
            try audioSession.setCategory(.playAndRecord, mode: .default)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)

            let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let audioFilename = documentsPath.appendingPathComponent("recording.m4a")

            let settings: [String: Any] = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 12000,
                AVNumberOfChannelsKey: 1,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]

            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder?.record()

            isRecording = true
        } catch {
            print("Error starting recording: \(error.localizedDescription)")
        }
    }
    private func stopRecording() {
        audioRecorder?.stop()
        isRecording = false
        recordedAudioURL = audioRecorder?.url
    }
    private func playRecording() {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: recordedAudioURL!)
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
            isPlaying = true
        } catch {
            print("Error playing recording: \(error.localizedDescription)")
        }
    }
    private func stopPlaying() {
        audioPlayer?.stop()
        isPlaying = false
    }
}

struct VoiceRecorderView_Previews: PreviewProvider {
    static var previews: some View {
        VoiceRecorderView()
    }
}
