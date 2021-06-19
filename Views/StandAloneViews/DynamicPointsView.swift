//
//  DynamicPointsView.swift
//  AthleticsPointsCalculator
//
//  Created by Mar Garcia on 18/6/21.
//

import SwiftUI

struct DynamicPointsView: View {
    
    @Binding var eventGroup: EventGroup
    
//    @State var arrayOfEventGroupEvents:[AthleticsEvent] = []
    @EnvironmentObject var mainViewModel : MainViewModel
    
    @State var selectedEventGroupEventIndexArray:[Int] = [0,0,0,0,0,0]
    @State var selectedEventGroupEventPerformance:[String] = ["0.0","0.0","0.0","0.0","0.0","0.0"]

    
    var body: some View {
        
        Text("My event is \(eventGroup.sName) and my array of events has count: \(eventGroup.getArrayOfAthleticEvents().count)")
        
        
        ForEach((1...eventGroup.sMinNumberPerformancesGroup), id: \.self) {i in
            Section {
                HStack{
//                    Text("Perf. Nº \(i)")
                    TextField(selectedEventGroupEventPerformance[i-1], text: $selectedEventGroupEventPerformance[i-1])
                    Picker("", selection: $selectedEventGroupEventIndexArray[i]) {
                        ForEach((1...eventGroup.getArrayOfAthleticEvents().count), id: \.self)  { j in
                            Text(eventGroup.getArrayOfAthleticEvents()[j-1].getIndoorDisplayName())
                        }
                    }.onChange(of: selectedEventGroupEventIndexArray[i]) {newValue in
                        print("New value of segeia: \(newValue)")
                    }
                }
            }
            
        }
        
    }
    
}
        
        
        
    



//struct CustomEventGroupEventPicker: View {
//    @State var selectedEventGroupEventIndex:Int = 0
//    @Binding var arrayOfEventGroupEvents:[AthleticsEvent]
//    //    @Binding var eventGroup: EventGroup
//
//
//    var body: some View {
//        Picker("Event", selection: $selectedEventGroupEventIndex) {
//            ForEach(0..<arrayOfEventGroupEvents.count) {
//                Text(arrayOfEventGroupEvents[$0].getIndoorDisplayName())
//            }
//            .onAppear{
//                //                print("on appear cutom picker: \(arrayOfEventGroupEvents.count)")
//            }
//        }.pickerStyle(WheelPickerStyle())
//        .frame(width: 120)
//        .clipped()
//
//    }
//}

//struct DynamicPointsView_Previews: PreviewProvider {
//    static var previews: some View {
//        DynamicPointsView(eventGroup: (EventGroup()))
//    }
//}
