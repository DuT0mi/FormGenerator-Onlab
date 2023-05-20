import SwiftUI

//MARK: credits: https://stackoverflow.com/questions/66601955/is-there-support-for-something-like-timepicker-hours-mins-secs-in-swiftui

struct AddTimerView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: TimerViewModel 
    @State private var selectionHour: Int = 0
    @State private var selectionMinute: Int = 0
    @State private var selectionSecond: Int = 0
    @State private var showAlert: Bool = false
    
    let columns = [
        MultiComponentPicker.Column(label: "h", options: Array(0...23).map { MultiComponentPicker.Column.Option(text: "\($0)", tag: $0) }),
        MultiComponentPicker.Column(label: "min", options: Array(0...59).map { MultiComponentPicker.Column.Option(text: "\($0)", tag: $0) }),
        MultiComponentPicker.Column(label: "sec", options: Array(0...59).map { MultiComponentPicker.Column.Option(text: "\($0)", tag: $0) }),
    ]
    
    private func getIntervalInSeconds() -> Int{
        ((selectionHour * 60 * 60) + (selectionMinute * 60) + (selectionSecond))
    }
    
    var body: some View {
        VStack {
            MultiComponentPicker(columns: columns, selections: [
                Binding<Int>(get: { self.selectionHour }, set: { self.selectionHour = $0 }),
                Binding<Int>(get: { self.selectionMinute }, set: { self.selectionMinute = $0 }),
                Binding<Int>(get: { self.selectionSecond }, set: { self.selectionSecond = $0 })
            ])
            .frame(height: 300)
            .padding()
            
            Group{
                Text("Selections: \(selectionHour)h \(selectionMinute)min \(selectionSecond)sec")
                if viewModel.calculatedTime > 0 { // Set to something
                    Text("Already set to: \(viewModel.calculatedTime)s")
                        .italic()
                        .foregroundColor(.accentColor)
                }
            }
            .padding()
            .bold()
            .font(.caption)
                
            Button {
                if getIntervalInSeconds() < 30 {
                    showAlert = true
                } else {
                    viewModel.calculatedTime = getIntervalInSeconds()
                    dismiss.callAsFunction()
                }
            } label: {
                Label("Set", systemImage: "clock")
            }
            .buttonBorderShape(.capsule)
            .buttonStyle(.borderedProminent)
            .alert("The minimum time is at least 30 seconds!", isPresented: $showAlert) {
                Button(role:.destructive){
                    
                } label: {
                    Text("Got it!")
                }
            }
        }
    }
}
