### 一些相关知识
- 相关控件
    - 新界面控件view Controller
    - 输入框text Field
- 计算属性
    ```swift
    import Foundation
    class Weather{
        
        // 温度
        var temp = 0
        
        // 城市
        var city = ""
        
        // 判断天气的依据
        var condition = 0
    
        // 计算属性--不能进行类型推断，根据其他属性推断自身
        // 指定返回图片名字
        var icon:String{
        
            switch (condition) {
                
            case 0...300 :
                return "tstorm1"
                
            case 301...500 :
                return "light_rain"
                
            case 501...600 :
                return "shower3"
                
            case 601...700 :
                return "snow4"
                
            case 701...771 :
                return "fog"
                
            case 772...799 :
                return "tstorm3"
                
            case 800 :
                return "sunny"
                
            case 801...804 :
                return "cloudy2"
                
            default :
                return "dunno"
            }
        }
    
    
    }
    ```
- apple自带gps管理
    - ```import CoreLocation```
        ```swift
        let locationManager = CLLocationManager()
        
        // 当app出现一次，执行一次里面代码
        override func viewDidAppear(_ animated:Bool){
            supper.viewDidAppear(animated)
            // 请求获取app权限
            locationManager.requestWhenInUseAuthorization() 
            
            // 操作完之后要设置相应属性，在info.plist添加相应的属性
            
        }
        ```
- 自带delegate操作
    - delegate--委托
    - protocol--协议
    ```swift
    // 首先要继承delegate类即遵守相应协议
    class ViewController:UIViewController,CLLocationManagerDelegate{
    
        override func viewDidLoad(){
            supper.viewDidLoad()
            
            // 指定代理人
            // 指定viewController给谁干活
            locationManager.delegate = self
            
            // 获取精度
            locationManager.desireAccuracy = kCLLocationAccuracyHundredMeters
            locationManager.requestLocation() // 请求用户位置，只请求一次
        }
        
        // 遵守协议还要实现相应功能
        // 当locationManager.requestLocation()操作时会调用下面函数，需要重写
        func locationManager(_ manager:CLLocationManager,didUpdateLocations locations:[CLLocation]){
            // 只请求一次
            
            // 获取经纬度
            let lat = locations[0].coordinate.latitude
            let lon = locations[0].coordinate.longitude
        }
    }
    ```
- cocoapods依赖库管理工具
    - cocoapods安装 
        - 官网安装app
        - 命令行```sudo gem install cocoapods```
    - cocoapods使用
        - 关闭项目，终端到项目目录下```pod init```
        - 在cocoapods的app里打开podfile
            ```ruby
            # 注释掉use_frameworks!该换成如下，为了在真机可调试
            use_modular_headers!
            
            # 在do里写入需要安装的依赖库，例如
            pod 'SVProgressHUD'
            
            # 点击右上角install进行安装
            
            # 如果安装速度慢，在podfile文件开头写入
            source 'https://github.com/CocoaPods/Specs.git'
            ```
- Alamofire网络请求
    - 安装，在podfile里写入```pod 'Alamofire'```进行安装
    - 实现功能
        ```swift
        import Alamofire 
        
        let appid = "e72ca729af228beabd5d20e3b7749713"
        
        // 遵守协议还要实现相应功能
        // 当locationManager.requestLocation()操作时会调用下面函数，需要重写
        func locationManager(_ manager:CLLocationManager,didUpdateLocations locations:[CLLocation]){
            // 只请求一次
            
            // 获取经纬度
            let lat = locations[0].coordinate.latitude
            let lon = locations[0].coordinate.longitude
             
            let paras = ["lat":"\(lat)", "lon":"\(lon)", "appid":appid]
            // 获取完经度纬度进行网络请求
            AF.request("https://api.openweathermap.org/data/2.5/weather",parameters: paras).responseJSON { response in
                if let json = response.value {
               
                    print("JSON: \(json)")
                
                }
            }
        
        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
           print(error)
           cityLabel.text = "获取位置失败"
       }
    
            
        }
        ```
- SwiftyJSON读取json文件
    - 安装，在podfile里写入```pod 'SwiftyJSON'```进行安装
    - 应用
        ```swift
        import SwiftyJSON
        
        
        let appid = "e72ca729af228beabd5d20e3b7749713"
        let weather = Weather()
        
        // 遵守协议还要实现相应功能
        // 当locationManager.requestLocation()操作时会调用下面函数，需要重写
        func locationManager(_ manager:CLLocationManager,didUpdateLocations locations:[CLLocation]){
            // 只请求一次
            
            // 获取经纬度
            let lat = locations[0].coordinate.latitude
            let lon = locations[0].coordinate.longitude
             
            let paras = ["lat":"\(lat)", "lon":"\(lon)", "appid":appid]
            // 获取完经度纬度进行网络请求
            AF.request("https://api.openweathermap.org/data/2.5/weather",parameters: paras).responseJSON { response in
                if let json = response.value {
                
                    // 读取json数据
                    let weather = JSON(json)
                    
                    // stringValue相比于string,如果返回为空不会报错而是返回一个空字符
                    self.weather.city = weather["name"].stringValue
                    self.weather.temp = Int(round(weather["main","temp"].doubleValue-273.15)) 
                    self.weather.condition = weather["weather",0,"id"].intValue
                    
                    // 给具体的label模块赋值，例如
                    self.cityLabel.text = self.weather.city
                    self.tempLabel.text = "\(self.weather.temp)"
                    self.imageView.image = UIImage(name:self.weather.icon)
                     
                
                }
            }
        ```
- 跳转界面之间连接
    - 两个页面跳转，点击主页面跳转按钮，按住control键拖到跳转页面，并选择相应Action Segue，将连接的箭头的identify设置名称例selectCity
    - 新建Cocoa Touch Class 文件，类型为UIViewController取名例SelectCityController
    - 将跳转页面的class选择为SelectCityController
    - 在viewControlller.swift下写入准备工作
        ```swift
        override func prepare(for segue:UIStoryboardSegue,sender:Any?){
            // segue即为两个界面连接的操作
            
            if segue.identifier == "selectCity"{
                
                // 强制转换类型
                let vc = segue.destination as! SelectCityController
                
                // vc相当于跳转页面的self，可以进行一些赋值操作
                vc.currentCity = weather.city
            
            }
        }
        ```
- 自定义protocol和delegate
    - [x] 在跳转页面自定义一个协议
        ```swift
        // 在SelectCityController.swift里写入
        protocol SelectCityDelegate{
            // 声明需要函数
            func didChangeCity(city:String)
        }
        ```
    - [x] 在跳转页面定义发生事件
        ```swift
        // 在SelectCityController.swift里写入
        class SelectCityController:UIViewController{
            var delegate:SelectCityDelegate?
        }
        ```
    - [x] 跳转页面按键触发事件发生
        ```swift
        // 在SelectCityController.swift的class SelectCityController里写入
        
        // button事件
        @IBAction func changeCity(_ sender:Any){
            // cityInput.text为输入框获取的文本
            delegate?.didChangeCity(city:cityInput.text!)
        }
        ```
    - [x] 在主页面遵守协议，并实现方法
        ```swift
        // 在ViewController.swift里写入
        
        // extension 扩展代码
        extension ViewController:SelectCityDelegate{
            // 实现协议方法
            func didChangeCity(city:String){
                let paras = ["q":city,"appid":appid]
                AF.request("https://api.openweathermap.org/data/2.5/weather",parameters: paras).responseJSON { response in
                    if let json = response.value {
                
                        // 读取json数据
                        let weather = JSON(json)
                        
                        // stringValue相比于string,如果返回为空不会报错而是返回一个空字符
                        self.weather.city = weather["name"].stringValue
                        self.weather.temp = Int(round(weather["main","temp"].doubleValue-273.15)) 
                        self.weather.condition = weather["weather",0,"id"].intValue
                        
                        // 给具体的label模块赋值，例如
                        self.cityLabel.text = self.weather.city
                        self.tempLabel.text = "\(self.weather.temp)"
                        self.imageView.image = UIImage(name:self.weather.icon)
                    }
                }
                
                // 销毁当前页面
                dismiss(animated:true,completion:nil)
                
            }
            
        }
        ```
    - [x] 指定代理人
        ```swift
        // 在ViewController.swift里写入
        override func prepare(for segue:UIStoryboardSegue,sender:Any?){
        // segue即为两个界面连接的操作
            
        if segue.identifier == "selectCity"{
                
            // 强制转换类型
            let vc = segue.destination as! SelectCityController
            
            // vc相当于跳转页面的self，可以进行一些赋值操作
            vc.currentCity = weather.city
            
            // 指定代理
            vc.delegate = self
        
            }
        }
        ```
