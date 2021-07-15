//
//  DynamicPointsView.swift
//  AthleticsPointsCalculator
//
//  Created by Mar Garcia on 18/6/21.
//

import Combine
import SwiftUI

struct DynamicPointsView: View {
    
    var eventGroup: EventGroup
    
    @EnvironmentObject var mainViewModel : MainViewModel
    
    @ObservedObject var eventGroupPointsHolder:EventGroupPointsHolder

    var body: some View {
        
        Section {
            HStack{
                VStack(alignment: .leading){
                    Text("Performance")
                    if EventGroup.needsWindParameter(eventGroupName: eventGroup.sName) {
                        Text("Wind (if applicable)")
                    }
                    Text("Placement")
                    Text("Total points")
                }
                Spacer()
                Text ("Event selection")
            }
        }
        .font(Font.system(size: 16))
        .foregroundColor(.gray)

        ForEach((0...eventGroup.sMinNumberPerformancesGroup-1), id: \.self) {performanceNumber in
            Section {
                HStack{
                    VStack(alignment: .leading){
                                           
                        SingleEventScoreWAView(performanceIndex: performanceNumber, eventGroupPointsHolder: self.eventGroupPointsHolder)
                        
                        if AthleticsEvent.needsWindParameter(eventKey: eventGroupPointsHolder.selectedAthleticsEvents[performanceNumber].sKey) {
                            ZStack {
                                WindReadingView2(windReading: $eventGroupPointsHolder.windReadings[performanceNumber], pointsModification: $eventGroupPointsHolder.windPointsModifications[performanceNumber])
                            }
                        }
                                             
                        TextField(eventGroupPointsHolder.eventPlacementPoints[performanceNumber], text: $eventGroupPointsHolder.eventPlacementPoints[performanceNumber])
                            .fixedSize()
                            .keyboardType(.decimalPad)
                        
                        Text("Total: \(eventGroupPointsHolder.getTotalPoints(performanceIndex: performanceNumber))")

                    }
                    
                    Picker("", selection: $eventGroupPointsHolder.selectedEventIndexesArray[performanceNumber]) {
                        ForEach((0...eventGroup.getArrayOfAthleticEvents().count-1), id: \.self)  { athleticEventIndex in
                            Text(eventGroup.getArrayOfAthleticEvents()[athleticEventIndex].getIndoorDisplayName())
                        }
                    }
                    .onChange(of: eventGroupPointsHolder.selectedEventIndexesArray[performanceNumber]) { newPickerIndex in
                        //updates the binding state that is passed to single score view
                        updateSomething(perfNumber: performanceNumber)
                        
                    }
                }
            }
        }

    }
    
    func updateSomething(perfNumber: Int) {
        eventGroupPointsHolder.updateSelectedAthleticEvents(perfNumber: perfNumber)
    }
}



struct WindReadingView2:View {
    
    @Binding var windReading:String
    @Binding var pointsModification:String
    
    let pointsPerUnitOfWind = 6.0
    var body: some View {
        HStack{
                Text("Wind:")
            
            CustomCenterTextField(value: $windReading, keyboardType: .numbersAndPunctuation, defaultValue: "0.0")
                .onChange(of: windReading) { newWindReading in
                    if newWindReading.isEmpty {
                        pointsModification="0"
                    } else {
                        updatePointsModification()
                    }
                }
            Text(pointsModification)
        }
    }
    
    func updatePointsModification() {
        if let windReadingDouble = Double(windReading) {
            if windReadingDouble<0.0 || windReadingDouble>2.0 {
                pointsModification=String(Int(floor(-windReadingDouble*pointsPerUnitOfWind)))
                print("points mod:\(String(Int(floor(-windReadingDouble*pointsPerUnitOfWind)))) ")
            } else {
                pointsModification="0"
            }
        }
    }
}




//struct DynamicPointsView_Previews: PreviewProvider {
//    static var previews: some View {
//        DynamicPointsView(eventGroup: (EventGroup()))
//    }
//}
