import Foundation

final class DemoData: ObservableObject{
    @Published var demoItems: [DemoItem]?
    
    init() {
        demoItems = load(from: "demoData.json")
    }
    
    func load<T>(from filename: String)-> T where T: Decodable{
            let data: Data

            guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
                else {
                    fatalError("Couldn't find \(filename) in main bundle.")
            }
            do {
                data = try Data(contentsOf: file)
            } catch {
                fatalError("Couldn't load \(filename) from main bundle:\n\(error)")                
            }
            do {
                let decoder = JSONDecoder()
                return try decoder.decode(T.self, from: data)
            } catch {
                fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
            }
        }
}
