import UIKit
import CoreData

class AddCotegoryViewController: UIViewController {
    let model = ModelData()
    var project:Project!
    
    @IBOutlet weak var categoryID: UITextField!
    @IBOutlet weak var categoryName: UITextField!
    @IBOutlet weak var addbutton: UIButton!
    @IBOutlet weak var imageContainer: UIImageView!
    @IBOutlet weak var containerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addbutton.layer.cornerRadius = 20
        containerView.layer.cornerRadius = 20
        title = "New Category"
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
    
    //TODO: click to add new category.
    
    @IBAction func AddCategorys(_ sender: UIButton) {
        sender.plusate()
        if (categoryID.text == "" || categoryName.text == ""){
            let alert = UIAlertController(title: "Elmohandes", message: "plz enter your category id and name ", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }else{
            let cate = Category(context: model.context)
            cate.cat_id = categoryID.text
            cate.cat_date = Date()
            cate.cat_name = categoryName.text
            project.addToCategories(cate)
            cate.addToProjects(project)
            model.saveData()
            self.navigationController?.popViewController(animated: true)
        }
        
    }
}
