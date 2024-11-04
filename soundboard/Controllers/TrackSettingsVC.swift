//
//  TrackSettingsVC.swift
//  soundboard
//
//  Created by Safwan on 28/04/2024.
//

import UIKit

class TrackSettingsVC: UIViewController {

    //MARK: @IBOutlets
    @IBOutlet weak var lblVolume: UILabel!
    @IBOutlet weak var sliderVolume: UISlider!
    @IBOutlet weak var switchLoop: UISwitch!
    @IBOutlet weak var txtTrackName: UITextField!
    @IBOutlet weak var lblFadeIn: UILabel!
    @IBOutlet weak var sliderFadeIn: UISlider!
    @IBOutlet weak var lblFadeOut: UILabel!
    @IBOutlet weak var sliderFadeOut: UISlider!
    
    
    //MARK: Variables
    var board: Int = -1
    var track: Int = -1
    var fadeIn: Double = 0
    var fadeOut: Double = 0
    var duration: Double = 0
    
    var dismissHandler: (()-> Void) = {}
    
    var trackDeleted: Bool = false
    
    //MARK: LifeCycle Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        onLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        onAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        onDisappear()
    }
    
    //MARK: @IBActions
    @IBAction func onTapDone(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func onChangeVolume(_ sender: Any) {
        lblVolume.text = sliderVolume.value.toPercentageString(fractionDigits: 0)
    }
    
    @IBAction func onChangeFadeIn(_ sender: Any) {
        var decrease = sliderFadeIn.value > Float(fadeIn) ? false : true
        fadeIn = Double(sliderFadeIn.value)
        if decrease || (fadeIn + fadeOut <= duration) {
            lblFadeIn.text = "\(sliderFadeIn.value.rounded(toDecimalPlaces: 1))s"
        } else {
            lblFadeIn.text = "\(sliderFadeIn.value.rounded(toDecimalPlaces: 1))s"
            sliderFadeOut.value = Float(duration - fadeIn)
            lblFadeOut.text = "\(sliderFadeOut.value.rounded(toDecimalPlaces: 1))s"
        }
    }
    
    @IBAction func onChangeFadeOut(_ sender: Any) {
        var decrease = sliderFadeOut.value > Float(fadeOut) ? false : true
        fadeOut = Double(sliderFadeOut.value)
        if decrease || (fadeIn + fadeOut <= duration) {
            lblFadeOut.text = "\(sliderFadeOut.value.rounded(toDecimalPlaces: 1))s"
        } else {
            lblFadeOut.text = "\(sliderFadeOut.value.rounded(toDecimalPlaces: 1))s"
            sliderFadeIn.value = Float(duration - fadeOut)
            lblFadeIn.text = "\(sliderFadeIn.value.rounded(toDecimalPlaces: 1))s"
        }
    }
    
    @IBAction func onTapDeleteTrack(_ sender: Any) {
        UserManager.shared.savedBoards[board].tracks.remove(at: track)
        UserManager.shared.updateBoardsInUserDefaults()
        trackDeleted = true
        self.dismiss(animated: true)
    }
    
    
}

//MARK: Custom Functionality
extension TrackSettingsVC {
    func onLoad() {
        
    }
    
    func onAppear() {
        let selectedTrack = UserManager.shared.savedBoards[board].tracks[track]
        
        sliderVolume.value = selectedTrack.volume
        lblVolume.text = selectedTrack.volume.toPercentageString(fractionDigits: 0)
        
        switchLoop.isOn = selectedTrack.loop
        
        txtTrackName.text = selectedTrack.title
        
        sliderFadeIn.maximumValue = Float(selectedTrack.duration)
        sliderFadeIn.value = Float(selectedTrack.fadeIn)
        lblFadeIn.text = "\(sliderFadeIn.value.rounded(toDecimalPlaces: 1))s"
        
        sliderFadeOut.maximumValue = Float(selectedTrack.duration)
        sliderFadeOut.value = Float(selectedTrack.fadeOut)
        lblFadeOut.text = "\(sliderFadeOut.value.rounded(toDecimalPlaces: 1))s"
        
        duration = selectedTrack.duration
        
    }
    
    func onDisappear() {
        if !trackDeleted {
            UserManager.shared.updateTrackSettings(board: board, track: track, title: txtTrackName.text ?? "audio", volume: sliderVolume.value, loop: switchLoop.isOn, fadeIn: Double(sliderFadeIn.value), fadeOut: Double(sliderFadeOut.value))
        }
        dismissHandler()
    }


}
