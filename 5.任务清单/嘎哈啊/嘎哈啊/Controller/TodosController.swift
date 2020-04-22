//
//  TodosController.swift
//  嘎哈啊
//
//  Created by Leslie Zhao on 2020/4/22.
//  Copyright © 2020 Leslie Zhao. All rights reserved.
//

import UIKit

class TodosController: UITableViewController {
    var todos:[Todo] = []
    
    var row = 0
    @IBAction func batchDelete(_ sender: Any) {
        if let indexPaths = tableView.indexPathsForSelectedRows{
            for indexPath in indexPaths{
                todos.remove(at: indexPath.row)
            }
            
            // 数据存入本机
            saveData()
            // 更新视图
            tableView.beginUpdates()
            tableView.deleteRows(at: indexPaths, with: .automatic)
            tableView.endUpdates()
        }
       
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        editButtonItem.title = isEditing ? "整完了" : "弄一下"
        navigationItem.leftBarButtonItem = editButtonItem
        
        // 沙盒位置
        print(FileManager.default.urls(for:.documentDirectory, in: .userDomainMask))
        if let data = UserDefaults.standard.data(forKey: "todos"){
            do {
                todos = try JSONDecoder().decode([Todo].self, from: data)
            } catch  {
                print(error)
            }
        }
        
        
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        editButtonItem.title = isEditing ? "整完了" : "弄一下"
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return todos.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todo", for: indexPath) as! ToDOCell

        // Configure the cell...
        cell.todo.text = todos[indexPath.row].name
        cell.checkMark.text = todos[indexPath.row].checked ? "√" : ""
        

        return cell
    }
    
    // 当用户选择cell发生
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !isEditing{
            todos[indexPath.row].checked = !todos[indexPath.row].checked
            saveData()
            // 改视图view
            let cell = tableView.cellForRow(at: indexPath  ) as! ToDOCell
            cell.checkMark.text = todos[indexPath.row].checked ? "√" : ""
           
            // 取消cell选择状态，把底色去掉
            tableView.deselectRow(at: indexPath, animated:true)
        }
       
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    //Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            todos.remove(at: indexPath.row)
            //Delete; the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            //Create; a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "不要了奥"
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let todo = todos[sourceIndexPath.row]
        todos.remove(at: sourceIndexPath.row)
        todos.insert(todo, at: destinationIndexPath.row)
        
        // 更新视图
        // tableView.moveRow(at: sourceIndexPath, to:destinationIndexPath)
        tableView.reloadData()
    }

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

    // In a storyboard-based application, you will often want to do a little preparation before navigation*/
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "addTodo"{
            let vc = segue.destination as! todoController
            vc.delegate = self
        }else if segue.identifier == "editTodo"{
            let vc = segue.destination as! todoController
            let cell = sender as! ToDOCell
            row = tableView.indexPath(for: cell)!.row
            vc.name = todos[row].name
            vc.delegate = self
        }
    }
    

}
extension TodosController:TodoDelegate{
    func didAdd(name: String) {
        todos.append(Todo(name:name,checked: false))
        // 数据存到本机
        saveData()
        print(name)
        let indexPath = IndexPath(row:todos.count-1,section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    func didEdit(name: String) {
        todos[row].name = name
        saveData()
        let indexPath = IndexPath(row: row, section: 0)
        let cell = tableView.cellForRow(at: indexPath) as! ToDOCell
        cell.todo.text = name
    }
    
    func saveData(){
        do {
            let data = try JSONEncoder().encode(todos)
            UserDefaults.standard.set(data, forKey: "todos")
        } catch  {
            print(error)
        }
       
    }
}
