//
//  ViewController.swift
//  JTAppleCalendarBonk
//
//  Created by Scott Puhl on 10/3/17.
//  Copyright © 2017 Muddlegeist Inc. All rights reserved.
//

import UIKit
import EasyPeasy

class ViewController: UIViewController {

    var calendarView = CalendarView()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.view.addSubview(self.calendarView)
        self.calendarView <- [Top(100.0),Left(0.0),Right(0.0),Height(220.0)]
        
        self.calendarView.jumpTo(date: Date())
    }
}

