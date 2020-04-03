//
//  RecordSoundsViewController.swift
//  Pitcher
//
//  Created by MANINDER SINGH on 02/04/20.
//  Copyright © 2020 MANINDER SINGH. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController,AVAudioRecorderDelegate{
     var audioRecorder: AVAudioRecorder!

    @IBOutlet weak var tapStartLbl: UILabel!
    @IBOutlet weak var recordBtn: UIButton!
    @IBOutlet weak var stopBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        stopBtn.isEnabled=false
        // Do any additional setup after loading the view.
    }
    
    func updateUI(_ isRecording: Bool)
       {
           recordBtn.isEnabled = !isRecording
           stopBtn.isEnabled = isRecording
           tapStartLbl.text = isRecording ? "Recording in Progress" : "Tab to Record"
          
       }


    @IBAction func recordButtonPreesed(_ sender: UIButton) {
        updateUI(true)
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
           let recordingName = "recordedVoice.wav"
           let pathArray = [dirPath, recordingName]
           let filePath = URL(string: pathArray.joined(separator: "/"))

           let session = AVAudioSession.sharedInstance()
           try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)

           try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
           audioRecorder.delegate=self
           audioRecorder.isMeteringEnabled = true
           audioRecorder.prepareToRecord()
           audioRecorder.record()
        
    }
    @IBAction func stopButtonPressed(_ sender: UIButton) {
        
        updateUI(false)
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
        
    }
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag{
        performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        }else{
             print("Recording was not successful")
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier=="stopRecording"{
            let playSoundsVC=segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordAudioURL=recordedAudioURL
            
        }
    }
}

