//
//  CalendarView.swift
//  OFW
//
//  Created by Scott Puhl on 9/29/17.
//  Copyright © 2017 Muddlegeist Inc. All rights reserved.
//

import UIKit
import JTAppleCalendar
import EasyPeasy

class CalendarView: UIView
{
    var yearHeaderView = UILabel()
    var monthHeaderView = UILabel()
    var daysStackView = DaysOfWeekStackView()
    var jtCalendarView = JTAppleCalendarView()
    
    let formatter = DateFormatter()
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        finishInit()
    }
    
    convenience init()
    {
        self.init(frame: CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        finishInit()
    }
    
    func finishInit()
    {
        self.yearHeaderView.textAlignment = .center
        self.yearHeaderView.text = "DUMMY"
        self.addSubview(self.yearHeaderView)
        self.yearHeaderView <- [Top(0.0),Left(0.0),Right(0.0),Height(20.0)]
        
        self.monthHeaderView.textAlignment = .center
        self.monthHeaderView.text = "DUMMY"
        self.addSubview(self.monthHeaderView)
        self.monthHeaderView <- [Top(0.0).to(self.yearHeaderView),Left(0.0),Right(0.0),Height(20.0)]
        
        self.addSubview(self.daysStackView)
        self.daysStackView <- [Top(0.0).to(self.monthHeaderView),Left(0.0),Right(0.0),Height(20.0)]
        
        self.jtCalendarView.calendarDataSource = self
        self.jtCalendarView.calendarDelegate = self
        self.jtCalendarView.scrollDirection = .horizontal
        self.jtCalendarView.isPagingEnabled = true
        self.jtCalendarView.showsHorizontalScrollIndicator = false
        self.jtCalendarView.showsVerticalScrollIndicator = false
        self.jtCalendarView.register( UINib(nibName: "OFWCalendarCell", bundle: nil), forCellWithReuseIdentifier: "OFWCalendarCell")
        self.jtCalendarView.allowsMultipleSelection  = true
        self.jtCalendarView.isRangeSelectionUsed = true
        self.jtCalendarView.minimumLineSpacing = 0.0
        self.jtCalendarView.minimumInteritemSpacing = 0.0
        self.jtCalendarView.contentInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)
        self.jtCalendarView.sectionInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)
        
        self.addSubview(self.jtCalendarView)
        self.jtCalendarView <- [Top(0.0).to(self.daysStackView),Left(0.0),Right(0.0),Bottom(0.0)]
    }
    
    func handleCellTextColor(view: JTAppleCell?, cellState: CellState)
    {
        guard let ofwCell = view as? OFWCalendarCell
            else {
            return
        }
        
        if cellState.isSelected
        {
            ofwCell.dayLabel?.textColor = UIColor.blue
        }
        else
        {
            if cellState.dateBelongsTo == .thisMonth
            {
                ofwCell.dayLabel?.textColor = UIColor.black
            }
            else
            {
                ofwCell.dayLabel?.textColor = UIColor.red
            }
        }
    }
    
    func handleCellSelection(view: JTAppleCell?, cellState: CellState)
    {
        guard let ofwCell = view as? OFWCalendarCell
            else {
                return
        }
        
        let round:CGFloat = 10.0
        
        if cellState.isSelected
        {
            ofwCell.selectedView?.isHidden = false
            
            switch cellState.selectedPosition()
            {
            case .full:
                ofwCell.selectedView?.roundCorners(radius: round, corners: .allCorners)
                
            case .left:
                ofwCell.selectedView?.roundCorners(radius: round, corners: [.bottomLeft,.topLeft])
                
            case .right:
                ofwCell.selectedView?.roundCorners(radius: round, corners: [.bottomRight,.topRight])
                
            case .middle:
                ofwCell.selectedView?.roundCorners(radius: 0.0, corners: .allCorners)
                
            default:
                ofwCell.selectedView?.roundCorners(radius: 0.0, corners: .allCorners)
                
            }
        }
        else
        {
            ofwCell.selectedView?.isHidden = true
            ofwCell.roundCorners(radius: 0.0, corners: .allCorners)
        }
    }
    
    func jumpTo(date:Date)
    {
        self.jtCalendarView.scrollToDate(date, triggerScrollToDateDelegate: true, animateScroll: false, completionHandler: {})
    }
    
    func scrollTo(date:Date)
    {
        self.jtCalendarView.scrollToDate(date)
    }
}

extension CalendarView : JTAppleCalendarViewDataSource
{
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters
    {
        let today = Date()
        let oneYearPreviousDate = Calendar.current.date(byAdding: .year, value: -1, to: today)
        let oneYearLaterDate = Calendar.current.date(byAdding: .year, value: 1, to: today)
        
        let startDate = oneYearPreviousDate ?? Date()
        let endDate = oneYearLaterDate ?? Date()                              // You can also use dates created from this function
        let parameters = ConfigurationParameters(startDate: startDate,
                                                 endDate: endDate,
                                                 numberOfRows: 4, // Only 1, 2, 3, & 6 are allowed
            calendar: Calendar.current,
            generateInDates: .forAllMonths,
            generateOutDates: .tillEndOfGrid,
            firstDayOfWeek: .sunday)
        return parameters
    }
}

extension CalendarView : JTAppleCalendarViewDelegate
{
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell
    {
        let cellIdentifier = "OFWCalendarCell"
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: cellIdentifier, for: indexPath)
        
        if let ofwCell = cell as? OFWCalendarCell
        {
            ofwCell.dayLabel?.text = cellState.text
            ofwCell.selectedView?.backgroundColor = UIColor.yellow
            
            self.handleCellTextColor(view: cell, cellState: cellState)
            self.handleCellSelection(view: cell, cellState: cellState)
        }
        
        return cell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState)
    {
        self.handleCellTextColor(view: cell, cellState: cellState)
        self.handleCellSelection(view: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState)
    {
        self.handleCellTextColor(view: cell, cellState: cellState)
        self.handleCellSelection(view: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo)
    {
        if let firstMonthDate = visibleDates.monthDates.first?.date
        {
            self.formatter.dateFormat = "yyyy"
            self.yearHeaderView.text = self.formatter.string(from: firstMonthDate)
            
            self.formatter.dateFormat = "MMMM"
            self.monthHeaderView.text = self.formatter.string(from: firstMonthDate)
        }
    }
}

