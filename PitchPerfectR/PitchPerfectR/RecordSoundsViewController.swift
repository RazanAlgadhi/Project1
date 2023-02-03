//
//  RecordSoundsViewController.swift
//  PitchPerfectR
//
//  Created by pc on 27/01/2023.
//
import UIKit
import AVFoundation
//indication that i conform to the AVAduioRecorderDelegate by adding the protocol here;
class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    //Property: this proprty gives this viewcontroller the ability to use and refrence the audioRecorder in multiple places
    var audioRecorder: AVAudioRecorder!
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    @IBOutlet weak var recordingLabel: UILabel!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        setPlayButtonsEnabled(true)
    }
    
    //Actoins
    @IBAction func recordAudio(_ sender: Any) {
        setPlayButtonsEnabled(false)
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        //then gets combined with a filename for the recording
               let recordingName = "recordedVoice.wav"
        //the last to lines actually combines the both the directory path and the recording name to create a full path for our file
               let pathArray = [dirPath, recordingName]
               let filePath = URL(string: pathArray.joined(separator: "/"))
//AVAudiosession is what is needed to either record or playback audio; the avaudiosession class is basically an abstraction of the entiore audio hardware
               let session = AVAudioSession.sharedInstance()
               try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)

               try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        //this is to tell the AVAduioRecorderDelegate that this VC will act as its delegate
               audioRecorder.delegate = self
               audioRecorder.isMeteringEnabled = true
               audioRecorder.prepareToRecord()
               audioRecorder.record()
        
    }
    
    
    @IBAction func stopRecording(_ sender: Any) {
        setPlayButtonsEnabled(true)
        //To stop recording button
            audioRecorder.stop()
            let audioSession = AVAudioSession.sharedInstance()
            try! audioSession.setActive(false)
    }
    
    //this is the method i need to call the stopRecording button's segue
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
       //the flag is needed to make sure the required file is finshed and saved 
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        } else {
            print("recording was not successful")
        }
    }
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
    

    func setPlayButtonsEnabled(_ enabled: Bool) {
        stopRecordingButton.isEnabled = !enabled
        recordButton.isEnabled = enabled
        if enabled {
            recordingLabel.text = "Tap to Record"
        } else {
            recordingLabel.text = "Recording in progress"
        }
        
    }
 
    
}

