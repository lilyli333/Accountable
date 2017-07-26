//
//  TimerViewController.swift
//  Accountable
//
//  Created by Lily Li on 7/20/17.
//  Copyright © 2017 Lily Li. All rights reserved.
//

import UIKit

class TimerViewController: UIViewController {
    
    var items = [Item]()
    var task: Task?
    
    var seconds = 0
    var timer = Timer()
    let group = DispatchGroup()
    
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var taskNameLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var itemsPageControl: UIPageControl!
    override func viewDidLoad() {
        super.viewDidLoad()
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
            performSegue(withIdentifier: "showSurvey", sender: self)
        }
//        else if seconds == -10 {
//            print("end timer")
//        }
        else {
            seconds -= 30
            timeLabel.text = ToStringHelper.timeString(time: TimeInterval(seconds))
        }
    }
    func getTime() -> Int {
        //if items.count > 0 {
            let item = items[0]
            return Int(item.itemTime)
        //}
//        else{
//            //RUN ENDING SEQUENCE
//            return -10
//        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSurvey" {
            let surveyViewController = segue.destination as! SurveyViewController
            surveyViewController.task = task!
            surveyViewController.items = items
            surveyViewController.item = items[0]
        }
    }
}

extension TimerViewController: UICollectionViewDelegate {
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
