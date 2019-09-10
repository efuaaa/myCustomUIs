//
//  ViewController.swift
//  myUis
//
//  Created by user on 06/09/2019.
//  Copyright © 2019 Qodehub. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var lineChart: LineChart!
    @IBOutlet weak var curvedlineChart: LineChart!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        
      
        let dataEntries = generateRandomEntries()
        
        
        lineChart.dataEntries = dataEntries
        lineChart.showDots = true
        lineChart.isCurved = false
        
        curvedlineChart.dataEntries = dataEntries
        curvedlineChart.showDots = true
        curvedlineChart.isCurved = true
    }
    
    private func generateRandomEntries() -> [PointEntry] {
        var result: [PointEntry] = []
        for i in 0..<100 {
            let value = Int(arc4random() % 500)
            
            let formatter = DateFormatter()
            formatter.dateFormat = "d MMM"
            var date = Date()
            date.addTimeInterval(TimeInterval(24*60*60*i))
            
            result.append(PointEntry(value: value, label: formatter.string(from: date)))
        }
        return result
    }
    
    
}

