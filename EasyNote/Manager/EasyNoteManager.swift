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

protocol EasyNoteDeleteGroupListID {
    func changeGroupID()
}

class EasyNoteManager {
    
    static let shared = EasyNoteManager()
    
    static var groudListCoreData = [GroupList]()
    static var groudIsSelectListCoreData = [GroupList]()
    static var isSelectGroupID = [String]()
    
    static var easyNoteCoreData = [EasyNote]()
    static var easyIsSelectNoteCoreData = [EasyNote]()
    static var changeGroupIdEasyNoteCoreData = [EasyNote]()
    
    static var deleteGroupListId :String!
    
    static let moc = CoreDataHelper.shared.managedObjectContext()
    
    static var groupListDelegate :EasyNoteManagerGroupListDelegate!
    static var selectGroupDelegate :EasyNoteManagerGroupListSelectDelegate!
    static var deleteGroupDelete :EasyNoteDeleteGroupListID!
    
    /*----------------------------------- Functions. -----------------------------------*/
    
    //MARK: func - Save CoreData.
    func saveCoreData() {
        CoreDataHelper.shared.saveContext()
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
                EasyNoteManager.selectGroupDelegate.selectGroupID()
            } catch {
                print("core Data query erro \(error)")
                EasyNoteManager.groudIsSelectListCoreData = []
            }
        }
    }
    
    //MARK: func - Easy Note Query CoreData.
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
                EasyNoteManager.shared.easyNoteDateSort(easyNote: EasyNoteManager.easyIsSelectNoteCoreData)
            } catch {
                print("core Data query erro \(error)")
                EasyNoteManager.groudListCoreData = []
                EasyNoteManager.easyIsSelectNoteCoreData = []
            }
        }
    }
    
    //MARK: func - easy note 時間排序.
    func easyNoteDateSort(easyNote :[EasyNote]) {
        // 轉換時間.
        for i in 0 ..< easyNote.count {
            let data = easyNote
            if let dateString = data[i].noteDate {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
                let date = dateFormatter.date(from: dateString)
                EasyNoteManager.easyIsSelectNoteCoreData[i].sortDate = date
            }
        }
        // 排序每筆note時間.
        EasyNoteManager.easyIsSelectNoteCoreData = EasyNoteManager.easyIsSelectNoteCoreData.sorted(by: { $0.sortDate!.compare($1.sortDate!) == .orderedDescending
        })
    }
    
    //MARK: func - delete group to Easy Note default groupid.
    func deleteGroupIdToChangeEasyNoteDefaultID(deleteGroupID :String) {
        let moc = CoreDataHelper.shared.managedObjectContext()
        //Create quert
        let query = NSFetchRequest<EasyNote>(entityName: "EasyNote")
        query.predicate = NSPredicate(format: "groupID == %@" , "\(deleteGroupID)")
        //performAndWait.
        moc.performAndWait {
            do {
                EasyNoteManager.changeGroupIdEasyNoteCoreData = try moc.fetch(query)
                EasyNoteManager.deleteGroupDelete.changeGroupID()
            } catch {
                print("core Data query erro \(error)")
                EasyNoteManager.changeGroupIdEasyNoteCoreData = []
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
                EasyNoteManager.groupListDelegate.updateGroupListName(groupListName: newGroupListName.text!)
            }
        }
        okAction.setValue(UIColor.black, forKey: "titleTextColor")
        alert.addAction(okAction)
        vc.present(alert, animated: true, completion: nil)
    }
}
