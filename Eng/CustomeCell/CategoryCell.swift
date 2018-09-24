import UIKit

class CategoryCell: UITableViewCell {

    @IBOutlet weak var categoryName: UILabel!
    @IBOutlet weak var categoryDate: UILabel!
    
    
    func setCategoryData(Cname:String, Cdate:String)  {
        categoryName.text = Cname
        categoryDate.text = Cdate
    }
}

