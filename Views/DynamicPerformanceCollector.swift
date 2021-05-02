//
//  DynamicPerformanceCollector.swift
//  AthleticsPointsCalculator
//
//  Created by Mar Garcia on 16/3/21.
//

import SwiftUI

struct DynamicPerformanceCollector:View {
    let athleticsEvent:AthleticsEvent
    @Binding var eventPerformance:String
    
    @State var minutes=""
    @State var minutesInSecondsInt=0.0
    @State var seconds=""
    @State var secondsInDouble=0.0
    
    var body: some View {
        
        
        if athleticsEvent.sType==AthleticsEvent.typeRunLong {
            print ("NEW VALUE FOR RUN LONG PERFORMANCE: \(eventPerformance)")

            let dynamicTextField = AnyView(HStack {
                TextField("0.0", text: $minutes)
                    .fixedSize()
                    .keyboardType(.decimalPad)
                    .onChange(of: minutes) {newMinutes in
                        if !newMinutes.isEmpty {
                            minutesInSecondsInt=Double(newMinutes)!*60
                            eventPerformance="\(minutesInSecondsInt+secondsInDouble)"
                        }
                    }
                Text("min")
                TextField("0.0", text: $seconds)
                    .fixedSize()
                    .keyboardType(.decimalPad)
                    .onChange(of: seconds) {newSeconds in
                        if !newSeconds.isEmpty {
                            secondsInDouble=Double(newSeconds)!
                            eventPerformance="\(minutesInSecondsInt+secondsInDouble)"
                        }
                    }
                Text("s")
                Spacer()
            }
            .onAppear(perform: updateMinutesAndSeconds))
            return dynamicTextField
            
        }
        
        return AnyView(HStack {
            TextField("0.0", text: $eventPerformance)
                .keyboardType(.decimalPad)
        })
        
    }
    
    //When data is loaded, the performance for long run will come in seconds, so tranform to minutes & seconds here and update state vars
    func updateMinutesAndSeconds() {
        if !eventPerformance.isEmpty {
            minutes=String(Int(floor(Double(eventPerformance)!/60.0)))
            seconds=String(Double(eventPerformance)! - Double(minutes)!*60)
        }
    }
}

struct DynamicPerformanceCollector_Previews: PreviewProvider {
    static var previews: some View {
        DynamicPerformanceCollector(athleticsEvent: AthleticsEvent.getExample(), eventPerformance: .constant("sds"))
    }
}
