import UIKit

protocol AddNewGroupViewControllerDelegate {
    func addNewGroupList(groupName :String, groupColor :String)
}

class AddNewGroupViewController: UIViewController {
    
    @IBOutlet weak var groupColorCV: UICollectionView!
    @IBOutlet weak var groupListNameTF: UITextField!
    
    var groupColorArray = [
    "Note-Group-1","Note-Group-2","Note-Group-3","Note-Group-4","Note-Group-5","Note-Group-6","Note-Group-7","Note-Group-8","Note-Group-9","Note-Group-10"
    ]
    
    var oldUseCellColorIndexRow :IndexPath!
    var useGroupName :String!
    var useGroupColor :String!
    
    var delegate :AddNewGroupViewControllerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.groupColorCV.dataSource = self
        self.groupColorCV.delegate = self
    }
    
    /*-------------------------------------------------- Functions --------------------------------------------------*/
    
    //MARK: func - Add New Group List.
    @IBAction func addNewGroupList(_ sender: UIButton) {
        if self.oldUseCellColorIndexRow == nil{
            EasyNoteManager.shared.okAlert(vc: self, title: "新增便貼群組異常", message: "請檢查是否有選取群組顏色")
        } else if self.groupListNameTF.text == ""  {
            EasyNoteManager.shared.okAlert(vc: self, title: "新增便貼群組異常", message: "請檢查是否有輸入群組名稱")
        } else {
            self.useGroupName = self.groupListNameTF.text!
            self.delegate.addNewGroupList(groupName: self.useGroupName, groupColor: self.useGroupColor)
            
            guard let oldIndexPath = self.oldUseCellColorIndexRow else {
                return
            }
            //清除新增設定
            let UseCellColor = self.groupColorCV.cellForItem(at: oldIndexPath) as! GroupColorCollectionViewCell
            UseCellColor.colorView.layer.borderWidth = 0
            UseCellColor.colorView.layer.borderColor = UIColor.white.cgColor
            
            self.groupListNameTF.text = ""
            self.groupListNameTF.backgroundColor = UIColor.white
        }
    }
    
    //MARK: func - scrollViewDidScroll(滑動取消新增設定).
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //初始化新增 Group List狀態ㄡ.
        guard let oldIndexPath = self.oldUseCellColorIndexRow else {
            return
        }
        let UseCellColor = self.groupColorCV.cellForItem(at: oldIndexPath) as! GroupColorCollectionViewCell
        UseCellColor.colorView.layer.borderWidth = 0
        UseCellColor.colorView.layer.borderColor = UIColor.white.cgColor
        
        self.oldUseCellColorIndexRow = nil
        
        self.groupListNameTF.backgroundColor = UIColor.white
    }
}

/*-------------------------------------------------- UICollectionViewDataSource --------------------------------------------------*/
extension AddNewGroupViewController :UICollectionViewDataSource {
    
    //MARK: Protocol - numberOfItemsInSection.
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.groupColorArray.count
    }
    
    //MARK: Protocol - cellForItemAt.
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let groupColorCell = self.groupColorCV.dequeueReusableCell(withReuseIdentifier: "groupColorCell", for: indexPath) as! GroupColorCollectionViewCell
        
        groupColorCell.colorView.layer.cornerRadius =  groupColorCell.colorView.bounds.height / 2
        groupColorCell.colorView.backgroundColor = UIColor(named: self.groupColorArray[indexPath.row])
        
        return groupColorCell
    }
}

/*-------------------------------------------------- UICollectionViewDelegate --------------------------------------------------*/
extension AddNewGroupViewController :UICollectionViewDelegate {
    
    //MARK: Protocol - didSelectItemAt.
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 變更 noteGroupTF backgroundColor.
        self.groupListNameTF.backgroundColor = UIColor(named: self.groupColorArray[indexPath.row])
        self.useGroupColor = self.groupColorArray[indexPath.row] // 設定新的useGroupColor
        

        // 檢查是否有old cell亮起邊框.
        if self.oldUseCellColorIndexRow != nil {
            // Clear old Cell 邊框.
            guard let oldIndexPath = self.oldUseCellColorIndexRow else {
                return
            }
            let oldUseCellColor = collectionView.cellForItem(at: oldIndexPath) as! GroupColorCollectionViewCell
            oldUseCellColor.colorView.layer.borderWidth = 0
            oldUseCellColor.colorView.layer.borderColor = UIColor.white.cgColor
            self.oldUseCellColorIndexRow = nil
        }
        
        // 點選cell亮起邊框.
        let useCellColor = collectionView.cellForItem(at: indexPath) as! GroupColorCollectionViewCell
        useCellColor.colorView.layer.borderWidth = 1.0
        useCellColor.colorView.layer.borderColor = UIColor.black.cgColor
        self.oldUseCellColorIndexRow = indexPath
    }
}
