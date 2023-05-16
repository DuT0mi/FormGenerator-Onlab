import SwiftUI
import AVFoundation

struct AudioTypeView: View {
    @StateObject private var viewModel: AudioTypeViewModel = AudioTypeViewModel()
    @State private var audioPlayer: AVPlayer?
    @State private var isPlaying: Bool = false
    
    var audioPath: String
    
    private func playRecording() {
        guard let url = URL(string: audioPath) else {return}
        let audioPlayerItem = AVPlayerItem(url: url)
        audioPlayer = AVPlayer(playerItem: audioPlayerItem)
        audioPlayer?.play()
        isPlaying = true
    }
    private func stopPlaying() {
        audioPlayer?.pause()
        isPlaying = false
    }
    
    var body: some View {
        VStack{
            HStack{
                if isPlaying{
                    Button{
                        stopPlaying()
                    }label: {
                        Label("Stop playing", systemImage: "pause")
                            .foregroundColor(.accentColor)
                    }                    
                } else {
                    Button{
                        playRecording()
                    } label: {
                        Label("Start playing", systemImage: "play")
                            .foregroundColor(.accentColor)
                    }
                }
            }
            TextField("Enter your answer: ", text: $viewModel.answer)
                .lineLimit(nil)
        }
        .padding()
    }
}

struct AudioTypeView_Previews: PreviewProvider {
    static var previews: some View {
        AudioTypeView(audioPath:"a")
    }
}
