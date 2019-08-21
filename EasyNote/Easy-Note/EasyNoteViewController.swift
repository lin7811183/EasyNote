import UIKit

class EasyNoteViewController: UIViewController {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        //EasyNoteManager.shared.queryCoreData(entityName: "EasyNote")
        EasyNoteManager.SelectGroupDelegate = self
        EasyNoteManager.shared.queryIsSelectGroupListCoreData()
        
    }
    
    @IBOutlet weak var easyNoteSV: UIScrollView!
    @IBOutlet weak var groupListBT: UIBarButtonItem!
    @IBOutlet weak var noteCV: UICollectionView!
    
    @IBOutlet weak var openGroupList: NSLayoutConstraint!
    @IBOutlet weak var clossGroupList: NSLayoutConstraint!
    
    var isOpenGroupList :Bool = false
    
    var pushNoteIndexPath :IndexPath!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Pattern Image
        if let pattern = UIImage(named: "App-Back-Grond-Icon") { //加入背景圖
            let bk = UIColor(patternImage: pattern) //把背景圖變成顏色
            self.noteCV.backgroundColor = bk//設定成背景色
            
            self.navigationController?.navigationBar.barTintColor = bk
            self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
            self.navigationController?.navigationBar.shadowImage = UIImage()
            
            self.view.backgroundColor = bk
        }
        
        // 設定groupListCV Layer 間距.
        let layout = self.noteCV.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 1
        self.noteCV.collectionViewLayout = layout
        
        // noteCV delegate.
        self.noteCV.dataSource = self
        self.noteCV.delegate = self
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
        let easyNoteCell = self.noteCV.dequeueReusableCell(withReuseIdentifier: "EasyNoteCell", for: indexPath) as! EasyNoteCollectionViewCell
        
        //easyNoteCell.backView.layer.borderWidth = 1.0
        //easyNoteCell.backView.layer.borderColor = UIColor.black.cgColor
        //陰影
        easyNoteCell.backView.layer.shadowColor = UIColor.darkGray.cgColor
        easyNoteCell.backView.layer.shadowOpacity = 0.5 //透明度
        easyNoteCell.backView.layer.shadowOffset = CGSize(width: 5, height: 5)
        
        //Pattern Image
        if let pattern = UIImage(named: "App-Back-Grond-Icon") { //加入背景圖
            let bk = UIColor(patternImage: pattern) //把背景圖變成顏色
            easyNoteCell.backgroundColor = bk
            easyNoteCell.mainView.backgroundColor = bk
        }
        
        let data = EasyNoteManager.easyIsSelectNoteCoreData[indexPath.row]
        
        easyNoteCell.groupView.layer.borderWidth = 100000.0
        easyNoteCell.groupView.layer.borderColor = UIColor(named: data.groupColor!)?.cgColor
        
        easyNoteCell.noteDateLB.text = data.noteDate
        
        easyNoteCell.noteTF.text = data.noteText
        easyNoteCell.noteTF.isSelectable = false
        easyNoteCell.noteTF.isEditable = false
        
        return easyNoteCell
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
        
        let cellSize = CGSize(width: self.noteCV.bounds.size.width / 2, height: self.noteCV.bounds.size.width / 2)
        return cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layoutcollectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
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

/*----------------------------------- EditEasyNoteViewControllerDelegate -----------------------------------*/
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
    //MARK: Protocol - 鎖定群組後，更新CV.
    func lockGroup() {
        self.noteCV.reloadData()
    }
}
