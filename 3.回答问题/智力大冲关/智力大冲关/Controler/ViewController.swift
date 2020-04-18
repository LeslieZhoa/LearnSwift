//
//  ViewController.swift
//  智力大冲关
//
//  Created by Leslie Zhao on 2020/4/18.
//  Copyright © 2020 Leslie Zhao. All rights reserved.
//

import SwiftUI

class ViewController: UIViewController {

    
    var questionNum = 0
    var score = 0
    let questionArray = [Question("卷积具有平移不变性",false),
    Question("池化层具有平移不变性",true),
    Question("棋盘效应是由于卷积尺度无法整除",true),
    Question("1+1=2是否正确呢？",true),
    Question("陈景润的师傅是华罗庚",true),
    Question("钱学森是两弹一星",true),
    Question("东北大学了不起",true)
    ]
    lazy var  length = questionArray.count
    
    
    @IBOutlet weak var showQuestion: UILabel!
    
    @IBOutlet weak var showNum: UILabel!
    
    @IBOutlet weak var showScore: UILabel!
    @IBOutlet weak var showSpeed: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        showQuestion.text = questionArray[0].question
        showNum.text = "\(1)/\(length)"
        showSpeed.frame.size.width = (view.frame.width / CGFloat(length))
    }
    @IBAction func progessLabel(_ sender: UIButton) {
        checkAnswer(sender.tag)
        questionNum += 1
        updateQuestion()
        updateUI()
    }
    func updateQuestion(){
        if questionNum < length{
            showQuestion.text = questionArray[questionNum].question
        }
        else{
            questionNum = 0
            score = 0
            let alert = UIAlertController(title:"漂亮！", message: "您的问题都已答完了哦！", preferredStyle:.alert )
            alert.addAction(UIAlertAction(title:"再来一遍？",style:.default,handler: {(_) in
                self.showQuestion.text = self.questionArray[0].question
                self.showScore.text = "总得分：0"
                self.updateUI()
            }) )
            present(alert,animated: true,completion: nil)
        }
    }
    func updateUI(){
        showNum.text = "\(questionNum + 1)/\(length)"
        showSpeed.frame.size.width = (view.frame.width / CGFloat(length)) * CGFloat(questionNum + 1)
    }
    func checkAnswer(_ tag:Int){
        if tag == 0{
            if questionArray[questionNum].answer == true{
                score += 10
                showScore.text = "总得分：\(score)"
                ProgressHUD.showSuccess("答对了呢！")
            }else{
                ProgressHUD.showError("很遗憾不对哦")
            }
        }
        else{
            if questionArray[questionNum].answer == false{
                score += 10
                showScore.text = "总得分：\(score)"
                ProgressHUD.showSuccess("答对了呢！")
                
            }else{
                ProgressHUD.showError("很遗憾不对哦")
            }
            
        }
    
    }
    
}
