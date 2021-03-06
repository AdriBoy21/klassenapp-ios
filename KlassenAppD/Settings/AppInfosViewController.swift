//
//  AppInfosViewController.swift
//  KlassenAppD
//
//  Created by Adrian Baumgart on 28.12.18.
//  Copyright © 2018 Adrian Baumgart. All rights reserved.
//

import FirebaseDatabase
import SPFakeBar
import UIKit

class AppInfosViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let navigationbar = SPFakeBarView(style: .stork)
    
    private var InfoTV: UITableView!
    
    var style = Appearances()
    
    var n1: [String] = ["Appname: KlassenApp", "Bundle-Identifier: \(AppInfoPublic.bundleid!)", "Appversion: \(AppInfoPublic.version) (Build: \(AppInfoPublic.build)) [\(AppInfoPublic.versionType)]", "Website: https://klassenappd.de", "E-Mail-Adresse: mail@klassenappd.de", "Erstveröffentlichung: 19.Juli 2018", "App-Entwickler: Adrian Baumgart", "Datenbank: Firebase Database", "© Adrian Baumgart, 2018 - 2019"]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return n1.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "infocell")
        cell?.textLabel?.numberOfLines = 0
        cell?.textLabel?.lineBreakMode = .byTruncatingTail
        cell?.textLabel!.text = n1[indexPath.row]
        
        if UserDefaults.standard.integer(forKey: "AutoAppearance") == 1 {
            if #available(iOS 13.0, *) {
                if traitCollection.userInterfaceStyle == .dark {
                    cell?.backgroundColor = UIColor(red: 0.05, green: 0.05, blue: 0.05, alpha: 1.0)
                    cell?.textLabel!.textColor = UIColor.white
                }
                else if traitCollection.userInterfaceStyle == .light || traitCollection.userInterfaceStyle == .unspecified {
                    cell?.backgroundColor = UIColor.white
                    cell?.textLabel!.textColor = UIColor.black
                }
            }
        }
        else {
            if UserDefaults.standard.integer(forKey: "DarkmodeStatus") == 1 {
                cell?.backgroundColor = UIColor(red: 0.05, green: 0.05, blue: 0.05, alpha: 1.0)
                cell?.textLabel!.textColor = UIColor.white
            }
            else if UserDefaults.standard.integer(forKey: "DarkmodeStatus") == 0 {
                cell?.backgroundColor = UIColor.white
                cell?.textLabel!.textColor = UIColor.black
            }
        }
        
        return cell!
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationbar.titleLabel.text = "Appinformationen"
        navigationbar.titleLabel.font = navigationbar.titleLabel.font.withSize(23)
        navigationbar.height = 95
        navigationbar.titleLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        navigationbar.titleLabel.numberOfLines = 3
        view.addSubview(navigationbar)
        for subview in navigationbar.subviews {
            if subview is UIVisualEffectView {
                subview.removeFromSuperview()
            }
        }
        
        let titlebar = UIView(frame: CGRect(x: 0, y: navigationbar.height - 1, width: view.frame.width, height: 3))
        titlebar.backgroundColor = UIColor(red: 0.61, green: 0.32, blue: 0.88, alpha: 1.0)
        
        if UserDefaults.standard.string(forKey: "TitleBarColor") != nil, UserDefaults.standard.string(forKey: "TitleBarColor") != "" {
            titlebar.backgroundColor = UIColor(red: CGFloat(UserDefaults.standard.integer(forKey: "TitleBarRed")) / 255, green: CGFloat(UserDefaults.standard.integer(forKey: "TitleBarGreen")) / 255, blue: CGFloat(UserDefaults.standard.integer(forKey: "TitleBarBlue")) / 255, alpha: 1)
        }
        view.addSubview(titlebar)
        
        InfoTV = UITableView(frame: CGRect(x: 8, y: 100, width: view.frame.width - 16, height: view.frame.height - 150))
        InfoTV.register(UITableViewCell.self, forCellReuseIdentifier: "infocell")
        InfoTV.dataSource = self
        InfoTV.delegate = self
        view.addSubview(InfoTV!)
        
        changeAppearance()
        loadData()
        
        InfoTV.allowsSelection = false
        InfoTV.estimatedRowHeight = 85
        InfoTV.rowHeight = UITableView.automaticDimension
    }
    
    func loadData() {
        let ref: DatabaseReference = Database.database().reference()
        
        ref.child("versions").child("ios").child("releases").child("all_releases").observe(.value) { (snapshot) in
            if snapshot.hasChild(Bundle.main.infoDictionary!["CFBundleVersion"] as! String) {
                // RELEASE
                AppInfoPublic.versionType = "Release"
                self.n1 = ["Appname: KlassenApp", "Bundle-Identifier: \(AppInfoPublic.bundleid!)", "Appversion: \(AppInfoPublic.version) (Build: \(AppInfoPublic.build)) [\(AppInfoPublic.versionType)]", "Website: https://klassenappd.de", "E-Mail-Adresse: mail@klassenappd.de", "Erstveröffentlichung: 19.Juli 2018", "App-Entwickler: Adrian Baumgart", "Datenbank: Firebase Database", "© Adrian Baumgart, 2018 - 2019"]
                self.InfoTV.reloadData()
            }
            else {
                ref.child("versions").child("ios").child("betas").child("all_betas").observe(.value) { (snapshoti) in
                    if snapshoti.hasChild(Bundle.main.infoDictionary!["CFBundleVersion"] as! String) {
                        // BETA
                        AppInfoPublic.versionType = "Beta"
                        self.n1 = ["Appname: KlassenApp", "Bundle-Identifier: \(AppInfoPublic.bundleid!)", "Appversion: \(AppInfoPublic.version) (Build: \(AppInfoPublic.build)) [\(AppInfoPublic.versionType)]", "Website: https://klassenappd.de", "E-Mail-Adresse: mail@klassenappd.de", "Erstveröffentlichung: 19.Juli 2018", "App-Entwickler: Adrian Baumgart", "Datenbank: Firebase Database", "© Adrian Baumgart, 2018 - 2019"]
                        self.InfoTV.reloadData()
                    }
                    else {
                        //UNIDENFIED
                        
                        AppInfoPublic.versionType = "Not identifiable"
                        self.n1 = ["Appname: KlassenApp", "Bundle-Identifier: \(AppInfoPublic.bundleid!)", "Appversion: \(AppInfoPublic.version) (Build: \(AppInfoPublic.build)) [\(AppInfoPublic.versionType)]", "Website: https://klassenappd.de", "E-Mail-Adresse: mail@klassenappd.de", "Erstveröffentlichung: 19.Juli 2018", "App-Entwickler: Adrian Baumgart", "Datenbank: Firebase Database", "© Adrian Baumgart, 2018 - 2019"]
                        self.InfoTV.reloadData()
                    }
                }
            }
        }
    }
    
    func changeAppearance() {
        if UserDefaults.standard.integer(forKey: "AutoAppearance") == 1 {
            if #available(iOS 13.0, *) {
                if traitCollection.userInterfaceStyle == .dark {
                    view.backgroundColor = style.darkBackground
                    navigationbar.backgroundColor = style.darkTitleBackground
                    navigationbar.titleLabel.textColor = style.darkText
                    InfoTV.backgroundColor = style.darkBackground
                    setNeedsStatusBarAppearanceUpdate()
                }
                else if traitCollection.userInterfaceStyle == .light || traitCollection.userInterfaceStyle == .unspecified {
                    view.backgroundColor = style.lightBackground
                    navigationbar.backgroundColor = style.lightTitleBackground
                    navigationbar.titleLabel.textColor = style.lightText
                    InfoTV.backgroundColor = style.lightBackground
                    setNeedsStatusBarAppearanceUpdate()
                }
            }
        }
        else {
            if UserDefaults.standard.integer(forKey: "DarkmodeStatus") == 1 {
                view.backgroundColor = style.darkBackground
                navigationbar.backgroundColor = style.darkTitleBackground
                navigationbar.titleLabel.textColor = style.darkText
                InfoTV.backgroundColor = style.darkBackground
                setNeedsStatusBarAppearanceUpdate()
            }
            else if UserDefaults.standard.integer(forKey: "DarkmodeStatus") == 0 {
                view.backgroundColor = style.lightBackground
                navigationbar.backgroundColor = style.lightTitleBackground
                navigationbar.titleLabel.textColor = style.lightText
                InfoTV.backgroundColor = style.lightBackground
                setNeedsStatusBarAppearanceUpdate()
            }
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if #available(iOS 13.0, *) {
            if UserDefaults.standard.integer(forKey: "AutoAppearance") == 1 {
                UIView.animate(withDuration: 0.1) {
                    self.changeAppearance()
                    self.InfoTV.reloadData()
                }
                self.setNeedsStatusBarAppearanceUpdate()
            }
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    struct AppInfoPublic {
        static var dictionary = Bundle.main.infoDictionary!
        static var version = dictionary["CFBundleShortVersionString"] as! String
        static var build = dictionary["CFBundleVersion"] as! String
        static var versionType = "..."
        static var bundleid = Bundle.main.bundleIdentifier
        static var database = "Laden..."
    }
}
