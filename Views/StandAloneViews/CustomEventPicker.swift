//
//  CustomEventPicker.swift
//  AthleticsPointsCalculator
//
//  Created by Mar Garcia on 19/3/21.
//

import SwiftUI

struct CustomEventPicker: View {
    
    @Binding var selectedSingleEventIndex:Int
    let arrayOfEvents:[AthleticsEvent]
    let pickerTitle:String
    
    var body: some View {
        Picker(pickerTitle, selection: $selectedSingleEventIndex) {
            ForEach(0..<arrayOfEvents.count) {
                Text(arrayOfEvents[$0].sName)
            }
        }.pickerStyle(WheelPickerStyle())
    }
}

//struct CustomEventPicker_Previews: PreviewProvider {
//    static var previews: some View {
//        CustomEventPicker()
//    }
//}
