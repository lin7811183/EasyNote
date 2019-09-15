import Foundation

class GrupoListColor {
    
    static let shared = GrupoListColor()
    static var groupListColorArray = [String]()
    
    //MARK: func - 產出顏色陣列
    func outPutColor() -> [String] {
        
        for i in 1...35 {
            
            let colorName = "Note-Group-\(i)"
            
            GrupoListColor.groupListColorArray.append(colorName)
        }
        return GrupoListColor.groupListColorArray
    }
    
}
