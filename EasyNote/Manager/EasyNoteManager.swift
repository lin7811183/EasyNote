import Foundation
import UIKit
import CoreData

protocol EasyNoteManagerGroupListDelegate {
    func updateGroupListName(groupListName :String)
}

class EasyNoteManager {
    
    static let shared = EasyNoteManager()
    
    static var groudListCoreData = [GroupList]()
    static var easyNoteCoreData = [EasyNote]()
    
    static let moc = CoreDataHelper.shared.managedObjectContext()
    
    static var GroupListDelegate :EasyNoteManagerGroupListDelegate!
    
    /*----------------------------------- Functions. -----------------------------------*/
    
    //MARK: func - Save CoreData.
    func saveCoreData() {
        CoreDataHelper.shared.saveContext()
    }
    
    //MARK: func - Query COreData.
    func queryCoreData(entityName :String) {
        let moc = CoreDataHelper.shared.managedObjectContext()
        //Create quert
        if entityName == "EasyNote" {
            let query = NSFetchRequest<EasyNote>(entityName: entityName)
            //performAndWait.
            moc.performAndWait {
                do {
                    EasyNoteManager.easyNoteCoreData = try moc.fetch(query)

                } catch {
                    print("core Data query erro \(error)")
                    EasyNoteManager.groudListCoreData = []
                }
            }
        } else if entityName == "GroupList" {
            let query = NSFetchRequest<GroupList>(entityName: entityName)
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
        
    }
    
    //MARK: func - UIAlert.
    func okAlert(vc: UIViewController, title: String, message: String) {
        let alert = UIAlertController(title: title, message: message,preferredStyle: .alert)
        let okAction = UIAlertAction(title: "確定", style: .default, handler: nil)
        alert.addAction(okAction)
        vc.present(alert, animated: true, completion: nil)
    }
    
    //MARK: func - 輸入對話框 Alter.
    func textAlter(vc: UIViewController, title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addTextField { (textfield) in
        }
        let okAction = UIAlertAction(title: "確認", style: .default) { (action) in
            if let newGroupListName = alert.textFields?[0] {
                EasyNoteManager.GroupListDelegate.updateGroupListName(groupListName: newGroupListName.text!)
            }
        }
        okAction.setValue(UIColor.black, forKey: "titleTextColor")
        alert.addAction(okAction)
        vc.present(alert, animated: true, completion: nil)
    }
}
