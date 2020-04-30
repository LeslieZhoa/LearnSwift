//
//  TodosController.swift
//  嘎哈啊
//
//  Created by Leslie Zhao on 2020/4/22.
//  Copyright © 2020 Leslie Zhao. All rights reserved.
//

import UIKit
import RealmSwift

class TodosController: UITableViewController {
    var todos:Results<Todo>?
    let realm = try! Realm()
    var row = 0
    @IBAction func batchDelete(_ sender: Any) {
        if let indexPaths = tableView.indexPathsForSelectedRows{
            for indexPath in indexPaths{
               do {
                   try realm.write {
                       realm.delete(todos![indexPath.row])
                   }
               } catch{
                   print(error)
               }
            }
            
            // 数据存入本机
            //saveData()
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
        
        // 从realm读取数据
        todos = realm.objects(Todo.self)
        
        
        
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
        return todos?.count ?? 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todo", for: indexPath) as! ToDOCell
        
        // Configure the cell...
        if let todos = todos{
        cell.todo.text = todos[indexPath.row].name
        cell.checkMark.text = todos[indexPath.row].checked ? "√" : ""
        }else{
            cell.todo.text = "开始一些任务"
        }

        
        
        return cell
    }
    
    // 当用户选择cell发生
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !isEditing{
            do {
                try realm.write {
                    todos![indexPath.row].checked = !todos![indexPath.row].checked
                    
                }
            } catch  {
                print(error)
            }
            // 更新视图
            tableView.reloadData()
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
            do {
                        try realm.write {
                            realm.delete(todos![indexPath.row])
                        }
                    } catch{
                        print(error)
                    }
            // 更新视图
            tableView.reloadData()
        }else if editingStyle == .insert {
            //Create; a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
        
        
         
    }
    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "不要了奥"
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let todo = todos![sourceIndexPath.row]
        do {
            try realm.write {
                todos![sourceIndexPath.row].name = todos![destinationIndexPath.row].name
                todos![sourceIndexPath.row].checked = todos![destinationIndexPath.row].checked
            }
        } catch{
            print(error)
        }
        do {
            try realm.write {
                todos![destinationIndexPath.row].name = todo.name
                todos![destinationIndexPath.row].checked = todo.checked
            }
        } catch{
            print(error)
        }
        
        
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
            vc.name = todos?[row].name
            vc.delegate = self
        }
    }
    

}
extension TodosController:TodoDelegate,UISearchBarDelegate{
    func didAdd(name: String) {
        
        
        let todo = Todo()
        todo.name = name
        
        // 数据存到本机
        saveData(todo)
        
        // 更新视图
        tableView.reloadData()
    }
    func didEdit(name: String) {
        do {
            try realm.write {
                todos![row].name = name
            }
        } catch{
            print(error)
        }
        // 更新视图
        tableView.reloadData()
    }
    
    
    func saveData(_ todo:Todo){
        do {
            try realm.write {
                realm.add(todo)
            }
        } catch  {
            print(error)
        }
       
    }
    
    // search之后todoscontroller干的事情
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // 查询数据
        // predicate 断言规定要怎么查询
        // 查询name 中包含search bar中文本的数据，并按createAT属性排序
        todos = realm.objects(Todo.self).filter("name CONTAINS %@", searchBar.text!).sorted(byKeyPath: "createAT",ascending: false)
        // 更新视图
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text!.isEmpty{
            // 显示所有数据
            todos = realm.objects(Todo.self)
            
            // 更新视图
            tableView.reloadData()
            
            // 让光标软键盘收起
            // 让用户在主线程优先执行
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
}

