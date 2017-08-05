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
    var originalItems = [Item]()
    var task: Task?
    
    var results = [Int]()
    
    var seconds = 0
    var timer = Timer()
    let group = DispatchGroup()
    
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        runTimer()
    }
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(self.updateTimer)), userInfo: nil, repeats: true)
    }
    
    func updateTimer() {
        
        if seconds < 1 {
            timer.invalidate()
            seconds = 0
            collectionView.reloadData()
            performSegue(withIdentifier: "showSurvey", sender: self)
            // AudioServicesPlaySystemSound (systemSoundID)
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
            surveyViewController.originalItems = originalItems
            surveyViewController.results = results
            
            if items.count > 1{
                surveyViewController.item = items[0]
                collectionView.reloadData()
            }
            else{
                surveyViewController.item = items[0]
                surveyViewController.isLastTime = true
                collectionView.reloadData()
            }
        }
        else if segue.identifier == "pinToCancel" {
            let inputPinViewController = segue.destination as! InputPinViewController
            inputPinViewController.fromSB = .timer
        }
    }
    @IBAction func unwindSegueToTimer(for segue: UIStoryboardSegue, sender: Any) {
    }
    
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
        if row == 0 {
            cell.currentTaskLabel.text = "⭐ current task"
        }
        else {
            cell.currentTaskLabel.text = ""
        }
        cell.itemTitleLabel.text = items[row].itemTitle
        print(items[row].itemDescription)
        cell.itemDescriptionTextView.text = items[row].itemDescription
        cell.itemTimeLabel.text = ToStringHelper.timeString(time: items[row].itemTime)
        cell.itemTimeLabel.adjustsFontSizeToFitWidth = true
        return cell
    }
    
}
