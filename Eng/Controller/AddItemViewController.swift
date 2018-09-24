import UIKit
import CoreData

class AddItemViewController: UIViewController {

    let model = ModelData()
    
    var flag:Int?
    var catobj:Category?
    var subobj:Sub_Category?
    
    @IBOutlet weak var itemName: UITextField!
    @IBOutlet weak var itemCoast: UITextField!
    @IBOutlet weak var itemDate: UIDatePicker!
    @IBOutlet weak var addbutton: UIButton!
    @IBOutlet weak var imageContainer: UIImageView!
    @IBOutlet weak var containerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addbutton.layer.cornerRadius = 20
        containerView.layer.cornerRadius = 20
        title = "new Item"
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
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

    //TODO: click to add new item
    
    @IBAction func AddItem(_ sender: UIButton) {
        sender.plusate()
        if (itemCoast.text == "" || itemName.text == "" ){
            let alert = UIAlertController(title: "Elmohandes", message: "plz enter your category id and name ", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }else{
        let item = Item(context: model.context)
            item.coast = itemCoast.text
        item.date = itemDate.date
        item.name = itemName.text
            if flag == 0{
                item.addToItem_cat(catobj!)
                print("add item from cat ")
            }else{
                item.addToItem_sub_cat(subobj!)
                print("add item from sub ")
            }
        model.saveData()
        self.navigationController?.popViewController(animated: true)
        }
    }
}
