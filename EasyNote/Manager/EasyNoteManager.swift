import Foundation
import UIKit
import CoreData

class EasyNoteManager {
    
    static let shared = EasyNoteManager()
    static var groudListCoreData :[GroupList] = []
    
    /*------------------------------------------------------------ Functions. ------------------------------------------------------------*/
    
    //MARK: func - Save CoreData.
    func saveCoreData() {
        CoreDataHelper
    }
    
    //MARK: func - Query COreData.
    func queryCoreData() {
        let moc = CoreDataHelper.shared.managedObjectContext()
        //Create quert
        let query = NSFetchRequest<GroupList>(entityName: "GroupList")
        //performAndWait.
        moc.performAndWait {
            do {
                EasyNoteManager.groudListCoreData = try moc.fetch(query)
            } catch {
                print("core Data query erro \(error)")
                EasyNoteManager.groudListCoreData = []
            }
        }
    }
    
    //MARK: func - UIAlert.
    func okAlter(vc: UIViewController, title: String, message: String) {
        let alter = UIAlertController(title: title, message: message,preferredStyle: .alert)
        let okAction = UIAlertAction(title: "確定", style: .default, handler: nil)
        alter.addAction(okAction)
        vc.present(alter, animated: true, completion: nil)
    }
}
