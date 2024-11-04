//
//  MainVC.swift
//  soundboard
//
//  Created by Safwan on 26/04/2024.
//

import UIKit
import AVFoundation
import MobileCoreServices
import RevenueCat
import RevenueCatUI
import StoreKit

class MainVC: UIViewController {

    //MARK: @IBOutlets
    @IBOutlet weak var collectBoards: UICollectionView!
    @IBOutlet weak var collectTracks: UICollectionView!
    @IBOutlet weak var btnNewBoard: UIButton!
    @IBOutlet weak var btnAddTrack: UIButton!
    @IBOutlet weak var lblNoTracks: UILabel!
    @IBOutlet weak var lblNoBoards: UILabel!
    
    //MARK: Variables
    var selectedBoard: Int = -1
    
    var audioPlayer: AVAudioPlayer?

    var currentTracks: [Track] = []
    
    var currentlyPlayingTrack: Int = -1
    
    var fadeOutWorkItem: DispatchWorkItem?
    
    //MARK: LifeCycle Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        onLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        onAppear()
    }
    
    //MARK: @IBActions
    @IBAction func onTapNewBoard(_ sender: UIButton) {
        if UserManager.shared.savedBoards.count > 0 && !UserManager.shared.premium {
            self.showAlert(withTitle: "Purchase Premium", message: "To create multiple boards purchase premium plan") { status in
                self.showIAP()
            }
            return
        }
        
        self.showAlertWithInputField(withTitle: "Create New Deck", message: "Please enter the name you would like to create a new deck with", placeholder: "board name") { text, noEntry in
            if !noEntry {
                if text.count == 0 {
//                    self.showErrorToast(message: "Board name cant be empty", seconds: 1.5)
                    self.showAlert(withTitle: "No Boards", message: "Board name can't be empty")

                    return
                }
                UserManager.shared.addNewBoard(newBoard: Board(title: text))
                if self.selectedBoard == -1 {
                    self.selectedBoard = 0
                    self.navigationItem.title = UserManager.shared.savedBoards[self.selectedBoard].title
                }
                self.collectBoards.reloadData()
            }
        }
    }
    
    @IBAction func onTapAddTrack(_ sender: UIButton) {
        if selectedBoard == -1 {
//            self.showErrorToast(message: "Please add a new deck first", seconds: 1.5)
            self.showAlert(withTitle: "No Boards", message: "Please add a new Board first")

            return
        }
        
        if currentTracks.count > 3 && !UserManager.shared.premium {
            self.showAlert(withTitle: "Purchase Premium", message: "To add more than 4 tracks purchase premium plan") { status in
                self.showIAP()
            }
            return
        }
        
        presentDocumentPicker()
    }
    
    
    
    @objc func settingsAlert() {
        
        var alertStyle = UIAlertController.Style.actionSheet
        if (UIDevice.current.userInterfaceIdiom == .pad) {
          alertStyle = UIAlertController.Style.alert
        }
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: alertStyle)
        
        
        
        let deleteAllTracks = UIAlertAction(title: "Delete all tracks from Current Deck", style: .default) { action in
            if self.currentTracks.count == 0 {
                self.showAlert(withTitle: "No Tracks", message: "There are no tracks in the current selected board to delete")
                return
            }
            
            self.askAlert(withTitle: "Are you sure?", message: "Do you want to delete all the tracks from the currently selected board: \(UserManager.shared.savedBoards[self.selectedBoard].title)", okBtnTitle: "Yes", cancelBtnTitle: "No") { status in
                if status {
                    UserManager.shared.savedBoards[self.selectedBoard].tracks.removeAll()
                    UserManager.shared.updateBoardsInUserDefaults()
                    self.currentTracks.removeAll()
                    self.collectTracks.reloadData()
                    self.currentlyPlayingTrack = -1
                    self.stopAudio()
                }
            }
        }
        
        let deleteCurrentBoard = UIAlertAction(title: "Delete Current Deck", style: .default) { action in
            if self.selectedBoard == -1 {
                self.showAlert(withTitle: "No Board Selected", message: "Select the baord from the bottom to delete")
                return
            }
            
            self.askAlert(withTitle: "Are you sure?", message: "Do you want to delete the currently selected board: \(UserManager.shared.savedBoards[self.selectedBoard].title)", okBtnTitle: "Yes", cancelBtnTitle: "No") { status in
                if status {
                    UserManager.shared.savedBoards.remove(at: self.selectedBoard)
                    UserManager.shared.updateBoardsInUserDefaults()
                    self.currentTracks.removeAll()
                    self.currentlyPlayingTrack = -1
                    self.stopAudio()
                    
                    if UserManager.shared.savedBoards.count != 0 {
                        self.selectedBoard = 0
                        self.navigationItem.title = UserManager.shared.savedBoards[self.selectedBoard].title
                        self.currentTracks = UserManager.shared.savedBoards[self.selectedBoard].tracks
                    } else {
                        self.selectedBoard = -1
                        self.navigationItem.title = ""
                    }
                    
                    self.collectTracks.reloadData()
                    self.collectBoards.reloadData()
                    
                }
            }
        }

        let deleteAllBoards = UIAlertAction(title: "Delete All Decks", style: .default) { action in
            if UserManager.shared.savedBoards.count == 0 {
                self.showAlert(withTitle: "No Boards", message: "There are no boards to delete")
                return
            }
            
            self.askAlert(withTitle: "Are you sure?", message: "Do you want to delete all the boards", okBtnTitle: "Yes", cancelBtnTitle: "No") { status in
                if status {
                    UserManager.shared.savedBoards.removeAll()
                    UserManager.shared.updateBoardsInUserDefaults()
                    self.currentTracks.removeAll()
                    self.currentlyPlayingTrack = -1
                    self.stopAudio()
                    self.selectedBoard = -1
                    self.collectBoards.reloadData()
                    self.collectTracks.reloadData()
                    self.navigationItem.title = ""
                }
            }
        }
        
        let restoreSubscription = UIAlertAction(title: "Restore Premium Access", style: .default) { action in
            if UserManager.shared.premium {
                self.showAlert(withTitle: "Already have Premium!", message: "You already have premium access. ")
            }
            
            Purchases.shared.restorePurchases { customerInfo, error in
                if customerInfo?.entitlements.all["premium"]?.isActive == true {
                    UserManager.shared.premium = true
                    self.navigationItem.leftBarButtonItem = nil
                    UserManager.shared.updatePremiumStatus(status: true, date: customerInfo?.entitlements.all["premium"]?.expirationDate)
                    self.showAlert(withTitle: "Premium Resotred", message: "Your premium subscription has been restored succesfully")

                }
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(deleteAllTracks)
        alertController.addAction(deleteCurrentBoard)
        alertController.addAction(deleteAllBoards)
        alertController.addAction(restoreSubscription)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }
    
    @objc func appDidEnterBackground() {
        if !UserManager.shared.premium {
            currentlyPlayingTrack = -1
            collectTracks.reloadData()
            stopAudio()
        }
    }
    
    @objc func showIAP() {
        //        let nextVC = Constants.MainStoryboard.instantiateViewController(withIdentifier: "SubscriptionVC") as! SubscriptionVC
        //        nextVC.modalTransitionStyle = .crossDissolve
        //        nextVC.modalPresentationStyle = .overCurrentContext
        //        nextVC.subscriptionSuccess = {
        //            self.navigationItem.leftBarButtonItem = nil
        //        }
        //        self.present(nextVC, animated: true)
        
        let nextVC = PaywallViewController()
        nextVC.delegate = self
        
        present(nextVC, animated: true, completion: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

//MARK: Custom Functionality
extension MainVC {
    func onLoad() {
        setupCollectionView()
        setupAudioSession()
        checkForReviewPopup()
        
        let rightBtn = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .plain, target: self, action: #selector(settingsAlert))
        self.navigationItem.rightBarButtonItem = rightBtn
        
        NotificationCenter.default.addObserver(self, selector: #selector(appDidEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        
        checkPremiumStatus()
        
        if UserManager.shared.premium {
            if let expireDate = UserManager.shared.expireDate {
                if expireDate > Date() {
                    UserManager.shared.updatePremiumStatus(status: false, date: nil)
                }
            }
        }
        
    }
    
    func onAppear() {
        if UserManager.shared.savedBoards.count > 0 {
            selectedBoard = 0
            currentTracks = UserManager.shared.savedBoards[selectedBoard].tracks
            self.navigationItem.title = UserManager.shared.savedBoards[selectedBoard].title
        }
        
        if !UserManager.shared.premium {
            let leftBtn = UIBarButtonItem(title: "Get Premium ➜", style: .plain, target: self, action: #selector(showIAP))
            self.navigationItem.leftBarButtonItem = leftBtn
        } else {
            self.navigationItem.leftBarButtonItem = nil
        }
    }
    
    func checkForReviewPopup() {
        let launchCounts = UserDefaults.standard.integer(forKey: "launchCounts")
        UserDefaults.standard.set(launchCounts + 1, forKey: "launchCounts")
        
        // Example: Request review on every 10th launch.
        if launchCounts % 10 == 0 {
            if #available(iOS 10.3, *) {
                SKStoreReviewController.requestReview()
            }
        }
    }
    
    func checkPremiumStatus() {
        Purchases.shared.getCustomerInfo { (customerInfo, error) in
            if customerInfo?.entitlements.all["premium"]?.isActive == true {
                
                UserManager.shared.premium = true
                self.navigationItem.leftBarButtonItem = nil
            } else {
                let leftBtn = UIBarButtonItem(title: "Get Premium!", style: .plain, target: self, action: #selector(self.showIAP))
                leftBtn.tintColor = .black
                self.navigationItem.leftBarButtonItem = leftBtn
                UserManager.shared.premium = false
                
                if UserDefaults.standard.bool(forKey: "hasLaunchedOnce") == false {
                    self.showIAP()
                    UserDefaults.standard.set(true, forKey: "hasLaunchedOnce")
                    UserDefaults.standard.synchronize()
                }
            }
        }
    }
    
}

//MARK: UICollectionViewDelegate
extension MainVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func setupCollectionView() {
        collectBoards.delegate = self
        collectBoards.dataSource = self
        collectBoards.register(BoardCollectionViewCell.nib, forCellWithReuseIdentifier: BoardCollectionViewCell.identifier)
        
        collectTracks.delegate = self
        collectTracks.dataSource = self
        collectTracks.register(TrackCollectionViewCell.nib, forCellWithReuseIdentifier: TrackCollectionViewCell.identifier)
        
        setupLongPressGesture()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectBoards {
            lblNoBoards.isHidden = UserManager.shared.savedBoards.count == 0 ? false : true
            return UserManager.shared.savedBoards.count
        } else {
            lblNoTracks.isHidden = currentTracks.count == 0 ? false : true
            return currentTracks.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == collectBoards {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BoardCollectionViewCell.identifier, for: indexPath) as! BoardCollectionViewCell
            
            cell.setupCell(title: UserManager.shared.savedBoards[indexPath.row].title, isSelected: (selectedBoard == indexPath.row))
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackCollectionViewCell.identifier, for: indexPath) as! TrackCollectionViewCell
            
            cell.setupCell(track: currentTracks[indexPath.row], isPlaying: (currentlyPlayingTrack == indexPath.row))
            
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == collectBoards {
            if traitCollection.horizontalSizeClass == .compact {
                return CGSize(width: 120, height: collectBoards.frame.height)
            } else {
                return CGSize(width: 240, height: collectBoards.frame.height)
            }
            
        } else {
            if traitCollection.horizontalSizeClass == .compact {
                return CGSize(width: collectTracks.frame.width / 2 - 5, height: 120)
            } else {
                return CGSize(width: collectTracks.frame.width / 4 - 15, height: 180)
            }
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == collectBoards {
            selectedBoard = indexPath.row
            self.navigationItem.title = UserManager.shared.savedBoards[selectedBoard].title
            collectBoards.reloadData()
            currentTracks = UserManager.shared.savedBoards[selectedBoard].tracks
            collectTracks.reloadData()
            currentlyPlayingTrack = -1
            stopAudio()
        } else {
            playTrack(trackToPlay: indexPath.row)
        }
    }
    
    private func setupLongPressGesture() {
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gesture:)))
        longPressRecognizer.minimumPressDuration = 0.5  // Duration in seconds
        collectTracks.addGestureRecognizer(longPressRecognizer)
    }

    @objc func handleLongPress(gesture: UILongPressGestureRecognizer) {
        if gesture.state != .began {
            return
        }
        
        let point = gesture.location(in: collectTracks)
        if let indexPath = collectTracks.indexPathForItem(at: point) {
            performAction(for: indexPath)
        } else {
            print("Long press at \(point) did not correspond to any item in the collection view.")
        }
    }

    private func performAction(for indexPath: IndexPath) {
        let nextVC = Constants.MainStoryboard.instantiateViewController(withIdentifier: "TrackSettingsVC") as! TrackSettingsVC
        nextVC.modalPresentationStyle = .formSheet
        nextVC.board = selectedBoard
        nextVC.track = indexPath.row
        nextVC.dismissHandler = {
            self.currentTracks = UserManager.shared.savedBoards[self.selectedBoard].tracks
            self.collectTracks.reloadData()
        }
        self.present(nextVC, animated: true)
    }
    
}

//MARK: Audio Playing Functionality
extension MainVC: UIDocumentPickerDelegate, AVAudioPlayerDelegate {
    func presentDocumentPicker() {
        let documentPicker = UIDocumentPickerViewController(documentTypes: [kUTTypeAudio as String], in: .import)
        documentPicker.delegate = self
        documentPicker.modalPresentationStyle = .formSheet
        self.present(documentPicker, animated: true, completion: nil)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let url = urls.first else { return }
        
        var duration: Double = 0
        do {
            duration = try AVAudioPlayer(contentsOf: url).duration
        } catch {
            self.showAlert(withTitle: "Error!", message: "Failed to retrieve selected audio's information")
            return
        }
        
        let audioTrack = Track(title: url.lastPathComponent, path: url, duration: duration)
        UserManager.shared.savedBoards[selectedBoard].tracks.append(audioTrack)
        currentTracks.append(audioTrack)
        collectTracks.reloadData()
        UserManager.shared.updateBoardsInUserDefaults()
        
        
    }

    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("Document picker was cancelled")
    }
    
    func playTrack(trackToPlay: Int) {
        do {
            if currentlyPlayingTrack == trackToPlay {
                stopAudio()
            } else {
                if let url = currentTracks[trackToPlay].path {
                    audioPlayer = try AVAudioPlayer(contentsOf: url)
                    audioPlayer?.delegate = self
                    audioPlayer?.prepareToPlay()
                    audioPlayer?.volume = 0
                    currentlyPlayingTrack = trackToPlay
                    playAudio()
                    collectTracks.reloadData()
                }
            }
        } catch {
            self.showAlert(withTitle: "Error!", message: "Failed to initialize player: \(error)")
        }
    }
    
    func playAudio() {
        fadeOutWorkItem?.cancel()
        audioPlayer?.play()
        audioPlayer?.setVolume(currentTracks[currentlyPlayingTrack].volume, fadeDuration: currentTracks[currentlyPlayingTrack].fadeIn)
        
        if currentTracks[currentlyPlayingTrack].fadeOut >= 0 && !currentTracks[currentlyPlayingTrack].loop {
            let fadeOutTrack = currentlyPlayingTrack
            fadeOutWorkItem = DispatchWorkItem {
                print(self.currentlyPlayingTrack)
                self.audioPlayer?.setVolume(0, fadeDuration: self.currentTracks[fadeOutTrack].fadeOut)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + currentTracks[currentlyPlayingTrack].duration - currentTracks[currentlyPlayingTrack].fadeOut, execute: fadeOutWorkItem!)
        }
    }

    func stopAudio() {
        fadeOutWorkItem?.cancel()
        audioPlayer?.stop()
        audioPlayer?.currentTime = 0 // Optional: Reset audio to start
        currentlyPlayingTrack = -1
        collectTracks.reloadData()
    }

    func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to set up audio session: \(error)")
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if currentTracks[currentlyPlayingTrack].loop {
            audioPlayer?.play()
        } else {
            currentlyPlayingTrack = -1
            collectTracks.reloadData()
        }
    }
    
}

//MARK: RevenueCat Paywall
extension MainVC: PaywallViewControllerDelegate {
    func paywallViewController(_ controller: PaywallViewController,
                               didFinishPurchasingWith customerInfo: CustomerInfo) {
        checkPremiumStatus()
    }

}

