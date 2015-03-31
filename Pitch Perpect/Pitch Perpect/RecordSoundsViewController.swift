//
//  RecordSoundsViewController.swift
//  Pitch Perpect
//
//  Created by Joseph Tan on 3/27/15.
//  Copyright (c) 2015 Joseph Tan. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var StopButton: UIButton!
    @IBOutlet weak var RecordingInProgress: UILabel!
    @IBOutlet weak var RecordButton: UIButton!
    
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        RecordButton.enabled=true
        StopButton.hidden=true
        RecordingInProgress.hidden=true
    }


    
    
    

    @IBAction func RecordButton(sender: UIButton) {
        RecordButton.enabled=false
        StopButton.hidden=false
        RecordingInProgress.hidden=false
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        println(filePath)
        
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate=self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        println("recording in progress")
    }

    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        
        if (flag){
            //save the audio file
            recordedAudio=RecordedAudio()
            recordedAudio.filePathUrl=recorder.url
            recordedAudio.title=recorder.url.lastPathComponent
            
            //go to next page
            self.performSegueWithIdentifier("StopMicRecording", sender: recordedAudio) //StopRecording is Segue from storyboard, recodedAudio is obj initiate d segue
        }
            
        else{
            println("Recording not Successful")
            RecordButton.enabled=true
            StopButton.hidden=true
        }
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier=="StopMicRecording"){
            let playSoundsVC:PlaySoundViewController = segue.destinationViewController as! PlaySoundViewController
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio=data
        }
    
    }
    
    @IBAction func StopRecording(sender: UIButton) {
        println("stop recording")
        RecordingInProgress.hidden=true
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
    }
}

