//
//  TableViewController.swift
//  Twenty-Usage-Awareness
//
//  Created by Rohin Tangirala on 10/31/16.
//  Copyright © 2016 Rohin Tangirala. All rights reserved.
//

import UIKit
import MessageUI

class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate {
    
    let defaults = UserDefaults.standard
    var gDates: [String] = []
    var gMins : [Double] = []
    var combinedData : [String] = []
    @IBOutlet weak var tableView: UITableView!
    @IBAction func emailButton(_ sender: Any) {
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        }
    }
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        
        
        mailComposerVC.setSubject("Twenty - Usage Time Log")
        
        
        let joinedString = combinedData.joined(separator: "\n")

        mailComposerVC.setMessageBody(joinedString, isHTML: false)
        
        return mailComposerVC
    }
    
    
    
    // MARK: MFMailComposeViewControllerDelegate
    
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult, error: Error?) {
        // Check the result or perform other tasks.
        
        // Dismiss the mail compose view controller.
        controller.dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.contentMode = UIViewContentMode.scaleAspectFill
        backgroundImage.image = UIImage(named: "pexels-photo")
        self.view.insertSubview(backgroundImage, at: 0)
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.frame
        
        self.view.insertSubview(blurEffectView, at: 1)
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        if let _ : AnyObject? = defaults.object(forKey: "usageTimes") as AnyObject?? {
            let mins = defaults.object(forKey: "usageTimes") as AnyObject?? as! [Double]
            gMins = mins
            if let _ : AnyObject? = defaults.object(forKey: "usageDates") as AnyObject?? {
                let dates = defaults.object(forKey: "usageDates") as AnyObject?? as! [String]
                gDates = dates
                for i in 0..<gDates.count {
                    combinedData.append(String(Int(gMins[i])) + " min - " + gDates[i])
                }
                
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.combinedData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
        
        cell.textLabel?.text = self.combinedData[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
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
