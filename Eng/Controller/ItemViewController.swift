import UIKit
import CoreData
import DropDown

class ItemViewController: UIViewController {

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var a:Int?
    var catItem:Category?
    var sub:Sub_Category?
    var flag:Int?

    var itemArray:[Item] = []
    
    @IBOutlet weak var itemTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        itemTableView.delegate = self
        itemTableView.dataSource = self
        title = "Item"
        itemTableView.register(UINib(nibName: "ItemTableViewCell", bundle: nil), forCellReuseIdentifier: "itemCell")
       
    }
   
}

//MARK : menu delegate method to delete - update item .

extension ItemViewController : MenuSelectionDelegte {
    
    //TODO: method to update.
    func update(index: Int) {
        var nametextfield = UITextField()
        var costTextfield = UITextField()
        let updateAlert = UIAlertController(title: "Elmohands", message: "", preferredStyle: .alert)
        let updateAction = UIAlertAction(title: "OK", style: .default) { (action) in
            self.itemArray[index].setValue(nametextfield.text, forKey: "name")
            self.itemArray[index].setValue(costTextfield.text, forKey: "coast")
            do{
                try self.context.save()
            }catch{
                print("upadte data error with \(error)")
            }
            self.itemTableView.reloadData()
        }
        updateAlert.addTextField(configurationHandler: { (alerttextfield) in
            alerttextfield.placeholder = "Update item Name"
            nametextfield = alerttextfield
        })
        updateAlert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Update Item Cost"
            costTextfield = alertTextField
        }
        updateAlert.addAction(updateAction)
        self.present(updateAlert, animated: true, completion: nil)
    }
    
    //TODO: method to delete .
    func delete(index: Int) {
        context.delete(itemArray[index])
        itemArray.remove(at: index)
        do{
            try context.save()
            itemTableView.reloadData()
        }catch{
            print("error ")
        }
}
}

//MARK: tableView delegate methods .

extension ItemViewController : UITableViewDelegate , UITableViewDataSource{
    //TODO: tableview data source .
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return itemArray.count
    }
    //TODO: tableview cell .
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as! ItemTableViewCell
        let itemcell = itemArray[indexPath.row]
        
        
        
        
        cell.menuDelegate = self
        cell.menuoption.tag = indexPath.row
        
        let itemdate = itemcell.date
        let formate = DateFormatter()
        formate.dateFormat = "dd-MM-yyyy"
        let stringItemDate =  formate.string(from: itemdate!)
        
        cell.setItemData(name: itemcell.name!, coast: itemcell.coast as! String, date: stringItemDate)
        return cell
}
    //TODO: tableview hieght .
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    //TODO: tableview selected cell .
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemTableView.deselectRow(at: indexPath, animated: true)
    }
    //TODO: animation cell
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let transform = CATransform3DTranslate(CATransform3DIdentity, 500, 0, 0)
        cell.layer.transform = transform
        UIView.animate(withDuration: 1.0) {
            cell.layer.transform = CATransform3DIdentity
        }
    }
    
    
}
