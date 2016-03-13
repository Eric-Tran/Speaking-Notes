//
//  stViewController.swift
//  OCR _Test
//
//  Created by Jonathan Ly on 1/16/16.
//  Copyright © 2016 River Inn Technology. All rights reserved.
//

import UIKit
import AVFoundation

class stViewController: UIViewController {

    @IBOutlet weak var textArea: UITextView!
    
    var textString: String!
    
    let synth = AVSpeechSynthesizer()
    var myUtterance = AVSpeechUtterance(string: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.textArea.text = self.textString

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func textSpeechButton(sender: UIButton) {
        if !synth.speaking{
        myUtterance = AVSpeechUtterance(string: textArea.text)
        myUtterance.rate = 0.5
        synth.speakUtterance(myUtterance)
        }
        else{
            synth.continueSpeaking()
        }
    }
    @IBAction func pauseSpeechButton(sender: UIButton) {
        
        synth.pauseSpeakingAtBoundary(AVSpeechBoundary.Word)
        
    }

    @IBAction func stopSpeechButton(sender: UIButton) {
        synth.stopSpeakingAtBoundary(AVSpeechBoundary.Immediate)
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
