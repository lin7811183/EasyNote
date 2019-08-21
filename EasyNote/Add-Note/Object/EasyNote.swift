import Foundation
import CoreData

class EasyNote: NSManagedObject {
    
    @NSManaged var groupID :String?
    @NSManaged var groupColor :String?
    @NSManaged var noteDate :String?
    @NSManaged var noteText :String?
    var sortDate :Date?
}
