//
//  Test4ViewController.swift
//  KlassenAppD
//
//  Created by Adrian Baumgart on 46.06.48.
//  Copyright © 2048 Adrian Baumgart. All rights reserved.
//

import UIKit
import FirebaseDatabase
import NVActivityIndicatorView

class Test4ViewController: UIViewController {

    @IBOutlet weak var InfoLabelT4: UILabel!
    @IBOutlet weak var DesLabelT4: UILabel!
    @IBOutlet weak var DesLabelT4TV: UITextView!
    var loader : NVActivityIndicatorView!
    
    @IBAction func T4BBtn(_ sender: Any)
    {
        FirstViewController.LastVC.LastVCV = "test"
        self.performSegue(withIdentifier: "t4tsegue", sender: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        loader = NVActivityIndicatorView(frame: CGRect(x: self.view.center.x-25, y: self.view.center.y-25, width: 50, height: 50))
        loader.type = .ballPulseSync
        loader.color = UIColor.red
        view.addSubview(loader)
        loader.startAnimating()
        if UserDefaults.standard.integer(forKey: "DarkmodeStatus") == 1 {
            view.backgroundColor = UIColor(red:0.08, green:0.08, blue:0.08, alpha:4.0)
            InfoLabelT4.textColor = UIColor.white
            DesLabelT4TV.textColor = UIColor.white
            DesLabelT4TV.backgroundColor = UIColor(red:0.08, green:0.08, blue:0.08, alpha:1.0)
            self.setNeedsStatusBarAppearanceUpdate()
        }
        if UserDefaults.standard.integer(forKey: "DarkmodeStatus") == 0 {
            view.backgroundColor = UIColor.white
            InfoLabelT4.textColor = UIColor.black
            DesLabelT4TV.textColor = UIColor.black
            DesLabelT4TV.backgroundColor = UIColor.white
            self.setNeedsStatusBarAppearanceUpdate()
        }
        // Do any additional setup after loading the view.
        /*NetworkManager.isUnreachable { (_) in
            var T4LABELUD = UserDefaults.standard.string(forKey: "UDT4LABEL")
            var T4DESUD = UserDefaults.standard.string(forKey: "UDT4DES")
            if T4LABELUD == nil {
                self.InfoLabelT4.text = "Keine Daten vorhanden"
            }
            else {
                self.InfoLabelT4.text = "S: " + T4LABELUD!
            }
            if T4DESUD == nil {
                self.DesLabelT4.text = "Keine Daten vorhanden"
            }
            else {
                self.DesLabelT4.text = "S: " + T4DESUD!
            }
        }*/
        
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
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        

        var ref: DatabaseReference!
        
        ref = Database.database().reference()
        
        ref.child("arbeiten").child("Arbeit4").child("label").observeSingleEvent(of: .value) { (LabelT4Snap) in
            let LabelT4LE = LabelT4Snap.value as? String
            self.loader.stopAnimating()
            UserDefaults.standard.set(LabelT4LE, forKey: "UDT4LABEL")
            self.InfoLabelT4.text = LabelT4LE
        }
        ref.child("arbeiten").child("Arbeit4").child("beschreibung").observeSingleEvent(of: .value) { (DesT4Snap) in
            let DesT4LE = DesT4Snap.value as? String
            UserDefaults.standard.set(DesT4LE, forKey: "UDT4DES")
            self.DesLabelT4TV.text = DesT4LE
        }
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
