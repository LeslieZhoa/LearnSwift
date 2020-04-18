//
//  ViewController.swift
//  Dicee
//
//  Created by Leslie Zhao on 2020/4/17.
//  Copyright © 2020 Leslie Zhao. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var index1: Int = 0
    var index2: Int = 0
    let diceArray = ["yes","no"]

   
    
    @IBOutlet weak var imageView1: UIImageView!
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        updateImage()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        updateImage()
    }
    
    func updateImage(){
        index1 = Int.random(in: 0...1)
        //print(index1)
        imageView1.image = (UIImage(named: diceArray[index1]))
        
    }


}

