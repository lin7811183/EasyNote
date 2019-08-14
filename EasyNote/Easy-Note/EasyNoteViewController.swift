import UIKit

class EasyNoteViewController: UIViewController {
    
    @IBOutlet weak var easyNoteSV: UIScrollView!
    @IBOutlet weak var groupListBT: UIBarButtonItem!
    @IBOutlet weak var noteCV: UICollectionView!
    
    var isOpenGroupList :Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: func - 展開 Group List.
    @IBAction func groupList(_ sender: UIBarButtonItem) {
        if self.isOpenGroupList == false {
            self.easyNoteSV.setContentOffset(CGPoint(x: 200, y: 0), animated: true)
            self.groupListBT.tintColor = UIColor.red
            self.isOpenGroupList = true
        } else {
            self.easyNoteSV.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            self.groupListBT.tintColor = UIColor.black
            self.isOpenGroupList = false
        }
    }
    
    //MARK: func - add New Note.
    @IBAction func addNewNote(_ sender: UIBarButtonItem) {
        let addNewNoteVC = self.storyboard?.instantiateViewController(withIdentifier: "AddNewNoteVC") as! AddNewNoteViewController
        self.present(addNewNoteVC, animated: true, completion: nil)
    }
}
