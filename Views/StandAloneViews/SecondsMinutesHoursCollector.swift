//
//  DynamicPerformanceCollector.swift
//  AthleticsPointsCalculator
//
//  Created by Mar Garcia on 16/3/21.
//

import SwiftUI

struct SecondsMinutesHoursCollector:View {
    
    let athleticsEvent:AthleticsEvent
    @Binding var totalTime:String
    
    @State var hours=""
    @State var secondsInHours=0.0
    @State var minutes=""
    @State var secondsInMinutes=0.0
    @State var seconds=""
    @State var secondsInSeconds=0.0
    
    var body: some View {
        
        if athleticsEvent.sType==AthleticsEvent.typeRunVeryLong{
            let hoursTextField = AnyView(HStack {
                CustomCenterTextField(value: $hours, keyboardType: .numberPad, defaultValue: "0")
                    .onChange(of: hours) {newHours in
                        if !newHours.isEmpty {
                            secondsInHours=Double(Int(newHours)!*3600)
                            totalTime="\(secondsInHours+secondsInMinutes+secondsInSeconds)"
                        }
                    }
                Text("h")
                CustomCenterTextField(value: $minutes, keyboardType: .numberPad, defaultValue: "0")
                    .onChange(of: minutes) {newMins in
                        if !newMins.isEmpty {
                            secondsInMinutes=Double(Int(newMins)!*60)
                            totalTime="\(secondsInHours+secondsInMinutes+secondsInSeconds)"
                        }
                    }
                Text("m")
                CustomCenterTextField(value: $seconds, keyboardType: .decimalPad, defaultValue: "0.0")
                    .onChange(of: seconds) {newSeconds in
                        if !newSeconds.isEmpty {
                            secondsInSeconds=Double(newSeconds)!
                            totalTime="\(secondsInHours+secondsInMinutes+secondsInSeconds)"
                        }
                    }
                Text("s")
                Spacer()
            }
            .onAppear(perform: loadSecondsMinutesHours))
            return hoursTextField
            
        }
        
        if athleticsEvent.sType==AthleticsEvent.typeRunLong {
            let minutesTextField = AnyView(HStack {
                CustomCenterTextField(value: $minutes, keyboardType: .numberPad, defaultValue: "0")
                    .onChange(of: minutes) {newMins in
                        if !newMins.isEmpty {
                            secondsInMinutes=Double(Int(newMins)!*60)
                            totalTime="\(secondsInMinutes+secondsInSeconds)"
                        }
                    }
                Text("m")
                CustomCenterTextField(value: $seconds, keyboardType: .decimalPad, defaultValue: "0.0")
                    .onChange(of: seconds) {newSeconds in
                        if !newSeconds.isEmpty {
                            secondsInSeconds=Double(newSeconds)!
                            totalTime="\(secondsInMinutes+secondsInSeconds)"
                        }
                    }
                Text("s")
                Spacer()
            }
            .onAppear(perform: loadSecondsMinutesHours))
            return minutesTextField
            
        }
        
        return AnyView(HStack {
            CustomCenterTextField(value: $totalTime, keyboardType: .numberPad, defaultValue: "0.0")
        })
        
    }
    
    //When data is loaded, the performance for long run will come in seconds, so tranform to minutes & seconds here and update state vars
    func loadSecondsMinutesHours() {
        if !totalTime.isEmpty {
            hours=String(Int(floor(Double(totalTime)!/3600.0)))
            let totalSecsMinusHours = Double(totalTime)! - Double(hours)!*3600
            minutes=String(Int(floor(Double(totalSecsMinusHours)/60.0)))
            let totalSecsMinusHoursMinusMins=Double(totalSecsMinusHours) - Double(minutes)!*60
            seconds=String(round(100*totalSecsMinusHoursMinusMins)/100)
        }
    }
}

struct DynamicPerformanceCollector_Previews: PreviewProvider {
    static var previews: some View {
        SecondsMinutesHoursCollector(athleticsEvent: AthleticsEvent.getExample(), totalTime: .constant("sds"))
    }
}
