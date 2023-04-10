import Foundation
import CoreData

class CoreDataController: ObservableObject {
    let container = NSPersistentContainer(name: "QuestionCD")
    
    init(){
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Failed to load the data: \(error.localizedDescription)")
            }
        }
    }
    
    func save(context: NSManagedObjectContext){
        do {
            try context.save()
            print("Saved")
        } catch {
            print(error.localizedDescription)
        }
    }
    func addQuestion(context: NSManagedObjectContext, question paramQ: String, type: String){
       let question = QuestionCoreData(context: context)
        question.id = UUID()
        question.question = paramQ
        question.type = type
        
    save(context: context)
        
    }
    
    func editQuestion(context: NSManagedObjectContext, question: QuestionCoreData, question paramQ: String, type: String){
        question.question = paramQ
        question.type = type
    }
}
