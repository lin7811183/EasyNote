import UIKit

class GroupListTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var groupColorView: UIView!
    @IBOutlet weak var groupNameLB: UILabel!
    @IBOutlet weak var isSelectImage: UIImageView!
    
    var isSelect :Bool!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
