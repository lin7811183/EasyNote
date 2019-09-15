import UIKit

class EasyNoteNavigationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        //check is login and registered.
        let loginUserDefault = UserDefaults.standard
        
        //read userdefault is login or registered?
        let checkIsFirstUse = loginUserDefault.bool(forKey: "isFirstUseEasyNote")
        print("********** user is first use EasyNote \(checkIsFirstUse) **********")
        
        guard checkIsFirstUse == true else {
            let PresentationVC = self.storyboard?.instantiateViewController(withIdentifier: "PresentationVC") as! PresentationViewController
            self.present(PresentationVC, animated: true, completion: nil)
            return
        }
    }

}
