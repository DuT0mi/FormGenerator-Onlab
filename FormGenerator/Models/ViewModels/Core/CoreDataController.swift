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
    
    func resetCoreData(context: NSManagedObjectContext) {
        // Fetch all entities from Core Data and delete them
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "QuestionCoreData")
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(batchDeleteRequest)
            
            // Save the changes to the persistent store
            try context.save()
            print("Core Data model reset successful")
        } catch {
            print("Failed to reset Core Data model: \(error.localizedDescription)")
        }
    }

}
