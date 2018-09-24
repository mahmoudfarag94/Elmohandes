import UIKit
import CoreData
class AddSubCatViewController: UIViewController {

    let model = ModelData()
    var catesObj:Category?
    var subcatobj:Sub_Category?
    var flag:Int?
    
    @IBOutlet weak var subId: UITextField!
    @IBOutlet weak var subName: UITextField!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var imageContainer: UIImageView!
    @IBOutlet weak var containerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addButton.layer.cornerRadius = 20
        containerView.layer.cornerRadius = 20
        title = "new sub Category"
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        imageContainer.addSubview(blurEffectView)
        containerView.transform = CGAffineTransform.init(scaleX: 0, y: 0)
    }
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.3) {
            self.containerView.transform = CGAffineTransform.identity
        }
    
    }
    //TODO: click to add new subcategory.
    @IBAction func AddSub(_ sender: UIButton) {
        sender.plusate()
        if (subId.text == "" || subName.text == ""){
            let alert = UIAlertController(title: "Elmohandes", message: "plz enter your category id and name ", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            
        }else{
            
            let subCat = Sub_Category(context: model.context)
            subCat.sub_id = subId.text
            subCat.sub_name = subName.text
            subCat.cates = catesObj
            catesObj?.addToSub_categories(subCat)
            if flag == 0{
                subCat.parent_sub = nil
            }else{
                subCat.parent_sub = subcatobj
            }
        model.saveData()
        self.navigationController?.popViewController(animated: true)
        }
    }
}
