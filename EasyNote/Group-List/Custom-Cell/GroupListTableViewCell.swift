import UIKit

class GroupListTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var groupColorView: UIView!
    @IBOutlet weak var groupNameLB: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
