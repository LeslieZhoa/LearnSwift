### 一些相关知识
- table view
    - 创建table view
        - 控件创建<br>
            Table View Controller控件代替view Contrller主界面，并把页面指示箭头指向Table View
        - 控件class链接<br>
            新建一个Cocoa Touch Class 类型为UITableViewController,命名例如TodosController,可以删除掉ViewController.swift,将storyboard里的TableView界面的class设置为TodosController
        - 设置identify<br>
            打开storyboard，选择Table View下的Table View Cell,将其属性的identify更改为例todo
        - 设置cell的class<br>
            新建一个Cocoa Touch Class 类型为UITableViewCell,命名例如TodoCell,选择storyboard里Table View里的todo的class选择为TodoCell
        - 属性设置<br>
            todo的style设定为Custom,Accessory为Detail Disclosure
    - 创建存储数据的class
        ```swift
        // 创建Todo.swift写入如下
        import Foundation
        
        // 结构体，不需要init实例化,继承Codable即为可编码类型
        struct  Todo:Codable {
            var name = ""
            var checked = false
        }
        ```
    - 一些全局变量
        ```swift
        var row = 0
        var todos:[Todo] = []
        ```
    - 设置table view<br>
        在TodosController.swift里填写
        - 设置table view的段数
            ```swift
            override func numberOfSections(in tableView:UITableView) -> Int{
                return 1
            }
            ```
        - 设置行数
            ```swift
            override func tableView(_ tableView:UITableView,numberOfRowsInSection section:Int) -> Int{
                return todos.count
            }
            ```
        - 设置表格里的内容
            ```swift
            override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                let cell = tableView.dequeueReusableCell(withIdentifier: "todo", for: indexPath) as! ToDOCell
                
                // indexPath.row表示在第几行
                // indexPath.section表示在第几段
        
                // 设置todo里面label的text
                cell.todo.text = todos[indexPath.row].name
                // 三元运算符
                cell.checkMark.text = todos[indexPath.row].checked ? "√" : ""
                
        
                return cell
            }
            ```
        - 用户选择cell操作
            ```swift
            override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                
                // isEditing默认属性
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
            ```
        - 增加内容
            ```swift
            func didAdd(name: String) {
                todos.append(Todo(name:name,checked: false))
                // 数据存到本机
                saveData()
                let indexPath = IndexPath(row:todos.count-1,section: 0)
                tableView.insertRows(at: [indexPath], with: .automatic)
            }
            ```
        - 编辑内容
            ```swift
            func didEdit(name: String) {
                todos[row].name = name
                saveData()
                // 更新视图
                let indexPath = IndexPath(row: row, section: 0)
                let cell = tableView.cellForRow(at: indexPath) as! ToDOCell
                cell.todo.text = name
            }
            ```
        - 删除内容
            ```swift
            // 删除所选cell
            override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
                if editingStyle == .delete {
                    todos.remove(at: indexPath.row)
                    //Delete; the row from the data source
                    tableView.deleteRows(at: [indexPath], with: .fade)
                } else if editingStyle == .insert {
                    //Create; a new instance of the appropriate class, insert it into the array, and add a new row to the table view
                }    
            }
            
            // 更改删除label
            override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
                return "删除"
            }
    
            ```
        - 批量删除<br>
            主页面Table View的Editing属性改为Multiple Selection During Editing
            ```swift
            override func viewDidLoad() {
                super.viewDidLoad()
        
                // 设置编辑按钮和显示文本
                editButtonItem.title = isEditing ? "完成" : "编辑"
                navigationItem.leftBarButtonItem = editButtonItem
            }
            
            // 用户点击editButton调用方法 
            override func setEditing(_ editing: Bool, animated: Bool) {
                super.setEditing(editing, animated: animated)
                editButtonItem.title = isEditing ? "完成" : "编辑"
            }
            
            // 批量选择后点击删除button的函数
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
            ```
        
        - 移动数据
            ```swift
            override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
                let todo = todos[sourceIndexPath.row]
                todos.remove(at: sourceIndexPath.row)
                todos.insert(todo, at: destinationIndexPath.row)
                
                // 更新视图
                // tableView.moveRow(at: sourceIndexPath, to:destinationIndexPath)
                tableView.reloadData()
            }
            ```
    - 页面跳转
        - 创建新页面<br>
            storyboard拖进一个新的table view控件，新建一个Cocoa Touch Class 类型为UITableViewController,命名例如Todo Controller,将storyboard里的新的TableView界面的class设置为TodoController
        - 页面跳转特效<br>
            在storyboard点击第一个Table View的Table View Controller在右下角可以选择stack View处选择
            Navigation Controller,作用就是是一个接受页面的栈
        - 添加转换页面的按钮<br>
            在Navigation Item下添加Bar Butten Item控件属性system Item可以选择Add，Navigation Item的属性中title例如设置为任务清单，相应text就变为Text，Navigation Item也会重命名为任务清单
            ```swift
            // navigation item的标题可以根据代码指定
            navigationItem.title = "编辑任务"
            ```
        - 跳转界面动作<br>
            点击Add按住control拖拽到第二个table view界面Action Segeue选择show,同时会自动出现返回按钮；点击第一个table view里的任务清单，修改Back Button为取消，按钮也就显示取消字样；点击箭头identity属性改为addTodo
        -调整页面字体<br>
            选择navigation bar选中Prefers Large Titles，会使标题都变大，同时第二个table view的标题也会变大，向第二个table view 拖拽一个navigation item控件，title属性即为标题名称，
            Large Title属性可以选择Never就可以避免两个table view都是大标题
        - 跳转页面一些属性<br>
            ```swift
            override func viewDidLoad() {
                super.viewDidLoad()
                // 打开本页面，让光标自动定位到输入框
                todoinput.becomeFirstResponder()
                
                todoinput.text = name
                
                if name != nil{
                    navigationItem.title = "编辑任务"
                }
            }
            ```
        - 跳转页面回到主页面
            ```swift
            // 在button操作中添加
            // 出栈
            navigationController?.popViewController(animated: true)
            ```
        - 主页面的内容传递到跳转页面
            ```swift
            // 在主页面的swift里写入
            override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
                // 添加数据跳转页面传递到主页面
                if segue.identifier == "addTodo"{
                    let vc = segue.destination as! todoController
                    vc.delegate = self
                }else if segue.identifier == "editTodo"{
                    
                    // 主页面内容传递到跳转页面
                    let vc = segue.destination as! todoController
                    let cell = sender as! ToDOCell
                    row = tableView.indexPath(for: cell)!.row
                    vc.name = todos[row].name
                    vc.delegate = self
                }
            }
            ```
- 本地存储
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
