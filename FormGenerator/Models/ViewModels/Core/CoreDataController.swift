import Foundation
import CoreData

class CoreDataController: ObservableObject {
    let containerQ = NSPersistentContainer(name: "QuestionCD")
    let containerF = NSPersistentContainer(name: "FormModel")
    
    init(){
        containerQ.loadPersistentStores { _, _ in }
        containerF.loadPersistentStores { _, _ in }
    }
    
    func save(context: NSManagedObjectContext){
        context.perform {
            do {
                try context.save()
            } catch { }
        }
    }
    private func resetFormData(context: NSManagedObjectContext){
        context.perform{
            let fetchRequestF: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "FormCoreData")
            let predicate = NSPredicate(format: "cID == %@", argumentArray: [UserDefaults.standard.string(forKey: UserConstants.currentUserID.rawValue) as Any])
            fetchRequestF.predicate = predicate
            let batchDeleteRequestF = NSBatchDeleteRequest(fetchRequest: fetchRequestF)
            do {
                try context.execute(batchDeleteRequestF)
                
                try context.save()
            }catch{ }
        }
    }
    func addFormMetaData(context: NSManagedObjectContext, formData: FormData){
        context.performAndWait {
            resetFormData(context: context) // For getting the latest always
           let form = FormCoreData(context: context)
            form.type = formData.type
            form.answers = formData.answers
            form.cDesc = formData.description
            form.cID = formData.companyID
            form.cName = formData.companyName
            form.title = formData.title
            
            save(context: context)
        }
    }
    func addQuestion(context: NSManagedObjectContext, question paramQ: String, type: String){
        context.performAndWait {
            let question = QuestionCoreData(context: context)
            question.qDate = Date()
            question.uid = UserDefaults.standard.string(forKey: UserConstants.currentUserID.rawValue)
            question.id = UUID()
            question.question = paramQ
            question.type = type
            
            save(context: context)
        }
    }
    
    func editQuestion(context: NSManagedObjectContext, question: QuestionCoreData, question paramQ: String, type: String){
        context.performAndWait {
            question.qDate = Date()
            question.question = paramQ
            question.type = type
            save(context: context)
        }
    }
    func resetCoreData(context: NSManagedObjectContext) {
        context.perform{
            // Fetch all entities from Core Data and delete them
            let fetchRequestQ: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "QuestionCoreData")
            let predicateQ = NSPredicate(format: "uid == %@", argumentArray: [UserDefaults.standard.string(forKey: UserConstants.currentUserID.rawValue) as Any])
                fetchRequestQ.predicate = predicateQ
            let batchDeleteRequestQ = NSBatchDeleteRequest(fetchRequest: fetchRequestQ)
            
            let fetchRequestF: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "FormCoreData")
            let predicateF = NSPredicate(format: "cID == %@", argumentArray: [UserDefaults.standard.string(forKey: UserConstants.currentUserID.rawValue) as Any])
            fetchRequestF.predicate = predicateF
            let batchDeleteRequestF = NSBatchDeleteRequest(fetchRequest: fetchRequestF)
            
            do {
                try context.execute(batchDeleteRequestQ)
                try context.execute(batchDeleteRequestF)
                
                // Save the changes to the persistent store
                try context.save()
            } catch { }
        }
    }

}
