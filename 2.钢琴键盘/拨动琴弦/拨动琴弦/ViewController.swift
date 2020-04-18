//
//  ViewController.swift
//  拨动琴弦
//
//  Created by Leslie Zhao on 2020/4/18.
//  Copyright © 2020 Leslie Zhao. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

   let urlArray = ["note1","note2","note3","note4","note5","note6","note7"]
    var player:AVAudioPlayer!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBAction func notePressed(_ sender: UIButton) {
        play(sender.tag)
    }
    
    func play(_ tag:Int){
        let url = Bundle.main.url(forResource: urlArray[tag], withExtension: "wav")
        do{
            player = try AVAudioPlayer(contentsOf:url!)
            player.play()
        }catch{
            print(error)
        }
        
    }


}

