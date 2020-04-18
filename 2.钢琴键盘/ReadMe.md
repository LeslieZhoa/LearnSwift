### 使用音视频功能
```swift
import AVFoundation

let url = Bundle.main.url(forResource:"note1",withExtension:"wav")
do{
    let player = try AVAudioPlayer(contenstsOf:url!)
    player.play()
}
catch{
    print(error)
}
```
