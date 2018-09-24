import UIKit
import DropDown

class ItemTableViewCell: UITableViewCell {

    var menuDelegate:MenuSelectionDelegte?
    
    @IBOutlet weak var menuoption: UIButton!
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var itemCoast: UILabel!
    @IBOutlet weak var itemDate: UILabel!
    
    
    func setItemData(name:String,coast:String,date:String) {
        itemName.text = name
        itemCoast.text = coast
        itemDate.text = date
    }
    
    @IBAction func menuButton(_ sender: UIButton) {
        sender.flash()
        let drop = DropDown()
        drop.backgroundColor = UIColor.brown
        drop.textColor = UIColor.white
        drop.textFont = UIFont.boldSystemFont(ofSize: 17)
        drop.anchorView  = menuoption
        drop.dataSource = ["Update","Delete"]
        drop.direction = .bottom
        drop.width = 120
        drop.bottomOffset = CGPoint(x: 0, y:(drop.anchorView?.plainView.bounds.height)!)
        drop.selectionAction = { [unowned self] (index: Int, item: String) in
            
            if index == 0{
                self.menuDelegate?.update(index: sender.tag)
            }else{
                self.menuDelegate?.delete(index: sender.tag)
            }
        }
        drop.show()
    }
        
    }

