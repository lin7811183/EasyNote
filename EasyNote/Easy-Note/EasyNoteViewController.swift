import UIKit

class EasyNoteViewController: UIViewController {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        EasyNoteManager.selectGroupDelegate = self
        EasyNoteManager.shared.queryIsSelectGroupListCoreData()
    }
    
    @IBOutlet weak var easyNoteSV: UIScrollView!
    @IBOutlet weak var groupListBT: UIBarButtonItem!
    @IBOutlet weak var noteCV: UICollectionView!
    @IBOutlet weak var changeShowMode: UIBarButtonItem!
    
    @IBOutlet weak var openGroupList: NSLayoutConstraint!
    @IBOutlet weak var clossGroupList: NSLayoutConstraint!
    
    var isOpenGroupList :Bool = false
    
    var pushNoteIndexPath :IndexPath!
    
    /*
     0 : 正方形
     1 : 長方形
     */
    var easyNoteShowMode :Int! = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Pattern Image
//        if let pattern = UIImage(named: "App-Back-Grond-Icon") { //加入背景圖
//            let bk = UIColor(patternImage: pattern) //把背景圖變成顏色
//            self.noteCV.backgroundColor = bk//設定成背景色
//
//            self.navigationController?.navigationBar.barTintColor = bk
//            self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
//            self.navigationController?.navigationBar.shadowImage = UIImage()
//
//            self.view.backgroundColor = bk
//        }
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.view.backgroundColor = UIColor(named: "Back-Ground-Color")
        
        // 設定groupListCV Layer 間距.
        let layout = self.noteCV.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 1
        self.noteCV.collectionViewLayout = layout
        
        // noteCV delegate.
        self.noteCV.dataSource = self
        self.noteCV.delegate = self
    }
    
    //MARK: func - 更換 Easy Note cell顯示.
    @IBAction func changeShowMode(_ sender: UIBarButtonItem) {
        if self.easyNoteShowMode == 0 {
            self.easyNoteShowMode = 1
            self.changeShowMode.image = UIImage(named: "Show-rectangle-Icon")
            self.noteCV.reloadData()
        } else if self.easyNoteShowMode == 1 {
            self.easyNoteShowMode = 0
            self.changeShowMode.image = UIImage(named: "Show-Square-Icon")
            self.noteCV.reloadData()
        }
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
        addNewNoteVC.delegate = self
        self.present(addNewNoteVC, animated: true, completion: nil)
    }
    
    //MARK: func - prepare seque.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Note" {
            let editEasyNoteVC = segue.destination as! EditEasyNoteViewController
            editEasyNoteVC.getIndexPath = self.pushNoteIndexPath
            
            editEasyNoteVC.delegate = self
        } else if segue.identifier == "GroupList" {
            let GroupListVC = segue.destination as! GroupListViewController
            GroupListVC.delegate = self
        }
    }
}

/*----------------------------------- UICollectionViewDataSource -----------------------------------*/
extension EasyNoteViewController :UICollectionViewDataSource {
    
    //MARK: Protocol - numberOfItemsInSection
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return EasyNoteManager.easyIsSelectNoteCoreData.count
    }
    
    //MARK: Protocol - cellForItemAt
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if self.easyNoteShowMode == 0 {
            let easyNoteCell = self.noteCV.dequeueReusableCell(withReuseIdentifier: "EasyNoteCell1", for: indexPath) as! EasyNoteCollectionViewCell
            
            //easyNoteCell.backView.layer.borderWidth = 1.0
            //easyNoteCell.backView.layer.borderColor = UIColor.black.cgColor
            //陰影
            easyNoteCell.backView.layer.shadowColor = UIColor.darkGray.cgColor
            easyNoteCell.backView.layer.shadowOpacity = 0.2 //透明度
            easyNoteCell.backView.layer.shadowOffset = CGSize(width: 5, height: 5)
            
            //Pattern Image
//            if let pattern = UIImage(named: "App-Back-Grond-Icon") { //加入背景圖
//                let bk = UIColor(patternImage: pattern) //把背景圖變成顏色
//                easyNoteCell.backgroundColor = bk
//                easyNoteCell.mainView.backgroundColor = bk
//            }
            
            let data = EasyNoteManager.easyIsSelectNoteCoreData[indexPath.row]
            
            easyNoteCell.noteDateLB.backgroundColor = UIColor(named: data.groupColor!)
            easyNoteCell.noteDateLB.text = data.noteDate
            
            easyNoteCell.noteTF.text = data.noteText
            easyNoteCell.noteTF.isSelectable = false
            easyNoteCell.noteTF.isEditable = false
            
            return easyNoteCell
        } else {
            let easyNoteCell = self.noteCV.dequeueReusableCell(withReuseIdentifier: "EasyNoteCell2", for: indexPath) as! EasyNoteCollectionViewCell
    
            let data = EasyNoteManager.easyIsSelectNoteCoreData[indexPath.row]
            
            easyNoteCell.groupView.layer.borderWidth = 100000.0
            easyNoteCell.groupView.layer.borderColor = UIColor(named: data.groupColor!)?.cgColor
            
            easyNoteCell.noteDateLB.text = data.noteDate
            
//            easyNoteCell.noteTF.text = data.noteText
//            easyNoteCell.noteTF.isSelectable = false
//            easyNoteCell.noteTF.isEditable = false
            
            easyNoteCell.noteLB.text = data.noteText
            
            return easyNoteCell
        }
    }

}

/*----------------------------------- UICollectionViewDelegate -----------------------------------*/
extension EasyNoteViewController :UICollectionViewDelegate {
    
    //MARK: Protocol - didSelectItemAt
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.pushNoteIndexPath = indexPath
        self.performSegue(withIdentifier: "Note", sender: nil)
    }
}

/*----------------------------------- UICollectionViewDelegateFlowLayout -----------------------------------*/
extension EasyNoteViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if self.easyNoteShowMode == 0 {
            let cellSize = CGSize(width: self.noteCV.bounds.size.width / 2, height: self.noteCV.bounds.size.width / 2)
            return cellSize
        } else {
            let cellSize = CGSize(width: self.noteCV.bounds.size.width - 10, height: self.noteCV.bounds.size.width / 3)
            return cellSize
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if self.easyNoteShowMode == 0 {
            return 0.0
        } else {
            return 10.0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layoutcollectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if self.easyNoteShowMode == 0 {
            return 0.0
        } else {
            return 10.0
        }
    }
}

/*----------------------------------- AddNewNoteViewControllerDelegate -----------------------------------*/
extension EasyNoteViewController :AddNewNoteViewControllerDelegate {
    func addEasyNote() {
        self.noteCV.reloadData()
        self.easyNoteSV.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
}

/*----------------------------------- EditEasyNoteViewControllerDelegate -----------------------------------*/
extension EasyNoteViewController :EditEasyNoteViewControllerDelegate {
    func updateEasyNote() {
        self.noteCV.reloadData()
    }
}

/*----------------------------------- EasyNoteManagerGroupListSelectDelegate -----------------------------------*/
extension EasyNoteViewController :EasyNoteManagerGroupListSelectDelegate {
    //MARK: Protocol - 讀取選取的GroupID.
    func selectGroupID() {
        for data in EasyNoteManager.groudIsSelectListCoreData {
            if let id = data.groupID {
                EasyNoteManager.shared.queryEasyNoteCoreData(groupIDs: id)
            }
        }
    }
    
    //MARK: Protocol - 讀取完成後，更新CV.
    func updateSelectGroupID() {
        self.noteCV.reloadData()
    }
}

/*----------------------------------- EditEasyNoteViewControllerDelegate -----------------------------------*/
extension EasyNoteViewController :GroupListViewControllerDelegate {
    //MARK: Protocol - 刪除群組後，更新CV.
    func deleteGroup() {
        self.noteCV.reloadData()
    }
    
    //MARK: Protocol - 鎖定群組後，更新CV.
    func lockGroup() {
        self.noteCV.reloadData()
    }
}
