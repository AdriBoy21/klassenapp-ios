//
//  TimeTableSwiftUIView.swift
//  KlassenAppD
//
//  Created by Adrian Baumgart on 24.09.19.
//  Copyright © 2019 Adrian Baumgart. All rights reserved.
//

/*
#if canImport(SwiftUI)
    import SwiftUI

@available(iOS 13.0, *)
    struct TimeTableSwiftUIView: View {
    
    @ObservedObject var StundenplanController = StundenplanClass()
    @State var stundenplanDetailShown: Bool = false
    @State private var selectedStundeWeek: String = ""
    @State private var selectedStundeOrder: String = ""
    
    /*@State private var selectedWeek: Int = 0 {
        didSet {
            DispatchQueue.main.async {
                self.StundenplanController.startFetch(week: self.selectedWeek)
            }
        }
    }*/
    
    
    var pickerWeeks = ["Woche A", "Woche B"]
    
        var body: some View {
            VStack {
                HStack {
                    Text("Stundenplan").font(.largeTitle).bold()
                    Spacer()
                }.padding(.all).padding(.top, 30)
                Picker(selection: $StundenplanController.selectedWeek, label: Text("Test")) {
                    Text("Woche A").tag(0)
                    Text("Woche B").tag(1)
                }.padding(.all, 25).pickerStyle(SegmentedPickerStyle())
                /*Picker(selection: $selectedWeek, label: Text("Hi")) {
                    Text("Woche A")
                }.pickerStyle(SegmentedPickerStyle())*/
                HStack {
                    Text("Aktuelle Woche: \(StundenplanController.ABWeek)").bold()
                    Spacer()
                }.padding(.leading)
                HStack {
                    Text("Woche: \(StundenplanController.ABWeek_Date)").foregroundColor(.secondary)
                    Spacer()
                }.padding(.leading)
                ScrollView {
                    HStack {
                        ForEach(StundenplanController.allDays, id: \.self) { day in
                            VStack {
                                Text(day.dayName)
                                ForEach(day.array, id: \.self) { stunde in
                                    Group {
                                        if !stunde.isEmpty {
                                            VStack {
                                                Text(stunde.fachName).bold().lineLimit(nil).foregroundColor(stunde.textColor).font(.system(size: 15))
                                                Group {
                                                    Text(stunde.stunde).foregroundColor(stunde.textColor).font(.system(size: 10))
                                                }
                                            }.frame(minWidth: 45, maxWidth: 200, minHeight: 135, maxHeight: 135).background(stunde.backColor).cornerRadius(15).padding(.bottom, 5).onTapGesture {
                                                if self.selectedStundeWeek == stunde.week && self.selectedStundeOrder == String(stunde.order) {
                                                    withAnimation(.easeOut(duration: 0.1)) {
                                                        self.stundenplanDetailShown = false
                                                    }
                                                    self.selectedStundeWeek = ""
                                                    self.selectedStundeOrder = ""
                                                }
                                                else {
                                                    self.stundenplanDetailShown = false
                                                    self.selectedStundeWeek = stunde.week
                                                    self.selectedStundeOrder = String(stunde.order)
                                                    self.StundenplanController.loadDetail(week: self.selectedStundeWeek, orderNr: self.selectedStundeOrder)
                                                    withAnimation(.easeIn(duration: 0.1)) {
                                                        self.stundenplanDetailShown = true
                                                    }
                                                }
                                                    /*if self.stundenplanDetailShown {
                                                        self.stundenplanDetailShown.toggle()
                                                        self.selectedStundeWeek = ""
                                                        self.selectedStundeOrder = ""
                                                    }
                                                    else {
                                                        self.selectedStundeWeek = stunde.week
                                                        self.selectedStundeOrder = String(stunde.order)
                                                        withAnimation {
                                                            self.stundenplanDetailShown.toggle()
                                                        }
                                                    }*/
                                            }
                                        }
                                        else {
                                            Group {
                                                Image(systemName: "minus")
                                            }.frame(minWidth: 45, maxWidth: 200, minHeight: 135, maxHeight: 135).background(Color("StundenplanNoData")).cornerRadius(15).padding(.bottom, 5)
                                        }//.frame(width: 55, height: 135, alignment: .center)
                                        Text("")
                                    }
                                }
                            }
                        }
                    }.padding(.all).onAppear {
                        self.stundenplanDetailShown = false
                        self.StundenplanController.startFetch()
                    }
                }
                if self.stundenplanDetailShown {
                    self.stundenplanDetailView
                }
            }/*.sheet(isPresented: $stundenplanDetailShown, onDismiss: {
                    self.stundenplanDetailShown = false
                }, content: {
                    self.stundenplanDetailView
                })*/
        }
    var stundenplanDetailView: some View {
        Group {
            VStack(alignment: .leading) {
                HStack {
                    Text("\(StundenplanController.detailFachName)").font(.title).bold()
                    Spacer()
                }.padding(.leading)
                HStack {
                    Text("Raum:").font(.system(size: 15)).bold()
                    Text("\(StundenplanController.detailRoom)").font(.system(size: 15))
                    Spacer()
                }.padding(.leading)
                HStack {
                    Text("Lehrerkürzel:").font(.system(size: 15)).bold()
                    Text("\(StundenplanController.detailTeacher)").font(.system(size: 15))
                    Spacer()
                }.padding(.leading)
                HStack {
                    Text("Zeit:").font(.system(size: 15)).bold()
                    Text("\(StundenplanController.detailTime)").font(.system(size: 15))
                    Spacer()
                }.padding(.leading)
                HStack {
                    Text("Weitere Informationen:").font(.system(size: 15)).bold()
                    Spacer()
                }.padding(.leading)
                ScrollView {
                    HStack {
                        Text("\(StundenplanController.detailInfo)").font(.system(size: 15))
                        Spacer()
                    }.padding(.leading)
                }
                Spacer()
            }.padding(.all).transition(.move(edge: .bottom))
        }.background(Color("MainCellBackground")).frame(height: 230).cornerRadius(12).onAppear {
            self.StundenplanController.loadDetail(week: self.selectedStundeWeek, orderNr: self.selectedStundeOrder)
        }.transition(.move(edge: .bottom))
    }
    }
@available(iOS 13.0, *)
    struct TimeTableSwiftUIView_Previews: PreviewProvider {
        static var previews: some View {
            TimeTableSwiftUIView()
        }
    }

@available(iOS 13.0, *)
struct singleStundenDay: Hashable {
    var dayName: String
    var array: [singleStunde]
}

struct dayPack {
    var name: String
    var short: String
}
@available(iOS 13.0, *)
struct singleStunde: Hashable {
    var fachName: String
    var backColor: Color
    var textColor: Color
    var isEmpty: Bool
    var order: Int
    var stunde: String
    var week: String
}
#endif
*/
