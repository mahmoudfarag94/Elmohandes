import UIKit
import DropDown

protocol MenuSelectionDelegte {
    func delete(index :Int)
    func update(index :Int)
}


class projectCell: UITableViewCell {

    var menudelegate:MenuSelectionDelegte?
    
    @IBOutlet weak var projectName: UILabel!
    @IBOutlet weak var projectDate: UILabel!
    @IBOutlet weak var projectMenu: UIButton!
   
    func setProjectData(name:String , date:String)  {
        projectName.text = name
        projectDate.text = date
    }

    @IBAction func projectMenuClicked(_ sender: UIButton) {
        sender.flash()
        let drop = DropDown()
        drop.backgroundColor = UIColor.brown
        drop.textColor = UIColor.white
        drop.textFont = UIFont.boldSystemFont(ofSize: 17)
        drop.anchorView = projectMenu
        drop.dataSource = ["Update","Delete"]
        drop.direction = .bottom
        drop.width = 120
        drop.bottomOffset = CGPoint(x: 0, y:(drop.anchorView?.plainView.bounds.height)!)
        drop.selectionAction = { [unowned self] (index: Int, item: String) in
            
            if index == 0{
                
              self.menudelegate?.update(index: sender.tag)
            }else{
               
              self.menudelegate?.delete(index: sender.tag)
            }
        }
        drop.show()
    }
    
    
}
