import SwiftUI
import AVFoundation

struct AudioTypeView: View {
    @StateObject private var viewModel: AudioTypeViewModel = AudioTypeViewModel()
    @ObservedObject var observer: StartFormViewModel
    @State private var symbolColorChange: Bool = false
    @State private var audioPlayer: AVPlayer?
    @State private var isPlaying: Bool = false
    
    var question: DownloadedQuestion
    var notMocked: Bool = true
    
    private func playRecording() {
        guard let url = URL(string: question.audio_path!) else {return}
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
            if notMocked{
                TextField("Enter your answer: ", text: $viewModel.answer)
                    .lineLimit(nil)
                    .disabled(symbolColorChange ? true : false)
                Image(systemName: "rectangle.filled.and.hand.point.up.left")
                    .onTapGesture {
                        symbolColorChange = true
                        observer.answers.append((viewModel.answer, question.id!))
                        
                    }
                    .foregroundColor(symbolColorChange ? .green : .gray)
                    .disabled(symbolColorChange ? true : false)
                    .padding()
            }
        }
        .padding()
    }
}

struct AudioTypeView_Previews: PreviewProvider {
    static var previews: some View {
        AudioTypeView(observer: StartFormViewModel(), question: DownloadedQuestion(id: "1", formQuestion: "Hello", type: "aa", choices: ["a"], audio_path: "", image_url: "https://picsum.photos/200/300"))
    }
}
