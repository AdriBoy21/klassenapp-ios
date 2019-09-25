//
//  StundenplanClass.swift
//  EI-App
//
//  Created by Adrian Baumgart on 18.09.19.
//  Copyright © 2019 Adrian Baumgart. All rights reserved.
//

import AppCenter
import AppCenterAnalytics
import AppCenterCrashes
import FirebaseDatabase
import LocalAuthentication

#if canImport(SwiftUI)
    import SwiftUI
#if canImport(Combine)
    import Combine
import SwiftyJSON
@available(iOS 13.0, *)
    final class StundenplanClass: ObservableObject {
        let objectWillChange = ObservableObjectPublisher()
        
        var allDays: [singleStundenDay] = [] {
            willSet {
                DispatchQueue.main.async {
                    self.objectWillChange.send()
                }
            }
        }
    
    var selectedWeek: Int = 0 {
        willSet {
            DispatchQueue.main.async {
                self.objectWillChange.send()
            }
        }
        didSet {
            self.startFetch()
        }
    }
        
        var userKlasse: String = "" {
            willSet {
                DispatchQueue.main.async {
                    self.objectWillChange.send()
                }
            }
        }

        
        var detailFachName: String = "" {
            willSet {
                DispatchQueue.main.async {
                    self.objectWillChange.send()
                }
            }
        }
        var detailRoom: String = "" {
            willSet {
                DispatchQueue.main.async {
                    self.objectWillChange.send()
                }
            }
        }
        var detailTeacher: String = "" {
            willSet {
                DispatchQueue.main.async {
                    self.objectWillChange.send()
                }
            }
        }
        var detailInfo: String = "" {
            willSet {
                DispatchQueue.main.async {
                    self.objectWillChange.send()
                }
            }
        }
    
        var detailTime: String = "" {
            willSet {
                DispatchQueue.main.async {
                    self.objectWillChange.send()
                }
            }
        }
        
    func startFetch() {
            allDays.removeAll()
            let ref: DatabaseReference = Database.database().reference()
            ref.removeAllObservers()
            
            ref.child("stundenplan_new").observe(.value) { (snapshot) in
                self.allDays.removeAll()
                self.objectWillChange.send()
                if self.selectedWeek == 0 {
                    print("WA")
                    self.loadDataWeekA()
                }
                else if self.selectedWeek == 1 {
                    print("WB")
                    self.loadDataWeekB()
                }
            }
        }
        
        func loadDataWeekA() {
            var databasekeys: [String] = []
            allDays.removeAll()
            databasekeys.removeAll()
            let ref: DatabaseReference = Database.database().reference()
            var days:[dayPack] = [dayPack(name: "monday", short: "Mo"), dayPack(name: "tuesday", short: "Di"), dayPack(name: "wednesday", short: "Mi"), dayPack(name: "thursday", short: "Do"), dayPack(name: "friday", short: "Fr")]
            
            for day in days {
                let stdRef = ref.child("stundenplan_new").child("week-a")
                var superArray:[singleStunde] = []
                stdRef.child(day.name).observeSingleEvent(of: .value) { (ListSnap) in
                    if let item = ListSnap.value as? [String: AnyObject] {
                        databasekeys = Array(item.keys)
                        self.allDays.removeAll()
                        for key in databasekeys {
                            let jsonFile = Bundle.main.url(forResource: "stundenplanColors", withExtension: "json")!
                            let jsonData = try? Data(contentsOf: jsonFile)
                            let json = try? JSON(data: jsonData!)
                            
                            let jsonTimeFile = Bundle.main.url(forResource: "stundenplanTimes", withExtension: "json")!
                            let jsonTimeData = try? Data(contentsOf: jsonTimeFile)
                            let jsonTime = try? JSON(data: jsonTimeData!)
                            
                            
                            let short = item[key]!["short"] as! String
                            let backColorDB = item[key]!["backColor"] as! String
                            let textColorDB = item[key]!["textColor"] as! String
                            let order = item[key]!["order"] as! Int
                            
                            let backColor = Color(red: Double(json![backColorDB]["r"].string!)! / 255.0, green: Double(json![backColorDB]["g"].string!)! / 255.0, blue: Double(json![backColorDB]["b"].string!)! / 255.0)
                            let textColor = Color(red: Double(json![textColorDB]["r"].string!)! / 255.0, green: Double(json![textColorDB]["g"].string!)! / 255.0, blue: Double(json![textColorDB]["b"].string!)! / 255.0)
                            let stunde = "\(jsonTime![String(order)]["time"].string!)\n \(jsonTime![String(order)]["stunde"].string!)"
                            
                            superArray.append(singleStunde(fachName: short, backColor: backColor, textColor: textColor, isEmpty: false, order: order, stunde: stunde, week: day.name))
                            //print("HI: \(superArray)")
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now()) {
                            superArray.sort(by: { $0.order < $1.order })
                            let rest = 9 - superArray.count
                            
                            while superArray.count < 9 {
                                superArray.append(singleStunde(fachName: "-", backColor: Color.clear, textColor: Color.clear, isEmpty: true, order: 1000, stunde: "-", week: day.name))
                            }
                            superArray.sort(by: { $0.order < $1.order })
                            self.allDays.append(singleStundenDay(dayName: day.short, array: superArray))
                            print("ARRAY!!: \(self.allDays)")
                        }
                    }
                }
            }
        }
    
    func loadDataWeekB() {
        var databasekeys: [String] = []
        allDays.removeAll()
        databasekeys.removeAll()
        let ref: DatabaseReference = Database.database().reference()
        var days:[dayPack] = [dayPack(name: "monday", short: "Mo"), dayPack(name: "tuesday", short: "Di"), dayPack(name: "wednesday", short: "Mi"), dayPack(name: "thursday", short: "Do"), dayPack(name: "friday", short: "Fr")]
        
        for day in days {
            var stdRef: DatabaseReference
            ref.child("stundenplan_new").child("week-b").child(day.name).observeSingleEvent(of: .value) { (snap) in
                if snap.hasChild("redirect") {
                    let stdRef = ref.child("stundenplan_new").child("week-a")
                    var superArray:[singleStunde] = []
                    stdRef.child(day.name).observeSingleEvent(of: .value) { (ListSnap) in
                        if let item = ListSnap.value as? [String: AnyObject] {
                            databasekeys = Array(item.keys)
                            self.allDays.removeAll()
                            for key in databasekeys {
                                let jsonFile = Bundle.main.url(forResource: "stundenplanColors", withExtension: "json")!
                                let jsonData = try? Data(contentsOf: jsonFile)
                                let json = try? JSON(data: jsonData!)
                                
                                let jsonTimeFile = Bundle.main.url(forResource: "stundenplanTimes", withExtension: "json")!
                                let jsonTimeData = try? Data(contentsOf: jsonTimeFile)
                                let jsonTime = try? JSON(data: jsonTimeData!)
                                
                                
                                let short = item[key]!["short"] as! String
                                let backColorDB = item[key]!["backColor"] as! String
                                let textColorDB = item[key]!["textColor"] as! String
                                let order = item[key]!["order"] as! Int
                                
                                let backColor = Color(red: Double(json![backColorDB]["r"].string!)! / 255.0, green: Double(json![backColorDB]["g"].string!)! / 255.0, blue: Double(json![backColorDB]["b"].string!)! / 255.0)
                                let textColor = Color(red: Double(json![textColorDB]["r"].string!)! / 255.0, green: Double(json![textColorDB]["g"].string!)! / 255.0, blue: Double(json![textColorDB]["b"].string!)! / 255.0)
                                let stunde = "\(jsonTime![String(order)]["time"].string!)\n \(jsonTime![String(order)]["stunde"].string!)"
                                
                                superArray.append(singleStunde(fachName: short, backColor: backColor, textColor: textColor, isEmpty: false, order: order, stunde: stunde, week: day.name))
                                //print("HI: \(superArray)")
                            }
                            
                            DispatchQueue.main.asyncAfter(deadline: .now()) {
                                superArray.sort(by: { $0.order < $1.order })
                                let rest = 9 - superArray.count
                                
                                while superArray.count < 9 {
                                    superArray.append(singleStunde(fachName: "-", backColor: Color.clear, textColor: Color.clear, isEmpty: true, order: 1000, stunde: "-", week: day.name))
                                }
                                superArray.sort(by: { $0.order < $1.order })
                                self.allDays.append(singleStundenDay(dayName: day.short, array: superArray))
                                print("ARRAY!!: \(self.allDays)")
                            }
                        }
                    }
                }
                else {
                    let stdRef = ref.child("stundenplan_new").child("week-b")
                    var superArray:[singleStunde] = []
                    stdRef.child(day.name).observeSingleEvent(of: .value) { (ListSnap) in
                        if let item = ListSnap.value as? [String: AnyObject] {
                            databasekeys = Array(item.keys)
                            self.allDays.removeAll()
                            for key in databasekeys {
                                let jsonFile = Bundle.main.url(forResource: "stundenplanColors", withExtension: "json")!
                                let jsonData = try? Data(contentsOf: jsonFile)
                                let json = try? JSON(data: jsonData!)
                                
                                let jsonTimeFile = Bundle.main.url(forResource: "stundenplanTimes", withExtension: "json")!
                                let jsonTimeData = try? Data(contentsOf: jsonTimeFile)
                                let jsonTime = try? JSON(data: jsonTimeData!)
                                
                                
                                let short = item[key]!["short"] as! String
                                let backColorDB = item[key]!["backColor"] as! String
                                let textColorDB = item[key]!["textColor"] as! String
                                let order = item[key]!["order"] as! Int
                                
                                let backColor = Color(red: Double(json![backColorDB]["r"].string!)! / 255.0, green: Double(json![backColorDB]["g"].string!)! / 255.0, blue: Double(json![backColorDB]["b"].string!)! / 255.0)
                                let textColor = Color(red: Double(json![textColorDB]["r"].string!)! / 255.0, green: Double(json![textColorDB]["g"].string!)! / 255.0, blue: Double(json![textColorDB]["b"].string!)! / 255.0)
                                let stunde = "\(jsonTime![String(order)]["time"].string!)\n \(jsonTime![String(order)]["stunde"].string!)"
                                
                                superArray.append(singleStunde(fachName: short, backColor: backColor, textColor: textColor, isEmpty: false, order: order, stunde: stunde, week: day.name))
                                //print("HI: \(superArray)")
                            }
                            
                            DispatchQueue.main.asyncAfter(deadline: .now()) {
                                superArray.sort(by: { $0.order < $1.order })
                                let rest = 9 - superArray.count
                                
                                while superArray.count < 9 {
                                    superArray.append(singleStunde(fachName: "-", backColor: Color.clear, textColor: Color.clear, isEmpty: true, order: 1000, stunde: "-", week: day.name))
                                }
                                superArray.sort(by: { $0.order < $1.order })
                                self.allDays.append(singleStundenDay(dayName: day.short, array: superArray))
                                print("ARRAY!!: \(self.allDays)")
                            }
                        }
                    }
                }
            }
        }
    }
        
        func loadDetail(week: String, orderNr: String) {
            let ref: DatabaseReference = Database.database().reference()
            
            if selectedWeek == 0 {
                let planRef = ref.child("stundenplan_new").child("week-a").child(week).child("_\(orderNr)")
                
                planRef.child("name").observe(.value) { (snapshot) in
                    self.detailFachName = snapshot.value as! String
                }
                planRef.child("room").observe(.value) { (snapshot) in
                    self.detailRoom = snapshot.value as! String
                }
                planRef.child("teacher").observe(.value) { (snapshot) in
                    self.detailTeacher = snapshot.value as! String
                }
                planRef.child("additional_information").observe(.value) { (snapshot) in
                    self.detailInfo = snapshot.value as! String
                }
                let jsonTimeFile = Bundle.main.url(forResource: "stundenplanTimes", withExtension: "json")!
                let jsonTimeData = try? Data(contentsOf: jsonTimeFile)
                let jsonTime = try? JSON(data: jsonTimeData!)

                self.detailTime = "\(jsonTime![String(orderNr)]["time"].string!) (\(jsonTime![String(orderNr)]["stunde"].string!))"
                
            }
            else if selectedWeek == 1 {
                ref.child("stundenplan_new").child("week-b").child(week).observeSingleEvent(of: .value) { (snap) in
                    if snap.hasChild("redirect") {
                        let planRef = ref.child("stundenplan_new").child("week-a").child(week).child("_\(orderNr)")
                        planRef.child("name").observe(.value) { (snapshot) in
                            self.detailFachName = snapshot.value as! String
                        }
                        planRef.child("room").observe(.value) { (snapshot) in
                            self.detailRoom = snapshot.value as! String
                        }
                        planRef.child("teacher").observe(.value) { (snapshot) in
                            self.detailTeacher = snapshot.value as! String
                        }
                        planRef.child("additional_information").observe(.value) { (snapshot) in
                            self.detailInfo = snapshot.value as! String
                        }
                        let jsonTimeFile = Bundle.main.url(forResource: "stundenplanTimes", withExtension: "json")!
                        let jsonTimeData = try? Data(contentsOf: jsonTimeFile)
                        let jsonTime = try? JSON(data: jsonTimeData!)

                        self.detailTime = "\(jsonTime![String(orderNr)]["time"].string!) (\(jsonTime![String(orderNr)]["stunde"].string!))"
                    }
                    else {
                        let planRef = ref.child("stundenplan_new").child("week-b").child(week).child("_\(orderNr)")
                        planRef.child("name").observe(.value) { (snapshot) in
                            self.detailFachName = snapshot.value as! String
                        }
                        planRef.child("room").observe(.value) { (snapshot) in
                            self.detailRoom = snapshot.value as! String
                        }
                        planRef.child("teacher").observe(.value) { (snapshot) in
                            self.detailTeacher = snapshot.value as! String
                        }
                        planRef.child("additional_information").observe(.value) { (snapshot) in
                            self.detailInfo = snapshot.value as! String
                        }
                        let jsonTimeFile = Bundle.main.url(forResource: "stundenplanTimes", withExtension: "json")!
                        let jsonTimeData = try? Data(contentsOf: jsonTimeFile)
                        let jsonTime = try? JSON(data: jsonTimeData!)

                        self.detailTime = "\(jsonTime![String(orderNr)]["time"].string!) (\(jsonTime![String(orderNr)]["stunde"].string!))"
                    }
                }
            }
        }
    }
#endif
#endif

