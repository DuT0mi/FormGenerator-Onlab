import Foundation
import CoreData

class CoreDataController: ObservableObject {
    let container = NSPersistentContainer(name: "QuestionCD")
    
    init(){
        container.loadPersistentStores { _, _ in }
    }
    
    func save(context: NSManagedObjectContext){
        context.perform {
            do {
                try context.save()
            } catch { }
        }
    }
    func addQuestion(context: NSManagedObjectContext, question paramQ: String, type: String){
        context.performAndWait {
            let question = QuestionCoreData(context: context)
            question.date = Date()
            question.uid = UserDefaults.standard.string(forKey: UserConstants.currentUserID.rawValue)
            question.id = UUID()
            question.question = paramQ
            question.type = type
            
            save(context: context)
        }
    }
    
    func editQuestion(context: NSManagedObjectContext, question: QuestionCoreData, question paramQ: String, type: String){
        context.performAndWait {
            question.date = Date()
            question.question = paramQ
            question.type = type
            save(context: context)
        }
    }
    
    func resetCoreData(context: NSManagedObjectContext) {
        context.perform{
            // Fetch all entities from Core Data and delete them
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "QuestionCoreData")
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            
            do {
                try context.execute(batchDeleteRequest)
                
                // Save the changes to the persistent store
                try context.save()
            } catch { }
        }
    }

}
