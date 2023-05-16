import SwiftUI

struct TrueOrFalseTypeView: View {
    @StateObject private var viewModel: TrueOrFalseTypeViewModel = TrueOrFalseTypeViewModel()
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
                            viewModel.selectedOption = true
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
        }
        .padding()
    }
}

struct TrueOrFalseTypeView_Previews: PreviewProvider {
    static var previews: some View {
        TrueOrFalseTypeView(question: "True or False?")
    }
}
