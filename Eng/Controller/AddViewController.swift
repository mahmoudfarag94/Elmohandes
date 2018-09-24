import UIKit
import CoreData

class AddViewController: UIViewController {

    let model = ModelData()
    
    @IBOutlet weak var projectId: UITextField!
    @IBOutlet weak var projectName: UITextField!
    @IBOutlet weak var projectSite: UITextField!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var imageSuperContainer: UIImageView!
    @IBOutlet var containerView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        addButton.layer.cornerRadius = 20
        containerView.layer.cornerRadius = 20
        title = "new Project"
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        imageSuperContainer.addSubview(blurEffectView)
        containerView.transform = CGAffineTransform.init(scaleX: 0, y: 0)
    }
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.3) {
            self.containerView.transform = CGAffineTransform.identity
        }
    }
    
    //TODO: fetch projectes and save new one.
    func fetchProId(){
        let req:NSFetchRequest<Project> = Project.fetchRequest()
        let newid = projectId.text!
        req.predicate = NSPredicate(format: "pro_id == %@", newid)
        var idArray:[Project] = []
        do{
            idArray = try model.context.fetch(req)
            if idArray.count > 0{
           let n = (idArray[0] as AnyObject).value(forKey: "pro_id") as! String
                if (newid == n){
                    let alert = UIAlertController(title: "Engineer", message: "ID already exsiste please select another ID ", preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .default) { (action) in
                        self.projectId.text = ""
                    }
                    alert.addAction(action)
                    self.present(alert, animated: true, completion: nil)
                }
            }else {
               
                let project = Project(context: model.context)
                project.pro_id = projectId.text
                project.pro_name = projectName.text
                project.pro_site = projectSite.text
                project.pro_date = Date()
                model.saveData()
                navigationController?.popViewController(animated: true)
            }
        }catch{
            print("id fetched error\(error)")
        }
    }
    //TODO: click to add new project.
    @IBAction func AddProject(_ sender: UIButton) {
        sender.flash()
        //sender.plusate()
        if (projectId.text == "" || projectName.text == "" || projectSite.text == ""){
            let alert = UIAlertController(title: "Elmohandes", message: "Please enter your project info  ", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default) { (action) in
                
                self.projectId.text = ""
                self.projectName.text = ""
                self.projectSite.text = ""
            }
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }else {
              fetchProId()
    }
    }
}












