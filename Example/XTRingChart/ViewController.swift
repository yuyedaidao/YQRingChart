//
//  ViewController.swift
//  XTRingChart
//
//  Created by wyqpadding@gmail.com on 05/07/2019.
//  Copyright (c) 2019 wyqpadding@gmail.com. All rights reserved.
//

import UIKit
import XTRingChart

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let view = YQRingChart(frame: UIScreen.main.bounds)
        view.backgroundColor = UIColor.white
        view.items = [
            YQRingChartItem(number: 16, title: "大刘", color: UIColor.brown),
            YQRingChartItem(number: 36, title: "乔三", color: UIColor.blue),
            YQRingChartItem(number: 26, title: "狗蛋", color: UIColor.purple),
            YQRingChartItem(number: 11, title: "大刘", color: UIColor.orange),
            YQRingChartItem(number: 9, title: "乔三", color: UIColor.green),
            YQRingChartItem(number: 20, title: "狗蛋", color: UIColor.gray)
        ]
        self.view.addSubview(view)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

