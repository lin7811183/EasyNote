import UIKit

class GroupListViewController: UIViewController {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // 檢查是不是第一次使用APP，若是產生預設 ; 若不是撈取CoreData資料
        guard EasyNoteManager.groudListCoreData.count != 0 else {
            print("第一次使用 Easy-Note APP.")
            let defaultGroupList = GroupList()
            defaultGroupList.groupID = UUID().uuidString
            defaultGroupList.groupColor = "Note-Group-Default"
            defaultGroupList.groupName = "請輸入群組名稱...."
            
            EasyNoteManager.groudListCoreData.append(defaultGroupList)
            EasyNoteManager.shared.saveCoreData()
            
            return
        }
        print("非第一次使用 Easy-Note APP.")
        EasyNoteManager.shared.queryCoreData()
        
    }

    @IBOutlet weak var groupListSC: UIScrollView!
    @IBOutlet weak var groupView: UIView!
    @IBOutlet weak var addNewGroupBT: UIButton!
    @IBOutlet weak var groupListTV: UITableView!
    
    var isAddNewGroup :Bool = false
    
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
                self.addNewGroupBT.transform =  CGAffineTransform(rotationAngle: CGFloat.pi / 4)
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

/*-------------------------------------------------- UITableViewDataSource --------------------------------------------------*/
extension GroupListViewController :UITableViewDataSource {
    
    //MARK: Protocol - numberOfRowsInSection section.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return EasyNoteManager.groudListCoreData.count
    }
    
    //MARK: Protocol - cellForRowAt.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let groupListCell = self.groupListTV.dequeueReusableCell(withIdentifier: "GroupListCell", for: indexPath) as! GroupListTableViewCell
        
        //groupListCell.groupColorView.backgroundColor = UIColor(named: self.groupListArray[indexPath.row].groupColor!)
        groupListCell.groupColorView.layer.borderWidth = 100000.0
        groupListCell.groupColorView.layer.borderColor = UIColor(named: EasyNoteManager.groudListCoreData[indexPath.row].groupColor!)?.cgColor
        groupListCell.groupColorView.layer.backgroundColor = UIColor(named: EasyNoteManager.groudListCoreData[indexPath.row].groupColor!)?.cgColor
        
        groupListCell.groupColorView.alpha = 100
        
        groupListCell.groupNameLB.text = EasyNoteManager.groudListCoreData[indexPath.row].groupName!
        
        return groupListCell
    }
}

/*-------------------------------------------------- UITableViewDelegate --------------------------------------------------*/
extension GroupListViewController :UITableViewDelegate {
    
    //MARK: Protocol - didSelectRowAt.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.groupListTV.deselectRow(at: indexPath, animated: true)
    }
    
}

/*-------------------------------------------------- AddNewGroupViewControllerDelegate --------------------------------------------------*/
extension GroupListViewController :AddNewGroupViewControllerDelegate {
    
    //MARK: Protocol - addNewGroupList (通知新增 Group List)
    func addNewGroupList(groupName: String, groupColor: String) {
        // 新增一筆新的 Group list.
        let newGroupList = GroupList()
        newGroupList.groupID = UUID().uuidString
        newGroupList.groupColor = groupColor
        newGroupList.groupName = groupName
        
        EasyNoteManager.groudListCoreData.append(newGroupList)
        
        EasyNoteManager.shared.saveCoreData()
        
        self.groupListTV.reloadData()
        
        self.groupListSC.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        self.isAddNewGroup = false
    }
}
