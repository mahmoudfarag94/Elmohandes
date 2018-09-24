import UIKit
import CoreData

class ProjectViewController: UIViewController  {

   
    
    @IBOutlet weak var projectTableView: UITableView!
    @IBOutlet weak var addprojectButton: UIBarButtonItem!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var projectsArray:[Project] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        projectTableView.delegate = self
        projectTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //TODO: call fetch project method.
        fetchProject()
    }
    
    //TODO: fetch projectes from core data .
    func fetchProject(){
        let req:NSFetchRequest<Project> = Project.fetchRequest()
        let sort = NSSortDescriptor(key: "pro_date", ascending: true)
        req.sortDescriptors = [sort]
       do{
        projectsArray = try context.fetch(req)
        projectTableView.reloadData()
        }catch{
            print("data fetching error with\(error)")
        }
    }
    
    //TODO: click to add new project
    @IBAction func AddNewPro(_ sender: UIBarButtonItem) {
        let newPro = UIStoryboard(name: "Main", bundle: nil)
        let newProVC = newPro.instantiateViewController(withIdentifier: "addnewproject")as! AddViewController
        navigationController?.pushViewController(newProVC, animated: true)
    }
    
}

//MARK: option menu button delegate method
extension ProjectViewController : MenuSelectionDelegte{
   
    //TODO: method to update.
    func update(index: Int) {
        var textfield = UITextField()
        let updateAlert = UIAlertController(title: "Elmohandes", message: "", preferredStyle: .alert)
        let updateAction = UIAlertAction(title: "OK", style: .default) { (action) in
            self.projectsArray[index].setValue(textfield.text, forKey: "pro_name")
            do{
                try self.context.save()
            }catch{
                print("upadte data error with \(error)")
            }
           self.projectTableView.reloadData()
        }
        updateAlert.addTextField(configurationHandler: { (alerttextfield) in
            alerttextfield.placeholder = "Update Project Name"
              textfield = alerttextfield
        })
        updateAlert.addAction(updateAction)
        self.present(updateAlert, animated: true, completion: nil)
    }
    
    //TODO: method to delete .
    func delete(index: Int) {
        context.delete(projectsArray[index])
        projectsArray.remove(at: index)
        do{
           try context.save()
            projectTableView.reloadData()
        }catch{
            print("deleted data error with \(error) ")
        }
    }
}


//MARK: table view method delegate .
extension ProjectViewController:UITableViewDelegate , UITableViewDataSource{
    
    //TODO: tableview data source method .
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projectsArray.count
    }
    
    //TODO: table view cellforRow method .
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "projectCell", for: indexPath) as! projectCell
       
        cell.menudelegate = self
        cell.projectMenu.tag = indexPath.row
        
        let procell = projectsArray[indexPath.row]
        let date = procell.pro_date
        let format = DateFormatter()
        format.dateFormat = "dd/ MM/ yyyy"
        let dateString = format.string(from: date!)

        cell.setProjectData(name: procell.pro_name!, date: dateString)
        return cell
    }
    
    //TODO: tableview rowhieght method .
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    //TODO: tableview editactionRow method .
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let addNewPro = UITableViewRowAction(style: .default, title: "Add Category") { (action, indexPath) in
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let viewCont = storyBoard.instantiateViewController(withIdentifier: "addnewcategory") as! AddCotegoryViewController
            viewCont.project = self.projectsArray[indexPath.row]
            self.navigationController?.pushViewController(viewCont, animated: true)
        }
        addNewPro.backgroundColor = UIColor.brown
        return [addNewPro]
    }
    
    //TODO: tableview didSelectRow method .
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let transform = CATransform3DTranslate(CATransform3DIdentity, -500, 10, 0)
        cell.layer.transform = transform
        UIView.animate(withDuration: 1.0) {
            cell.layer.transform = CATransform3DIdentity
        }
    }
    
    //TODO: prepare segue method .
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let index = projectTableView.indexPathForSelectedRow
        if (projectsArray[(index?.row)!].categories?.count == 0) {
            let ProjectAlert = UIAlertController(title: "ELmohandes", message: "This Project Not Have Any Categories Please Swipe To Add New One ", preferredStyle: .alert)
            let projectAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            ProjectAlert.addAction(projectAction)
            self.present(ProjectAlert, animated: true, completion: nil)
        }else{
            if segue.identifier == "showCategory"{
                let dis  = segue.destination as! CategoryViewController
                dis.pro = projectsArray[(index?.row)!]
            }
        }
    }
}
