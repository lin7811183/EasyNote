import Foundation
import CoreData

class GroupList :NSManagedObject {
    
    @NSManaged var groupID :String?
    @NSManaged var groupColor :String?
    @NSManaged var groupName :String?
    @NSManaged var isSelect :Bool
    
    override func awakeFromInsert() {
        self.isSelect = false
    }
    
}
