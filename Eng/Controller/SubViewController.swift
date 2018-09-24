import UIKit
import CoreData
import DropDown

class SubViewController: UIViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    @IBOutlet weak var subTableView: UITableView!
    
    var c:Category!
    var subArray:[Sub_Category] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subTableView.delegate = self
        subTableView.dataSource = self
        subTableView.register(UINib(nibName: "subCatTableViewCell", bundle: nil), forCellReuseIdentifier: "subCatCell")
        title = ""
    }
    
}


//MARK: menu delegate method .

extension SubViewController : MenuSelectionDelegte{
    func update(index: Int) {
        var textfield = UITextField()
        let updateAlert = UIAlertController(title: "Elmohands", message: "", preferredStyle: .alert)
        let updateAction = UIAlertAction(title: "OK", style: .default) { (action) in
            self.subArray[index].setValue(textfield.text, forKey: "sub_name")
            do{
                try self.context.save()
            }catch{
                print("update data error \(error)")
            }
            self.subTableView.reloadData()
        }
        updateAlert.addTextField(configurationHandler: { (alerttextfield) in
            alerttextfield.placeholder = "Update Category Name"
            textfield = alerttextfield
        })
        updateAlert.addAction(updateAction)
        self.present(updateAlert, animated: true, completion: nil)
    }
    func delete(index: Int) {
        context.delete(subArray[index])
        subArray.remove(at: index)
        do{
            try context.save()
            subTableView.reloadData()
        }catch{
            print("delete data with error \(error) ")
        }
    }
    }


//MARK: table view method delegate .

extension SubViewController:UITableViewDelegate , UITableViewDataSource{

    //TODO: tableview data source method .
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subArray.count
    }
    //TODO: table view cellforRow method .
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "subCatCell", for: indexPath) as! subCatTableViewCell
        cell.subMenudelegate = self
        cell.menuButton.tag = indexPath.row
        let subCell = subArray[indexPath.row]
        print(subCell.sub_name!)
        cell.subNamelabel.text = subCell.sub_name
        
        return cell
}
    //TODO: tableview rowhieght method .
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    //TODO: tableview didSelectRow method .
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        subTableView.deselectRow(at: indexPath, animated: true)
        
        if((subArray[indexPath.row].sub_items?.count)! > 0){
            let st = UIStoryboard(name: "Main", bundle: nil)
            let vc = st.instantiateViewController(withIdentifier: "itemview") as! ItemViewController
            let itemArray = subArray[indexPath.row].sub_items?.allObjects as! [Item]
            vc.itemArray = itemArray
            vc.flag = 1
            navigationController?.pushViewController(vc, animated: true)
            
        }else{
       
        let subSub = UIStoryboard(name: "Main", bundle: nil)
        let subsubVC = subSub.instantiateViewController(withIdentifier: "subCatView") as! SubViewController
        let subData = subArray[indexPath.row]
        let req:NSFetchRequest<Sub_Category> = Sub_Category.fetchRequest()
        req.predicate = NSPredicate(format: "parent_sub == %@", subData)
        let descriptors = NSSortDescriptor(key: "sub_name", ascending: true)
        req.sortDescriptors = [descriptors]
        var subsData:[Sub_Category] = []
        do{
            subsData = try context.fetch(req)
            if subsData.count > 0 {
            subsubVC.subArray = subsData
                navigationController?.pushViewController(subsubVC, animated: true)
            }else{
                let alert = UIAlertController(title: "Elmohandes", message: "this category not have any items", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
                print("alert")
            }
            
        }catch{
            print("fetched data error with \(error)")
        }
        
    }
    }

    // TODO: tableview editAction method.
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let addSubCat = UITableViewRowAction(style: .default, title: "Add SubCategory") { (action, indexPath) in
            let st = UIStoryboard(name: "Main", bundle: nil)
            let vc = st.instantiateViewController(withIdentifier: "addNewSubCat") as! AddSubCatViewController
            vc.flag = 1
            vc.subcatobj = self.subArray[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
        let addItem = UITableViewRowAction(style: .default, title: "Add Item") { (action, indexPath) in
            let st = UIStoryboard(name: "Main", bundle: nil)
            let vc = st.instantiateViewController(withIdentifier: "additem") as! AddItemViewController
            vc.subobj = self.subArray[indexPath.row]
            vc.flag = 1
            self.navigationController?.pushViewController(vc, animated: true)
        }
        addItem.backgroundColor = UIColor.brown
        addSubCat.backgroundColor = UIColor.gray
        return [addItem , addSubCat]
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let transform = CATransform3DTranslate(CATransform3DIdentity, 500, 10, 0)
        cell.layer.transform = transform
        UIView.animate(withDuration: 1.0) {
            cell.layer.transform = CATransform3DIdentity
        }
        
    }
}
