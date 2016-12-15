//
//  BarChartViewController.swift
//  Twenty-Usage-Awareness
//
//  Created by Rohin Tangirala on 10/31/16.
//  Copyright © 2016 Rohin Tangirala. All rights reserved.
//

import UIKit
import Charts

class BarChartViewController: UIViewController {

    let defaults = UserDefaults.standard
    var days: [String]!
    var initialViewController : ViewController = ViewController()
    
    @IBOutlet weak var yAxisLabel: UILabel!
    @IBOutlet weak var barChartView: BarChartView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //barChartView.noDataText = "You need to provide data for the chart."
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.contentMode = UIViewContentMode.scaleAspectFill
        backgroundImage.image = UIImage(named: "pexels-photo")
        self.view.insertSubview(backgroundImage, at: 0)
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.frame
        
        self.view.insertSubview(blurEffectView, at: 1)
        
        
        yAxisLabel.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
        if let _ : AnyObject? = defaults.object(forKey: "usageTimes") as AnyObject?? {
            let mins = defaults.object(forKey: "usageTimes") as AnyObject?? as! [Double]
            if let _ : AnyObject? = defaults.object(forKey: "usageDates") as AnyObject?? {
                let dates = defaults.object(forKey: "usageDates") as AnyObject?? as! [String]
                setChart(dataPoints: dates, values: mins)
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setChart(dataPoints: [String], values: [Double]) {
        
        barChartView.noDataText = "You need to provide data for the chart."
        
        var dataEntries: [BarChartDataEntry] = Array()
        var counter = 0.0
        
        for i in 0..<dataPoints.count {
            counter += 1.0
            let dataEntry = BarChartDataEntry(x: counter, y: values[i])
            dataEntries.append(dataEntry)
        }

        let chartDataSet = BarChartDataSet(values: dataEntries, label: "Usage in minutes of each working period")
        let chartData = BarChartData()
        chartData.addDataSet(chartDataSet)
        barChartView.data = chartData
        self.barChartView.xAxis.drawGridLinesEnabled = false
        self.barChartView.legend.enabled = false
        self.barChartView.xAxis.drawLabelsEnabled = false
        self.barChartView.chartDescription?.text = "";
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
