### 一些相关知识

- userdefaults--存储本地轻量数据
    - 沙盒位置--本地存储位置
        ```swift
        print(FileManager.default.urls(for:.documentDirectory, in: .userDomainMask))
        ```
    - 把数据变换为Data类型存入
        ```swift
        func saveData(){
            do {
                
                // 数据编码成data形式
                let data = try JSONEncoder().encode(todos)
                UserDefaults.standard.set(data, forKey: "todos")
            } catch  {
                print(error)
            }
           
        }
        ```
    - 数据解码读取
        ```swift
        if let data = UserDefaults.standard.data(forKey: "todos"){
            do {
                todos = try JSONDecoder().decode([Todo].self, from: data)
            } catch  {
                print(error)
            }
        }
        ```
- coreData<br>
    是在5的基础上更改
    - 准备<br>
        - [ ] 用户新建项目时，选中use core data
        - [ ] 实质是在AppDelegate.swift里新增里一些Core Data Stack的代码，再新建一个Core Data里的Data Model文件例命名为Todo
    - 设置数据类型
        - [ ] 点击新建的Todo.xcdatamodeld,点击Add Entity新建模型，可以更改其名字，例Todo;
        - [ ] Attribute添加name:String,checked:Boolean,新增的两个属性栏都取消勾选option即不可选型
        - [ ] 可以删除Todo.swift的数据类型
    - 存储数据
        - [ ] 准备工作<br>
            1.修改name
            ```swift
            // 在AppDelegate.swift里的lazy var persistentContainer: NSPersistentCloudKitContainer修改name
            lazy var persistentContainer: NSPersistentCloudKitContainer = {
       
                let container = NSPersistentCloudKitContainer(name: "Todo")
                container.loadPersistentStores(completionHandler: { (storeDescription, error) in
                    if let error = error as NSError? {
                        
                        fatalError("Unresolved error \(error), \(error.userInfo)")
                    }
                })
                return container
            }()
            ```
            2.引入CoreData
            ```swift
            // 在TodosController.swift下
            import CoreData
            ```
            3.实例化数据
            ```swift
            func didAdd(name: String) {
                
                // 实例化数据
                let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                let todo = Todo(context: context)
                todo.name = name
                todo.checked = false
                todos.append(todo)
                
                ....
            }
            ```
        - [ ] 存储数据
            ```swift
            func saveData(){
                do {
                    try context.save()
                } catch  {
                    print(error)
                }
               
            }
            ```
    - 加载数据
        ```swift
        do {
            todos = try context.fetch(Todo.fetchRequest())
        } catch  {
            print(error)
        }
        ```
    - 数据删除
        ```swift
        override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                
                // 先删除数据库数据，再删除todos数据
                context.delete(todos[indexPath.row])
                todos.remove(at: indexPath.row)
                saveData()
                //Delete; the row from the data source
                tableView.deleteRows(at: [indexPath], with: .fade)
            } else if editingStyle == .insert {
                //Create; a new instance of the appropriate class, insert it into the array, and add a new row to the table view
            }    
        }
        ```
- Realm
    - 安装<br>
        - [ ] 进入realm的官网，点击产品选择database,语言选择swift,下载for mac的app并安装
        - [ ] cd到项目文件下，命令行输入```pod init```生成podfile文件
        - [ ] 使用Cocoapods打开podfile并添加```pod 'RealmSwift'```进行安装
    - 创建数据类型
        - [ ] 新建一个swift file文件命名如Todo
        - [ ] 创建数据类型
            ```swift
            // 删除Core Data的Todo.xcdatamodeld
            // Todo.swift下写入
            import Foundation
            import RealmSwift
            
            class Todo: Object {
                @objc dynamic var name = ""
                @objc dynamic var checked = false
                @objc dynamic var createAT = Date()
            }
            ```
    - 沙盒位置
        ```swift
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        ```
    - 实例化数据库
        ```swift
        let realm = try! Realm()
        ```
    - 保存数据
        ```swift
        func saveData(_ todo:Todo){
            do {
                try realm.write {
                    realm.add(todo)
                }
            } catch  {
                print(error)
            }
           
        }
        ```
    - 读取数据
        ```swift
        // 添加全局todos
        var todos:Results<Todo>?
        
        // 从realm读取数据
        todos = realm.objects(Todo.self)
        
        // 每行显示内容
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
        ```
    - 添加数据
        ```swift
        func didAdd(name: String) {
        
        
            let todo = Todo()
            todo.name = name
            
            // 数据存到本机
            saveData(todo)
            
            // 更新视图
            tableView.reloadData()
        }
        ```
    - 空合运算符
        ```swift
        // 如果为空返回1
        todos?.count ?? 1
        ```
    - 修改数据
        ```swift
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
        ```
    - 删除数据
        ```swift
        //Override to support editing the table view.
        override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
             do {
                        try realm.write {
                            realm.delete(todos![indexPath.row])
                        }
                    } catch{
                        print(error)
                    }
            // 更新视图
            tableView.reloadData()
        }
        ```
    - 一些搜索排序操做
        
        - 添加search bar 控件，可以拖拽设定delegate
        ```swift
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
        ```
