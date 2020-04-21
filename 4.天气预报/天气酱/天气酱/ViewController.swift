//
//
//  Created by Leslie Zhao on 2020/4/18.
//  Copyright © 2020 Leslie Zhao. All rights reserved.
//
import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

// delegate - 委托
// protocol - 协议
// 一旦遵守某个协议，就意味着你需要干一些脏活累活，实现一些协议里没有实现的函数


class ViewController: UIViewController {
    
    
    let locationManager = CLLocationManager()
    let weather = Weather()
    let appid = "e72ca729af228beabd5d20e3b7749713"
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // 一开始viewController遵守CLLocationManagerDelegate之后，他干完活（实现函数）
        // 依然不知道具体给谁干
        // 下面这句让viewcontroller知道，究竟给谁做事情
        locationManager.delegate = self // CLLocationManager代理人是self
        // Do any additional setup after loading the view.
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters //设置位置信息
        locationManager.requestLocation() // 请求用户位置，只请求一次
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        locationManager.requestWhenInUseAuthorization() //请求获取当前位置
        
        
        
    }
    // 当请求用户位置时立刻调用这个方法--系统调用，不需要我们自己调用
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let lat = locations[0].coordinate.latitude
        let lon = locations[0].coordinate.longitude
        print(lat,lon)
        let paras = ["lat":"\(lat)", "lon":"\(lon)", "appid":appid]
        getWeather(paras:paras)
        
                
                
                
        }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "selectCity"{
             let vc = segue.destination as! SelectCityController
             vc.currentCity = weather.city
            
             // 3.第二个页面事件函数委托给本controller实现
             vc.delegate = self
        }
    }
        
    
    
}

// 扩展代码
// 1.遵守协议
extension ViewController:CLLocationManagerDelegate,SelectCityDelegate{
    
    // 2.实现协议里必选方法
    func didChangeCity(city: String) {
        let paras = ["q":city, "appid":appid]
        
        getWeather(paras:paras)
        print(city)
    }
    func getWeather(paras:[String:String]) {
            AF.request("https://api.openweathermap.org/data/2.5/weather",parameters: paras).responseJSON { response in
            if let json = response.value {
                let weather = JSON(json )
                self.createWeather(weatherJSON: weather)
                //print(self.weather.city,self.weather.temp)
                self.updateUI()
                
                
                    }
            }
        }
    func createWeather(weatherJSON:JSON){
        weather.city = weatherJSON["name"].stringValue
        weather.temp = Int(round(weatherJSON["main","temp"].doubleValue-273.15))
        weather.condition = weatherJSON["weather",0,"id"].intValue
    }
    
    func updateUI(){
        cityLabel.text = weather.city
        tempLabel.text = "\(weather.temp)˚"
        imageView.image = UIImage(named:weather.icon)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
           print(error)
           cityLabel.text = "获取位置失败"
       }
    
}


