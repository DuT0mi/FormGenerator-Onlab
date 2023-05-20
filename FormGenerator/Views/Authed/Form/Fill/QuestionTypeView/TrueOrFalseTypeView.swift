import SwiftUI

struct TrueOrFalseTypeView: View {
    @StateObject private var viewModel: TrueOrFalseTypeViewModel = TrueOrFalseTypeViewModel()
    @ObservedObject var observed: StartFormViewModel
    @State private var symbolColorChange: Bool = false
    var question: String
    
    var body: some View {
        VStack{
            Text(question)
                .downloadedQuestionTemplateModifier()
                HStack{
                    Circle()
                        .frame(width: 25, height: 25)
                        .foregroundColor((viewModel.selectedOption ?? false) ? .accentColor : .gray)
                        .onTapGesture {
                            if !symbolColorChange{
                                viewModel.selectedOption = true
                            }
                        }
                    Text("True")
                        .foregroundColor(.accentColor)
                    Spacer()
                }
                HStack{
                    Circle()
                        .frame(width: 25, height: 25)
                        .foregroundColor(!(viewModel.selectedOption ?? false) ? .accentColor : .gray)
                        .onTapGesture {
                            viewModel.selectedOption = false
                        }
                    Text("False")
                        .foregroundColor(.accentColor)
                    Spacer()
                }
            Image(systemName: "rectangle.filled.and.hand.point.up.left")
                .onTapGesture {
                    symbolColorChange = true
                    observed.answers.append(viewModel.selectedOption?.description ?? "false")
                }
                .foregroundColor(symbolColorChange ? .green : .gray)
                .disabled(symbolColorChange ? true : false)
                .padding()
        }
        .padding()
    }
}

struct TrueOrFalseTypeView_Previews: PreviewProvider {
    static var previews: some View {
        TrueOrFalseTypeView(observed: StartFormViewModel(), question: "True or False?")
    }
}
