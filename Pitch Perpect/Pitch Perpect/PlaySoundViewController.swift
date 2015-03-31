//
//  PlaySoundViewController.swift
//  Pitch Perpect
//
//  Created by Joseph Tan on 3/27/15.
//  Copyright (c) 2015 Joseph Tan. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundViewController: UIViewController {
    
    var audioPlayer:AVAudioPlayer!
    var receivedAudio:RecordedAudio!
    
    var audioEngine:AVAudioEngine! //create audio engine
    var audioFile:AVAudioFile! //create audiofile, this will be used later since file receivedAudio is NSUrl
 
    func playAudioWithVariablePitch(pitch: Float){
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        
//        code in // is to play fix file say from hd
//        if var filePath = NSBundle.mainBundle().pathForResource("movie_quote", ofType: "mp3"){
//            var filepathurl = NSURL.fileURLWithPath(filePath)
//                    }
//        else {println("FIleMP3 not found")
//        
//        }
        
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer.enableRate=true
        
        audioEngine=AVAudioEngine()
        audioFile=AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func PlaySlow(sender: UIButton) {
        audioPlayer.stop()  //good practice to stop player before playing
        audioPlayer.currentTime=0.0
        audioPlayer.rate=0.5
        audioPlayer.play()
    }

    @IBAction func PlayFast(sender: UIButton) {
        audioPlayer.stop()  //good practice to stop player before playing
        audioPlayer.currentTime=0.0
        audioPlayer.rate=1.5
        audioPlayer.play()
    }
    
    
    
    @IBAction func PlayChipMunk(sender: UIButton) {
        playAudioWithVariablePitch(1000)
    }
    
    
    @IBAction func DarthVader(sender: UIButton) {
    playAudioWithVariablePitch(-1000)
    }
    
    @IBAction func StopPlay(sender: UIButton) {
    audioPlayer.stop()
    audioEngine.stop()
    audioEngine.reset()
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
