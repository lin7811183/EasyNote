import UIKit

class PresentationViewController: UIViewController {
    
    
    @IBOutlet weak var useEasyNoteButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.useEasyNoteButton.layer.borderWidth = 1.0
        self.useEasyNoteButton.layer.borderColor = UIColor.black.cgColor
        self.useEasyNoteButton.layer.cornerRadius = self.useEasyNoteButton.frame.size.height / 2
    }
    
    //MARK: func - 開始使用便便貼
    @IBAction func useEasyNote(_ sender: Any) {
        
        //set user data key to UserDefaults.
        let userDataDefault = UserDefaults.standard
        userDataDefault.string(forKey: "isFirstUseEasyNote")
        userDataDefault.set(true , forKey: "isFirstUseEasyNote")
        
        self.dismiss(animated: true, completion: nil)
    }
    
}
