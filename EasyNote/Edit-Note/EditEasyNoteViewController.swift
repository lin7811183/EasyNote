import UIKit

protocol EditEasyNoteViewControllerDelegate {
    func updateEasyNote()
}

class EditEasyNoteViewController: UIViewController {
    
    @IBOutlet weak var groupColorCV: UICollectionView!
    @IBOutlet weak var blackView: UIView!
    @IBOutlet weak var groupColorView: UIView!
    @IBOutlet weak var noteDateLB: UILabel!
    @IBOutlet weak var noteTF: UITextView!
    
    var getIndexPath :IndexPath!
    
    var delegate :EditEasyNoteViewControllerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 設定選取便便貼.
        guard let indexPath = self.getIndexPath else {
            print("Error : self.getIndexPath error.")
            return
        }
        
        self.blackView.layer.borderWidth = 1.0
        self.blackView.layer.borderColor = UIColor.lightGray.cgColor

        self.groupColorView.layer.borderWidth = 1000000.0
        
        let data = EasyNoteManager.easyIsSelectNoteCoreData[indexPath.row]
        
        self.groupColorView.layer.borderColor = UIColor(named: data.groupColor!)?.cgColor

        self.noteDateLB.text = data.noteDate!

        self.noteTF.text = data.noteText!
    }
    
    /*----------------------------------- Functions. -----------------------------------*/
    
    //MARK: func - Delete Note.
    @IBAction func deleteNote(_ sender: UIBarButtonItem) {
        // Delete easyIsSelectNoteCoreData data.
        let deleteData = EasyNoteManager.easyIsSelectNoteCoreData[self.getIndexPath.row]
        EasyNoteManager.easyIsSelectNoteCoreData.remove(at: self.getIndexPath.row)
        // Delete coredaa.
        EasyNoteManager.moc.delete(deleteData)
        EasyNoteManager.shared.saveCoreData()
        
        self.delegate.updateEasyNote()
        
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: func - Save Note.
    @IBAction func saveNote(_ sender: UIBarButtonItem) {
        // Save easyIsSelectNoteCoreData data.
        EasyNoteManager.easyIsSelectNoteCoreData[self.getIndexPath.row].noteText = self.noteTF.text!
        // Save CoreData.
        EasyNoteManager.shared.saveCoreData()
        
        self.delegate.updateEasyNote()
        
        self.navigationController?.popViewController(animated: true)
    }
}
