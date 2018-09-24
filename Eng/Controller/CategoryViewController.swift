import UIKit
import CoreData

class CategoryViewController: UIViewController  {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var pro:Project!
    var catArray:[Category] = []
    
    @IBOutlet weak var categoryTableView: UITableView!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryTableView.delegate = self
        categoryTableView.dataSource = self
        title = "Category"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        fetchCategory()
    }
    
    
}
//MARK: table view method delegate .

extension CategoryViewController:UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate{

    //TODO: tableview data source method .
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return catArray.count
    }
    //TODO: table view cellforRow method .
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as! CategoryCell
        let catCell = catArray[indexPath.row]
//        if (catArray[indexPath.row].items?.count)! > 0{
//
//        }
        let date = catCell.cat_date
        let format = DateFormatter()
        format.dateFormat = "dd/ MM/ yyyy"
        let dateString = format.string(from: date!)
        cell.setCategoryData(Cname: catCell.cat_name!, Cdate: dateString)
        return cell
}
    //TODO: tableview rowhieght method .
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
   //TODO: tableview editactionRow method .
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let addSubCategory = UITableViewRowAction(style: .default, title: "Add SubCategory") { (action, indexPath) in
            let st = UIStoryboard(name: "Main", bundle: nil)
            let vc = st.instantiateViewController(withIdentifier: "addNewSubCat") as! AddSubCatViewController
            vc.catesObj = self.catArray[indexPath.row]
            vc.flag = 0
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        let addItem = UITableViewRowAction(style: .default, title: "Add Item") { (action, indexPath) in
            let st = UIStoryboard(name: "Main", bundle: nil)
            let vc = st.instantiateViewController(withIdentifier: "additem") as! AddItemViewController
            vc.catobj = self.catArray[indexPath.row]
            vc.flag = 0
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        addItem.backgroundColor = UIColor.brown
        addSubCategory.backgroundColor = UIColor.gray
        return [addSubCategory , addItem]
    }
    //TODO: tableview didSelectRow method .
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        categoryTableView.deselectRow(at: indexPath, animated: true)
        
        if ((catArray[indexPath.row].sub_categories?.count)! > 0 && (catArray[indexPath.row].items?.count)! > 0){
            let itemSt = UIStoryboard(name: "Main", bundle: nil)
            let itemVC = itemSt.instantiateViewController(withIdentifier: "itemview")as!ItemViewController
            let item = catArray[indexPath.row].items?.allObjects as! [Item]
            itemVC.itemArray = item
          //  itemVC.catItem = catArray[indexPath.row]
            itemVC.flag = 0
            navigationController?.pushViewController(itemVC, animated: true)
            print("big items")
            
        }else if ((catArray[indexPath.row].sub_categories?.count)! > 0 && catArray[indexPath.row].items?.count == 0){
            let subSt = UIStoryboard(name: "Main", bundle: nil)
            let subVC = subSt.instantiateViewController(withIdentifier: "subCatView")as!SubViewController
            
            let categoryData = catArray[indexPath.row].sub_categories?.allObjects as! [Sub_Category]
            
             subVC.subArray = categoryData
            navigationController?.pushViewController(subVC, animated: true)
            
        }else if((catArray[indexPath.row].sub_categories?.count)! == 0 && (catArray[indexPath.row].items?.count)! > 0){
            let itemSt = UIStoryboard(name: "Main", bundle: nil)
            let itemVC = itemSt.instantiateViewController(withIdentifier: "itemview")as!ItemViewController
            let item = catArray[indexPath.row].items?.allObjects as! [Item]
            itemVC.itemArray = item
            //itemVC.catItem = catArray[indexPath.row]
            itemVC.flag = 0
            navigationController?.pushViewController(itemVC, animated: true)
            print("items")
            
        }else {
            let catAlert = UIAlertController(title: "ELmohands", message: "this Category not have Categories or Item", preferredStyle: .alert)
            let catAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            catAlert.addAction(catAction)
            self.present(catAlert, animated: true, completion: nil)
           print("alert")
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let tranform = CATransform3DTranslate(CATransform3DIdentity, -500, 10, 0)
        cell.layer.transform = tranform
        UIView.animate(withDuration: 1.0) {
            cell.layer.transform = CATransform3DIdentity
        }
    }
    
    //TODO: fetch categories from core data .
    
    func fetchCategory(){
        if (pro.categories == nil) {
            print("no cat to show")
        }else{
            let projectCategories =  pro?.categories?.allObjects as! [Category]
            catArray = projectCategories
        }
}
    
    //MARK: search bar delegate method.
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let req:NSFetchRequest<Category> = Category.fetchRequest()
        let pridicate = NSPredicate(format: "cat_name CONTAINS[cd] %@", searchBar.text!)
        req.predicate = pridicate
        let discriptor = NSSortDescriptor(key: "cat_name", ascending: true)
        req.sortDescriptors = [discriptor]
        do {
            catArray = try context.fetch(req)
        }catch{
            print("data fetched error with \(error)")
        }
        
        categoryTableView.reloadData()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            fetchCategory()
           
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
             categoryTableView.reloadData()
            
            
        }
    }
    }

