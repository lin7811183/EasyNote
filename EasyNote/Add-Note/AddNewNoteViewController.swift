import UIKit

protocol AddNewNoteViewControllerDelegate {
    func addEasyNote()
}

class AddNewNoteViewController: UIViewController {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var addEasyNoteTB: UINavigationBar!
    @IBOutlet weak var groupListCV: UICollectionView!
    @IBOutlet weak var NoteTF: UITextView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var groupListColorView: UIView!
    @IBOutlet weak var addNewEasyNoteTarBar: UINavigationBar!
    
    var oldColorIndexPath :IndexPath!
    
    var newEasyNoteGroupID :String!
    var newEasyNoteGroupColor :String!
    
    var delegate :AddNewNoteViewControllerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.backView.layer.borderWidth = 1.0
//        self.backView.layer.borderColor = UIColor.black.cgColor
        
        //陰影
        self.backView.layer.shadowColor = UIColor.darkGray.cgColor
        self.backView.layer.shadowOpacity = 0.5 //透明度
        self.backView.layer.shadowOffset = CGSize(width: 10, height: 10)
        
        self.groupListColorView.layer.borderWidth = 1000000.0
        self.groupListColorView.layer.borderColor = UIColor.lightGray.cgColor
        
        //Pattern Image
//        if let pattern = UIImage(named: "App-Back-Grond-Icon") { //加入背景圖
//            let bk = UIColor(patternImage: pattern) //把背景圖變成顏色
//            self.view.backgroundColor = bk//設定成背景色
//            self.addEasyNoteTB.barTintColor = bk//設定成背景色
//            self.mainView.backgroundColor = bk//設定成背景色
//            self.groupListCV.backgroundColor = bk//設定成背景色
//            self.view.backgroundColor = bk
//        }
        self.view.backgroundColor = UIColor(named: "Back-Ground-Color")
        
        self.addNewEasyNoteTarBar.barTintColor = UIColor(named: "Back-Ground-Color")
        
        // 設定groupListCV Layer 間距.
        let layout = self.groupListCV.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        self.groupListCV.collectionViewLayout = layout
        
        // groupListCV delegate.
        self.groupListCV.dataSource = self
        self.groupListCV.delegate = self
        
        // NoteTF delegate.
        self.NoteTF.delegate = self
    }
    
    //MARK: func - 確定新增 Note.
    @IBAction func ok(_ sender: Any) {
        let newEasyNote = EasyNote(context: EasyNoteManager.moc)
        
        if let groupID =  self.newEasyNoteGroupID {
            newEasyNote.groupID = groupID
        } else {
            newEasyNote.groupID = "Not-Group"
        }
        
        if let groupColor =  self.newEasyNoteGroupColor {
            newEasyNote.groupColor = groupColor
        } else {
            newEasyNote.groupColor = "Note-Group-Default"
        }

        
        let creatDate = Date()
        let dateFormat :DateFormatter = DateFormatter()
        dateFormat.locale = Locale(identifier: "zh_Hant_TW") // 設定地區(台灣)
        dateFormat.timeZone = TimeZone(identifier: "Asia/Taipei") // 設定時區(台灣)
        dateFormat.dateFormat = "yy-MM-dd HH:mm"
        let nowdate = dateFormat.string(from: creatDate)
        
        newEasyNote.noteDate = nowdate
        
        newEasyNote.noteText = self.NoteTF.text!
        
        EasyNoteManager.easyIsSelectNoteCoreData.insert(newEasyNote, at: 0)
        
        EasyNoteManager.shared.saveCoreData()
        
        self.delegate.addEasyNote()
        
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: func - 取消.
    @IBAction func canel(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: func - scrollViewDidScroll(滑動取消新增設定).
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //初始化新增 Group List狀態ㄡ.
        guard let oldIndexPath = self.oldColorIndexPath else {
            return
        }
        let UseCellColor = self.groupListCV.cellForItem(at: oldIndexPath) as! AddNewNoteCollectionViewCell
        UseCellColor.backView.layer.borderWidth = 0
        UseCellColor.backView.layer.borderColor = UIColor.white.cgColor
        
        self.oldColorIndexPath = nil
        
        self.backView.layer.borderWidth = 1.0
        self.backView.layer.borderColor = UIColor.lightGray.cgColor
    }
}

/*----------------------------------- UICollectionViewDataSource -----------------------------------*/
extension AddNewNoteViewController :UICollectionViewDataSource {
    
    //MARK: Protocol - numberOfItemsInSection.
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return EasyNoteManager.groudListCoreData.count
    }
    
    //MARK: Protocol - cellForItemAt.
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let groupListCell = self.groupListCV.dequeueReusableCell(withReuseIdentifier: "GroupListCell", for: indexPath) as! AddNewNoteCollectionViewCell
        
        groupListCell.backView.backgroundColor = UIColor(named: EasyNoteManager.groudListCoreData[indexPath.row].groupColor!)
        
        groupListCell.groupListNameLB.text = EasyNoteManager.groudListCoreData[indexPath.row].groupName!
        
        return groupListCell
    }
}

/*----------------------------------- UICollectionViewDelegate -----------------------------------*/
extension AddNewNoteViewController :UICollectionViewDelegate {
    
    //MARK: Protocol - didDeselectItemAt.
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 變更 NoteTF backgroundColor.
        self.groupListColorView.layer.borderWidth = 100000.0
        self.groupListColorView.layer.borderColor = UIColor(named: EasyNoteManager.groudListCoreData[indexPath.row].groupColor!)?.cgColor
        
        self.newEasyNoteGroupID = EasyNoteManager.groudListCoreData[indexPath.row].groupID!
        self.newEasyNoteGroupColor = EasyNoteManager.groudListCoreData[indexPath.row].groupColor!
        
        // 檢查是否有old cell亮起邊框.
        if self.oldColorIndexPath != nil {
            // Clear old Cell 邊框.
            guard let oldIndexPath = self.oldColorIndexPath else {
                return
            }
            let oldUseCellColor = collectionView.cellForItem(at: oldIndexPath) as! AddNewNoteCollectionViewCell
            oldUseCellColor.backView.layer.borderWidth = 0
            oldUseCellColor.backView.layer.borderColor = UIColor.white.cgColor
            self.oldColorIndexPath = nil
        }
        
        // 點選cell亮起邊框.
        let selectCell = collectionView.cellForItem(at: indexPath) as! AddNewNoteCollectionViewCell
        selectCell.backView.layer.borderWidth = 1.0
        selectCell.backView.layer.borderColor = UIColor.black.cgColor
        self.oldColorIndexPath = indexPath
    }
}

extension AddNewNoteViewController :UITextViewDelegate {
    //MARK: Protocol - textFiel Delegate.
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        self.NoteTF.text = ""
        self.NoteTF.textColor = UIColor.black
        return true
    }
}
