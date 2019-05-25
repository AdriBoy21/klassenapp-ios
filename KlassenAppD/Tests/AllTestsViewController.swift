//
//  AllTestsViewController.swift
//  KlassenAppD
//
//  Created by Adrian Baumgart on 25.05.19.
//  Copyright © 2019 Adrian Baumgart. All rights reserved.
//

import UIKit
import Firebase
import SPFakeBar

class AllTestsViewController: UIViewController {

    let navigationbar = SPFakeBarView(style: .stork)
    
    override func viewDidLoad() {
        navigationbar.titleLabel.text = "Download..."
        navigationbar.titleLabel.font = navigationbar.titleLabel.font.withSize(23)
        navigationbar.height = 95
        navigationbar.titleLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        navigationbar.titleLabel.numberOfLines = 3
        self.view.addSubview(navigationbar)
        for subview in navigationbar.subviews {
            if subview is UIVisualEffectView {
                subview.removeFromSuperview()
            }
        }
        var teststextview = UITextView(frame: CGRect(x: 8, y: 100, width: self.view.frame.width - 16, height: self.view.frame.height - 100))
        teststextview.isEditable = false
        teststextview.text = "Download..."
        teststextview.font = .systemFont(ofSize: 16)
        
        self.view.addSubview(teststextview)
        if UserDefaults.standard.integer(forKey: "DarkmodeStatus") == 1 {
            view.backgroundColor = UIColor(red:0.05, green:0.05, blue:0.05, alpha:1.0)
            navigationbar.backgroundColor = UIColor(red:0.13, green:0.13, blue:0.13, alpha:1.0)
            navigationbar.titleLabel.textColor = .white
            teststextview.textColor = .white
            teststextview.backgroundColor = UIColor(red:0.05, green:0.05, blue:0.05, alpha:1.0)
            self.setNeedsStatusBarAppearanceUpdate()
        }
        if UserDefaults.standard.integer(forKey: "DarkmodeStatus") == 0 {
            view.backgroundColor = UIColor.white
            navigationbar.backgroundColor = UIColor(red:0.95, green:0.95, blue:0.95, alpha:1.0)
            navigationbar.titleLabel.textColor = .black
            teststextview.textColor = .black
            teststextview.backgroundColor = .white
            self.setNeedsStatusBarAppearanceUpdate()
        }
        
        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        ref.child("arbeiten").child(TestVC.selectedTest).child("label").observeSingleEvent(of: .value) { (datesnap) in
            let DateLE = datesnap.value as? String
            self.navigationbar.titleLabel.text = DateLE
        }
        
        ref.child("arbeiten").child(TestVC.selectedTest).child("beschreibung").observeSingleEvent(of: .value) { (TestsSnap) in
            let TestsLE = TestsSnap.value as? String
            teststextview.text = TestsLE
            
        }
        
        
        // Do any additional setup after loading the view.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        var style: UIStatusBarStyle!
        if UserDefaults.standard.integer(forKey: "DarkmodeStatus") == 1 {
            style = .lightContent
        }
        else if UserDefaults.standard.integer(forKey: "DarkmodeStatus") == 0 {
            style = .default
        }
        return style
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    struct TestVC {
        static var selectedTest = ""
    }

}