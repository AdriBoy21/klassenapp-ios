//
//  TimeTableWednesdayViewController.swift
//  KlassenAppD
//
//  Created by Adrian Baumgart on 19.09.18.
//  Copyright © 2018 Adrian Baumgart. All rights reserved.
//

import UIKit

class TimeTableWednesdayViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var TVWednesdayTitle: UILabel!
    
    let WednesdayTVarray: [String] = ["1. Std: NwT/Spanisch", "2. Std: NwT/Spanisch", "3. Std: Physik", "4. Std: Physik", "5. Std: Geschichte Bili", "6. Std: Englisch"]
    
    @IBOutlet weak var TimeTableWednesdayTV: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UserDefaults.standard.integer(forKey: "DarkmodeStatus") == 1 {
            view.backgroundColor = UIColor(red:0.05, green:0.05, blue:0.05, alpha:1.0)
            TVWednesdayTitle.textColor = UIColor.white
            TimeTableWednesdayTV.backgroundColor = UIColor(red:0.05, green:0.05, blue:0.05, alpha:1.0)
            UIApplication.shared.statusBarStyle = .lightContent
        }
        
        if UserDefaults.standard.integer(forKey: "DarkmodeStatus") == 0 {
            view.backgroundColor = UIColor.white
            TVWednesdayTitle.textColor = UIColor.black
            TimeTableWednesdayTV.backgroundColor = UIColor.white
            UIApplication.shared.statusBarStyle = .default
        }


        // Do any additional setup after loading the view.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return WednesdayTVarray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellwed = TimeTableWednesdayTV.dequeueReusableCell(withIdentifier: "cellwednesday", for: indexPath)
        cellwed.textLabel?.text = WednesdayTVarray[indexPath.row]
        if UserDefaults.standard.integer(forKey: "DarkmodeStatus") == 1 {
            cellwed.backgroundColor = UIColor(red:0.05, green:0.05, blue:0.05, alpha:1.0)
            cellwed.textLabel!.textColor = UIColor.white
        }
        if UserDefaults.standard.integer(forKey: "DarkmodeStatus") == 0 {
            cellwed.backgroundColor = UIColor.white
            cellwed.textLabel!.textColor = UIColor.black
        }
        return cellwed
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
