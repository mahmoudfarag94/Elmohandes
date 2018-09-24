import Foundation
import UIKit
import CoreData

class ModelData {

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    func saveData()  {
        do{
            try context.save()
        }catch{
            print("data saved error with \(error)")
        }
    }
    
    func delete()  {
        
    }
    
    
    
}

//                // add sub
//                let sub = Sub_Category(context: context)
//                sub.parent_sub = nil
//                sub.sub_name = "root sub"
//                // add sub from sub
//                let ss = Sub_Category(context: context)
//                ss.parent_sub = sub
//                ss.sub_name = "sub of sub"
