//
//  DaysOfWeekStackView.swift
//
//  Created by Scott Puhl on 10/3/17.
//  Copyright © 2017 Avirat Inc. All rights reserved.
//

import UIKit

class DaysOfWeekStackView : UIStackView
{
    required override init(frame: CGRect)
    {
        super.init(frame: frame)
        self.finishInit()
    }
    
    convenience init()
    {
        self.init(frame: CGRect.zero)
    }
    
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        self.finishInit()
    }
    
    func finishInit()
    {
        self.axis = .horizontal
        self.distribution = .fillEqually
        self.alignment = .bottom
        
        let dateFormatter = DateFormatter()
        if let daysOfWeek = dateFormatter.shortWeekdaySymbols
        {
            for day in daysOfWeek
            {
                let label = UILabel()
                label.textAlignment = .center
                label.text = day
                self.addArrangedSubview(label)
            }
        }
    }
}
