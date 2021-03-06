//
//  CalendarScheduleViewController.swift
//  carolina_fever_0
//
//  Created by Caleb Kang on 8/1/19.
//  Copyright © 2019 Caleb Kang. All rights reserved.
//

/*Global Color Variables that's used in all classes*/
let CAROLINA_BLUE = UIColor(red: 0.482, green: 0.686, blue: 0.831, alpha: 1)
let CAROLINA_NAVY = UIColor(red: 0.0745, green: 0.161, blue: 0.294, alpha: 1) // RGB:(19,41,75)

import UIKit
import Parse


class CalendarScheduleViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource  {
    
    // MARK: - Properties
    var schedule = [Game]()
    let calendar = Calendar(identifier: .gregorian)
    
    // calendar as 2d array of fever games
    var model = Array<[UICollectionViewCell?]>(repeating: Array<UICollectionViewCell?>(repeating: nil, count: 7), count: 6)
    var currentDate = Date()
    
    
    
    // MARK: - Outlets
    @IBOutlet var monthAndYear: UILabel!
    @IBOutlet var calendarView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentDate = calendar.startOfDay(for: currentDate)
        updateHeader()
        updateData()
    }
    
    // MARK: - Collection View Methods
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // 5 weeks
        return 7
    }
    
    /*this method renders each calendar view cell*/
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cellModel = model[indexPath.section][indexPath.row] as? CalendarCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "calendarCell", for: indexPath) as! CalendarCell
            
            cell.dateNumber.text = cellModel.dateNumber.text
            cell.isGameDay = cellModel.isGameDay
            cell.games = cellModel.games
            cell.event.text = cellModel.event.text
            cell.date = cellModel.date
            cell.backgroundColor = cellModel.backgroundColor
            
            return cell
        } else {
            return collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        }
        
        
        
    }
    
    /*called when user taps on one of the calendar cells. if the day is a gameday
     a list view of the game schedule for that day appears*/
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = model[indexPath.section][indexPath.row] as? CalendarCell {
            
            if cell.games.count != 0 {
                
                if let parentControl = parent as? ScheduleViewController {
                    
                    let filteredView = parentControl.listViewController
                    filteredView.schedule = cell.games
                    filteredView.tableView.reloadData()
                    
                    parentControl.addChild(filteredView)
                    parentControl.removeChild(viewController: self)
                    
                    parentControl.scheduleSwitcher.selectedSegmentIndex = -1
                }
                
            } else {
                // there are no games this day
            }
            
        } else {
            // cell selected not in the current month
        }
    }
    
    
    
    // MARK: - Action Buttons

    /*this method changes calendar to next month*/
    @IBAction func nextPressed(_ sender: UIButton) {
        currentDate = calendar.date(byAdding: Calendar.Component.month, value: 1, to: currentDate, wrappingComponents: false)!
        updateData()
        calendarView.reloadData()
        updateHeader()
    }
    
    /*this method changes calendar to previous month*/
    @IBAction func previousPressed(_ sender: UIButton) {
        currentDate = calendar.date(byAdding: Calendar.Component.month, value: -1, to: currentDate, wrappingComponents: false)!
        updateData()
        calendarView.reloadData()
        updateHeader()
    }
    
    // MARK: - Helper Methods
    
    func updateData() {
        
        for section in 0..<6 {
            for row in 0..<7 {
                
                /*get cell number of first day of month*/
                let components = DateComponents(calendar: calendar, timeZone: TimeZone.current, year: getCurrentYear(), month: getCurrentMonth(), day: 1)
                let first_date = calendar.date(from: components)
                let startCell = getDateNumber(date: first_date!)
                
                /*get cell number of last day of month*/
                let nextMonthDate = calendar.date(byAdding: Calendar.Component.month, value: 1, to: first_date!)
                let last_day = calendar.date(byAdding: Calendar.Component.day, value: -1, to: nextMonthDate!) // get first day of current month
                let lastCell = getDateNumber(date: last_day!)
                
                /*get cell number of currentCell*/
                let currentCell = (section*7) + (row+1)
                
                if startCell <= currentCell && currentCell <= lastCell {
                    
                    let date_comp = DateComponents(calendar: calendar, year: getCurrentYear(), month: getCurrentMonth(), day: currentCell-startCell+1)
                    let date = calendar.date(from: date_comp)
                    
                    let cell = calendarView.dequeueReusableCell(withReuseIdentifier: "calendarCell", for: IndexPath(row: row, section: section)) as! CalendarCell
                    
                    cell.date = date
                    cell.dateNumber.text = String(currentCell-startCell+1)
                    
                    var isAGameDay = false
                    
                    /*if today is a gameday put fever games on the calendar*/
                    for game in schedule {
                        if calendar.isDate(date!, inSameDayAs: game.date as Date) {
                            
                            cell.backgroundColor = CAROLINA_NAVY
                            cell.event.text = game.getDescription() as String
                            
                            cell.games.append(game)
                            cell.isGameDay = true
                            isAGameDay = true
                        }
                    }
                    
                    
                    if !isAGameDay {
                        cell.backgroundColor = CAROLINA_BLUE
                        cell.event.text = ""
                    }
                    
                    model[section][row] = cell
                } else {
                    /*not a calendar date*/
                    model[section][row] = UICollectionViewCell()
                }
            }
        }
    }
    
    /*method chooses the correct month string to display**/
    func updateHeader() {
        
        var months = ["January", "Feburary", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
        let month = months[(getCurrentMonth()-1) % 12]
        monthAndYear.text = "\(month) \(getCurrentYear())"
    }
    
    /*helper methods to get time components*/
    func getCurrentMonth() -> Int {
        return calendar.component(Calendar.Component.month, from: currentDate)
    }
    
    func getCurrentYear() -> Int {
        return calendar.component(Calendar.Component.year, from: currentDate)
    }
    
    func getCurrentDay() -> Int {
        return calendar.component(Calendar.Component.day, from: currentDate)
    }
    
    func getDateNumber(date: Date)->Int {
        let week = (calendar.component(Calendar.Component.weekOfMonth, from: date)-1) * 7
        let weekday = calendar.component(Calendar.Component.weekday, from: date)
        return week + weekday
    }

}
