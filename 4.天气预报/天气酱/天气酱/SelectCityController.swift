//
//  SelectCityController.swift
//  天气酱
//
//  Created by Leslie Zhao on 2020/4/20.
//  Copyright © 2020 Leslie Zhao. All rights reserved.
//

import UIKit

// 1.自定义一个协议及里面的事件方法
protocol SelectCityDelegate {
    func didChangeCity(city:String)
}
class SelectCityController: UIViewController {
    var currentCity = ""
    
    // 2.在本页面有一些事件发生，这些事件函数究竟存放在哪里--相当于告诉别人这个工具是谁所有
    var delegate:SelectCityDelegate?
    @IBOutlet weak var cityInput: UITextField!
    @IBOutlet weak var currentCityLabel: UILabel!
    
    @IBAction func changeCity(_ sender: Any) {
           delegate?.didChangeCity(city: cityInput.text!)
           dismiss(animated: true, completion: nil)
       }
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    // 究竟在哪里触发这些事件函数--在哪里使用这些工具
   
    override func viewDidLoad() {
        super.viewDidLoad()
        currentCityLabel.text = currentCity
        print(currentCity)

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
