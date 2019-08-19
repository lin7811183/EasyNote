import Foundation
import UIKit
import CoreData

protocol EasyNoteManagerGroupListDelegate {
    func updateGroupListName(groupListName :String)
}

protocol EasyNoteManagerGroupListSelectDelegate {
    func selectGroupID()
    func updateSelectGroupID()
}

class EasyNoteManager {
    
    static let shared = EasyNoteManager()
    
    static var groudListCoreData = [GroupList]()
    static var groudIsSelectListCoreData = [GroupList]()
    static var isSelectGroupID = [String]()
    
    static var easyNoteCoreData = [EasyNote]()
    static var easyIsSelectNoteCoreData = [EasyNote]()
    
    static let moc = CoreDataHelper.shared.managedObjectContext()
    
    static var GroupListDelegate :EasyNoteManagerGroupListDelegate!
    static var SelectGroupDelegate :EasyNoteManagerGroupListSelectDelegate!
    
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
                    EasyNoteManager.easyIsSelectNoteCoreData = try moc.fetch(query)
                } catch {
                    print("core Data query erro \(error)")
                    EasyNoteManager.groudListCoreData = []
                }
            }
        } else if entityName == "GroupList" {
            let query = NSFetchRequest<GroupList>(entityName: entityName)
            let isSelectquery = NSFetchRequest<GroupList>(entityName: entityName)
            isSelectquery.predicate = NSPredicate(format: "isSelect == %@" , "1")
            //performAndWait.
            moc.performAndWait {
                do {
                    EasyNoteManager.groudListCoreData = try moc.fetch(query)
                    EasyNoteManager.groudIsSelectListCoreData = try moc.fetch(isSelectquery)
                    
                } catch {
                    print("core Data query erro \(error)")
                    EasyNoteManager.groudListCoreData = []
                }
            }
        }
    }
    
    //MARK: func - Group List Query COreData.
    func queryGroupListCoreData() {
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
    
    //MARK: func - Select isSelect Group List.
    func queryIsSelectGroupListCoreData() {
        let moc = CoreDataHelper.shared.managedObjectContext()
        let isSelectquery = NSFetchRequest<GroupList>(entityName: "GroupList")
        isSelectquery.predicate = NSPredicate(format: "isSelect == %@" , "1")
        //performAndWait.
        moc.performAndWait {
            do {
                EasyNoteManager.groudIsSelectListCoreData = try moc.fetch(isSelectquery)
                EasyNoteManager.SelectGroupDelegate.selectGroupID()
            } catch {
                print("core Data query erro \(error)")
                EasyNoteManager.groudIsSelectListCoreData = []
            }
        }
    }
    
    //MARK: func - Easy Note Query COreData.
    func queryEasyNoteCoreData(groupIDs :String) {
        let moc = CoreDataHelper.shared.managedObjectContext()
        //Create quert
        let query = NSFetchRequest<EasyNote>(entityName: "EasyNote")
        query.predicate = NSPredicate(format: "groupID == %@" , "\(groupIDs)")
        //performAndWait.
        moc.performAndWait {
            do {
                EasyNoteManager.easyNoteCoreData = try moc.fetch(query)
                EasyNoteManager.easyIsSelectNoteCoreData += EasyNoteManager.easyNoteCoreData
            } catch {
                print("core Data query erro \(error)")
                EasyNoteManager.groudListCoreData = []
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
