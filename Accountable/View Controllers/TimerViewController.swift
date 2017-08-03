//
//  TimerViewController.swift
//  Accountable
//
//  Created by Lily Li on 7/20/17.
//  Copyright © 2017 Lily Li. All rights reserved.
//

import UIKit
import AVFoundation

class TimerViewController: UIViewController {
    
    var items = [Item]()
    var task: Task?
    
    var seconds = 0
    var timer = Timer()
    let group = DispatchGroup()
    
    var canTxt = true
    
    let systemSoundID: SystemSoundID = 1304
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "pinToCancel", sender: self)
    }
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var taskNameLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var itemsPageControl: UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        taskNameLabel.text = task?.title
        seconds = getTime()
        runTimer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(self.updateTimer)), userInfo: nil, repeats: true)
    }
    
    func updateTimer() {
        if seconds < 1 {
            timer.invalidate()
            seconds = 0
            print(items.count)
            collectionView.reloadData()
            print(seconds)
            if canTxt == true{
                performSegue(withIdentifier: "showSurvey", sender: self)
            }
            else{
                if items.count > 1{
                AudioServicesPlaySystemSound (systemSoundID)
                items.remove(at: 0)
                collectionView.reloadData()
                seconds = getTime()
                runTimer()
                }
                else{
                    performSegue(withIdentifier: "timerToCongrats", sender: self)
                }
            }
        }
        else {
            seconds -= 10
            timeLabel.text = ToStringHelper.timeString(time: TimeInterval(seconds))
        }
    }
    func getTime() -> Int {
        let item = items[0]
        return Int(item.itemTime)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSurvey" {
            let surveyViewController = segue.destination as! SurveyViewController
            surveyViewController.task = task!
            surveyViewController.items = items
            surveyViewController.item = items[0]
            AudioServicesPlaySystemSound (systemSoundID)
        }
        else if segue.identifier == "timerToCongrats" {
            let congratsViewController = segue.destination as! FinishTaskViewController
            congratsViewController.task = task!
        }
        else if segue.identifier == "pinToCancel" {
            let inputPinViewController = segue.destination as! InputPinViewController
            inputPinViewController.fromSB = .timer
        }
    }
    @IBAction func unwindSegueToTimer(for segue: UIStoryboardSegue, sender: Any) {
    }

}

extension TimerViewController: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let cellWidth = UIScreen.main.bounds.size.width
//        return CGSize(width: cellWidth, height: 300)
//    }
    
}

extension TimerViewController: UICollectionViewDataSource {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        itemsPageControl.currentPage = (collectionView.indexPathsForVisibleItems.first?.row)!
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.itemsPageControl.numberOfPages = items.count
        return items.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "itemCollectionViewCell", for: indexPath) as! ItemCollectionViewCell
        let row = indexPath.row
        cell.itemTitleLabel.text = items[row].itemTitle
        print(items[row].itemDescription)
        cell.itemDescriptionTextView.text = items[row].itemDescription
        cell.itemTimeLabel.text = ToStringHelper.timeString(time: items[row].itemTime)
        return cell
    }
    
}
