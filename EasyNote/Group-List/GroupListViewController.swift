import UIKit

class GroupListViewController: UIViewController {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        EasyNoteManager.shared.queryCoreData()
        
        // 檢查是不是第一次使用APP，若是產生預設 ; 若不是撈取CoreData資料
        guard EasyNoteManager.groudListCoreData.count != 0 else {
            print("第一次使用 Easy Note APP.")
            let defaultGroupList = GroupList(context: EasyNoteManager.moc)
            defaultGroupList.groupID = UUID().uuidString
            defaultGroupList.groupColor = "Note-Group-Default"
            defaultGroupList.groupName = "請輸入群組名稱...."
            defaultGroupList.isSelect = false

            EasyNoteManager.groudListCoreData.append(defaultGroupList)
            EasyNoteManager.shared.saveCoreData()

            return
        }
        print("非第一次使用 Easy Note APP.")
        
    }

    @IBOutlet weak var groupListSC: UIScrollView!
    @IBOutlet weak var groupView: UIView!
    @IBOutlet weak var addNewGroupBT: UIButton!
    @IBOutlet weak var groupListTV: UITableView!
    
    var isAddNewGroup :Bool = false
    var changeGroupListNameIndexPath :IndexPath!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 設定 groupView 邊框.
        self.groupView.layer.borderWidth = 1.0
        self.groupView.layer.borderColor = UIColor.lightGray.cgColor
        
        // TableView Delegate.
        self.groupListTV.dataSource = self
        self.groupListTV.delegate = self
    }
    
    //MARK: func - 新增 new group
    @IBAction func addNewGroup(_ sender: UIButton) {
        if self.isAddNewGroup == false {
            self.groupListSC.setContentOffset(CGPoint(x: 0, y: 150), animated: true)
            self.isAddNewGroup = true
            UIView.animate(withDuration: 1.0, animations: {
                self.addNewGroupBT.transform =  CGAffineTransform(rotationAngle: CGFloat.pi / 4)
            })
        } else {
            self.groupListSC.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            self.isAddNewGroup = false
            UIView.animate(withDuration: 1.0, animations: {
                self.addNewGroupBT.transform =  CGAffineTransform(rotationAngle: -(CGFloat.pi / 2) )
            })
        }
    }
    
    //MARK: func - prepare segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // 產生 AddNewGroupViewController 實例.
        let addGroupListVC = segue.destination as! AddNewGroupViewController
        addGroupListVC.delegate = self
    }
}

/*----------------------------------- UITableViewDataSource -----------------------------------*/
extension GroupListViewController :UITableViewDataSource {
    
    //MARK: Protocol - numberOfRowsInSection section.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return EasyNoteManager.groudListCoreData.count
    }
    
    //MARK: Protocol - cellForRowAt.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let groupListCell = self.groupListTV.dequeueReusableCell(withIdentifier: "GroupListCell", for: indexPath) as! GroupListTableViewCell
        // 設定 groupColorView layer.
        groupListCell.groupColorView.layer.borderWidth = 100000.0
        groupListCell.groupColorView.layer.borderColor = UIColor(named: EasyNoteManager.groudListCoreData[indexPath.row].groupColor!)?.cgColor
        // 設定 groupNameLB text
        groupListCell.groupNameLB.text = EasyNoteManager.groudListCoreData[indexPath.row].groupName!
        
        if EasyNoteManager.groudListCoreData[indexPath.row].isSelect == false {
            groupListCell.isSelectImage.image = UIImage(named: "")
        } else {
            groupListCell.isSelectImage.image = UIImage(named: "Group-List-Select-Icon")
        }
        
        return groupListCell
    }
}

/*----------------------------------- UITableViewDelegate -----------------------------------*/
extension GroupListViewController :UITableViewDelegate {
    
    //MARK: Protocol - didSelectRowAt.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 點選後，取消反灰.
        self.groupListTV.deselectRow(at: indexPath, animated: true)
        // 點選後，看是否被選取.
        let selectGroupListCell = tableView.cellForRow(at: indexPath) as! GroupListTableViewCell
        let isSelect = EasyNoteManager.groudListCoreData[indexPath.row].isSelect
        if isSelect == false {
            selectGroupListCell.isSelectImage.image = UIImage(named: "Group-List-Select-Icon")
            selectGroupListCell.isSelect = true
            
            EasyNoteManager.groudListCoreData[indexPath.row].isSelect = true
            EasyNoteManager.shared.saveCoreData()
        } else {
            selectGroupListCell.isSelectImage.image = UIImage(named: "")
            selectGroupListCell.isSelect = false
            
            EasyNoteManager.groudListCoreData[indexPath.row].isSelect = false
            EasyNoteManager.shared.saveCoreData()
        }
        
    }
    
    //MARK: Protocol - editActionsForRowAt.
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        // 修改 Group List 名稱.
        let changeGroupListNameAction = UITableViewRowAction(style: .default, title: "改名稱") { (action, indexPath) in
            self.changeGroupListNameIndexPath = indexPath
            EasyNoteManager.shared.textAlter(vc: self, title: "請輸入新的群組名稱", message: "")
            EasyNoteManager.GroupListDelegate = self
        }
        changeGroupListNameAction.backgroundColor = UIColor.lightGray
        
        // 刪除 Group List.
        let deleteGroupListAction = UITableViewRowAction(style: .default, title: "刪除") { (action, indexPath) in
            // 刪除 Group List 元素.
            let deleteData = EasyNoteManager.groudListCoreData[indexPath.row]
            EasyNoteManager.groudListCoreData.remove(at: indexPath.row)
            // 刪除 Group List TablView.
            self.groupListTV.deleteRows(at: [indexPath], with: .automatic)
            self.groupListTV.reloadData()
            // Core Data save.
            EasyNoteManager.moc.delete(deleteData)
            EasyNoteManager.shared.saveCoreData()
        }
        deleteGroupListAction.backgroundColor = UIColor.red
        
        return [ deleteGroupListAction, changeGroupListNameAction ]
    }
}

/*----------------------------------- AddNewGroupViewControllerDelegate -----------------------------------*/
extension GroupListViewController :AddNewGroupViewControllerDelegate {
    
    //MARK: Protocol - addNewGroupList (通知新增 Group List)
    func addNewGroupList(groupName: String, groupColor: String) {
        // 新增一筆新的 Group list.
        let newGroupList = GroupList(context: EasyNoteManager.moc)
        newGroupList.groupID = UUID().uuidString
        newGroupList.groupColor = groupColor
        newGroupList.groupName = groupName
        newGroupList.isSelect = false
        
        EasyNoteManager.groudListCoreData.append(newGroupList)
        
        EasyNoteManager.shared.saveCoreData()
        
        self.groupListTV.reloadData()
        
        self.groupListSC.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        self.isAddNewGroup = false
    }
}

/*----------------------------------- EasyNoteManagerGroupListDelegate -----------------------------------*/
extension GroupListViewController :EasyNoteManagerGroupListDelegate {
    //MARK: Protocol - 更新新群組名稱 Delegate.
    func updateGroupListName(groupListName: String) {
        guard let indexPath = self.changeGroupListNameIndexPath else {
            print("changeGroupListNameIndexPath Error.")
            return
        }
        // 更新 cell Data.
        let changeCell = self.groupListTV.cellForRow(at: indexPath) as! GroupListTableViewCell
        changeCell.groupNameLB.text = groupListName
        self.groupListTV.rectForRow(at: indexPath)
        // 更新 groudList CoreData Array Data.
        EasyNoteManager.groudListCoreData[indexPath.row].groupName = groupListName
        EasyNoteManager.shared.saveCoreData()
        // 新增按鈕動畫.
        UIView.animate(withDuration: 1.0, animations: {
            self.addNewGroupBT.transform =  CGAffineTransform(rotationAngle: -(CGFloat.pi / 2) )
        })
    }
}
