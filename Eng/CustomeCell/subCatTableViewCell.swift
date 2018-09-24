import UIKit
import DropDown

class subCatTableViewCell: UITableViewCell {

    var subMenudelegate:MenuSelectionDelegte?
    
    @IBOutlet weak var subNamelabel: UILabel!
    @IBOutlet weak var menuButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func clickedMenu(_ sender: UIButton) {
        sender.flash()
        let drop = DropDown()
        drop.backgroundColor = UIColor.brown
        drop.textColor = UIColor.white
        drop.textFont = UIFont.boldSystemFont(ofSize: 17)
        drop.anchorView = menuButton
        drop.dataSource = ["Update","Delete"]
        drop.direction = .bottom
        drop.width = 120
        drop.bottomOffset = CGPoint(x: 0, y:(drop.anchorView?.plainView.bounds.height)!)
        drop.selectionAction = { [unowned self] (index: Int, item: String) in
            
            if index == 0{
                self.subMenudelegate?.update(index: sender.tag)
            }else{
                self.subMenudelegate?.delete(index: sender.tag)
            }
        }
        drop.show()
    }
}
