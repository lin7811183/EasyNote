import UIKit

protocol EditEasyNoteViewControllerDelegate {
    func updateEasyNote()
}

class EditEasyNoteViewController: UIViewController {
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var groupColorCV: UICollectionView!
    @IBOutlet weak var blackView: UIView!
    @IBOutlet weak var groupColorView: UIView!
    @IBOutlet weak var noteDateLB: UILabel!
    @IBOutlet weak var noteTF: UITextView!
    
    var getIndexPath :IndexPath!
    
    var delegate :EditEasyNoteViewControllerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Pattern Image
//        if let pattern = UIImage(named: "App-Back-Grond-Icon") { //加入背景圖
//            let bk = UIColor(patternImage: pattern) //把背景圖變成顏色
//            self.mainView.backgroundColor = bk//設定成背景色
//            self.view.backgroundColor = bk//設定成背景色
//            self.blackView.backgroundColor = UIColor.white
//            self.groupColorCV.backgroundColor = bk
//        }
        self.view.backgroundColor = UIColor(named: "Back-Ground-Color")
        
        //陰影
        self.blackView.layer.shadowColor = UIColor.darkGray.cgColor
        self.blackView.layer.shadowOpacity = 0.5 //透明度
        self.blackView.layer.shadowOffset = CGSize(width: 10, height: 10)
        
        // 設定選取便便貼.
        guard let indexPath = self.getIndexPath else {
            print("Error : self.getIndexPath error.")
            return
        }
        
        let data = EasyNoteManager.easyIsSelectNoteCoreData[indexPath.row]

        self.noteDateLB.backgroundColor = UIColor(named: data.groupColor!)
        self.noteDateLB.text = data.noteDate!
        
        self.noteTF.text = data.noteText!
        
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.back(sender:)))
        newBackButton.image = UIImage(named: "Back-Icon")
        self.navigationItem.leftBarButtonItem = newBackButton
    }
    
    /*----------------------------------- Functions. -----------------------------------*/
    
    @objc func back(sender: UIBarButtonItem) {
        // Save easyIsSelectNoteCoreData data.
        EasyNoteManager.easyIsSelectNoteCoreData[self.getIndexPath.row].noteText = self.noteTF.text!
        // Save CoreData.
        EasyNoteManager.shared.saveCoreData()
        
        self.delegate.updateEasyNote()
        
        self.navigationController?.popViewController(animated: true)
    }
    
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
