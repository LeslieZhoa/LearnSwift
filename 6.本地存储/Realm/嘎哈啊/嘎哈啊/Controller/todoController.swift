//
//  todoController.swift
//  嘎哈啊
//
//  Created by Leslie Zhao on 2020/4/22.
//  Copyright © 2020 Leslie Zhao. All rights reserved.
//

import UIKit

protocol TodoDelegate {
    func didAdd(name:String)
    func didEdit(name:String)
}

class todoController: UITableViewController {
    
    var delegate:TodoDelegate?
    var name:String?
    @IBOutlet weak var todoinput: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 打开本页面，让光标自动定位到输入框
        todoinput.becomeFirstResponder()
        
        todoinput.text = name
        
        if name != nil{
            navigationItem.title = "编辑任务"
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    @IBAction func done(_ sender: Any) {
        if !todoinput.text!.isEmpty{
            if let name = todoinput.text,!name.isEmpty{
            if self.name != nil{
                delegate?.didEdit(name:name)
            }else{
                delegate?.didAdd(name: name)
            }
        }
        
            
            
        }
        navigationController?.popViewController(animated: true)
        
    }

    // MARK: - Table view data source

    

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

}
extension todoController:TodoDelegate{
    func didAdd(name: String) {
        <#code#>
    }*/
}

